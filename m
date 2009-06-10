Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZFJVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZFJVmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZFJVmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:42:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZFJVml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:42:41 -0400
Date: Wed, 10 Jun 2009 23:42:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [GIT PULL] x86/mm for v2.6.31
Message-ID: <20090610214228.GA3979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus

The mm.h and page_alloc.c change was OK-ed by Andrew.

out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
include/linux/mm.h                 # 888a589: mm, x86: remove MEMORY_HOTPLUG_RE
mm/page_alloc.c                    # 888a589: mm, x86: remove MEMORY_HOTPLUG_RE

 Thanks,

	Ingo

------------------>
Amerigo Wang (2):
      x86: merge process.c a bit
      x86: process.c, remove useless headers

H. Peter Anvin (1):
      x86: fix typo in address space documentation

Ingo Molnar (2):
      x86/mm: further cleanups of fault.c's include file section
      x86, mm: fault.c, use printk_once() in is_errata93()

Jaswinder Singh Rajput (1):
      x86: page_types.h unification of declarations

Linus Torvalds (1):
      x86, e820, pci: reserve extra free space near end of RAM

Pekka Enberg (5):
      x86: unify noexec handling
      x86: move max_pfn_mapped and max_low_pfn_mapped to setup.c
      x86: move per-cpu mmu_gathers to mm/init.c
      x86: unify 64-bit UMA and NUMA paging_init()
      x86: use sparse_memory_present_with_active_regions() on UMA

Rik van Riel (1):
      x86: 46 bit physical address support on 64 bits

Shaohua Li (1):
      x86: make sparse mem work in non-NUMA mode

Yinghai Lu (8):
      x86: remove (null) in /sys kernel_page_tables
      x86/pci: remove rounding quirk from e820_setup_gap()
      x86: clean up and and print out initial max_pfn_mapped
      x86: Sanity check the e820 against the SRAT table using e820 map only
      x86: Allow 1MB of slack between the e820 map and SRAT, not 4GB
      mm, x86: remove MEMORY_HOTPLUG_RESERVE related code
      x86, mm: Fix node_possible_map logic
      x86: fix system without memory on node0


 Documentation/x86/x86_64/boot-options.txt |    5 --
 Documentation/x86/x86_64/mm.txt           |    9 ++-
 arch/x86/include/asm/numa_64.h            |   10 ++-
 arch/x86/include/asm/page_32_types.h      |    4 -
 arch/x86/include/asm/page_64_types.h      |    8 +--
 arch/x86/include/asm/page_types.h         |    6 ++
 arch/x86/include/asm/pgtable_64_types.h   |    8 +-
 arch/x86/include/asm/pgtable_types.h      |    1 -
 arch/x86/include/asm/sparsemem.h          |    2 +-
 arch/x86/include/asm/traps.h              |    1 +
 arch/x86/kernel/e820.c                    |   46 +++++++++++---
 arch/x86/kernel/process.c                 |   14 ++++
 arch/x86/kernel/process_32.c              |   15 -----
 arch/x86/kernel/process_64.c              |   15 -----
 arch/x86/kernel/setup.c                   |   12 ++++
 arch/x86/kernel/setup_percpu.c            |    8 +++
 arch/x86/mm/dump_pagetables.c             |    7 +-
 arch/x86/mm/fault.c                       |   51 +++------------
 arch/x86/mm/init.c                        |   77 ++++++++++++++++++++---
 arch/x86/mm/init_32.c                     |   61 +-----------------
 arch/x86/mm/init_64.c                     |   47 +-------------
 arch/x86/mm/numa_64.c                     |   33 +++-------
 arch/x86/mm/srat_64.c                     |   98 +++++------------------------
 include/linux/mm.h                        |    2 -
 mm/page_alloc.c                           |   69 --------------------
 25 files changed, 213 insertions(+), 396 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..2db5893 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -150,11 +150,6 @@ NUMA
 		Otherwise, the remaining system RAM is allocated to an
 		additional node.
 
-  numa=hotadd=percent
-		Only allow hotadd memory to preallocate page structures upto
-		percent of already available memory.
-		numa=hotadd=0 will disable hotadd memory.
-
 ACPI
 
   acpi=off	Don't enable ACPI
diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 29b52b1..d6498e3 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -6,10 +6,11 @@ Virtual memory map with 4 level page tables:
 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
 ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
-ffff880000000000 - ffffc0ffffffffff (=57 TB) direct mapping of all phys. memory
-ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
-ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
-ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
+ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys. memory
+ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
+ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
+ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
+ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
 ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 064ed6d..c4ae822 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -17,9 +17,6 @@ extern int compute_hash_shift(struct bootnode *nodes, int numblks,
 extern void numa_init_array(void);
 extern int numa_off;
 
-extern void srat_reserve_add_area(int nodeid);
-extern int hotadd_percent;
-
 extern s16 apicid_to_node[MAX_LOCAL_APIC];
 
 extern unsigned long numa_free_all_bootmem(void);
@@ -27,6 +24,13 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
 
 #ifdef CONFIG_NUMA
+/*
+ * Too small node sizes may confuse the VM badly. Usually they
+ * result from BIOS bugs. So dont recognize nodes as standalone
+ * NUMA entities that have less than this amount of RAM listed:
+ */
+#define NODE_MIN_SIZE (4*1024*1024)
+
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index 0f915ae..6f1b733 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -54,10 +54,6 @@ extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
 extern void find_low_pfn_range(void);
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-extern void initmem_init(unsigned long, unsigned long);
-extern void free_initmem(void);
 extern void setup_bootmem_allocator(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d38c91b..6fadb02 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -47,7 +47,7 @@
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
+/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define __PHYSICAL_MASK_SHIFT	46
 #define __VIRTUAL_MASK_SHIFT	48
 
@@ -71,12 +71,6 @@ extern unsigned long __phys_addr(unsigned long);
 
 #define vmemmap ((struct page *)VMEMMAP_START)
 
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
-extern void free_initmem(void);
-
 extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
 extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 826ad37..6473f5c 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -46,6 +46,12 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
+
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
+extern void free_initmem(void);
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif	/* _ASM_X86_PAGE_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index fbf42b8..766ea16 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -51,11 +51,11 @@ typedef struct { pteval_t pte; } pte_t;
 #define PGDIR_SIZE	(_AC(1, UL) << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
-
+/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define MAXMEM		 _AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
-#define VMALLOC_START    _AC(0xffffc20000000000, UL)
-#define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
-#define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
+#define VMALLOC_START    _AC(0xffffc90000000000, UL)
+#define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
+#define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b8238dc..4d258ad 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -273,7 +273,6 @@ typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
 extern int nx_enabled;
-extern void set_nx(void);
 
 #define pgprot_writecombine	pgprot_writecombine
 extern pgprot_t pgprot_writecombine(pgprot_t prot);
diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index e3cc3c0..4517d6b 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -27,7 +27,7 @@
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
 # define MAX_PHYSADDR_BITS	44
-# define MAX_PHYSMEM_BITS	44 /* Can be max 45 bits */
+# define MAX_PHYSMEM_BITS	46
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..37fb07a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_TRAPS_H
 
 #include <asm/debugreg.h>
+#include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
 #ifdef CONFIG_X86_32
 #define dotraplinkage
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0062813..7271fa3 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
  */
 __init void e820_setup_gap(void)
 {
-	unsigned long gapstart, gapsize, round;
+	unsigned long gapstart, gapsize;
 	int found;
 
 	gapstart = 0x10000000;
@@ -635,14 +635,9 @@ __init void e820_setup_gap(void)
 #endif
 
 	/*
-	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
+	 * e820_reserve_resources_late protect stolen RAM already
 	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
+	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
@@ -1371,6 +1366,23 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+/* How much should we pad RAM ending depending on where it is? */
+static unsigned long ram_alignment(resource_size_t pos)
+{
+	unsigned long mb = pos >> 20;
+
+	/* To 64kB in the first megabyte */
+	if (!mb)
+		return 64*1024;
+
+	/* To 1MB in the first 16MB */
+	if (mb < 16)
+		return 1024*1024;
+
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
+}
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1382,6 +1394,24 @@ void __init e820_reserve_resources_late(void)
 			insert_resource_expand_to_fit(&iomem_resource, res);
 		res++;
 	}
+
+	/*
+	 * Try to bump up RAM regions to reasonable boundaries to
+	 * avoid stolen RAM:
+	 */
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820_saved.map[i];
+		resource_size_t start, end;
+
+		if (entry->type != E820_RAM)
+			continue;
+		start = entry->addr + entry->size;
+		end = round_up(start, ram_alignment(start));
+		if (start == end)
+			continue;
+		reserve_region_with_split(&iomem_resource, start,
+						  end - 1, "RAM buffer");
+	}
 }
 
 char *__init default_machine_specific_memory_setup(void)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..2b9a8d0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
+#include <linux/random.h>
 #include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -613,3 +614,16 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
+unsigned long arch_align_stack(unsigned long sp)
+{
+	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+		sp -= get_random_int() % 8192;
+	return sp & ~0xf;
+}
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..56d50b7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,8 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
@@ -33,7 +31,6 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
@@ -497,15 +494,3 @@ unsigned long get_wchan(struct task_struct *p)
 	return 0;
 }
 
-unsigned long arch_align_stack(unsigned long sp)
-{
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
-	return sp & ~0xf;
-}
-
-unsigned long arch_randomize_brk(struct mm_struct *mm)
-{
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
-}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..9d6b20e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,8 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
@@ -32,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
@@ -660,15 +657,3 @@ long sys_arch_prctl(int code, unsigned long addr)
 	return do_arch_prctl(current, code, addr);
 }
 
-unsigned long arch_align_stack(unsigned long sp)
-{
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
-	return sp & ~0xf;
-}
-
-unsigned long arch_randomize_brk(struct mm_struct *mm)
-{
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
-}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..4031d6c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,6 +112,14 @@
 #define ARCH_SETUP
 #endif
 
+/*
+ * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
+ * The direct mapping extends to max_pfn_mapped, so that we can directly access
+ * apertures, ACPI and other tables without having to play with fixmaps.
+ */
+unsigned long max_low_pfn_mapped;
+unsigned long max_pfn_mapped;
+
 RESERVE_BRK(dmi_alloc, 65536);
 
 unsigned int boot_cpu_id __read_mostly;
@@ -854,12 +862,16 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
 
+	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
+			max_pfn_mapped<<PAGE_SHIFT);
+
 	reserve_brk();
 
 	/* max_pfn_mapped is updated here */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3a97a4c..3b5f327 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -423,6 +423,14 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+	/*
+	 * make sure boot cpu node_number is right, when boot cpu is on the
+	 * node that doesn't have mem installed
+	 */
+	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
+#endif
+
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
 
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index e7277cb..a725b7f 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -161,13 +161,14 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
+		int width = sizeof(unsigned long) * 2;
 
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%p-0x%p   ",
-			   (void *)st->start_address,
-			   (void *)st->current_address);
+		seq_printf(m, "0x%0*lx-0x%0*lx   ",
+			   width, st->start_address,
+			   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..b9ca6d7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,40 +3,16 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/interrupt.h>
-#include <linux/mmiotrace.h>
-#include <linux/bootmem.h>
-#include <linux/compiler.h>
-#include <linux/highmem.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
-#include <linux/vt_kern.h>
-#include <linux/signal.h>
-#include <linux/kernel.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-#include <linux/errno.h>
-#include <linux/magic.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/mman.h>
-#include <linux/tty.h>
-#include <linux/smp.h>
-#include <linux/mm.h>
-
-#include <asm-generic/sections.h>
-
-#include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
-#include <asm/segment.h>
-#include <asm/system.h>
-#include <asm/proto.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
+#include <linux/magic.h>		/* STACK_END_MAGIC		*/
+#include <linux/sched.h>		/* test_thread_flag(), ...	*/
+#include <linux/kdebug.h>		/* oops_begin/end, ...		*/
+#include <linux/module.h>		/* search_exception_table	*/
+#include <linux/bootmem.h>		/* max_low_pfn			*/
+#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
+
+#include <asm/traps.h>			/* dotraplinkage, ...		*/
+#include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 
 /*
  * Page fault error code bits:
@@ -538,8 +514,6 @@ bad:
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
 #ifdef CONFIG_X86_64
-	static int once;
-
 	if (address != regs->ip)
 		return 0;
 
@@ -549,10 +523,7 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	address |= 0xffffffffUL << 32;
 	if ((address >= (u64)_stext && address <= (u64)_etext) ||
 	    (address >= MODULES_VADDR && address <= MODULES_END)) {
-		if (!once) {
-			printk(errata93_warning);
-			once = 1;
-		}
+		printk_once(errata93_warning);
 		regs->ip = address;
 		return 1;
 	}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ae4f7b5..92d2108 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -10,6 +10,9 @@
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
 unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
@@ -23,6 +26,69 @@ int direct_gbpages
 #endif
 ;
 
+int nx_enabled;
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static int disable_nx __cpuinitdata;
+
+/*
+ * noexec = on|off
+ *
+ * Control non-executable mappings for processes.
+ *
+ * on      Enable
+ * off     Disable
+ */
+static int __init noexec_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		disable_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		disable_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", noexec_setup);
+#endif
+
+#ifdef CONFIG_X86_PAE
+static void __init set_nx(void)
+{
+	unsigned int v[4], l, h;
+
+	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
+		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+
+		if ((v[3] & (1 << 20)) && !disable_nx) {
+			rdmsr(MSR_EFER, l, h);
+			l |= EFER_NX;
+			wrmsr(MSR_EFER, l, h);
+			nx_enabled = 1;
+			__supported_pte_mask |= _PAGE_NX;
+		}
+	}
+}
+#else
+static inline void set_nx(void)
+{
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || disable_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+#endif
+
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
@@ -66,12 +132,11 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
-#else /* CONFIG_X86_64 */
+#else
 	start = 0x8000;
-	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 #endif
+	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
@@ -159,12 +224,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
@@ -175,7 +237,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
-#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..949708d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,12 +49,9 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
+#include <asm/page_types.h>
 #include <asm/init.h>
 
-unsigned long max_low_pfn_mapped;
-unsigned long max_pfn_mapped;
-
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
@@ -587,61 +584,9 @@ void zap_low_mappings(void)
 	flush_tlb_all();
 }
 
-int nx_enabled;
-
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-#ifdef CONFIG_X86_PAE
-
-static int disable_nx __initdata;
-
-/*
- * noexec = on|off
- *
- * Control non executable mappings.
- *
- * on      Enable
- * off     Disable
- */
-static int __init noexec_setup(char *str)
-{
-	if (!str || !strcmp(str, "on")) {
-		if (cpu_has_nx) {
-			__supported_pte_mask |= _PAGE_NX;
-			disable_nx = 0;
-		}
-	} else {
-		if (!strcmp(str, "off")) {
-			disable_nx = 1;
-			__supported_pte_mask &= ~_PAGE_NX;
-		} else {
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-early_param("noexec", noexec_setup);
-
-void __init set_nx(void)
-{
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
-
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
-		}
-	}
-}
-#endif
-
 /* user-defined highmem size */
 static unsigned int highmem_pages = -1;
 
@@ -761,15 +706,15 @@ void __init initmem_init(unsigned long start_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memory_present(0, 0, highend_pfn);
 	e820_register_active_regions(0, 0, highend_pfn);
+	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memory_present(0, 0, max_low_pfn);
 	e820_register_active_regions(0, 0, max_low_pfn);
+	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..52bb951 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,18 +50,8 @@
 #include <asm/cacheflush.h>
 #include <asm/init.h>
 
-/*
- * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
- * The direct mapping extends to max_pfn_mapped, so that we can directly access
- * apertures, ACPI and other tables without having to play with fixmaps.
- */
-unsigned long max_low_pfn_mapped;
-unsigned long max_pfn_mapped;
-
 static unsigned long dma_reserve __initdata;
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
@@ -85,39 +75,6 @@ early_param("gbpages", parse_direct_gbpages_on);
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-static int disable_nx __cpuinitdata;
-
-/*
- * noexec=on|off
- * Control non-executable mappings for 64-bit processes.
- *
- * on	Enable (default)
- * off	Disable
- */
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		disable_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", nonx_setup);
-
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-
 int force_personality32;
 
 /*
@@ -628,6 +585,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
+#endif
 
 void __init paging_init(void)
 {
@@ -638,11 +596,10 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
-	memory_present(0, 0, max_pfn);
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }
-#endif
 
 /*
  * Memory hotplug specific functions
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 2d05a12..459913b 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -179,18 +179,25 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 }
 
 /* Initialize bootmem allocator for a node */
-void __init setup_node_bootmem(int nodeid, unsigned long start,
-			       unsigned long end)
+void __init
+setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 {
 	unsigned long start_pfn, last_pfn, bootmap_pages, bootmap_size;
+	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
-	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
 	if (!end)
 		return;
 
+	/*
+	 * Don't confuse VM with a node that doesn't have the
+	 * minimum amount of memory:
+	 */
+	if (end && (end - start) < NODE_MIN_SIZE)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
@@ -272,9 +279,6 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
 				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
 
-#ifdef CONFIG_ACPI_NUMA
-	srat_reserve_add_area(nodeid);
-#endif
 	node_set_online(nodeid);
 }
 
@@ -578,21 +582,6 @@ unsigned long __init numa_free_all_bootmem(void)
 	return pages;
 }
 
-void __init paging_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
-
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
-	sparse_init();
-
-	free_area_init_nodes(max_zone_pfns);
-}
-
 static __init int numa_setup(char *opt)
 {
 	if (!opt)
@@ -606,8 +595,6 @@ static __init int numa_setup(char *opt)
 #ifdef CONFIG_ACPI_NUMA
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
-	if (!strncmp(opt, "hotadd=", 7))
-		hotadd_percent = simple_strtoul(opt+7, NULL, 10);
 #endif
 	return 0;
 }
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 0176595..2dfcbf9 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -31,17 +31,11 @@ static nodemask_t nodes_parsed __initdata;
 static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
-static int found_add_area __initdata;
-int hotadd_percent __initdata = 0;
 
 static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
 static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
 
-/* Too small nodes confuse the VM badly. Usually they result
-   from BIOS bugs. */
-#define NODE_MIN_SIZE (4*1024*1024)
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -66,9 +60,6 @@ static __init void cutoff_node(int i, unsigned long start, unsigned long end)
 {
 	struct bootnode *nd = &nodes[i];
 
-	if (found_add_area)
-		return;
-
 	if (nd->start < start) {
 		nd->start = start;
 		if (nd->end < nd->start)
@@ -86,7 +77,6 @@ static __init void bad_srat(void)
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	found_add_area = 0;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_to_node[i] = NUMA_NO_NODE;
 	for (i = 0; i < MAX_NUMNODES; i++)
@@ -182,24 +172,21 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }
 
-static int update_end_of_memory(unsigned long end) {return -1;}
-static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int save_add_info(void) {return 1;}
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
 /*
- * Update nodes_add and decide if to include add are in the zone.
- * Both SPARSE and RESERVE need nodes_add information.
- * This code supports one contiguous hot add area per node.
+ * Update nodes_add[]
+ * This code supports one contiguous hot add area per node
  */
-static int __init
-reserve_hotadd(int node, unsigned long start, unsigned long end)
+static void __init
+update_nodes_add(int node, unsigned long start, unsigned long end)
 {
 	unsigned long s_pfn = start >> PAGE_SHIFT;
 	unsigned long e_pfn = end >> PAGE_SHIFT;
-	int ret = 0, changed = 0;
+	int changed = 0;
 	struct bootnode *nd = &nodes_add[node];
 
 	/* I had some trouble with strange memory hotadd regions breaking
@@ -210,7 +197,7 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
 	   mistakes */
 	if ((signed long)(end - start) < NODE_MIN_SIZE) {
 		printk(KERN_ERR "SRAT: Hotplug area too small\n");
-		return -1;
+		return;
 	}
 
 	/* This check might be a bit too strict, but I'm keeping it for now. */
@@ -218,12 +205,7 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
 		printk(KERN_ERR
 			"SRAT: Hotplug area %lu -> %lu has existing memory\n",
 			s_pfn, e_pfn);
-		return -1;
-	}
-
-	if (!hotadd_enough_memory(&nodes_add[node]))  {
-		printk(KERN_ERR "SRAT: Hotplug area too large\n");
-		return -1;
+		return;
 	}
 
 	/* Looks good */
@@ -245,11 +227,9 @@ reserve_hotadd(int node, unsigned long start, unsigned long end)
 			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
 	}
 
-	ret = update_end_of_memory(nd->end);
-
 	if (changed)
-	 	printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n", nd->start, nd->end);
-	return ret;
+		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
+				 nd->start, nd->end);
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -310,13 +290,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	       start, end);
 	e820_register_active_regions(node, start >> PAGE_SHIFT,
 				     end >> PAGE_SHIFT);
-	push_node_boundaries(node, nd->start >> PAGE_SHIFT,
-						nd->end >> PAGE_SHIFT);
 
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) &&
-	    (reserve_hotadd(node, start, end) < 0)) {
-		/* Ignore hotadd region. Undo damage */
-		printk(KERN_NOTICE "SRAT: Hotplug region ignored\n");
+	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+		update_nodes_add(node, start, end);
+		/* restore nodes[node] */
 		*nd = oldnode;
 		if ((nd->start | nd->end) == 0)
 			node_clear(node, nodes_parsed);
@@ -345,9 +322,9 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
-	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
-	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
+	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
 	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
 			(pxmram << PAGE_SHIFT) >> 20,
@@ -357,17 +334,6 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 	return 1;
 }
 
-static void __init unparse_node(int node)
-{
-	int i;
-	node_clear(node, nodes_parsed);
-	node_clear(node, cpu_nodes_parsed);
-	for (i = 0; i < MAX_LOCAL_APIC; i++) {
-		if (apicid_to_node[i] == node)
-			apicid_to_node[i] = NUMA_NO_NODE;
-	}
-}
-
 void __init acpi_numa_arch_fixup(void) {}
 
 /* Use the information discovered above to actually set up the nodes. */
@@ -379,18 +345,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 
 	/* First clean up the node list */
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++)
 		cutoff_node(i, start, end);
-		/*
-		 * don't confuse VM with a node that doesn't have the
-		 * minimum memory.
-		 */
-		if (nodes[i].end &&
-			(nodes[i].end - nodes[i].start) < NODE_MIN_SIZE) {
-			unparse_node(i);
-			node_set_offline(i);
-		}
-	}
 
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
@@ -423,7 +379,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 
 		if (node == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(node, node_possible_map))
+		if (!node_online(node))
 			numa_clear_node(i);
 	}
 	numa_init_array();
@@ -510,26 +466,6 @@ static int null_slit_node_compare(int a, int b)
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init srat_reserve_add_area(int nodeid)
-{
-	if (found_add_area && nodes_add[nodeid].end) {
-		u64 total_mb;
-
-		printk(KERN_INFO "SRAT: Reserving hot-add memory space "
-				"for node %d at %Lx-%Lx\n",
-			nodeid, nodes_add[nodeid].start, nodes_add[nodeid].end);
-		total_mb = (nodes_add[nodeid].end - nodes_add[nodeid].start)
-					>> PAGE_SHIFT;
-		total_mb *= sizeof(struct page);
-		total_mb >>= 20;
-		printk(KERN_INFO "SRAT: This will cost you %Lu MB of "
-				"pre-allocated memory.\n", (unsigned long long)total_mb);
-		reserve_bootmem_node(NODE_DATA(nodeid), nodes_add[nodeid].start,
-			       nodes_add[nodeid].end - nodes_add[nodeid].start,
-			       BOOTMEM_DEFAULT);
-	}
-}
-
 int __node_distance(int a, int b)
 {
 	int index;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..511b098 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1031,8 +1031,6 @@ extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
-extern void push_node_boundaries(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fe753ec..474c7e9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -149,10 +149,6 @@ static unsigned long __meminitdata dma_reserve;
   static int __meminitdata nr_nodemap_entries;
   static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
   static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
-  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
-#endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   static unsigned long __initdata required_kernelcore;
   static unsigned long __initdata required_movablecore;
   static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
@@ -3103,64 +3099,6 @@ void __init sparse_memory_present_with_active_regions(int nid)
 }
 
 /**
- * push_node_boundaries - Push node boundaries to at least the requested boundary
- * @nid: The nid of the node to push the boundary for
- * @start_pfn: The start pfn of the node
- * @end_pfn: The end pfn of the node
- *
- * In reserve-based hot-add, mem_map is allocated that is unused until hotadd
- * time. Specifically, on x86_64, SRAT will report ranges that can potentially
- * be hotplugged even though no physical memory exists. This function allows
- * an arch to push out the node boundaries so mem_map is allocated that can
- * be used later.
- */
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-void __init push_node_boundaries(unsigned int nid,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
-			"Entering push_node_boundaries(%u, %lu, %lu)\n",
-			nid, start_pfn, end_pfn);
-
-	/* Initialise the boundary for this node if necessary */
-	if (node_boundary_end_pfn[nid] == 0)
-		node_boundary_start_pfn[nid] = -1UL;
-
-	/* Update the boundaries */
-	if (node_boundary_start_pfn[nid] > start_pfn)
-		node_boundary_start_pfn[nid] = start_pfn;
-	if (node_boundary_end_pfn[nid] < end_pfn)
-		node_boundary_end_pfn[nid] = end_pfn;
-}
-
-/* If necessary, push the node boundary out for reserve hotadd */
-static void __meminit account_node_boundary(unsigned int nid,
-		unsigned long *start_pfn, unsigned long *end_pfn)
-{
-	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
-			"Entering account_node_boundary(%u, %lu, %lu)\n",
-			nid, *start_pfn, *end_pfn);
-
-	/* Return if boundary information has not been provided */
-	if (node_boundary_end_pfn[nid] == 0)
-		return;
-
-	/* Check the boundaries and update if necessary */
-	if (node_boundary_start_pfn[nid] < *start_pfn)
-		*start_pfn = node_boundary_start_pfn[nid];
-	if (node_boundary_end_pfn[nid] > *end_pfn)
-		*end_pfn = node_boundary_end_pfn[nid];
-}
-#else
-void __init push_node_boundaries(unsigned int nid,
-		unsigned long start_pfn, unsigned long end_pfn) {}
-
-static void __meminit account_node_boundary(unsigned int nid,
-		unsigned long *start_pfn, unsigned long *end_pfn) {}
-#endif
-
-
-/**
  * get_pfn_range_for_nid - Return the start and end page frames for a node
  * @nid: The nid to return the range for. If MAX_NUMNODES, the min and max PFN are returned.
  * @start_pfn: Passed by reference. On return, it will have the node start_pfn.
@@ -3185,9 +3123,6 @@ void __meminit get_pfn_range_for_nid(unsigned int nid,
 
 	if (*start_pfn == -1UL)
 		*start_pfn = 0;
-
-	/* Push the node boundaries out if requested */
-	account_node_boundary(nid, start_pfn, end_pfn);
 }
 
 /*
@@ -3793,10 +3728,6 @@ void __init remove_all_active_ranges(void)
 {
 	memset(early_node_map, 0, sizeof(early_node_map));
 	nr_nodemap_entries = 0;
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-	memset(node_boundary_start_pfn, 0, sizeof(node_boundary_start_pfn));
-	memset(node_boundary_end_pfn, 0, sizeof(node_boundary_end_pfn));
-#endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 }
 
 /* Compare two active node_active_regions */
