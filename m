Return-Path: <linux-kernel-owner+w=401wt.eu-S1764391AbYCWJJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764391AbYCWJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYCWIMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:34 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2372 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759666AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 094/148] include/asm-x86/pgtable_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:09 -0700
Message-Id: <1206259443-13210-95-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgtable_32.h |  102 ++++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 49 deletions(-)

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 82ba08f..e9c8c3f 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -40,13 +40,13 @@ void paging_init(void);
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level-defs.h>
 # define PMD_SIZE	(1UL << PMD_SHIFT)
-# define PMD_MASK	(~(PMD_SIZE-1))
+# define PMD_MASK	(~(PMD_SIZE - 1))
 #else
 # include <asm/pgtable-2level-defs.h>
 #endif
 
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
-#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+#define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the
@@ -55,21 +55,22 @@ void paging_init(void);
  * The vmalloc() routines leaves a hole of 4kB between each vmalloced
  * area for the same reason. ;)
  */
-#define VMALLOC_OFFSET	(8*1024*1024)
-#define VMALLOC_START	(((unsigned long) high_memory + \
-			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
+#define VMALLOC_OFFSET	(8 * 1024 * 1024)
+#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
+			 & ~(VMALLOC_OFFSET - 1))
 #ifdef CONFIG_X86_PAE
 #define LAST_PKMAP 512
 #else
 #define LAST_PKMAP 1024
 #endif
 
-#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK)
+#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
+		    & PMD_MASK)
 
 #ifdef CONFIG_HIGHMEM
-# define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
+# define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
 #else
-# define VMALLOC_END	(FIXADDR_START-2*PAGE_SIZE)
+# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
 #endif
 
 /*
@@ -86,16 +87,16 @@ extern unsigned long pg0[];
 #define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
 
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
-#define pmd_none(x)	(!(unsigned long)pmd_val(x))
-#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#define pmd_none(x)	(!(unsigned long)pmd_val((x)))
+#define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
 
 extern int pmd_bad(pmd_t pmd);
 
-#define pmd_bad_v1(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
-#define	pmd_bad_v2(x)	((pmd_val(x) \
-			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
-			 != _KERNPG_TABLE)
-
+#define pmd_bad_v1(x)							\
+	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER)))
+#define	pmd_bad_v2(x)							\
+	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER |	\
+					    _PAGE_PSE | _PAGE_NX)))
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
@@ -106,17 +107,18 @@ extern int pmd_bad(pmd_t pmd);
 #endif
 
 /*
- * Macro to mark a page protection value as "uncacheable".  On processors which do not support
- * it, this is a no-op.
+ * Macro to mark a page protection value as "uncacheable".
+ * On processors which do not support it, this is a no-op.
  */
-#define pgprot_noncached(prot)	((boot_cpu_data.x86 > 3)					  \
-				 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT)) : (prot))
+#define pgprot_noncached(prot)					\
+	((boot_cpu_data.x86 > 3)				\
+	 ? (__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))	\
+	 : (prot))
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */
-
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
 /*
@@ -125,20 +127,20 @@ extern int pmd_bad(pmd_t pmd);
  * this macro returns the index of the entry in the pgd page which would
  * control the given virtual address
  */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_index_k(addr) pgd_index(addr)
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#define pgd_index_k(addr) pgd_index((addr))
 
 /*
  * pgd_offset() returns a (pgd_t *)
  * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
  */
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index((address)))
 
 /*
  * a shortcut which implies the use of the kernel's pgd, instead
  * of a process's
  */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+#define pgd_offset_k(address) pgd_offset(&init_mm, (address))
 
 static inline int pud_large(pud_t pud) { return 0; }
 
@@ -148,8 +150,8 @@ static inline int pud_large(pud_t pud) { return 0; }
  * this macro returns the index of the entry in the pmd page which would
  * control the given virtual address
  */
-#define pmd_index(address) \
-		(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+#define pmd_index(address)				\
+	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 
 /*
  * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
@@ -157,43 +159,45 @@ static inline int pud_large(pud_t pud) { return 0; }
  * this macro returns the index of the entry in the pte page which would
  * control the given virtual address
  */
-#define pte_index(address) \
-		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
+#define pte_index(address)					\
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset_kernel(dir, address)				\
+	((pte_t *)pmd_page_vaddr(*(dir)) +  pte_index((address)))
 
-#define pmd_page(pmd) (pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+#define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
-#define pmd_page_vaddr(pmd) \
-		((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+#define pmd_page_vaddr(pmd)					\
+	((unsigned long)__va(pmd_val((pmd)) & PAGE_MASK))
 
 #if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
+#define pte_offset_map(dir, address)					\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
+	 pte_index((address)))
+#define pte_offset_map_nested(dir, address)				\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
+	 pte_index((address)))
+#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
 #else
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_offset_map(dir, address)					\
+	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
+#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
 #define pte_unmap(pte) do { } while (0)
 #define pte_unmap_nested(pte) do { } while (0)
 #endif
 
 /* Clear a kernel PTE and flush it from the TLB */
-#define kpte_clear_flush(ptep, vaddr)					\
-do {									\
-	pte_clear(&init_mm, vaddr, ptep);				\
-	__flush_tlb_one(vaddr);						\
+#define kpte_clear_flush(ptep, vaddr)		\
+do {						\
+	pte_clear(&init_mm, (vaddr), (ptep));	\
+	__flush_tlb_one((vaddr));		\
 } while (0)
 
 /*
  * The i386 doesn't have any external MMU info: the kernel page
  * tables contain all the necessary information.
  */
-#define update_mmu_cache(vma,address,pte) do { } while (0)
+#define update_mmu_cache(vma, address, pte) do { } while (0)
 
 void native_pagetable_setup_start(pgd_t *base);
 void native_pagetable_setup_done(pgd_t *base);
@@ -222,7 +226,7 @@ static inline void paravirt_pagetable_setup_done(pgd_t *base)
 #define kern_addr_valid(kaddr)	(0)
 #endif
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
-		remap_pfn_range(vma, vaddr, pfn, size, prot)
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #endif /* _I386_PGTABLE_H */
-- 
1.5.4.rc2

