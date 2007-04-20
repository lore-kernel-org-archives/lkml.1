Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXDTFCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXDTFCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161186AbXDTFCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:02:36 -0400
Received: from ozlabs.org ([203.10.76.45]:53864 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161158AbXDTFCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:02:34 -0400
Date: Fri, 20 Apr 2007 15:02:30 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@osdl.org>
Cc: David Miller <davem@davemloft.net>, William Lee Irwin <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Cleanup mostly unused IOSPACE macros
Message-ID: <20070420050230.GA16420@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>,
	William Lee Irwin <wli@holomorphy.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures defined three macros, MK_IOSPACE_PFN(),
GET_IOSPACE() and GET_PFN() in pgtable.h.  However, the only callers
of any of these macros are in Sparc specific code, either in
arch/sparc, arch/sparc64 or drivers/sbus.

This patch removes the redundant macros from all architectures except
sparc and sparc64.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

---
 include/asm-alpha/pgtable.h     |    4 ----
 include/asm-arm/pgtable-nommu.h |    4 ----
 include/asm-arm/pgtable.h       |    4 ----
 include/asm-arm26/pgtable.h     |    4 ----
 include/asm-avr32/pgtable.h     |    4 ----
 include/asm-frv/pgtable.h       |    4 ----
 include/asm-h8300/pgtable.h     |    4 ----
 include/asm-i386/pgtable.h      |    4 ----
 include/asm-ia64/pgtable.h      |    4 ----
 include/asm-m32r/pgtable.h      |    4 ----
 include/asm-m68k/pgtable.h      |    4 ----
 include/asm-m68knommu/pgtable.h |    4 ----
 include/asm-mips/pgtable.h      |    4 ----
 include/asm-parisc/pgtable.h    |    4 ----
 include/asm-ppc/pgtable.h       |    4 ----
 include/asm-sh/pgtable.h        |    4 ----
 include/asm-sh64/pgtable.h      |    4 ----
 include/asm-x86_64/pgtable.h    |    4 ----
 18 files changed, 72 deletions(-)

Index: working-2.6/include/asm-alpha/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-alpha/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-alpha/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -345,10 +345,6 @@ extern inline pte_t mk_swap_pte(unsigned
 #define io_remap_pfn_range(vma, start, pfn, size, prot)	\
 		remap_pfn_range(vma, start, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pmd_ERROR(e) \
Index: working-2.6/include/asm-arm/pgtable-nommu.h
===================================================================
--- working-2.6.orig/include/asm-arm/pgtable-nommu.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-arm/pgtable-nommu.h	2007-04-20 14:55:08.000000000 +1000
@@ -83,10 +83,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_page_range	remap_page_range
 #define io_remap_pfn_range	remap_pfn_range
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 
 /*
  * All 32bit addresses are effectively valid for vmalloc...
Index: working-2.6/include/asm-arm/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-arm/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-arm/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -395,10 +395,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 #define io_remap_pfn_range(vma,from,pfn,size,prot) \
 		remap_pfn_range(vma, from, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define pgtable_cache_init() do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
Index: working-2.6/include/asm-arm26/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-arm26/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-arm26/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -297,10 +297,6 @@ static inline pte_t mk_pte_phys(unsigned
 #define io_remap_pfn_range(vma,from,pfn,size,prot) \
 		remap_pfn_range(vma, from, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASMARM_PGTABLE_H */
Index: working-2.6/include/asm-avr32/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-avr32/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-avr32/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -394,10 +394,6 @@ typedef pte_t *pte_addr_t;
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* No page table caches to initialize (?) */
 #define pgtable_cache_init()	do { } while(0)
 
Index: working-2.6/include/asm-frv/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-frv/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-frv/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -509,10 +509,6 @@ static inline int pte_file(pte_t pte)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
Index: working-2.6/include/asm-h8300/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-h8300/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-h8300/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -55,10 +55,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * All 32bit addresses are effectively valid for vmalloc...
  * Sort of meaningless for non-VM targets.
Index: working-2.6/include/asm-i386/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-i386/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-i386/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -519,10 +519,6 @@ do {									\
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #include <asm-generic/pgtable.h>
 
 #endif /* _I386_PGTABLE_H */
Index: working-2.6/include/asm-ia64/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-ia64/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-ia64/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -485,10 +485,6 @@ extern void paging_init (void);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
Index: working-2.6/include/asm-m32r/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-m32r/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-m32r/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -381,10 +381,6 @@ static inline void pmd_set(pmd_t * pmdp,
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
Index: working-2.6/include/asm-m68k/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-m68k/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-m68k/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -143,10 +143,6 @@ static inline void update_mmu_cache(stru
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* MMU-specific headers */
 
 #ifdef CONFIG_SUN3
Index: working-2.6/include/asm-m68knommu/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-m68knommu/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-m68knommu/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -59,10 +59,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * All 32bit addresses are effectively valid for vmalloc...
  * Sort of meaningless for non-VM targets.
Index: working-2.6/include/asm-mips/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-mips/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-mips/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -387,10 +387,6 @@ static inline int io_remap_pfn_range(str
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 #endif
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #include <asm-generic/pgtable.h>
 
 /*
Index: working-2.6/include/asm-parisc/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-parisc/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-parisc/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -528,10 +528,6 @@ static inline void ptep_set_wrprotect(st
 
 #define pgprot_noncached(prot) __pgprot(pgprot_val(prot) | _PAGE_NO_CACHE)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* We provide our own get_unmapped_area to provide cache coherency */
 
 #define HAVE_ARCH_UNMAPPED_AREA
Index: working-2.6/include/asm-ppc/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-ppc/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-ppc/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -827,10 +827,6 @@ static inline int io_remap_pfn_range(str
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 #endif
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * No page table caches to initialise
  */
Index: working-2.6/include/asm-sh/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-sh/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-sh/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -568,10 +568,6 @@ typedef pte_t *pte_addr_t;
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 struct mm_struct;
 
 /*
Index: working-2.6/include/asm-sh64/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-sh64/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-sh64/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -485,10 +485,6 @@ extern void update_mmu_cache(struct vm_a
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
Index: working-2.6/include/asm-x86_64/pgtable.h
===================================================================
--- working-2.6.orig/include/asm-x86_64/pgtable.h	2007-04-20 14:55:06.000000000 +1000
+++ working-2.6/include/asm-x86_64/pgtable.h	2007-04-20 14:55:08.000000000 +1000
@@ -413,10 +413,6 @@ extern int kern_addr_valid(unsigned long
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define pgtable_cache_init()   do { } while (0)

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
