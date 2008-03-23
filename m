Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbYCWI3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbYCWI3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYCWIJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:37 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2280 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbYCWIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:33 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 097/148] include/asm-x86/pgtable.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:12 -0700
Message-Id: <1206259443-13210-98-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgtable.h |  197 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 142 insertions(+), 55 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 0e31e72..2533f79 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -18,27 +18,28 @@
 #define _PAGE_BIT_UNUSED2	10
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_HIDDEN	11
-#define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
+#define _PAGE_BIT_NX		63	/* No execute:
+					 * only valid after cpuid check */
 
 /*
  * Note: we use _AC(1, L) instead of _AC(1, UL) so that we get a
  * sign-extended value on 32-bit with all 1's in the upper word,
  * which preserves the upper pte values on 64-bit ptes:
  */
-#define _PAGE_PRESENT	(_AC(1, L)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, L)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, L)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, L)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, L)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, L)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, L)<<_PAGE_BIT_DIRTY)
-#define _PAGE_PSE	(_AC(1, L)<<_PAGE_BIT_PSE)	/* 2MB page */
-#define _PAGE_GLOBAL	(_AC(1, L)<<_PAGE_BIT_GLOBAL)	/* Global TLB entry */
-#define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
-#define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
-#define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
-#define _PAGE_HIDDEN	(_AC(1, L)<<_PAGE_BIT_HIDDEN)
+#define _PAGE_PRESENT	(_AC(1, L) << _PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, L) << _PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, L) << _PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, L) << _PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, L) << _PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, L) << _PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, L) << _PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AC(1, L) << _PAGE_BIT_PSE)	/* 2MB page */
+#define _PAGE_GLOBAL	(_AC(1, L) << _PAGE_BIT_GLOBAL)	/* Global TLB entry */
+#define _PAGE_UNUSED1	(_AC(1, L) << _PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AC(1, L) << _PAGE_BIT_UNUSED2)
+#define _PAGE_PAT	(_AC(1, L) << _PAGE_BIT_PAT)
+#define _PAGE_PAT_LARGE (_AC(1, L) << _PAGE_BIT_PAT_LARGE)
+#define _PAGE_HIDDEN	(_AC(1, L) << _PAGE_BIT_HIDDEN)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
@@ -47,12 +48,15 @@
 #endif
 
 /* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	_PAGE_DIRTY	/* nonlinear file mapping, saved PTE; unset:swap */
+#define _PAGE_FILE	_PAGE_DIRTY	/* nonlinear file mapping,
+					 * saved PTE; unset:swap */
 #define _PAGE_PROTNONE	_PAGE_PSE	/* if the user mapped it with PROT_NONE;
 					   pte_present gives true */
 
-#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |	\
+			 _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
+			 _PAGE_DIRTY)
 
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 
@@ -63,14 +67,20 @@
 #define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
 
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-
-#define PAGE_SHARED_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY_NOEXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_COPY_EXEC		__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
+				 _PAGE_ACCESSED | _PAGE_NX)
+
+#define PAGE_SHARED_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_RW |	\
+					 _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY_NOEXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
+					 _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_COPY_EXEC		__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
+					 _PAGE_ACCESSED)
 #define PAGE_COPY		PAGE_COPY_NOEXEC
-#define PAGE_READONLY		__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_READONLY_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_READONLY		__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
+					 _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_READONLY_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
+					 _PAGE_ACCESSED)
 
 #ifdef CONFIG_X86_32
 #define _PAGE_KERNEL_EXEC \
@@ -88,11 +98,13 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | \
+					 _PAGE_PWT)
 #define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | \
+					 _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
@@ -139,7 +151,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
 extern spinlock_t pgd_lock;
@@ -149,30 +161,101 @@ extern struct list_head pgd_list;
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
-static inline int pte_global(pte_t pte) 	{ return pte_val(pte) & _PAGE_GLOBAL; }
-static inline int pte_exec(pte_t pte)		{ return !(pte_val(pte) & _PAGE_NX); }
-
-static inline int pmd_large(pmd_t pte) {
-	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
-		(_PAGE_PSE|_PAGE_PRESENT);
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
 }
 
-static inline pte_t pte_mkclean(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_DIRTY); }
-static inline pte_t pte_mkold(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_ACCESSED); }
-static inline pte_t pte_wrprotect(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_RW); }
-static inline pte_t pte_mkexec(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_NX); }
-static inline pte_t pte_mkdirty(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_DIRTY); }
-static inline pte_t pte_mkyoung(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_ACCESSED); }
-static inline pte_t pte_mkwrite(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_RW); }
-static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
-static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_PSE); }
-static inline pte_t pte_mkglobal(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_GLOBAL); }
-static inline pte_t pte_clrglobal(pte_t pte)	{ return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL); }
+static inline int pte_global(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_GLOBAL;
+}
+
+static inline int pte_exec(pte_t pte)
+{
+	return !(pte_val(pte) & _PAGE_NX);
+}
+
+static inline int pmd_large(pmd_t pte)
+{
+	return (pmd_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+		(_PAGE_PSE | _PAGE_PRESENT);
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_DIRTY);
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_ACCESSED);
+}
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_RW);
+}
+
+static inline pte_t pte_mkexec(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_NX);
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_DIRTY);
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_ACCESSED);
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_RW);
+}
+
+static inline pte_t pte_mkhuge(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_PSE);
+}
+
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_PSE);
+}
+
+static inline pte_t pte_mkglobal(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_GLOBAL);
+}
+
+static inline pte_t pte_clrglobal(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~(pteval_t)_PAGE_GLOBAL);
+}
 
 extern pteval_t __supported_pte_mask;
 
@@ -210,9 +293,9 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
-                              unsigned long size, pgprot_t vma_prot);
+			      unsigned long size, pgprot_t vma_prot);
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
-                              unsigned long size, pgprot_t *vma_prot);
+				 unsigned long size, pgprot_t *vma_prot);
 #endif
 
 #ifdef CONFIG_PARAVIRT
@@ -331,7 +414,8 @@ extern int ptep_clear_flush_young(struct vm_area_struct *vma,
 				  unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
+				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
 	pte_update(mm, addr, ptep);
@@ -339,7 +423,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 }
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep,
+					    int full)
 {
 	pte_t pte;
 	if (full) {
@@ -355,7 +441,8 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void ptep_set_wrprotect(struct mm_struct *mm,
+				      unsigned long addr, pte_t *ptep)
 {
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 	pte_update(mm, addr, ptep);
-- 
1.5.4.rc2

