Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbXLJVGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbXLJVGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbXLJVFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:05:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:38699 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbXLJVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:05:14 -0500
X-SBRS: 5.6
X-MesageID: 33292001
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,148,1196658000"; 
   d="scan'208";a="33292001"
Message-ID: <475DA7C5.70900@goop.org>
Date: Mon, 10 Dec 2007 12:55:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH 5/4] x86: fix up asm-x86/pgtable*.h formatting
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up various pieces of unconventional formatting in
asm-x86/pgtable*.h.  In some cases, the old formatting was arguablly
clearer with a wide enough terminal, but this patch gives the option
of using a more standard form.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable-2level.h |   24 +++++++---
 include/asm-x86/pgtable-3level.h |   17 ++++---
 include/asm-x86/pgtable.h        |   91 ++++++++++++++++++++++++++++++++------
 include/asm-x86/pgtable_64.h     |   20 +++++---
 4 files changed, 118 insertions(+), 34 deletions(-)

diff -r 449d529a6056 include/asm-x86/pgtable-2level.h
--- a/include/asm-x86/pgtable-2level.h	Mon Dec 10 12:46:06 2007 -0800
+++ b/include/asm-x86/pgtable-2level.h	Mon Dec 10 12:49:16 2007 -0800
@@ -28,14 +28,22 @@ static inline void native_set_pmd(pmd_t 
 }
 
 #undef set_pte_atomic
-#define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
-#define set_pte_present(mm,addr,ptep,pteval) set_pte_at(mm,addr,ptep,pteval)
+#define set_pte_atomic(pteptr, pteval)		set_pte(pteptr,pteval)
+#define set_pte_present(mm,addr,ptep,pteval)	set_pte_at(mm,addr,ptep,pteval)
 
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+#define pte_clear(mm,addr,xp)				\
+	do {						\
+		set_pte_at(mm, addr, xp, __pte(0));	\
+	} while (0)
+
 #undef pmd_clear
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+#define pmd_clear(xp)				\
+	do {					\
+		set_pmd(xp, __pmd(0));		\
+	} while (0)
 
-static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
+static inline void native_pte_clear(struct mm_struct *mm,
+				    unsigned long addr, pte_t *xp)
 {
 	*xp = __pte(0);
 }
@@ -68,7 +76,8 @@ static inline int pte_exec_kernel(pte_t 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
+#define __swp_entry(type, offset)	\
+	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
diff -r 449d529a6056 include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h	Mon Dec 10 12:46:06 2007 -0800
+++ b/include/asm-x86/pgtable-3level.h	Mon Dec 10 12:49:16 2007 -0800
@@ -9,7 +9,8 @@
  */
 
 #define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, &(e), (e).pte_high, (e).pte_low)
+	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__,	\
+	       &(e), (e).pte_high, (e).pte_low)
 #define pmd_ERROR(e) \
 	printk("%s:%d: bad pmd %p(%016Lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
 #define pgd_ERROR(e) \
@@ -39,6 +40,7 @@ static inline void native_set_pte(pte_t 
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
@@ -65,10 +67,12 @@ static inline void native_set_pte_atomic
 {
 	set_64bit((unsigned long long *)(ptep),native_pte_val(pte));
 }
+
 static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	set_64bit((unsigned long long *)(pmdp),native_pmd_val(pmd));
 }
+
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
@@ -79,7 +83,8 @@ static inline void native_set_pud(pud_t 
  * entry, so clear the bottom half first and enforce ordering with a compiler
  * barrier.
  */
-static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void native_pte_clear(struct mm_struct *mm,
+				    unsigned long addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -102,11 +107,11 @@ static inline void native_pmd_clear(pmd_
  */
 static inline void pud_clear (pud_t * pud) { }
 
-#define pud_page(pud) \
-((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page(pud)					\
+	((struct page *) __va(pud_val(pud) & PAGE_MASK))
 
-#define pud_page_vaddr(pud) \
-((unsigned long) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud)				\
+	((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
 
 #ifdef CONFIG_SMP
diff -r 449d529a6056 include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h	Mon Dec 10 12:46:06 2007 -0800
+++ b/include/asm-x86/pgtable.h	Mon Dec 10 12:49:16 2007 -0800
@@ -67,11 +67,30 @@ void paging_init(void);
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+static inline int pte_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_DIRTY;
+}
+
+static inline int pte_young(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_ACCESSED;
+}
+
+static inline int pte_write(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_RW;
+}
+
+static inline int pte_file(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_FILE;
+}
+
+static inline int pte_huge(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_PSE;
+}
 
 #endif	/* __ASSEMBLY__ */
 
@@ -213,15 +232,59 @@ static inline int pte_huge(pte_t pte)		{
 
 #ifndef __ASSEMBLY__
 
-static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
-static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
-static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
-static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
-static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
-static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
-static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
-static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY));
+	return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED));
+	return pte;
+}
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW));
+	return pte;
+}
+
+static inline pte_t pte_mkexec(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX));
+	return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY));
+	return pte;
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED));
+	return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW));
+	return pte;
+}
+
+static inline pte_t pte_mkhuge(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE));
+	return pte;
+}
+
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE));
+	return pte;
+}
 
 #ifndef __PAGETABLE_PUD_FOLDED
 static inline bool pgd_bad(pgd_t pgd)
diff -r 449d529a6056 include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h	Mon Dec 10 12:46:06 2007 -0800
+++ b/include/asm-x86/pgtable_64.h	Mon Dec 10 12:49:16 2007 -0800
@@ -178,7 +178,8 @@ static inline void ptep_set_wrprotect(st
 /*
  * Level 4 access.
  */
-#define pgd_page_vaddr(pgd) ((unsigned long) __va((unsigned long)pgd_val(pgd) & PTE_MASK))
+#define pgd_page_vaddr(pgd)	\
+	((unsigned long) __va((unsigned long)pgd_val(pgd) & PTE_MASK))
 #define pgd_page(pgd)		(pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT))
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 #define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
@@ -188,11 +189,13 @@ static inline void ptep_set_wrprotect(st
 
 /* PUD - Level 3 access */
 /* to find an entry in a page-table-directory. */
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PHYSICAL_PAGE_MASK))
+#define pud_page_vaddr(pud)	((unsigned long) __va(pud_val(pud) & PHYSICAL_PAGE_MASK))
 #define pud_page(pud)		(pfn_to_page(pud_val(pud) >> PAGE_SHIFT))
-#define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pud_offset(pgd, address) ((pud_t *) pgd_page_vaddr(*(pgd)) + pud_index(address))
-#define pud_present(pud) (pud_val(pud) & _PAGE_PRESENT)
+#define pud_index(address)	\
+	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+#define pud_offset(pgd, address)	\
+	((pud_t *) pgd_page_vaddr(*(pgd)) + pud_index(address))
+#define pud_present(pud)	(pud_val(pud) & _PAGE_PRESENT)
 
 /* PMD  - Level 2 access */
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
@@ -236,7 +239,8 @@ static inline void ptep_set_wrprotect(st
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
 #define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
+#define __swp_entry(type, offset)	\
+	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
@@ -247,8 +251,8 @@ extern int kern_addr_valid(unsigned long
 
 pte_t *lookup_address(unsigned long addr);
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
-		remap_pfn_range(vma, vaddr, pfn, size, prot)
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define HAVE_ARCH_UNMAPPED_AREA
 

