Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbYCWJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbYCWJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760342AbYCWIM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2373 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 095/148] include/asm-x86/pgtable-3level.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:10 -0700
Message-Id: <1206259443-13210-96-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgtable-3level.h |   48 ++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
index 1d763ee..8b4a9d4 100644
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -8,22 +8,26 @@
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
  */
 
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, &(e), (e).pte_high, (e).pte_low)
-#define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %p(%016Lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
-#define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %p(%016Lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
-
+#define pte_ERROR(e)							\
+	printk("%s:%d: bad pte %p(%08lx%08lx).\n",			\
+	       __FILE__, __LINE__, &(e), (e).pte_high, (e).pte_low)
+#define pmd_ERROR(e)							\
+	printk("%s:%d: bad pmd %p(%016Lx).\n",				\
+	       __FILE__, __LINE__, &(e), pmd_val(e))
+#define pgd_ERROR(e)							\
+	printk("%s:%d: bad pgd %p(%016Lx).\n",				\
+	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 static inline int pud_none(pud_t pud)
 {
 	return pud_val(pud) == 0;
 }
+
 static inline int pud_bad(pud_t pud)
 {
 	return (pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
 }
+
 static inline int pud_present(pud_t pud)
 {
 	return pud_val(pud) & _PAGE_PRESENT;
@@ -48,7 +52,8 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte)
  * we are justified in merely clearing the PTE present bit, followed
  * by a set.  The ordering here is important.
  */
-static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+static inline void native_set_pte_present(struct mm_struct *mm,
+					  unsigned long addr,
 					  pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
@@ -60,15 +65,17 @@ static inline void native_set_pte_present(struct mm_struct *mm, unsigned long ad
 
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
-	set_64bit((unsigned long long *)(ptep),native_pte_val(pte));
+	set_64bit((unsigned long long *)(ptep), native_pte_val(pte));
 }
+
 static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-	set_64bit((unsigned long long *)(pmdp),native_pmd_val(pmd));
+	set_64bit((unsigned long long *)(pmdp), native_pmd_val(pmd));
 }
+
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
-	set_64bit((unsigned long long *)(pudp),native_pud_val(pud));
+	set_64bit((unsigned long long *)(pudp), native_pud_val(pud));
 }
 
 /*
@@ -76,7 +83,8 @@ static inline void native_set_pud(pud_t *pudp, pud_t pud)
  * entry, so clear the bottom half first and enforce ordering with a compiler
  * barrier.
  */
-static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -107,20 +115,19 @@ static inline void pud_clear(pud_t *pudp)
 	 * current pgd to avoid unnecessary TLB flushes.
 	 */
 	pgd = read_cr3();
-	if (__pa(pudp) >= pgd && __pa(pudp) < (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
+	if (__pa(pudp) >= pgd && __pa(pudp) <
+	    (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) \
-((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PAGE_MASK))
 
-#define pud_page_vaddr(pud) \
-((unsigned long) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
 
 /* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
-			pmd_index(address))
+#define pmd_offset(pud, address) ((pmd_t *)pud_page(*(pud)) +	\
+				  pmd_index(address))
 
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
@@ -161,7 +168,8 @@ static inline unsigned long pte_pfn(pte_t pte)
  * put the 32 bits of offset into the high part.
  */
 #define pte_to_pgoff(pte) ((pte).pte_high)
-#define pgoff_to_pte(off) ((pte_t) { { .pte_low = _PAGE_FILE, .pte_high = (off) } })
+#define pgoff_to_pte(off)						\
+	((pte_t) { { .pte_low = _PAGE_FILE, .pte_high = (off) } })
 #define PTE_FILE_MAX_BITS       32
 
 /* Encode and de-code a swap entry */
-- 
1.5.4.rc2

