Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbXJJOl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbXJJOl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXJJOlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:41:49 -0400
Received: from saeurebad.de ([85.214.36.134]:60464 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbXJJOlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:41:49 -0400
Date: Wed, 10 Oct 2007 16:41:44 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] i386 memory initialization cleanup
Message-ID: <20071010144144.GB32677@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

386 memory init cleanup -- prerequisites

This patch fixes whitespace errors only.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

---
 arch/i386/mm/init.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index 730a5b1..dc3c03f 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -61,7 +61,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 {
 	pud_t *pud;
 	pmd_t *pmd_table;
-		
+
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
@@ -91,19 +91,19 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
 		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
 	}
-	
+
 	return pte_offset_kernel(pmd, 0);
 }
 
 /*
- * This function initializes a certain range of kernel virtual memory 
+ * This function initializes a certain range of kernel virtual memory
  * with new bootmem page tables, everywhere page tables are missing in
  * the given range.
  */
 
 /*
- * NOTE: The pagetables are allocated contiguous on the physical space 
- * so we can cache the place of the first one and move around without 
+ * NOTE: The pagetables are allocated contiguous on the physical space
+ * so we can cache the place of the first one and move around without
  * checking the pgd every time.
  */
 static void __init page_table_range_init (unsigned long start, unsigned long end, pgd_t *pgd_base)
@@ -138,8 +138,8 @@ static inline int is_kernel_text(unsigned long addr)
 }
 
 /*
- * This maps the physical memory to kernel virtual address space, a total 
- * of max_low_pfn pages, by creating page tables starting from address 
+ * This maps the physical memory to kernel virtual address space, a total
+ * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET.
  */
 static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
@@ -265,7 +265,7 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pud = pud_offset(pgd, vaddr);
 	pmd = pmd_offset(pud, vaddr);
 	pte = pte_offset_kernel(pmd, vaddr);
-	pkmap_page_table = pte;	
+	pkmap_page_table = pte;
 }
 
 static void __meminit free_new_highpage(struct page *page)
@@ -608,7 +608,7 @@ static void __init test_wp_bit(void)
 	}
 }
 
-static struct kcore_list kcore_mem, kcore_vmalloc; 
+static struct kcore_list kcore_mem, kcore_vmalloc;
 
 void __init mem_init(void)
 {
@@ -620,7 +620,7 @@ void __init mem_init(void)
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
-	
+
 	bad_ppro = ppro_with_ram_bug();
 
 #ifdef CONFIG_HIGHMEM
@@ -632,7 +632,7 @@ void __init mem_init(void)
 		BUG();
 	}
 #endif
- 
+
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
@@ -650,8 +650,8 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT); 
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START, 
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
@@ -789,7 +789,7 @@ static int noinline do_test_wp_bit(void)
 		 "=r" (flag)
 		:"2" (1)
 		:"memory");
-	
+
 	return flag;
 }
