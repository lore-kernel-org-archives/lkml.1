Return-Path: <linux-kernel-owner+w=401wt.eu-S934156AbZFLVqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156AbZFLVqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763136AbZFLVqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:46:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbZFLVqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:46:08 -0400
From: Izik Eidus <ieidus@redhat.com>
To: hugh.dickins@tiscali.co.uk
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 1/3] ksm: remove ksm from being a module.
Date: Sat, 13 Jun 2009 00:44:58 +0300
Message-Id: <1244843100-4128-2-git-send-email-ieidus@redhat.com>
In-Reply-To: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/mm.h   |    2 +-
 include/linux/rmap.h |    4 ++--
 mm/Kconfig           |    5 ++---
 mm/memory.c          |    2 +-
 mm/rmap.c            |    2 +-
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e617bab..c1259bf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1258,7 +1258,7 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#ifdef CONFIG_KSM
 int replace_page(struct vm_area_struct *vma, struct page *oldpage,
 		 struct page *newpage, pte_t orig_pte, pgprot_t prot);
 #endif
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 469376d..8b98536 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -118,7 +118,7 @@ static inline int try_to_munlock(struct page *page)
 }
 #endif
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#ifdef CONFIG_KSM
 int page_wrprotect(struct page *page, int *odirect_sync, int count_offset);
 #endif
 
@@ -136,7 +136,7 @@ static inline int page_mkclean(struct page *page)
 	return 0;
 }
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#ifdef CONFIG_KSM
 static inline int page_wrprotect(struct page *page, int *odirect_sync,
 				 int count_offset)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 5ebfd18..e7c118f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -227,10 +227,9 @@ config MMU_NOTIFIER
 	bool
 
 config KSM
-	tristate "Enable KSM for page sharing"
+	bool "Enable KSM for page sharing"
 	help
-	  Enable the KSM kernel module to allow page sharing of equal pages
-	  among different tasks.
+	  Enable KSM to allow page sharing of equal pages among different tasks.
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
diff --git a/mm/memory.c b/mm/memory.c
index 8b4e40e..203bbd0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1617,7 +1617,7 @@ int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#ifdef CONFIG_KSM
 
 /**
  * replace_page - replace page in vma with new page
diff --git a/mm/rmap.c b/mm/rmap.c
index f53074c..34a2029 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -585,7 +585,7 @@ int page_mkclean(struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#ifdef CONFIG_KSM
 
 static int page_wrprotect_one(struct page *page, struct vm_area_struct *vma,
 			      int *odirect_sync, int count_offset)
-- 
1.5.6.5

