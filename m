Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYJJRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYJJRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbYJJRmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:42:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993AbYJJRl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:41:57 -0400
Date: Fri, 10 Oct 2008 19:41:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2] x86 updates for v2.6.28, phase #2 - PAT updates
Message-ID: <20081010174131.GA8806@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010170426.GA5947@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010170426.GA5947@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in other words, this linear commit range:

abfae7f6: Revert "x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot"
f279399: Revert "x86, cpa: remove USER permission from the very early identity mapping attribute"
153eb23: Revert "x86, cpa: make the kernel physical mapping initialization a two pass sequence"
f5c3489: Revert "x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC"
c613e65: Revert "x86, cpa: fix taking the pgd_lock with interrupts off"
e64b1f1: Revert "x86, cpa: remove cpa pool code"
94448e3: Revert "x86, cpa: global flush tlb after splitting large page and before doing cpa"
aca9b5f: Revert "x86: track memtype for RAM in page struct"
6375b67: Revert "x86: handle error returns in set_memory_*()"
6b5b551: x86: handle error returns in set_memory_*()
5f25f5b: x86: track memtype for RAM in page struct
3196625: x86, cpa: global flush tlb after splitting large page and before doing cpa
79abc89: x86, cpa: remove cpa pool code
e96d59b: x86, cpa: fix taking the pgd_lock with interrupts off
888fdd9: x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
e579af6: x86, cpa: make the kernel physical mapping initialization a two pass sequence
c86eefc: x86, cpa: remove USER permission from the very early identity mapping attribute
e8729a5: x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot

is a NOP, "git diff f81b691..abfae7f6" comes up empty. So it carries 
nothing other than the information that this series was broken. (and 
even that is not very apparent)

So ... i've created a new branch, tip/x86/pat2 for the cleaned up 
history and we'll retire the contents of tip/x86/pat later on once we 
are sure it has no value. (other than for it to be a permanent 
embarrassment for me, which i'm totally fine with to destroy)

i merged your latest tree to tip/x86/pat and compared that to pat2, and 
the difference is zero:

  earth4:~/tip> git diff x86/pat x86/pat2
  earth4:~/tip>

which is the expected result.

i'll re-roll the seven x86-v28-for-linus-phase3...phase10 trees as well.

Find below the updated pull request.

Another question i was thinking about: the x86-v28-for-linus-phase2-B 
kind of branch names sound a bit artificial to pull. But i definitely 
needed them to be cleanly enumerated to be able to test through every 
step (we did serious boot testing of every phase) and to be able to keep 
track of everything.

	Ingo

-------------->
Linus,

Please pull the latest x86-v28-for-linus-phase2-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase2-B


out-of-topic modifications in x86-v28-for-linus-phase2-B:
---------------------------------------------------------
drivers/char/agp/agp.h             # bd07928: agp: add agp_generic_destroy_page
                                   # 37acee1: agp: generic_alloc_pages()
                                   # 9326d61: Revert "reduce tlb/cache flush ti
                                   # 466ae83: reduce tlb/cache flush times of a
drivers/char/agp/alpha-agp.c       # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/amd-k7-agp.c      # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/amd64-agp.c       # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/ati-agp.c         # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/efficeon-agp.c    # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/generic.c         # bd07928: agp: add agp_generic_destroy_page
                                   # 37acee1: agp: generic_alloc_pages()
                                   # 9326d61: Revert "reduce tlb/cache flush ti
                                   # 466ae83: reduce tlb/cache flush times of a
drivers/char/agp/hp-agp.c          # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/i460-agp.c        # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/intel-agp.c       # bd07928: agp: add agp_generic_destroy_page
                                   # 37acee1: agp: generic_alloc_pages()
drivers/char/agp/nvidia-agp.c      # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/parisc-agp.c      # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/sis-agp.c         # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/sworks-agp.c      # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/uninorth-agp.c    # c09ff7e: linux-next: fix x86 tree build fa
                                   # 5f310b6: agp: enable optimized agp_alloc_p
drivers/char/agp/via-agp.c         # 5f310b6: agp: enable optimized agp_alloc_p
mm/highmem.c                       # 5843d9a: x86, pat: avoid highmem cache att

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: compile pat debugfs interface only if CONFIG_X86_PAT is set

Ingo Molnar (3):
      Revert "reduce tlb/cache flush times of agpgart memory allocation"
      Revert "introduce two APIs for page attribute"
      x86, pat: cleanups

Jeremy Fitzhardinge (1):
      x86: make sure the CPA test code's use of _PAGE_UNUSED1 is obvious

Nick Piggin (1):
      x86, pat: avoid highmem cache attribute aliasing

Rene Herman (3):
      x86: {reverve,free}_memtype() take a physical address
      x86: have set_memory_array_{uc,wb} coalesce memtypes.
      agp: enable optimized agp_alloc_pages methods

Shaohua Li (6):
      introduce two APIs for page attribute
      reduce tlb/cache flush times of agpgart memory allocation
      x86, pageattr: introduce APIs to change pageattr of a page array
      agp: generic_alloc_pages()
      agp: add agp_generic_destroy_pages()
      x86: fix pageattr-test

Stephen Rothwell (1):
      linux-next: fix x86 tree build failure

Suresh Siddha (10):
      x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
      x86, cpa: remove USER permission from the very early identity mapping attribute
      x86, cpa: make the kernel physical mapping initialization a two pass sequence
      x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
      x86, cpa: no need to check alias for __set_pages_p/__set_pages_np
      x86, cpa: remove cpa pool code
      x86, cpa: srlz cpa(), global flush tlb after splitting big page and before doing cpa
      x86: track memtype for RAM in page struct
      x86: fix pagetable init 64-bit breakage
      x86, cpa: make the kernel physical mapping initialization a two pass sequence, fix

Venki Pallipadi (1):
      x86: have set_memory_array_{uc,wb} coalesce memtypes, fix


 arch/x86/kernel/head_32.S       |   34 ++--
 arch/x86/kernel/head_64.S       |    4 +-
 arch/x86/mm/init_32.c           |   84 +++++++-
 arch/x86/mm/init_64.c           |  110 +++++++---
 arch/x86/mm/ioremap.c           |   19 ++
 arch/x86/mm/pageattr-test.c     |    9 +-
 arch/x86/mm/pageattr.c          |  459 +++++++++++++++++++++------------------
 arch/x86/mm/pat.c               |  132 +++++++++---
 drivers/char/agp/agp.h          |    5 +
 drivers/char/agp/alpha-agp.c    |    2 +
 drivers/char/agp/amd-k7-agp.c   |    2 +
 drivers/char/agp/amd64-agp.c    |    2 +
 drivers/char/agp/ati-agp.c      |    2 +
 drivers/char/agp/efficeon-agp.c |    2 +
 drivers/char/agp/generic.c      |   97 ++++++++-
 drivers/char/agp/hp-agp.c       |    2 +
 drivers/char/agp/i460-agp.c     |    2 +
 drivers/char/agp/intel-agp.c    |   28 +++
 drivers/char/agp/nvidia-agp.c   |    2 +
 drivers/char/agp/parisc-agp.c   |    2 +
 drivers/char/agp/sis-agp.c      |    2 +
 drivers/char/agp/sworks-agp.c   |    2 +
 drivers/char/agp/uninorth-agp.c |    4 +
 drivers/char/agp/via-agp.c      |    4 +
 include/asm-x86/cacheflush.h    |    7 +-
 include/asm-x86/page.h          |    1 +
 include/asm-x86/pgtable.h       |   13 +
 mm/highmem.c                    |    5 +-
 28 files changed, 730 insertions(+), 307 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index a7010c3..e835b4e 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -172,10 +172,6 @@ num_subarch_entries = (. - subarch_entries) / 4
  *
  * Note that the stack is not yet set up!
  */
-#define PTE_ATTR	0x007		/* PRESENT+RW+USER */
-#define PDE_ATTR	0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
-#define PGD_ATTR	0x001		/* PRESENT (no other attributes) */
-
 default_entry:
 #ifdef CONFIG_X86_PAE
 
@@ -196,9 +192,9 @@ default_entry:
 	movl $pa(pg0), %edi
 	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_pmd), %edx
-	movl $PTE_ATTR, %eax
+	movl $PTE_IDENT_ATTR, %eax
 10:
-	leal PDE_ATTR(%edi),%ecx		/* Create PMD entry */
+	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PMD entry */
 	movl %ecx,(%edx)			/* Store PMD entry */
 						/* Upper half already zero */
 	addl $8,%edx
@@ -215,7 +211,7 @@ default_entry:
 	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
 	 * bytes beyond the end of our own page tables.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
+	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
@@ -224,7 +220,7 @@ default_entry:
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
 	movl %eax,pa(swapper_pg_pmd+0x1000*KPMDS-8)
 #else	/* Not PAE */
 
@@ -233,9 +229,9 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl $pa(pg0), %edi
 	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_dir), %edx
-	movl $PTE_ATTR, %eax
+	movl $PTE_IDENT_ATTR, %eax
 10:
-	leal PDE_ATTR(%edi),%ecx		/* Create PDE entry */
+	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PDE entry */
 	movl %ecx,(%edx)			/* Store identity PDE entry */
 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
 	addl $4,%edx
@@ -249,7 +245,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	 * bytes beyond the end of our own page tables; the +0x007 is
 	 * the attribute bits
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
+	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
 	movl %edi,pa(init_pg_tables_end)
@@ -257,7 +253,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
 	movl %eax,pa(swapper_pg_dir+0xffc)
 #endif
 	jmp 3f
@@ -634,19 +630,19 @@ ENTRY(empty_zero_page)
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0		/* low identity map */
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
 # if KPMDS == 3
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x1000),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x2000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x2000),0
 # elif KPMDS == 2
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_ATTR+0x1000),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
 # elif KPMDS == 1
 	.long	0,0
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_ATTR),0
+	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index db3280a..26cfdc1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -110,7 +110,7 @@ startup_64:
 	movq	%rdi, %rax
 	shrq	$PMD_SHIFT, %rax
 	andq	$(PTRS_PER_PMD - 1), %rax
-	leaq	__PAGE_KERNEL_LARGE_EXEC(%rdi), %rdx
+	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
 	leaq	level2_spare_pgt(%rip), %rbx
 	movq	%rdx, 0(%rbx, %rax, 8)
 ident_complete:
@@ -374,7 +374,7 @@ NEXT_PAGE(level2_ident_pgt)
 	/* Since I easily can, map the first 1G.
 	 * Don't set NX because code runs from these pages.
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
+	PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
 	/*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 6b9a935..c3789bb 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -195,11 +195,30 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte;
-	unsigned pages_2m = 0, pages_4k = 0;
+	unsigned pages_2m, pages_4k;
+	int mapping_iter;
+
+	/*
+	 * First iteration will setup identity mapping using large/small pages
+	 * based on use_pse, with other attributes same as set by
+	 * the early code in head_32.S
+	 *
+	 * Second iteration will setup the appropriate attributes (NX, GLOBAL..)
+	 * as desired for the kernel identity mapping.
+	 *
+	 * This two pass mechanism conforms to the TLB app note which says:
+	 *
+	 *     "Software should not write to a paging-structure entry in a way
+	 *      that would change, for any linear address, both the page size
+	 *      and either the page frame or attributes."
+	 */
+	mapping_iter = 1;
 
 	if (!cpu_has_pse)
 		use_pse = 0;
 
+repeat:
+	pages_2m = pages_4k = 0;
 	pfn = start_pfn;
 	pgd_idx = pgd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
@@ -225,6 +244,13 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
 			if (use_pse) {
 				unsigned int addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
+				/*
+				 * first pass will use the same initial
+				 * identity mapping attribute + _PAGE_PSE.
+				 */
+				pgprot_t init_prot =
+					__pgprot(PTE_IDENT_ATTR |
+						 _PAGE_PSE);
 
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
@@ -234,7 +260,10 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				pages_2m++;
-				set_pmd(pmd, pfn_pmd(pfn, prot));
+				if (mapping_iter == 1)
+					set_pmd(pmd, pfn_pmd(pfn, init_prot));
+				else
+					set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
 				continue;
@@ -246,17 +275,43 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
 			for (; pte_ofs < PTRS_PER_PTE && pfn < end_pfn;
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
+				/*
+				 * first pass will use the same initial
+				 * identity mapping attribute.
+				 */
+				pgprot_t init_prot = __pgprot(PTE_IDENT_ATTR);
 
 				if (is_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
-				set_pte(pte, pfn_pte(pfn, prot));
+				if (mapping_iter == 1)
+					set_pte(pte, pfn_pte(pfn, init_prot));
+				else
+					set_pte(pte, pfn_pte(pfn, prot));
 			}
 		}
 	}
-	update_page_count(PG_LEVEL_2M, pages_2m);
-	update_page_count(PG_LEVEL_4K, pages_4k);
+	if (mapping_iter == 1) {
+		/*
+		 * update direct mapping page count only in the first
+		 * iteration.
+		 */
+		update_page_count(PG_LEVEL_2M, pages_2m);
+		update_page_count(PG_LEVEL_4K, pages_4k);
+
+		/*
+		 * local global flush tlb, which will flush the previous
+		 * mappings present in both small and large page TLB's.
+		 */
+		__flush_tlb_all();
+
+		/*
+		 * Second iteration will set the actual desired PTE attributes.
+		 */
+		mapping_iter = 2;
+		goto repeat;
+	}
 }
 
 /*
@@ -719,7 +774,7 @@ void __init setup_bootmem_allocator(void)
 	after_init_bootmem = 1;
 }
 
-static void __init find_early_table_space(unsigned long end)
+static void __init find_early_table_space(unsigned long end, int use_pse)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
@@ -729,7 +784,7 @@ static void __init find_early_table_space(unsigned long end)
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
 
-	if (cpu_has_pse) {
+	if (use_pse) {
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
@@ -769,12 +824,22 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long start_pfn, end_pfn;
 	unsigned long big_page_start;
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	int use_pse = 0;
+#else
+	int use_pse = cpu_has_pse;
+#endif
 
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 */
 	if (!after_init_bootmem)
-		find_early_table_space(end);
+		find_early_table_space(end, use_pse);
 
 #ifdef CONFIG_X86_PAE
 	set_nx();
@@ -820,7 +885,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
 	if (start_pfn < end_pfn)
 		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
-						cpu_has_pse);
+					     use_pse);
 
 	/* tail is not big page alignment ? */
 	start_pfn = end_pfn;
@@ -983,7 +1048,6 @@ void __init mem_init(void)
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
-	cpa_init();
 	save_pg_dir();
 	zap_low_mappings();
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 770536e..fb30486 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -271,7 +271,8 @@ static __ref void unmap_low_page(void *adr)
 }
 
 static unsigned long __meminit
-phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
+phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
+	      pgprot_t prot)
 {
 	unsigned pages = 0;
 	unsigned long last_map_addr = end;
@@ -289,36 +290,43 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
 			break;
 		}
 
+		/*
+		 * We will re-use the existing mapping.
+		 * Xen for example has some special requirements, like mapping
+		 * pagetable pages as RO. So assume someone who pre-setup
+		 * these mappings are more intelligent.
+		 */
 		if (pte_val(*pte))
 			continue;
 
 		if (0)
 			printk("   pte=%p addr=%lx pte=%016lx\n",
 			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
-		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
-		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
 		pages++;
+		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, prot));
+		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
 	}
+
 	update_page_count(PG_LEVEL_4K, pages);
 
 	return last_map_addr;
 }
 
 static unsigned long __meminit
-phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end)
+phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end,
+		pgprot_t prot)
 {
 	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
 
-	return phys_pte_init(pte, address, end);
+	return phys_pte_init(pte, address, end, prot);
 }
 
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
-			 unsigned long page_size_mask)
+	      unsigned long page_size_mask, pgprot_t prot)
 {
 	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
-	unsigned long start = address;
 
 	int i = pmd_index(address);
 
@@ -326,6 +334,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
+		pgprot_t new_prot = prot;
 
 		if (address >= end) {
 			if (!after_bootmem) {
@@ -339,27 +348,40 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
 				last_map_addr = phys_pte_update(pmd, address,
-								end);
+								end, prot);
 				spin_unlock(&init_mm.page_table_lock);
+				continue;
 			}
-			/* Count entries we're using from level2_ident_pgt */
-			if (start == 0)
-				pages++;
-			continue;
+			/*
+			 * If we are ok with PG_LEVEL_2M mapping, then we will
+			 * use the existing mapping,
+			 *
+			 * Otherwise, we will split the large page mapping but
+			 * use the same existing protection bits except for
+			 * large page, so that we don't violate Intel's TLB
+			 * Application note (317080) which says, while changing
+			 * the page sizes, new and old translations should
+			 * not differ with respect to page frame and
+			 * attributes.
+			 */
+			if (page_size_mask & (1 << PG_LEVEL_2M))
+				continue;
+			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
-				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+				pfn_pte(address >> PAGE_SHIFT,
+					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
 			continue;
 		}
 
 		pte = alloc_low_page(&pte_phys);
-		last_map_addr = phys_pte_init(pte, address, end);
+		last_map_addr = phys_pte_init(pte, address, end, new_prot);
 		unmap_low_page(pte);
 
 		spin_lock(&init_mm.page_table_lock);
@@ -372,12 +394,12 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 static unsigned long __meminit
 phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
-			 unsigned long page_size_mask)
+		unsigned long page_size_mask, pgprot_t prot)
 {
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long last_map_addr;
 
-	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask);
+	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask, prot);
 	__flush_tlb_all();
 	return last_map_addr;
 }
@@ -394,6 +416,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		unsigned long pmd_phys;
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
+		pgprot_t prot = PAGE_KERNEL;
 
 		if (addr >= end)
 			break;
@@ -405,10 +428,26 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		}
 
 		if (pud_val(*pud)) {
-			if (!pud_large(*pud))
+			if (!pud_large(*pud)) {
 				last_map_addr = phys_pmd_update(pud, addr, end,
-							 page_size_mask);
-			continue;
+							 page_size_mask, prot);
+				continue;
+			}
+			/*
+			 * If we are ok with PG_LEVEL_1G mapping, then we will
+			 * use the existing mapping.
+			 *
+			 * Otherwise, we will split the gbpage mapping but use
+			 * the same existing protection  bits except for large
+			 * page, so that we don't violate Intel's TLB
+			 * Application note (317080) which says, while changing
+			 * the page sizes, new and old translations should
+			 * not differ with respect to page frame and
+			 * attributes.
+			 */
+			if (page_size_mask & (1 << PG_LEVEL_1G))
+				continue;
+			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
@@ -422,7 +461,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		}
 
 		pmd = alloc_low_page(&pmd_phys);
-		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask);
+		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
+					      prot);
 		unmap_low_page(pmd);
 
 		spin_lock(&init_mm.page_table_lock);
@@ -430,6 +470,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		spin_unlock(&init_mm.page_table_lock);
 	}
 	__flush_tlb_all();
+
 	update_page_count(PG_LEVEL_1G, pages);
 
 	return last_map_addr;
@@ -446,13 +487,14 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-static void __init find_early_table_space(unsigned long end)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-	if (direct_gbpages) {
+	if (use_gbpages) {
 		unsigned long extra;
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
@@ -460,7 +502,7 @@ static void __init find_early_table_space(unsigned long end)
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
-	if (cpu_has_pse) {
+	if (use_pse) {
 		unsigned long extra;
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -528,6 +570,7 @@ static unsigned long __init kernel_physical_mapping_init(unsigned long start,
 		pgd_populate(&init_mm, pgd, __va(pud_phys));
 		spin_unlock(&init_mm.page_table_lock);
 	}
+	__flush_tlb_all();
 
 	return last_map_addr;
 }
@@ -571,6 +614,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
+	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping\n");
 
@@ -584,9 +628,21 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		init_gbpages();
 
-	if (direct_gbpages)
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	use_pse = use_gbpages = 0;
+#else
+	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
+#endif
+
+	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (cpu_has_pse)
+	if (use_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
 	memset(mr, 0, sizeof(mr));
@@ -647,7 +703,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
 	if (!after_bootmem)
-		find_early_table_space(end);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		last_map_addr = kernel_physical_mapping_init(
@@ -806,8 +862,6 @@ void __init mem_init(void)
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
-
-	cpa_init();
 }
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index cac6da5..6ab3196 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -83,6 +83,25 @@ int page_is_ram(unsigned long pagenr)
 	return 0;
 }
 
+int pagerange_is_ram(unsigned long start, unsigned long end)
+{
+	int ram_page = 0, not_rampage = 0;
+	unsigned long page_nr;
+
+	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
+	     ++page_nr) {
+		if (page_is_ram(page_nr))
+			ram_page = 1;
+		else
+			not_rampage = 1;
+
+		if (ram_page == not_rampage)
+			return -1;
+	}
+
+	return ram_page;
+}
+
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index d4aa503..e1d1069 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -32,7 +32,7 @@ enum {
 	GPS			= (1<<30)
 };
 
-#define PAGE_TESTBIT	__pgprot(_PAGE_UNUSED1)
+#define PAGE_CPA_TEST	__pgprot(_PAGE_CPA_TEST)
 
 static int pte_testbit(pte_t pte)
 {
@@ -118,6 +118,7 @@ static int pageattr_test(void)
 	unsigned int level;
 	int i, k;
 	int err;
+	unsigned long test_addr;
 
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
@@ -172,7 +173,8 @@ static int pageattr_test(void)
 			continue;
 		}
 
-		err = change_page_attr_set(addr[i], len[i], PAGE_TESTBIT);
+		test_addr = addr[i];
+		err = change_page_attr_set(&test_addr, len[i], PAGE_CPA_TEST, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
@@ -204,7 +206,8 @@ static int pageattr_test(void)
 			failed++;
 			continue;
 		}
-		err = change_page_attr_clear(addr[i], len[i], PAGE_TESTBIT);
+		test_addr = addr[i];
+		err = change_page_attr_clear(&test_addr, len[i], PAGE_CPA_TEST, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);
 			failed++;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 898fad6..a9ec89c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -25,15 +25,27 @@
  * The current flushing context - we pass it instead of 5 arguments:
  */
 struct cpa_data {
-	unsigned long	vaddr;
+	unsigned long	*vaddr;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		flushtlb;
+	int		flags;
 	unsigned long	pfn;
 	unsigned	force_split : 1;
+	int		curpage;
 };
 
+/*
+ * Serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity mappings)
+ * using cpa_lock. So that we don't allow any other cpu, with stale large tlb
+ * entries change the page attribute in parallel to some other cpu
+ * splitting a large page entry along with changing the attribute.
+ */
+static DEFINE_SPINLOCK(cpa_lock);
+
+#define CPA_FLUSHTLB 1
+#define CPA_ARRAY 2
+
 #ifdef CONFIG_PROC_FS
 static unsigned long direct_pages_count[PG_LEVEL_NUM];
 
@@ -190,6 +202,41 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
+static void cpa_flush_array(unsigned long *start, int numpages, int cache)
+{
+	unsigned int i, level;
+	unsigned long *addr;
+
+	BUG_ON(irqs_disabled());
+
+	on_each_cpu(__cpa_flush_range, NULL, 1);
+
+	if (!cache)
+		return;
+
+	/* 4M threshold */
+	if (numpages >= 1024) {
+		if (boot_cpu_data.x86_model >= 4)
+			wbinvd();
+		return;
+	}
+	/*
+	 * We only need to flush on one CPU,
+	 * clflush is a MESI-coherent instruction that
+	 * will cause all other CPUs to flush the same
+	 * cachelines:
+	 */
+	for (i = 0, addr = start; i < numpages; i++, addr++) {
+		pte_t *pte = lookup_address(*addr, &level);
+
+		/*
+		 * Only flush present addresses:
+		 */
+		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
+			clflush_cache_range((void *) *addr, PAGE_SIZE);
+	}
+}
+
 /*
  * Certain areas of memory on x86 require very specific protection flags,
  * for example the BIOS area or kernel text. Callers don't always get this
@@ -398,7 +445,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 		 */
 		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
 		__set_pmd_pte(kpte, address, new_pte);
-		cpa->flushtlb = 1;
+		cpa->flags |= CPA_FLUSHTLB;
 		do_split = 0;
 	}
 
@@ -408,84 +455,6 @@ out_unlock:
 	return do_split;
 }
 
-static LIST_HEAD(page_pool);
-static unsigned long pool_size, pool_pages, pool_low;
-static unsigned long pool_used, pool_failed;
-
-static void cpa_fill_pool(struct page **ret)
-{
-	gfp_t gfp = GFP_KERNEL;
-	unsigned long flags;
-	struct page *p;
-
-	/*
-	 * Avoid recursion (on debug-pagealloc) and also signal
-	 * our priority to get to these pagetables:
-	 */
-	if (current->flags & PF_MEMALLOC)
-		return;
-	current->flags |= PF_MEMALLOC;
-
-	/*
-	 * Allocate atomically from atomic contexts:
-	 */
-	if (in_atomic() || irqs_disabled() || debug_pagealloc)
-		gfp =  GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
-
-	while (pool_pages < pool_size || (ret && !*ret)) {
-		p = alloc_pages(gfp, 0);
-		if (!p) {
-			pool_failed++;
-			break;
-		}
-		/*
-		 * If the call site needs a page right now, provide it:
-		 */
-		if (ret && !*ret) {
-			*ret = p;
-			continue;
-		}
-		spin_lock_irqsave(&pgd_lock, flags);
-		list_add(&p->lru, &page_pool);
-		pool_pages++;
-		spin_unlock_irqrestore(&pgd_lock, flags);
-	}
-
-	current->flags &= ~PF_MEMALLOC;
-}
-
-#define SHIFT_MB		(20 - PAGE_SHIFT)
-#define ROUND_MB_GB		((1 << 10) - 1)
-#define SHIFT_MB_GB		10
-#define POOL_PAGES_PER_GB	16
-
-void __init cpa_init(void)
-{
-	struct sysinfo si;
-	unsigned long gb;
-
-	si_meminfo(&si);
-	/*
-	 * Calculate the number of pool pages:
-	 *
-	 * Convert totalram (nr of pages) to MiB and round to the next
-	 * GiB. Shift MiB to Gib and multiply the result by
-	 * POOL_PAGES_PER_GB:
-	 */
-	if (debug_pagealloc) {
-		gb = ((si.totalram >> SHIFT_MB) + ROUND_MB_GB) >> SHIFT_MB_GB;
-		pool_size = POOL_PAGES_PER_GB * gb;
-	} else {
-		pool_size = 1;
-	}
-	pool_low = pool_size;
-
-	cpa_fill_pool(NULL);
-	printk(KERN_DEBUG
-	       "CPA: page pool initialized %lu of %lu pages preallocated\n",
-	       pool_pages, pool_size);
-}
-
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
 	unsigned long flags, pfn, pfninc = 1;
@@ -494,28 +463,15 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	pgprot_t ref_prot;
 	struct page *base;
 
-	/*
-	 * Get a page from the pool. The pool list is protected by the
-	 * pgd_lock, which we have to take anyway for the split
-	 * operation:
-	 */
-	spin_lock_irqsave(&pgd_lock, flags);
-	if (list_empty(&page_pool)) {
-		spin_unlock_irqrestore(&pgd_lock, flags);
-		base = NULL;
-		cpa_fill_pool(&base);
-		if (!base)
-			return -ENOMEM;
-		spin_lock_irqsave(&pgd_lock, flags);
-	} else {
-		base = list_first_entry(&page_pool, struct page, lru);
-		list_del(&base->lru);
-		pool_pages--;
-
-		if (pool_pages < pool_low)
-			pool_low = pool_pages;
-	}
+	if (!debug_pagealloc)
+		spin_unlock(&cpa_lock);
+	base = alloc_pages(GFP_KERNEL, 0);
+	if (!debug_pagealloc)
+		spin_lock(&cpa_lock);
+	if (!base)
+		return -ENOMEM;
 
+	spin_lock_irqsave(&pgd_lock, flags);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -572,11 +528,8 @@ out_unlock:
 	 * If we dropped out via the lookup_address check under
 	 * pgd_lock then stick the page back into the pool:
 	 */
-	if (base) {
-		list_add(&base->lru, &page_pool);
-		pool_pages++;
-	} else
-		pool_used++;
+	if (base)
+		__free_page(base);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 
 	return 0;
@@ -584,11 +537,16 @@ out_unlock:
 
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
-	unsigned long address = cpa->vaddr;
+	unsigned long address;
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
+	if (cpa->flags & CPA_ARRAY)
+		address = cpa->vaddr[cpa->curpage];
+	else
+		address = *cpa->vaddr;
+
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -600,7 +558,7 @@ repeat:
 			return 0;
 		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       cpa->vaddr);
+		       *cpa->vaddr);
 		return -EINVAL;
 	}
 
@@ -626,7 +584,7 @@ repeat:
 		 */
 		if (pte_val(old_pte) != pte_val(new_pte)) {
 			set_pte_atomic(kpte, new_pte);
-			cpa->flushtlb = 1;
+			cpa->flags |= CPA_FLUSHTLB;
 		}
 		cpa->numpages = 1;
 		return 0;
@@ -650,7 +608,25 @@ repeat:
 	 */
 	err = split_large_page(kpte, address);
 	if (!err) {
-		cpa->flushtlb = 1;
+		/*
+	 	 * Do a global flush tlb after splitting the large page
+	 	 * and before we do the actual change page attribute in the PTE.
+	 	 *
+	 	 * With out this, we violate the TLB application note, that says
+	 	 * "The TLBs may contain both ordinary and large-page
+		 *  translations for a 4-KByte range of linear addresses. This
+		 *  may occur if software modifies the paging structures so that
+		 *  the page size used for the address range changes. If the two
+		 *  translations differ with respect to page frame or attributes
+		 *  (e.g., permissions), processor behavior is undefined and may
+		 *  be implementation-specific."
+	 	 *
+	 	 * We do this global tlb flush inside the cpa_lock, so that we
+		 * don't allow any other cpu, with stale tlb entries change the
+		 * page attribute in parallel, that also falls into the
+		 * just split large page entry.
+	 	 */
+		flush_tlb_all();
 		goto repeat;
 	}
 
@@ -663,6 +639,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	int ret = 0;
+	unsigned long temp_cpa_vaddr, vaddr;
 
 	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
@@ -675,16 +652,24 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!(within(cpa->vaddr, PAGE_OFFSET,
+	if (cpa->flags & CPA_ARRAY)
+		vaddr = cpa->vaddr[cpa->curpage];
+	else
+		vaddr = *cpa->vaddr;
+
+	if (!(within(vaddr, PAGE_OFFSET,
 		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
 #ifdef CONFIG_X86_64
-		|| within(cpa->vaddr, PAGE_OFFSET + (1UL<<32),
+		|| within(vaddr, PAGE_OFFSET + (1UL<<32),
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
 #endif
 	)) {
 
 		alias_cpa = *cpa;
-		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.flags &= ~CPA_ARRAY;
+
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 	}
@@ -696,7 +681,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
 		return 0;
 
 	/*
@@ -707,8 +692,9 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		return 0;
 
 	alias_cpa = *cpa;
-	alias_cpa.vaddr =
-		(cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	alias_cpa.vaddr = &temp_cpa_vaddr;
+	alias_cpa.flags &= ~CPA_ARRAY;
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -728,8 +714,15 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 * preservation check.
 		 */
 		cpa->numpages = numpages;
+		/* for array changes, we can't use large page */
+		if (cpa->flags & CPA_ARRAY)
+			cpa->numpages = 1;
 
+		if (!debug_pagealloc)
+			spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, checkalias);
+		if (!debug_pagealloc)
+			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
 
@@ -746,7 +739,11 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		cpa->vaddr += cpa->numpages * PAGE_SIZE;
+		if (cpa->flags & CPA_ARRAY)
+			cpa->curpage++;
+		else
+			*cpa->vaddr += cpa->numpages * PAGE_SIZE;
+
 	}
 	return 0;
 }
@@ -757,9 +754,9 @@ static inline int cache_attr(pgprot_t attr)
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
+static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split)
+				    int force_split, int array)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -774,21 +771,38 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (addr & ~PAGE_MASK) {
-		addr &= PAGE_MASK;
-		/*
-		 * People should not be passing in unaligned addresses:
-		 */
-		WARN_ON_ONCE(1);
+	if (!array) {
+		if (*addr & ~PAGE_MASK) {
+			*addr &= PAGE_MASK;
+			/*
+			 * People should not be passing in unaligned addresses:
+			 */
+			WARN_ON_ONCE(1);
+		}
+	} else {
+		int i;
+		for (i = 0; i < numpages; i++) {
+			if (addr[i] & ~PAGE_MASK) {
+				addr[i] &= PAGE_MASK;
+				WARN_ON_ONCE(1);
+			}
+		}
 	}
 
+	/* Must avoid aliasing mappings in the highmem code */
+	kmap_flush_unused();
+
 	cpa.vaddr = addr;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
-	cpa.flushtlb = 0;
+	cpa.flags = 0;
+	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
+	if (array)
+		cpa.flags |= CPA_ARRAY;
+
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
 
@@ -797,7 +811,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!cpa.flushtlb)
+	if (!(cpa.flags & CPA_FLUSHTLB))
 		goto out;
 
 	/*
@@ -812,27 +826,30 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	 * error case we fall back to cpa_flush_all (which uses
 	 * wbindv):
 	 */
-	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages, cache);
-	else
+	if (!ret && cpu_has_clflush) {
+		if (cpa.flags & CPA_ARRAY)
+			cpa_flush_array(addr, numpages, cache);
+		else
+			cpa_flush_range(*addr, numpages, cache);
+	} else
 		cpa_flush_all(cache);
 
 out:
-	cpa_fill_pool(NULL);
-
 	return ret;
 }
 
-static inline int change_page_attr_set(unsigned long addr, int numpages,
-				       pgprot_t mask)
+static inline int change_page_attr_set(unsigned long *addr, int numpages,
+				       pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0);
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
+		array);
 }
 
-static inline int change_page_attr_clear(unsigned long addr, int numpages,
-					 pgprot_t mask)
+static inline int change_page_attr_clear(unsigned long *addr, int numpages,
+					 pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
+		array);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
@@ -840,8 +857,8 @@ int _set_memory_uc(unsigned long addr, int numpages)
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC_MINUS));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
@@ -857,10 +874,48 @@ int set_memory_uc(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray)
+{
+	unsigned long start;
+	unsigned long end;
+	int i;
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
+	for (i = 0; i < addrinarray; i++) {
+		start = __pa(addr[i]);
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
+			goto out;
+	}
+
+	return change_page_attr_set(addr, addrinarray,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
+out:
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long tmp = __pa(addr[i]);
+
+		if (tmp == start)
+			break;
+		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(tmp, end);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(set_memory_array_uc);
+
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_WC), 0);
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
@@ -878,8 +933,8 @@ EXPORT_SYMBOL(set_memory_wc);
 
 int _set_memory_wb(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_CACHE_MASK));
+	return change_page_attr_clear(&addr, numpages,
+				      __pgprot(_PAGE_CACHE_MASK), 0);
 }
 
 int set_memory_wb(unsigned long addr, int numpages)
@@ -890,39 +945,59 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+int set_memory_array_wb(unsigned long *addr, int addrinarray)
+{
+	int i;
+
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long start = __pa(addr[i]);
+		unsigned long end;
+
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(start, end);
+	}
+	return change_page_attr_clear(addr, addrinarray,
+				      __pgprot(_PAGE_CACHE_MASK), 1);
+}
+EXPORT_SYMBOL(set_memory_array_wb);
+
 int set_memory_x(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_nx);
 
 int set_memory_ro(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 EXPORT_SYMBOL_GPL(set_memory_ro);
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 EXPORT_SYMBOL_GPL(set_memory_rw);
 
 int set_memory_np(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_PRESENT));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
 }
 
 int set_memory_4k(unsigned long addr, int numpages)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0),
-					__pgprot(0), 1);
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
+					__pgprot(0), 1, 0);
 }
 
 int set_pages_uc(struct page *page, int numpages)
@@ -975,22 +1050,38 @@ int set_pages_rw(struct page *page, int numpages)
 
 static int __set_pages_p(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long) page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
-				.mask_clr = __pgprot(0)};
+				.mask_clr = __pgprot(0),
+				.flags = 0};
 
-	return __change_page_attr_set_clr(&cpa, 1);
+	/*
+	 * No alias checking needed for setting present flag. otherwise,
+	 * we may need to break large pages for 64-bit kernel text
+	 * mappings (this adds to complexity if we want to do this from
+	 * atomic context especially). Let's keep it simple!
+	 */
+	return __change_page_attr_set_clr(&cpa, 0);
 }
 
 static int __set_pages_np(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long) page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
-				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW)};
+				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
+				.flags = 0};
 
-	return __change_page_attr_set_clr(&cpa, 1);
+	/*
+	 * No alias checking needed for setting not present flag. otherwise,
+	 * we may need to break large pages for 64-bit kernel text
+	 * mappings (this adds to complexity if we want to do this from
+	 * atomic context especially). Let's keep it simple!
+	 */
+	return __change_page_attr_set_clr(&cpa, 0);
 }
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
@@ -1010,11 +1101,8 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 
 	/*
 	 * The return value is ignored as the calls cannot fail.
-	 * Large pages are kept enabled at boot time, and are
-	 * split up quickly with DEBUG_PAGEALLOC. If a splitup
-	 * fails here (due to temporary memory shortage) no damage
-	 * is done because we just keep the largepage intact up
-	 * to the next attempt when it will likely be split up:
+	 * Large pages for identity mappings are not used at boot time
+	 * and hence no memory allocations during large page split.
 	 */
 	if (enable)
 		__set_pages_p(page, numpages);
@@ -1026,53 +1114,8 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	 * but that can deadlock->flush only current cpu:
 	 */
 	__flush_tlb_all();
-
-	/*
-	 * Try to refill the page pool here. We can do this only after
-	 * the tlb flush.
-	 */
-	cpa_fill_pool(NULL);
 }
 
-#ifdef CONFIG_DEBUG_FS
-static int dpa_show(struct seq_file *m, void *v)
-{
-	seq_puts(m, "DEBUG_PAGEALLOC\n");
-	seq_printf(m, "pool_size     : %lu\n", pool_size);
-	seq_printf(m, "pool_pages    : %lu\n", pool_pages);
-	seq_printf(m, "pool_low      : %lu\n", pool_low);
-	seq_printf(m, "pool_used     : %lu\n", pool_used);
-	seq_printf(m, "pool_failed   : %lu\n", pool_failed);
-
-	return 0;
-}
-
-static int dpa_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, dpa_show, NULL);
-}
-
-static const struct file_operations dpa_fops = {
-	.open		= dpa_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init debug_pagealloc_proc_init(void)
-{
-	struct dentry *de;
-
-	de = debugfs_create_file("debug_pagealloc", 0600, NULL, NULL,
-				 &dpa_fops);
-	if (!de)
-		return -ENOMEM;
-
-	return 0;
-}
-__initcall(debug_pagealloc_proc_init);
-#endif
-
 #ifdef CONFIG_HIBERNATION
 
 bool kernel_page_present(struct page *page)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2a50e0f..738fd0f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -7,24 +7,24 @@
  * Loosely based on earlier PAT patchset from Eric Biederman and Andi Kleen.
  */
 
-#include <linux/mm.h>
+#include <linux/seq_file.h>
+#include <linux/bootmem.h>
+#include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
+#include <linux/mm.h>
 #include <linux/fs.h>
-#include <linux/bootmem.h>
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
 
-#include <asm/msr.h>
-#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/page.h>
+#include <asm/tlbflush.h>
 #include <asm/pgtable.h>
-#include <asm/pat.h>
-#include <asm/e820.h>
-#include <asm/cacheflush.h>
 #include <asm/fcntl.h>
+#include <asm/e820.h>
 #include <asm/mtrr.h>
+#include <asm/page.h>
+#include <asm/msr.h>
+#include <asm/pat.h>
 #include <asm/io.h>
 
 #ifdef CONFIG_X86_PAT
@@ -46,6 +46,7 @@ early_param("nopat", nopat);
 
 
 static int debug_enable;
+
 static int __init pat_debug_setup(char *str)
 {
 	debug_enable = 1;
@@ -145,14 +146,14 @@ static char *cattr_name(unsigned long flags)
  */
 
 struct memtype {
-	u64 start;
-	u64 end;
-	unsigned long type;
-	struct list_head nd;
+	u64			start;
+	u64			end;
+	unsigned long		type;
+	struct list_head	nd;
 };
 
 static LIST_HEAD(memtype_list);
-static DEFINE_SPINLOCK(memtype_lock); 	/* protects memtype list */
+static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype list */
 
 /*
  * Does intersection of PAT memory type and MTRR memory type and returns
@@ -180,8 +181,8 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
-static int chk_conflict(struct memtype *new, struct memtype *entry,
-			unsigned long *type)
+static int
+chk_conflict(struct memtype *new, struct memtype *entry, unsigned long *type)
 {
 	if (new->type != entry->type) {
 		if (type) {
@@ -211,6 +212,66 @@ static struct memtype *cached_entry;
 static u64 cached_start;
 
 /*
+ * For RAM pages, mark the pages as non WB memory type using
+ * PageNonWB (PG_arch_1). We allow only one set_memory_uc() or
+ * set_memory_wc() on a RAM page at a time before marking it as WB again.
+ * This is ok, because only one driver will be owning the page and
+ * doing set_memory_*() calls.
+ *
+ * For now, we use PageNonWB to track that the RAM page is being mapped
+ * as non WB. In future, we will have to use one more flag
+ * (or some other mechanism in page_struct) to distinguish between
+ * UC and WC mapping.
+ */
+static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
+				  unsigned long *new_type)
+{
+	struct page *page;
+	u64 pfn, end_pfn;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
+		page = pfn_to_page(pfn);
+		if (page_mapped(page) || PageNonWB(page))
+			goto out;
+
+		SetPageNonWB(page);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		ClearPageNonWB(page);
+	}
+
+	return -EINVAL;
+}
+
+static int free_ram_pages_type(u64 start, u64 end)
+{
+	struct page *page;
+	u64 pfn, end_pfn;
+
+	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
+		page = pfn_to_page(pfn);
+		if (page_mapped(page) || !PageNonWB(page))
+			goto out;
+
+		ClearPageNonWB(page);
+	}
+	return 0;
+
+out:
+	end_pfn = pfn;
+	for (pfn = (start >> PAGE_SHIFT); pfn < end_pfn; ++pfn) {
+		page = pfn_to_page(pfn);
+		SetPageNonWB(page);
+	}
+	return -EINVAL;
+}
+
+/*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
  * - _PAGE_CACHE_WC
@@ -226,14 +287,15 @@ static u64 cached_start;
  * it will return a negative return value.
  */
 int reserve_memtype(u64 start, u64 end, unsigned long req_type,
-			unsigned long *new_type)
+		    unsigned long *new_type)
 {
 	struct memtype *new, *entry;
 	unsigned long actual_type;
 	struct list_head *where;
+	int is_range_ram;
 	int err = 0;
 
- 	BUG_ON(start >= end); /* end is exclusive */
+	BUG_ON(start >= end); /* end is exclusive */
 
 	if (!pat_enabled) {
 		/* This is identical to page table setting without PAT */
@@ -266,17 +328,24 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			actual_type = _PAGE_CACHE_WB;
 		else
 			actual_type = _PAGE_CACHE_UC_MINUS;
-	} else
+	} else {
 		actual_type = pat_x_mtrr_type(start, end,
 					      req_type & _PAGE_CACHE_MASK);
+	}
+
+	is_range_ram = pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return reserve_ram_pages_type(start, end, req_type, new_type);
+	else if (is_range_ram < 0)
+		return -EINVAL;
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
-	new->start = start;
-	new->end = end;
-	new->type = actual_type;
+	new->start	= start;
+	new->end	= end;
+	new->type	= actual_type;
 
 	if (new_type)
 		*new_type = actual_type;
@@ -335,6 +404,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		       start, end, cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
 		spin_unlock(&memtype_lock);
+
 		return err;
 	}
 
@@ -358,6 +428,7 @@ int free_memtype(u64 start, u64 end)
 {
 	struct memtype *entry;
 	int err = -EINVAL;
+	int is_range_ram;
 
 	if (!pat_enabled)
 		return 0;
@@ -366,6 +437,12 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
+	is_range_ram = pagerange_is_ram(start, end);
+	if (is_range_ram == 1)
+		return free_ram_pages_type(start, end);
+	else if (is_range_ram < 0)
+		return -EINVAL;
+
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
@@ -386,6 +463,7 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
+
 	return err;
 }
 
@@ -492,9 +570,9 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 
 void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 {
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
 	u64 addr = (u64)pfn << PAGE_SHIFT;
 	unsigned long flags;
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
 
 	reserve_memtype(addr, addr + size, want_flags, &flags);
 	if (flags != want_flags) {
@@ -514,7 +592,7 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 	free_memtype(addr, addr + size);
 }
 
-#if defined(CONFIG_DEBUG_FS)
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */
 static struct memtype *memtype_get_idx(loff_t pos)
@@ -537,6 +615,7 @@ static struct memtype *memtype_get_idx(loff_t pos)
 	}
 	spin_unlock(&memtype_lock);
 	kfree(print_entry);
+
 	return NULL;
 }
 
@@ -567,6 +646,7 @@ static int memtype_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "%s @ 0x%Lx-0x%Lx\n", cattr_name(print_entry->type),
 			print_entry->start, print_entry->end);
 	kfree(print_entry);
+
 	return 0;
 }
 
@@ -598,4 +678,4 @@ static int __init pat_memtype_list_init(void)
 
 late_initcall(pat_memtype_list_init);
 
-#endif /* CONFIG_DEBUG_FS */
+#endif /* CONFIG_DEBUG_FS && CONFIG_X86_PAT */
diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 4bada0e..46f5075 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -116,7 +116,9 @@ struct agp_bridge_driver {
 	struct agp_memory *(*alloc_by_type) (size_t, int);
 	void (*free_by_type)(struct agp_memory *);
 	void *(*agp_alloc_page)(struct agp_bridge_data *);
+	int (*agp_alloc_pages)(struct agp_bridge_data *, struct agp_memory *, size_t);
 	void (*agp_destroy_page)(void *, int flags);
+	void (*agp_destroy_pages)(struct agp_memory *);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
 };
@@ -277,7 +279,10 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type);
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
 void agp_generic_free_by_type(struct agp_memory *curr);
 void *agp_generic_alloc_page(struct agp_bridge_data *bridge);
+int agp_generic_alloc_pages(struct agp_bridge_data *agp_bridge,
+			    struct agp_memory *memory, size_t page_count);
 void agp_generic_destroy_page(void *addr, int flags);
+void agp_generic_destroy_pages(struct agp_memory *memory);
 void agp_free_key(int key);
 int agp_num_entries(void);
 u32 agp_collect_device_status(struct agp_bridge_data *bridge, u32 mode, u32 command);
diff --git a/drivers/char/agp/alpha-agp.c b/drivers/char/agp/alpha-agp.c
index 5da89f6..5ea4da8 100644
--- a/drivers/char/agp/alpha-agp.c
+++ b/drivers/char/agp/alpha-agp.c
@@ -143,7 +143,9 @@ struct agp_bridge_driver alpha_core_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index e280531..603a986 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -386,7 +386,9 @@ static const struct agp_bridge_driver amd_irongate_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 7495c52..2812ee2 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -224,7 +224,9 @@ static const struct agp_bridge_driver amd_8151_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 6ecbcaf..ae2791b 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -418,7 +418,9 @@ static const struct agp_bridge_driver ati_generic_bridge = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 8ca6f26..453543a 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -335,7 +335,9 @@ static const struct agp_bridge_driver efficeon_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 118dbde..10d6cbd 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -201,14 +201,22 @@ void agp_free_memory(struct agp_memory *curr)
 		return;
 	}
 	if (curr->page_count != 0) {
-		for (i = 0; i < curr->page_count; i++) {
-			curr->memory[i] = (unsigned long)gart_to_virt(curr->memory[i]);
-			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
-							       AGP_PAGE_DESTROY_UNMAP);
-		}
-		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
-							       AGP_PAGE_DESTROY_FREE);
+		if (curr->bridge->driver->agp_destroy_pages) {
+			curr->bridge->driver->agp_destroy_pages(curr);
+		} else {
+
+			for (i = 0; i < curr->page_count; i++) {
+				curr->memory[i] = (unsigned long)gart_to_virt(
+					curr->memory[i]);
+				curr->bridge->driver->agp_destroy_page(
+					(void *)curr->memory[i],
+					AGP_PAGE_DESTROY_UNMAP);
+			}
+			for (i = 0; i < curr->page_count; i++) {
+				curr->bridge->driver->agp_destroy_page(
+					(void *)curr->memory[i],
+					AGP_PAGE_DESTROY_FREE);
+			}
 		}
 	}
 	agp_free_key(curr->key);
@@ -264,6 +272,15 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
 	if (new == NULL)
 		return NULL;
 
+	if (bridge->driver->agp_alloc_pages) {
+		if (bridge->driver->agp_alloc_pages(bridge, new, page_count)) {
+			agp_free_memory(new);
+			return NULL;
+		}
+		new->bridge = bridge;
+		return new;
+	}
+
 	for (i = 0; i < page_count; i++) {
 		void *addr = bridge->driver->agp_alloc_page(bridge);
 
@@ -1203,6 +1220,39 @@ EXPORT_SYMBOL(agp_generic_alloc_user);
  * against a maximum value.
  */
 
+int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *mem, size_t num_pages)
+{
+	struct page * page;
+	int i, ret = -ENOMEM;
+
+	for (i = 0; i < num_pages; i++) {
+		page = alloc_page(GFP_KERNEL | GFP_DMA32);
+		/* agp_free_memory() needs gart address */
+		if (page == NULL)
+			goto out;
+
+#ifndef CONFIG_X86
+		map_page_into_agp(page);
+#endif
+		get_page(page);
+		atomic_inc(&agp_bridge->current_memory_agp);
+
+		/* set_memory_array_uc() needs virtual address */
+		mem->memory[i] = (unsigned long)page_address(page);
+		mem->page_count++;
+	}
+
+#ifdef CONFIG_X86
+	set_memory_array_uc(mem->memory, num_pages);
+#endif
+	ret = 0;
+out:
+	for (i = 0; i < mem->page_count; i++)
+		mem->memory[i] = virt_to_gart((void *)mem->memory[i]);
+	return ret;
+}
+EXPORT_SYMBOL(agp_generic_alloc_pages);
+
 void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 {
 	struct page * page;
@@ -1219,6 +1269,37 @@ void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 }
 EXPORT_SYMBOL(agp_generic_alloc_page);
 
+void agp_generic_destroy_pages(struct agp_memory *mem)
+{
+	int i;
+	void *addr;
+	struct page *page;
+
+	if (!mem)
+		return;
+
+	for (i = 0; i < mem->page_count; i++)
+		mem->memory[i] = (unsigned long)gart_to_virt(mem->memory[i]);
+
+#ifdef CONFIG_X86
+	set_memory_array_wb(mem->memory, mem->page_count);
+#endif
+
+	for (i = 0; i < mem->page_count; i++) {
+		addr = (void *)mem->memory[i];
+		page = virt_to_page(addr);
+
+#ifndef CONFIG_X86
+		unmap_page_from_agp(page);
+#endif
+
+		put_page(page);
+		free_page((unsigned long)addr);
+		atomic_dec(&agp_bridge->current_memory_agp);
+		mem->memory[i] = 0;
+	}
+}
+EXPORT_SYMBOL(agp_generic_destroy_pages);
 
 void agp_generic_destroy_page(void *addr, int flags)
 {
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 80d7317..183ac3f 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -435,7 +435,9 @@ const struct agp_bridge_driver hp_zx1_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index e587eeb..10da687 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -575,7 +575,9 @@ const struct agp_bridge_driver intel_i460_driver = {
 	.insert_memory		= i460_insert_memory_small_io_page,
 	.remove_memory		= i460_remove_memory_small_io_page,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 #endif
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 016fdf0..043e366 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1711,7 +1711,9 @@ static const struct agp_bridge_driver intel_generic_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1736,7 +1738,9 @@ static const struct agp_bridge_driver intel_810_driver = {
 	.alloc_by_type		= intel_i810_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1760,7 +1764,9 @@ static const struct agp_bridge_driver intel_815_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= agp_generic_type_to_mask_type,
 };
 
@@ -1785,7 +1791,9 @@ static const struct agp_bridge_driver intel_830_driver = {
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
 };
@@ -1810,7 +1818,9 @@ static const struct agp_bridge_driver intel_820_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1834,7 +1844,9 @@ static const struct agp_bridge_driver intel_830mp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1858,7 +1870,9 @@ static const struct agp_bridge_driver intel_840_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1882,7 +1896,9 @@ static const struct agp_bridge_driver intel_845_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.chipset_flush		= intel_i830_chipset_flush,
 };
@@ -1907,7 +1923,9 @@ static const struct agp_bridge_driver intel_850_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1931,7 +1949,9 @@ static const struct agp_bridge_driver intel_860_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -1956,7 +1976,9 @@ static const struct agp_bridge_driver intel_915_driver = {
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };
@@ -1982,7 +2004,9 @@ static const struct agp_bridge_driver intel_i965_driver = {
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };
@@ -2007,7 +2031,9 @@ static const struct agp_bridge_driver intel_7505_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -2032,7 +2058,9 @@ static const struct agp_bridge_driver intel_g33_driver = {
 	.alloc_by_type		= intel_i830_alloc_by_type,
 	.free_by_type		= intel_i810_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages        = agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages      = agp_generic_destroy_pages,
 	.agp_type_to_mask_type	= intel_i830_type_to_mask_type,
 	.chipset_flush		= intel_i915_chipset_flush,
 };
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index eaceb61..dc70d37 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -312,7 +312,9 @@ static const struct agp_bridge_driver nvidia_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 8c42dcc..f2492ec 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -224,7 +224,9 @@ static const struct agp_bridge_driver parisc_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 2587ef9..6c3837a 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -140,7 +140,9 @@ static struct agp_bridge_driver sis_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 2fb27fe..6224df8 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -437,7 +437,9 @@ static const struct agp_bridge_driver sworks_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index eef7270..0f004b6 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -509,7 +509,9 @@ const struct agp_bridge_driver uninorth_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
@@ -534,7 +536,9 @@ const struct agp_bridge_driver u3_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 	.needs_scratch_page	= true,
diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 7b36476..9f4d49e 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -190,7 +190,9 @@ static const struct agp_bridge_driver via_agp3_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -214,7 +216,9 @@ static const struct agp_bridge_driver via_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/include/asm-x86/cacheflush.h b/include/asm-x86/cacheflush.h
index 59859cb..68840ef 100644
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -24,6 +24,8 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
 	memcpy((dst), (src), (len))
 
+#define PG_non_WB				PG_arch_1
+PAGEFLAG(NonWB, non_WB)
 
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
@@ -66,6 +68,9 @@ int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
 int set_memory_4k(unsigned long addr, int numpages);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray);
+int set_memory_array_wb(unsigned long *addr, int addrinarray);
+
 /*
  * For legacy compatibility with the old APIs, a few functions
  * are provided that work on a "struct page".
@@ -96,8 +101,6 @@ int set_pages_rw(struct page *page, int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
-void cpa_init(void);
-
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 79544e6..c915747 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -57,6 +57,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
 extern int page_is_ram(unsigned long pagenr);
+extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 888add7..ed93245 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -19,6 +19,7 @@
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
+#define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 #define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
@@ -36,6 +37,7 @@
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
+#define _PAGE_CPA_TEST	(_AT(pteval_t, 1) << _PAGE_BIT_CPA_TEST)
 #define __HAVE_ARCH_PTE_SPECIAL
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
@@ -130,6 +132,17 @@
 #define __S110	PAGE_SHARED_EXEC
 #define __S111	PAGE_SHARED_EXEC
 
+/*
+ * early identity mapping  pte attrib macros.
+ */
+#ifdef CONFIG_X86_64
+#define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
+#else
+#define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
+#define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/mm/highmem.c b/mm/highmem.c
index e16e152..b36b83b 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -70,6 +70,7 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
+	int need_flush = 0;
 
 	flush_cache_kmaps();
 
@@ -101,8 +102,10 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
+		need_flush = 1;
 	}
-	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+	if (need_flush)
+		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 }
 
 /**
