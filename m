Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbXIUWjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbXIUWjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXIUWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:30 -0400
Received: from ns.suse.de ([195.135.220.2]:57056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763395AbXIUWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:20 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/50] x86_64: Fix some broken white space in arch/x86_64/mm/init.c
Message-Id: <20070921223219.30ADD13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


No functional changes
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/init.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -73,7 +73,7 @@ void show_mem(void)
 	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 
 	for_each_online_pgdat(pgdat) {
-               for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			/* this loop can take a while with 256 GB and 4k pages
 			   so update the NMI watchdog */
 			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
@@ -89,7 +89,7 @@ void show_mem(void)
 				cached++;
 			else if (page_count(page))
 				shared += page_count(page) - 1;
-               }
+		}
 	}
 	printk(KERN_INFO "%lu pages of RAM\n", total);
 	printk(KERN_INFO "%lu reserved pages\n",reserved);
@@ -114,7 +114,7 @@ static __init void *spp_getpage(void)
 } 
 
 static __init void set_pte_phys(unsigned long vaddr,
-			 unsigned long phys, pgprot_t prot)
+				unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -324,7 +324,7 @@ static void __init find_early_table_spac
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE) +
-		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+		round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
 
  	/* RED-PEN putting page tables only on node 0 could
  	   cause a hotspot and fill up ZONE_DMA. The page tables
@@ -338,8 +338,8 @@ static void __init find_early_table_spac
 	table_end = table_start;
 
 	early_printk("kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT,
-		(table_start << PAGE_SHIFT) + tables);
+		     end, table_start << PAGE_SHIFT,
+		     (table_start << PAGE_SHIFT) + tables);
 }
 
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
@@ -428,7 +428,7 @@ void __init clear_kernel_mapping(unsigne
 		if (0 == (pmd_val(*pmd) & _PAGE_PSE)) { 
 			/* Could handle this, but it should not happen currently. */
 			printk(KERN_ERR 
-	       "clear_kernel_mapping: mapping has been split. will leak memory\n"); 
+			       "clear_kernel_mapping: mapping has been split. will leak memory\n");
 			pmd_ERROR(*pmd); 
 		}
 		set_pmd(pmd, __pmd(0)); 		
@@ -539,7 +539,7 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 #endif
 	reservedpages = end_pfn - totalram_pages -
-					absent_pages_in_range(0, end_pfn);
+		absent_pages_in_range(0, end_pfn);
 
 	after_bootmem = 1;
 
@@ -554,15 +554,15 @@ void __init mem_init(void)
 	kclist_add(&kcore_kernel, &_stext, _end - _stext);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START, 
-				 VSYSCALL_END - VSYSCALL_START);
+		   VSYSCALL_END - VSYSCALL_START);
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, %ldk data, %ldk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		end_pfn << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10);
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       end_pfn << (PAGE_SHIFT-10),
+	       codesize >> 10,
+	       reservedpages << (PAGE_SHIFT-10),
+	       datasize >> 10,
+	       initsize >> 10);
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
@@ -669,10 +669,10 @@ void __init reserve_bootmem_generic(unsi
 int kern_addr_valid(unsigned long addr) 
 { 
 	unsigned long above = ((long)addr) >> __VIRTUAL_MASK_SHIFT;
-       pgd_t *pgd;
-       pud_t *pud;
-       pmd_t *pmd;
-       pte_t *pte;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
 
 	if (above != 0 && above != -1UL)
 		return 0; 
@@ -737,7 +737,7 @@ int in_gate_area_no_task(unsigned long a
 void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
-			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+				    SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
 }
 
 const char *arch_vma_name(struct vm_area_struct *vma)
