Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZETSdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZETSdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbZETSZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52090 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbZETSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:41 -0400
Subject: [RFC v2][PATCH 35/35] remove old ptemap.h includes
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:40 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182540.256CBDE7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we're directly including ptemap.h everywhere we need it
we no longer need the includes from all the various arch
headers.  Kill them.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/arm/include/asm/pgtable.h           |    2 --
 linux-2.6.git-dave/arch/cris/include/asm/pgtable.h          |    1 -
 linux-2.6.git-dave/arch/frv/include/asm/pgtable.h           |    2 --
 linux-2.6.git-dave/arch/ia64/include/asm/pgtable.h          |    2 --
 linux-2.6.git-dave/arch/m32r/include/asm/pgtable.h          |    1 -
 linux-2.6.git-dave/arch/m68k/include/asm/motorola_pgtable.h |    2 --
 linux-2.6.git-dave/arch/m68k/include/asm/sun3_pgtable.h     |    3 ---
 linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h       |    1 -
 linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h       |    1 -
 linux-2.6.git-dave/arch/mn10300/include/asm/pgtable.h       |    2 --
 linux-2.6.git-dave/arch/parisc/include/asm/pgtable.h        |    2 --
 linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc64.h |    2 --
 linux-2.6.git-dave/arch/s390/include/asm/pgtable.h          |    2 --
 linux-2.6.git-dave/arch/sh/include/asm/pgtable_32.h         |    1 -
 linux-2.6.git-dave/arch/sh/include/asm/pgtable_64.h         |    2 --
 linux-2.6.git-dave/arch/sparc/include/asm/pgtable_32.h      |    2 --
 linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h      |    2 --
 linux-2.6.git-dave/arch/um/include/asm/pgtable.h            |    1 -
 linux-2.6.git-dave/arch/x86/include/asm/pgtable_32.h        |    2 --
 linux-2.6.git-dave/arch/x86/include/asm/pgtable_64.h        |    2 --
 20 files changed, 35 deletions(-)

diff -puN arch/arm/include/asm/pgtable.h~remove-old-ptemap-includes arch/arm/include/asm/pgtable.h
--- linux-2.6.git/arch/arm/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -265,8 +265,6 @@ extern struct page *empty_zero_page;
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 #define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
 
-#include <asm/ptemap.h>
-
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
 
 #define set_pte_at(mm,addr,ptep,pteval) do { \
diff -puN arch/cris/include/asm/pgtable.h~remove-old-ptemap-includes arch/cris/include/asm/pgtable.h
--- linux-2.6.git/arch/cris/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/cris/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -244,7 +244,6 @@ static inline pgd_t * pgd_offset(const s
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) +  __pte_offset(address))
-#include <asm/ptemap.h>
 #define pte_pfn(x)		((unsigned long)(__va((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -puN arch/frv/include/asm/pgtable.h~remove-old-ptemap-includes arch/frv/include/asm/pgtable.h
--- linux-2.6.git/arch/frv/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -449,8 +449,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
 
-#include <asm/ptemap.h>
-
 /*
  * Handle swap and file entries
  * - the PTE is encoded in the following format:
diff -puN arch/ia64/include/asm/pgtable.h~remove-old-ptemap-includes arch/ia64/include/asm/pgtable.h
--- linux-2.6.git/arch/ia64/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/ia64/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -406,8 +406,6 @@ pgd_offset (const struct mm_struct *mm, 
 #define pte_index(addr)	 	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir,addr)	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
 
-#include <asm/ptemap.h>
-
 /* atomic versions of the some PTE manipulations: */
 
 static inline int
diff -puN arch/m32r/include/asm/pgtable.h~remove-old-ptemap-includes arch/m32r/include/asm/pgtable.h
--- linux-2.6.git/arch/m32r/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/m32r/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -330,7 +330,6 @@ static inline void pmd_set(pmd_t * pmdp,
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address)	\
 	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
-#include <asm/ptemap.h>
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
diff -puN arch/m68k/include/asm/motorola_pgtable.h~remove-old-ptemap-includes arch/m68k/include/asm/motorola_pgtable.h
--- linux-2.6.git/arch/m68k/include/asm/motorola_pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:47.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/motorola_pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -220,8 +220,6 @@ static inline pte_t *pte_offset_kernel(p
 	return (pte_t *)__pmd_page(*pmdp) + ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
 }
 
-#include <asm/ptemap.h>
-
 /*
  * Allocate and free page tables. The xxx_kernel() versions are
  * used to allocate a kernel page table - this turns on ASN bits
diff -puN arch/m68k/include/asm/sun3_pgtable.h~remove-old-ptemap-includes arch/m68k/include/asm/sun3_pgtable.h
--- linux-2.6.git/arch/m68k/include/asm/sun3_pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/sun3_pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -217,9 +217,6 @@ static inline pte_t pgoff_to_pte(unsigne
 /* Find an entry in the third-level pagetable. */
 #define pte_index(address) ((address >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 #define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
-/* FIXME: should we bother with kmap() here? */
-
-#include <asm/ptemap.h>
 
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
diff -puN arch/mips/include/asm/pgtable-32.h~remove-old-ptemap-includes arch/mips/include/asm/pgtable-32.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-32.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h	2009-05-20 11:09:48.000000000 -0700
@@ -150,7 +150,6 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 #define pte_offset(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
 #define pte_offset_kernel(dir, address) pte_offset(dir, address)
-#include <asm/ptemap.h>
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
diff -puN arch/mips/include/asm/pgtable-64.h~remove-old-ptemap-includes arch/mips/include/asm/pgtable-64.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-64.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h	2009-05-20 11:09:48.000000000 -0700
@@ -220,7 +220,6 @@ static inline pmd_t *pmd_offset(pud_t * 
 #define pte_offset(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
 #define pte_offset_kernel(dir, address)	pte_offset(dir, address)
-#include <asm/ptemap.h>
 /*
  * Initialize a new pgd / pmd table with invalid pointers.
  */
diff -puN arch/mn10300/include/asm/pgtable.h~remove-old-ptemap-includes arch/mn10300/include/asm/pgtable.h
--- linux-2.6.git/arch/mn10300/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -455,8 +455,6 @@ static inline int set_kernel_exec(unsign
 	return 0;
 }
 
-#include <asm/ptemap.h>
-
 /*
  * The MN10300 has external MMU info in the form of a TLB: this is adapted from
  * the kernel page tables containing the necessary information by tlb-mn10300.S
diff -puN arch/parisc/include/asm/pgtable.h~remove-old-ptemap-includes arch/parisc/include/asm/pgtable.h
--- linux-2.6.git/arch/parisc/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -397,8 +397,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_offset_kernel(pmd, address) \
 	((pte_t *) pmd_page_vaddr(*(pmd)) + pte_index(address))
 
-#include <asm/ptemap.h>
-
 extern void paging_init (void);
 
 /* Used for deferring calls to flush_dcache_page() */
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~remove-old-ptemap-includes arch/powerpc/include/asm/pgtable-ppc64.h
--- linux-2.6.git/arch/powerpc/include/asm/pgtable-ppc64.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc64.h	2009-05-20 11:09:48.000000000 -0700
@@ -162,8 +162,6 @@
 #define pte_offset_kernel(dir,addr) \
   (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 
-#include <asm/ptemap.h>
-
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
diff -puN arch/s390/include/asm/pgtable.h~remove-old-ptemap-includes arch/s390/include/asm/pgtable.h
--- linux-2.6.git/arch/s390/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/s390/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -1041,8 +1041,6 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_offset(pmd, addr) ((pte_t *) pmd_deref(*(pmd)) + pte_index(addr))
 #define pte_offset_kernel(pmd, address) pte_offset(pmd,address)
 
-#include <asm/ptemap.h>
-
 /*
  * 31 bit swap entry format:
  * A page-table entry has some bits we have to treat in a special way.
diff -puN arch/sh/include/asm/pgtable_32.h~remove-old-ptemap-includes arch/sh/include/asm/pgtable_32.h
--- linux-2.6.git/arch/sh/include/asm/pgtable_32.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/pgtable_32.h	2009-05-20 11:09:48.000000000 -0700
@@ -403,7 +403,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_index(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
-#include <asm/ptemap.h>
 
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
diff -puN arch/sh/include/asm/pgtable_64.h~remove-old-ptemap-includes arch/sh/include/asm/pgtable_64.h
--- linux-2.6.git/arch/sh/include/asm/pgtable_64.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/pgtable_64.h	2009-05-20 11:09:48.000000000 -0700
@@ -83,8 +83,6 @@ static __inline__ void pmd_set(pmd_t *pm
 #define pte_offset_kernel(dir, addr) \
 		((pte_t *) ((pmd_val(*(dir))) & PAGE_MASK) + pte_index((addr)))
 
-#include <asm/ptemap.h>
-
 #ifndef __ASSEMBLY__
 #define IOBASE_VADDR	0xff000000
 #define IOBASE_END	0xffffffff
diff -puN arch/sparc/include/asm/pgtable_32.h~remove-old-ptemap-includes arch/sparc/include/asm/pgtable_32.h
--- linux-2.6.git/arch/sparc/include/asm/pgtable_32.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/include/asm/pgtable_32.h	2009-05-20 11:09:48.000000000 -0700
@@ -300,8 +300,6 @@ BTFIXUPDEF_CALL(pmd_t *, pmd_offset, pgd
 BTFIXUPDEF_CALL(pte_t *, pte_offset_kernel, pmd_t *, unsigned long)
 #define pte_offset_kernel(dir,addr) BTFIXUP_CALL(pte_offset_kernel)(dir,addr)
 
-#include <asm/ptemap.h>
-
 /* Certain architectures need to do special things when pte's
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
diff -puN arch/sparc/include/asm/pgtable_64.h~remove-old-ptemap-includes arch/sparc/include/asm/pgtable_64.h
--- linux-2.6.git/arch/sparc/include/asm/pgtable_64.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h	2009-05-20 11:09:48.000000000 -0700
@@ -652,8 +652,6 @@ static inline int pte_special(pte_t pte)
 /* Find an entry in the third-level page table.. */
 #define pte_offset_kernel(dir, address)	\
 	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
-#include <asm/ptemap.h>
-
 /* Actual page table PTE updates.  */
 extern void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig);
 
diff -puN arch/um/include/asm/pgtable.h~remove-old-ptemap-includes arch/um/include/asm/pgtable.h
--- linux-2.6.git/arch/um/include/asm/pgtable.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/um/include/asm/pgtable.h	2009-05-20 11:09:48.000000000 -0700
@@ -331,7 +331,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
-#include <asm/ptemap.h>
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 
diff -puN arch/x86/include/asm/pgtable_32.h~remove-old-ptemap-includes arch/x86/include/asm/pgtable_32.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_32.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_32.h	2009-05-20 11:09:48.000000000 -0700
@@ -48,8 +48,6 @@ extern void set_pmd_pfn(unsigned long, u
 # include <asm/pgtable-2level.h>
 #endif
 
-#include <asm/ptemap.h>
-
 /* Clear a kernel PTE and flush it from the TLB */
 #define kpte_clear_flush(ptep, vaddr)		\
 do {						\
diff -puN arch/x86/include/asm/pgtable_64.h~remove-old-ptemap-includes arch/x86/include/asm/pgtable_64.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_64.h~remove-old-ptemap-includes	2009-05-20 11:09:48.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_64.h	2009-05-20 11:09:48.000000000 -0700
@@ -127,8 +127,6 @@ static inline int pgd_large(pgd_t pgd) {
 
 /* PTE - Level 1 access. */
 
-#include <asm/ptemap.h>
-
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
 extern int direct_gbpages;
diff -puN include/linux/ptemap.h~remove-old-ptemap-includes include/linux/ptemap.h
diff -puN include/asm-generic/ptemap.h~remove-old-ptemap-includes include/asm-generic/ptemap.h
_
