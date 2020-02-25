# R Studio API Code
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import
library(stringi)
citations <- stri_read_lines("../Data/citations.txt") 
citations_txt <- citations[!stri_isempty(citations)]
length(citations)-length(citations_txt)

# Data Cleaning
library(stringr)
library(rebus)
library(tidyverse)
sample(citations_txt,10)
citations_tbl <- tibble(line=1:45492,cite=citations_txt) %>%
  mutate(cite=str_remove_all(cite,pattern="\"|'")) %>% # remove all single and double quotes
  select(cite) %>%
  mutate(year=as.integer(str_extract(cite,"(?<=[(])[0-9]{4}(?=[)])"))) %>% # year: look for 4 digit numbers between ( and )
  mutate(page_start=as.integer(str_extract(cite,"[0-9]+(?=[-])"))) %>% # start page: look for any number of digits before -
  mutate(perf_ref=as.logical(str_detect(cite,regex("performance",ignore_case=TRUE)))) %>% # look for citations that contain "performance"
  mutate(title=str_extract(cite,"(?<=[0-9]{4}[)][.] )(.*?)(?=[.])")) %>% # title: look for content between year). and the next . ;(?<=) is look behind; (?=) is look ahead
  mutate(first_author=str_extract(cite,"(^(.*?)(?=(\\.,|\\. and|\\. \\&)))|(^(.*?)(?=[(]))")) # Grab everything before ., or . and or . & OR grab everything before ( for single author citations
