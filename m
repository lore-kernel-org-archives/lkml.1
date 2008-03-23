Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbYCWJGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbYCWJGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbYCWIM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:26 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2371 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760241AbYCWIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:02 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 096/148] include/asm-x86/pgtable_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:11 -0700
Message-Id: <1206259443-13210-97-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgtable_64.h |  141 ++++++++++++++++++++++-------------------
 1 files changed, 76 insertions(+), 65 deletions(-)

diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9bd551e..a3bbf87 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -52,14 +52,18 @@ extern void paging_init(void);
 
 #ifndef __ASSEMBLY__
 
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
-#define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
-#define pud_ERROR(e) \
-	printk("%s:%d: bad pud %p(%016lx).\n", __FILE__, __LINE__, &(e), pud_val(e))
-#define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+#define pte_ERROR(e)					\
+	printk("%s:%d: bad pte %p(%016lx).\n",		\
+	       __FILE__, __LINE__, &(e), pte_val(e))
+#define pmd_ERROR(e)					\
+	printk("%s:%d: bad pmd %p(%016lx).\n",		\
+	       __FILE__, __LINE__, &(e), pmd_val(e))
+#define pud_ERROR(e)					\
+	printk("%s:%d: bad pud %p(%016lx).\n",		\
+	       __FILE__, __LINE__, &(e), pud_val(e))
+#define pgd_ERROR(e)					\
+	printk("%s:%d: bad pgd %p(%016lx).\n",		\
+	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 #define pgd_none(x)	(!pgd_val(x))
 #define pud_none(x)	(!pud_val(x))
@@ -87,7 +91,8 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 #ifdef CONFIG_SMP
 	return native_make_pte(xchg(&xp->pte, 0));
 #else
-	/* native_local_ptep_get_and_clear, but duplicated because of cyclic dependency */
+	/* native_local_ptep_get_and_clear,
+	   but duplicated because of cyclic dependency */
 	pte_t ret = *xp;
 	native_pte_clear(NULL, 0, xp);
 	return ret;
@@ -119,7 +124,7 @@ static inline void native_set_pgd(pgd_t *pgdp, pgd_t pgd)
 	*pgdp = pgd;
 }
 
-static inline void native_pgd_clear(pgd_t * pgd)
+static inline void native_pgd_clear(pgd_t *pgd)
 {
 	native_set_pgd(pgd, native_make_pgd(0));
 }
@@ -128,15 +133,15 @@ static inline void native_pgd_clear(pgd_t * pgd)
 
 #endif /* !__ASSEMBLY__ */
 
-#define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
-#define PMD_MASK	(~(PMD_SIZE-1))
-#define PUD_SIZE	(_AC(1,UL) << PUD_SHIFT)
-#define PUD_MASK	(~(PUD_SIZE-1))
-#define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
-#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+#define PMD_SIZE	(_AC(1, UL) << PMD_SHIFT)
+#define PMD_MASK	(~(PMD_SIZE - 1))
+#define PUD_SIZE	(_AC(1, UL) << PUD_SHIFT)
+#define PUD_MASK	(~(PUD_SIZE - 1))
+#define PGDIR_SIZE	(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 
-#define MAXMEM		 _AC(0x3fffffffffff, UL)
+#define MAXMEM		 _AC(0x00003fffffffffff, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
@@ -163,18 +168,18 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
-#define pte_none(x)	(!pte_val(x))
-#define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
+#define pte_none(x)	(!pte_val((x)))
+#define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
-#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this right? */
-#define pte_page(x)	pfn_to_page(pte_pfn(x))
-#define pte_pfn(x)  ((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
+#define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
+#define pte_page(x)	pfn_to_page(pte_pfn((x)))
+#define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
 /*
  * Macro to mark a page protection value as "uncacheable".
  */
-#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
-
+#define pgprot_noncached(prot)					\
+	(__pgprot(pgprot_val((prot)) | _PAGE_PCD | _PAGE_PWT))
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
@@ -184,77 +189,81 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 /*
  * Level 4 access.
  */
-#define pgd_page_vaddr(pgd) ((unsigned long) __va((unsigned long)pgd_val(pgd) & PTE_MASK))
-#define pgd_page(pgd)		(pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT))
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
-#define pgd_offset_k(address) (init_level4_pgt + pgd_index(address))
+#define pgd_page_vaddr(pgd)						\
+	((unsigned long)__va((unsigned long)pgd_val((pgd)) & PTE_MASK))
+#define pgd_page(pgd)		(pfn_to_page(pgd_val((pgd)) >> PAGE_SHIFT))
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#define pgd_offset(mm, address)	((mm)->pgd + pgd_index((address)))
+#define pgd_offset_k(address) (init_level4_pgt + pgd_index((address)))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 static inline int pgd_large(pgd_t pgd) { return 0; }
 #define mk_kernel_pgd(address) ((pgd_t){ (address) | _KERNPG_TABLE })
 
 /* PUD - Level3 access */
 /* to find an entry in a page-table-directory. */
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PHYSICAL_PAGE_MASK))
-#define pud_page(pud)		(pfn_to_page(pud_val(pud) >> PAGE_SHIFT))
-#define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pud_offset(pgd, address) ((pud_t *) pgd_page_vaddr(*(pgd)) + pud_index(address))
-#define pud_present(pud) (pud_val(pud) & _PAGE_PRESENT)
+#define pud_page_vaddr(pud)						\
+	((unsigned long)__va(pud_val((pud)) & PHYSICAL_PAGE_MASK))
+#define pud_page(pud)	(pfn_to_page(pud_val((pud)) >> PAGE_SHIFT))
+#define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+#define pud_offset(pgd, address)					\
+	((pud_t *)pgd_page_vaddr(*(pgd)) + pud_index((address)))
+#define pud_present(pud) (pud_val((pud)) & _PAGE_PRESENT)
 
 static inline int pud_large(pud_t pte)
 {
-	return (pud_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
-		(_PAGE_PSE|_PAGE_PRESENT);
+	return (pud_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+		(_PAGE_PSE | _PAGE_PRESENT);
 }
 
 /* PMD  - Level 2 access */
-#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
-#define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-
-#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-#define pmd_offset(dir, address) ((pmd_t *) pud_page_vaddr(*(dir)) + \
-			pmd_index(address))
-#define pmd_none(x)	(!pmd_val(x))
-#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
-#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
-
-#define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) | _PAGE_FILE })
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val((pmd)) & PTE_MASK))
+#define pmd_page(pmd)		(pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
+
+#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+#define pmd_offset(dir, address) ((pmd_t *)pud_page_vaddr(*(dir)) + \
+				  pmd_index(address))
+#define pmd_none(x)	(!pmd_val((x)))
+#define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
+#define pfn_pmd(nr, prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val((prot))))
+#define pmd_pfn(x)  ((pmd_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
+
+#define pte_to_pgoff(pte) ((pte_val((pte)) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
+#define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) |	\
+					    _PAGE_FILE })
 #define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
 
 /* PTE - Level 1 access. */
 
 /* page, protection -> pte */
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
- 
-#define pte_index(address) \
-		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn((page)), (pgprot))
+
+#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \
-			pte_index(address))
+					 pte_index((address)))
 
 /* x86-64 always has all page tables mapped. */
-#define pte_offset_map(dir,address) pte_offset_kernel(dir,address)
-#define pte_offset_map_nested(dir,address) pte_offset_kernel(dir,address)
+#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
+#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) /* NOP */
-#define pte_unmap_nested(pte) /* NOP */ 
+#define pte_unmap_nested(pte) /* NOP */
 
-#define update_mmu_cache(vma,address,pte) do { } while (0)
+#define update_mmu_cache(vma, address, pte) do { } while (0)
 
 extern int direct_gbpages;
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
 #define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
-#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | \
+							 ((offset) << 8) })
+#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
-extern int kern_addr_valid(unsigned long addr); 
+extern int kern_addr_valid(unsigned long addr);
 extern void cleanup_highmap(void);
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
-		remap_pfn_range(vma, vaddr, pfn, size, prot)
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
@@ -267,8 +276,10 @@ extern void cleanup_highmap(void);
 
 /* fs/proc/kcore.c */
 #define	kc_vaddr_to_offset(v) ((v) & __VIRTUAL_MASK)
-#define	kc_offset_to_vaddr(o) \
-   (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
+#define	kc_offset_to_vaddr(o)				\
+	(((o) & (1UL << (__VIRTUAL_MASK_SHIFT - 1)))	\
+	 ? ((o) | ~__VIRTUAL_MASK)			\
+	 : (o))
 
 #define __HAVE_ARCH_PTE_SAME
 #endif /* !__ASSEMBLY__ */
-- 
1.5.4.rc2

