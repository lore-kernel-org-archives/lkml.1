Return-Path: <linux-kernel-owner+w=401wt.eu-S966292AbXDDCmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966292AbXDDCmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966303AbXDDCmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:42:21 -0400
Received: from waste.org ([66.93.16.53]:5459 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966292AbXDDCmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:20 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <2.486631555@selenic.com>
Subject: [PATCH 1/13] maps: Uninline some functions in the page walker
Date: Tue, 03 Apr 2007 21:43:31 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uninline some functions in the page walker

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-24 21:33:42.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-24 21:33:47.000000000 -0500
@@ -284,7 +284,7 @@ static void clear_refs_pte_range(struct 
 	cond_resched();
 }
 
-static inline void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
+static void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
 				  unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
@@ -299,7 +299,7 @@ static inline void walk_pmd_range(struct
 	}
 }
 
-static inline void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
+static void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
 				  unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
@@ -323,11 +323,11 @@ static inline void walk_pud_range(struct
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static inline void walk_page_range(struct vm_area_struct *vma,
-				   void (*action)(struct vm_area_struct *,
-						  pmd_t *, unsigned long,
-						  unsigned long, void *),
-				   void *private)
+static void walk_page_range(struct vm_area_struct *vma,
+			    void (*action)(struct vm_area_struct *,
+					   pmd_t *, unsigned long,
+					   unsigned long, void *),
+			    void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
