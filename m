Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXIVTSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXIVTSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXIVTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:18:00 -0400
Received: from www.osadl.org ([213.239.205.134]:52473 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754344AbXIVTR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:17:59 -0400
Subject: Re: [PATCH] [20/50] x86_64: Fix some broken white space in
	arch/x86_64/mm/init.c
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223219.30ADD13DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de>
	 <20070921223219.30ADD13DCD@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 21:17:56 +0200
Message-Id: <1190488676.4035.96.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> No functional changes
> Signed-off-by: Andi Kleen <ak@suse.de>

Can we please fix _ALL_ white space and coding style issues in this file
while we are at it?

Updated patch below.

	tglx

diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 458893b..346c962 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -70,10 +70,11 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
+	printk(KERN_INFO "Free swap:       %6ldkB\n",
+	       nr_swap_pages<<(PAGE_SHIFT-10));
 
 	for_each_online_pgdat(pgdat) {
-               for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			/* this loop can take a while with 256 GB and 4k pages
 			   so update the NMI watchdog */
 			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
@@ -89,7 +90,7 @@ void show_mem(void)
 				cached++;
 			else if (page_count(page))
 				shared += page_count(page) - 1;
-               }
+		}
 	}
 	printk(KERN_INFO "%lu pages of RAM\n", total);
 	printk(KERN_INFO "%lu reserved pages\n",reserved);
@@ -100,21 +101,22 @@ void show_mem(void)
 int after_bootmem;
 
 static __init void *spp_getpage(void)
-{ 
+{
 	void *ptr;
 	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC); 
+		ptr = (void *) get_zeroed_page(GFP_ATOMIC);
 	else
 		ptr = alloc_bootmem_pages(PAGE_SIZE);
 	if (!ptr || ((unsigned long)ptr & ~PAGE_MASK))
-		panic("set_pte_phys: cannot allocate page data %s\n", after_bootmem?"after bootmem":"");
+		panic("set_pte_phys: cannot allocate page data %s\n",
+		      after_bootmem?"after bootmem":"");
 
 	Dprintk("spp_getpage %p\n", ptr);
 	return ptr;
-} 
+}
 
 static __init void set_pte_phys(unsigned long vaddr,
-			 unsigned long phys, pgprot_t prot)
+				unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -130,10 +132,11 @@ static __init void set_pte_phys(unsigned long vaddr,
 	}
 	pud = pud_offset(pgd, vaddr);
 	if (pud_none(*pud)) {
-		pmd = (pmd_t *) spp_getpage(); 
+		pmd = (pmd_t *) spp_getpage();
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE | _PAGE_USER));
 		if (pmd != pmd_offset(pud, 0)) {
-			printk("PAGETABLE BUG #01! %p <-> %p\n", pmd, pmd_offset(pud,0));
+			printk("PAGETABLE BUG #01! %p <-> %p\n", pmd,
+			       pmd_offset(pud,0));
 			return;
 		}
 	}
@@ -162,7 +165,7 @@ static __init void set_pte_phys(unsigned long vaddr,
 }
 
 /* NOTE: this is meant to be run only at boot */
-void __init 
+void __init
 __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
 {
 	unsigned long address = __fix_to_virt(idx);
@@ -177,7 +180,7 @@ __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
 unsigned long __meminitdata table_start, table_end;
 
 static __meminit void *alloc_low_page(unsigned long *phys)
-{ 
+{
 	unsigned long pfn = table_end++;
 	void *adr;
 
@@ -187,8 +190,8 @@ static __meminit void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= end_pfn) 
-		panic("alloc_low_page: ran out of memory"); 
+	if (pfn >= end_pfn)
+		panic("alloc_low_page: ran out of memory");
 
 	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
 	memset(adr, 0, PAGE_SIZE);
@@ -197,13 +200,13 @@ static __meminit void *alloc_low_page(unsigned long *phys)
 }
 
 static __meminit void unmap_low_page(void *adr)
-{ 
+{
 
 	if (after_bootmem)
 		return;
 
 	early_iounmap(adr, PAGE_SIZE);
-} 
+}
 
 /* Must run before zap_low_mappings */
 __meminit void *early_ioremap(unsigned long addr, unsigned long size)
@@ -224,7 +227,8 @@ __meminit void *early_ioremap(unsigned long addr, unsigned long size)
 		vaddr += addr & ~PMD_MASK;
 		addr &= PMD_MASK;
 		for (i = 0; i < pmds; i++, addr += PMD_SIZE)
-			set_pmd(pmd + i,__pmd(addr | _KERNPG_TABLE | _PAGE_PSE));
+			set_pmd(pmd + i,
+				__pmd(addr | _KERNPG_TABLE | _PAGE_PSE));
 		__flush_tlb();
 		return (void *)vaddr;
 	next:
@@ -284,8 +288,9 @@ phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
 	__flush_tlb_all();
 }
 
-static void __meminit phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
-{ 
+static void __meminit phys_pud_init(pud_t *pud_page, unsigned long addr,
+				    unsigned long end)
+{
 	int i = pud_index(addr);
 
 
@@ -298,9 +303,9 @@ static void __meminit phys_pud_init(pud_t *pud_page, unsigned long addr, unsigne
 			break;
 
 		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
-			set_pud(pud, __pud(0)); 
+			set_pud(pud, __pud(0));
 			continue;
-		} 
+		}
 
 		if (pud_val(*pud)) {
 			phys_pmd_update(pud, addr, end);
@@ -315,7 +320,7 @@ static void __meminit phys_pud_init(pud_t *pud_page, unsigned long addr, unsigne
 		unmap_low_page(pmd);
 	}
 	__flush_tlb();
-} 
+}
 
 static void __init find_early_table_space(unsigned long end)
 {
@@ -324,13 +329,13 @@ static void __init find_early_table_space(unsigned long end)
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE) +
-		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+		round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
 
- 	/* RED-PEN putting page tables only on node 0 could
- 	   cause a hotspot and fill up ZONE_DMA. The page tables
- 	   need roughly 0.5KB per GB. */
- 	start = 0x8000;
- 	table_start = find_e820_area(start, end, tables);
+	/* RED-PEN putting page tables only on node 0 could
+	   cause a hotspot and fill up ZONE_DMA. The page tables
+	   need roughly 0.5KB per GB. */
+	start = 0x8000;
+	table_start = find_e820_area(start, end, tables);
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
@@ -338,24 +343,24 @@ static void __init find_early_table_space(unsigned long end)
 	table_end = table_start;
 
 	early_printk("kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, table_start << PAGE_SHIFT,
-		(table_start << PAGE_SHIFT) + tables);
+		     end, table_start << PAGE_SHIFT,
+		     (table_start << PAGE_SHIFT) + tables);
 }
 
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
-   This runs before bootmem is initialized and gets pages directly from the 
+   This runs before bootmem is initialized and gets pages directly from the
    physical memory. To access them they are temporarily mapped. */
 void __meminit init_memory_mapping(unsigned long start, unsigned long end)
-{ 
-	unsigned long next; 
+{
+	unsigned long next;
 
 	Dprintk("init_memory_mapping\n");
 
-	/* 
-	 * Find space for the kernel direct mapping tables.
-	 * Later we should allocate these tables in the local node of the memory
-	 * mapped.  Unfortunately this is done currently before the nodes are 
-	 * discovered.
+	/*
+	 * Find space for the kernel direct mapping tables.  Later we
+	 * should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before
+	 * the nodes are discovered.
 	 */
 	if (!after_bootmem)
 		find_early_table_space(end);
@@ -364,7 +369,7 @@ void __meminit init_memory_mapping(unsigned long start, unsigned long end)
 	end = (unsigned long)__va(end);
 
 	for (; start < end; start = next) {
-		unsigned long pud_phys; 
+		unsigned long pud_phys;
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
@@ -374,13 +379,13 @@ void __meminit init_memory_mapping(unsigned long start, unsigned long end)
 			pud = alloc_low_page(&pud_phys);
 
 		next = start + PGDIR_SIZE;
-		if (next > end) 
-			next = end; 
+		if (next > end)
+			next = end;
 		phys_pud_init(pud, __pa(start), __pa(next));
 		if (!after_bootmem)
 			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
-	} 
+	}
 
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
@@ -402,18 +407,20 @@ void __init paging_init(void)
 }
 #endif
 
-/* Unmap a kernel mapping if it exists. This is useful to avoid prefetches
-   from the CPU leading to inconsistent cache lines. address and size
-   must be aligned to 2MB boundaries. 
-   Does nothing when the mapping doesn't exist. */
-void __init clear_kernel_mapping(unsigned long address, unsigned long size) 
+/*
+ * Unmap a kernel mapping if it exists. This is useful to avoid
+ * prefetches from the CPU leading to inconsistent cache
+ * lines. address and size must be aligned to 2MB boundaries.  Does
+ * nothing when the mapping doesn't exist.
+ */
+void __init clear_kernel_mapping(unsigned long address, unsigned long size)
 {
 	unsigned long end = address + size;
 
 	BUG_ON(address & ~LARGE_PAGE_MASK);
-	BUG_ON(size & ~LARGE_PAGE_MASK); 
-	
-	for (; address < end; address += LARGE_PAGE_SIZE) { 
+	BUG_ON(size & ~LARGE_PAGE_MASK);
+
+	for (; address < end; address += LARGE_PAGE_SIZE) {
 		pgd_t *pgd = pgd_offset_k(address);
 		pud_t *pud;
 		pmd_t *pmd;
@@ -421,20 +428,23 @@ void __init clear_kernel_mapping(unsigned long address, unsigned long size)
 			continue;
 		pud = pud_offset(pgd, address);
 		if (pud_none(*pud))
-			continue; 
+			continue;
 		pmd = pmd_offset(pud, address);
 		if (!pmd || pmd_none(*pmd))
-			continue; 
-		if (0 == (pmd_val(*pmd) & _PAGE_PSE)) { 
-			/* Could handle this, but it should not happen currently. */
-			printk(KERN_ERR 
-	       "clear_kernel_mapping: mapping has been split. will leak memory\n"); 
-			pmd_ERROR(*pmd); 
+			continue;
+		if (0 == (pmd_val(*pmd) & _PAGE_PSE)) {
+			/*
+			 * Could handle this, but it should not happen
+			 * currently.
+			 */
+			printk(KERN_ERR "clear_kernel_mapping: mapping has "
+			       "been split. will leak memory\n");
+			pmd_ERROR(*pmd);
 		}
-		set_pmd(pmd, __pmd(0)); 		
+		set_pmd(pmd, __pmd(0));
 	}
 	__flush_tlb_all();
-} 
+}
 
 /*
  * Memory hotplug specific functions
@@ -492,10 +502,11 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
 /*
- * Memory Hotadd without sparsemem. The mem_maps have been allocated in advance,
- * just online the pages.
+ * Memory Hotadd without sparsemem. The mem_maps have been allocated
+ * in advance, just online the pages.
  */
-int __add_pages(struct zone *z, unsigned long start_pfn, unsigned long nr_pages)
+int __add_pages(struct zone *z, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
 	int err = -EIO;
 	unsigned long pfn;
@@ -539,7 +550,7 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 #endif
 	reservedpages = end_pfn - totalram_pages -
-					absent_pages_in_range(0, end_pfn);
+		absent_pages_in_range(0, end_pfn);
 
 	after_bootmem = 1;
 
@@ -548,21 +559,22 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT); 
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START, 
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START);
 	kclist_add(&kcore_kernel, &_stext, _end - _stext);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN);
-	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START, 
-				 VSYSCALL_END - VSYSCALL_START);
-
-	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, %ldk data, %ldk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		end_pfn << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10);
+	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
+		   VSYSCALL_END - VSYSCALL_START);
+
+	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
+	       "%ldk data, %ldk init)\n",
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       end_pfn << (PAGE_SHIFT-10),
+	       codesize >> 10,
+	       reservedpages << (PAGE_SHIFT-10),
+	       datasize >> 10,
+	       initsize >> 10);
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
@@ -609,14 +621,15 @@ void mark_rodata_ro(void)
 #ifdef CONFIG_KPROBES
 	start = (unsigned long)__start_rodata;
 #endif
-	
+
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;
 	if (end <= start)
 		return;
 
-	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT,
+			      PAGE_KERNEL_RO);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -638,8 +651,8 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void __init reserve_bootmem_generic(unsigned long phys, unsigned len) 
-{ 
+void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
+{
 #ifdef CONFIG_NUMA
 	int nid = phys_to_nid(phys);
 #endif
@@ -656,9 +669,9 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
-  	reserve_bootmem_node(NODE_DATA(nid), phys, len);
-#else       		
-	reserve_bootmem(phys, len);    
+	reserve_bootmem_node(NODE_DATA(nid), phys, len);
+#else
+	reserve_bootmem(phys, len);
 #endif
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
@@ -666,24 +679,24 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 	}
 }
 
-int kern_addr_valid(unsigned long addr) 
-{ 
+int kern_addr_valid(unsigned long addr)
+{
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
-		return 0; 
-	
+		return 0;
+
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd))
 		return 0;
 
 	pud = pud_offset(pgd, addr);
 	if (pud_none(*pud))
-		return 0; 
+		return 0;
 
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
@@ -737,7 +750,7 @@ int in_gate_area_no_task(unsigned long addr)
 void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
-			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+				    SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
 }
 
 const char *arch_vma_name(struct vm_area_struct *vma)


