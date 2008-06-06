Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYFFKyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYFFKyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYFFKyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:54:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYFFKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:54:39 -0400
Date: Fri, 6 Jun 2008 03:54:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606035413.37f340ef.akpm@linux-foundation.org>
In-Reply-To: <20080606024811.70db9ab2.akpm@linux-foundation.org>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606002957.6329a0ec.akpm@linux-foundation.org>
	<20080606024811.70db9ab2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 02:48:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I'll try a linear search starting at

	ff0e010ef613b0e7136f2f40ec4b51273676b085
	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:05:25
	Parent: b65e04b53ffcb4002737a5346c9ff8865c37be58 (x86: don't call pxm_to_node again)
	Child:  dfdf1d75efee39e9396f8384c6f3bf555349ed60 (x86: modify Kconfig to allow up to 4096 cpus)
	Branch: 
	Follows: v2.6.26-rc2
	Precedes: next-20080526

	    x86: fix remove cpu_pda table patch


Good

	dfdf1d75efee39e9396f8384c6f3bf555349ed60
	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:05:39
	Parent: ff0e010ef613b0e7136f2f40ec4b51273676b085 (x86: fix remove cpu_pda table patch)
	Child:  29657a44f8660acd8751d7e9f5aac06ec8633481 (x86: cleanup early per cpu variables/accesses v4)
	Branch: 
	Follows: v2.6.26-rc2
	Precedes: next-20080526

	    x86: modify Kconfig to allow up to 4096 cpus

Good

	29657a44f8660acd8751d7e9f5aac06ec8633481
	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:23
	Parent: dfdf1d75efee39e9396f8384c6f3bf555349ed60 (x86: modify Kconfig to allow up to 4096 cpus)
	Child:  543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
	Branch: 
	Follows: v2.6.26-rc2
	Precedes: next-20080526

	    x86: cleanup early per cpu variables/accesses v4

Good


	543e21916497be5a4005fd5820264ce1de9bd56d
	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:37
	Parent: 29657a44f8660acd8751d7e9f5aac06ec8633481 (x86: cleanup early per cpu variables/accesses v4)
	Child:  a9ad585c8a18f7ba754b85f5786976609b9d7d29 (x86: remove the static 256k node_to_cpumask_map)
	Branch: 
	Follows: v2.6.26-rc2
	Precedes: next-20080526

	    x86: restore pda nodenumber field

Good

	a9ad585c8a18f7ba754b85f5786976609b9d7d29
	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:47
	Parent: 543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
	Child:  78d49c6d890aee9cf8aea371011c9d7b0121b822 (x86: remove static boot_cpu_pda array v2)
	Branch: 
	Follows: v2.6.26-rc2
	Precedes: next-20080526

	    x86: remove the static 256k node_to_cpumask_map

crash, as described earlier.

I don't know what happened to that early exception - it didn't come back.

The below revert gets linux-next working for me.



From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit a9ad585c8a18f7ba754b85f5786976609b9d7d29
Author: Mike Travis <travis@sgi.com>
Date:   Mon May 12 21:21:12 2008 +0200

    x86: remove the static 256k node_to_cpumask_map
    
      * Consolidate node_to_cpumask operations and remove the 256k
        byte node_to_cpumask_map.  This is done by allocating the
        node_to_cpumask_map array after the number of possible nodes
        (nr_node_ids) is known.
    
      * Debug printouts when CONFIG_DEBUG_PER_CPU_MAPS is active have
        been increased.  It now shows faults when calling node_to_cpumask()
        and node_to_cpumask_ptr().
    
    For inclusion into sched-devel/latest tree.
    
    Based on:
    	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c    |  132 +----------------------------------
 arch/x86/mm/numa_64.c      |    6 +
 include/asm-x86/topology.h |   25 ++----
 3 files changed, 19 insertions(+), 144 deletions(-)

diff -puN arch/x86/kernel/setup.c~revert-x86-remove-the-static-256k-node_to_cpumask_map arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/arch/x86/kernel/setup.c
@@ -35,16 +35,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
 /* map cpu index to node index */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
-/* which logical CPUs are on which nodes */
-cpumask_t *node_to_cpumask_map;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
-/* setup node_to_cpumask_map */
-static void __init setup_node_to_cpumask_map(void);
-
-#else
-static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
@@ -191,15 +181,11 @@ void __init setup_per_cpu_areas(void)
 
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
+	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
 
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
-	/* Setup node to cpumask map */
-	setup_node_to_cpumask_map();
-
 	/* Setup cpumask_of_cpu map */
 	setup_cpumask_of_cpu();
 }
@@ -220,35 +206,6 @@ void __cpuinit amd_enable_pci_ext_cfg(st
 #endif
 
 #ifdef X86_64_NUMA
-
-/*
- * Allocate node_to_cpumask_map based on number of available nodes
- * Requires node_possible_map to be valid.
- *
- * Note: node_to_cpumask() is not valid until after this is done.
- */
-static void __init setup_node_to_cpumask_map(void)
-{
-	unsigned int node, num = 0;
-	cpumask_t *map;
-
-	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
-
-	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-
-	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
-}
-
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
@@ -271,8 +228,6 @@ void __cpuinit numa_clear_node(int cpu)
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
 
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
 void __cpuinit numa_add_cpu(int cpu)
 {
 	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
@@ -282,44 +237,9 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
 }
+#endif /* CONFIG_NUMA */
 
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	int node = cpu_to_node(cpu);
-	cpumask_t *mask;
-	char buf[64];
-
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map NULL\n");
-		dump_stack();
-		return;
-	}
-
-	mask = &node_to_cpumask_map[node];
-	if (enable)
-		cpu_set(cpu, *mask);
-	else
-		cpu_clear(cpu, *mask);
-
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
- }
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
+#if defined(CONFIG_DEBUG_PER_CPU_MAPS) && defined(CONFIG_X86_64)
 
 int cpu_to_node(int cpu)
 {
@@ -333,10 +253,6 @@ int cpu_to_node(int cpu)
 }
 EXPORT_SYMBOL(cpu_to_node);
 
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
 int early_cpu_to_node(int cpu)
 {
 	if (early_per_cpu_ptr(x86_cpu_to_node_map))
@@ -345,47 +261,9 @@ int early_cpu_to_node(int cpu)
 	if (!per_cpu_offset(cpu)) {
 		printk(KERN_WARNING
 			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
+			dump_stack();
 		return NUMA_NO_NODE;
 	}
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
-
-/*
- * Returns a pointer to the bitmask of CPUs on Node 'node'.
- */
-cpumask_t *_node_to_cpumask_ptr(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return &cpu_online_map;
-	}
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
-
-/*
- * Returns a bitmask of CPUs on Node 'node'.
- */
-cpumask_t node_to_cpumask(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
-		dump_stack();
-		return cpu_online_map;
-	}
-	return node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(node_to_cpumask);
-
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-#endif /* X86_64_NUMA */
+#endif
diff -puN arch/x86/mm/numa_64.c~revert-x86-remove-the-static-256k-node_to_cpumask_map arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/arch/x86/mm/numa_64.c
@@ -35,6 +35,9 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
+cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
@@ -557,6 +560,9 @@ void __init numa_initmem_init(unsigned l
 	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
+	/* cpumask_of_cpu() may not be available during early startup */
+	memset(&node_to_cpumask_map[0], 0, sizeof(node_to_cpumask_map[0]));
+	cpu_set(0, node_to_cpumask_map[0]);
 	e820_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
diff -puN include/asm-x86/topology.h~revert-x86-remove-the-static-256k-node_to_cpumask_map include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~revert-x86-remove-the-static-256k-node_to_cpumask_map
+++ a/include/asm-x86/topology.h
@@ -57,16 +57,10 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'. */
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return node_to_cpumask_map[node];
-}
-
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t *node_to_cpumask_map;
+extern cpumask_t node_to_cpumask_map[];
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
@@ -110,6 +104,7 @@ static inline cpumask_t node_to_cpumask(
 }
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
+#endif /* CONFIG_X86_64 */
 
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
@@ -118,7 +113,12 @@ static inline cpumask_t node_to_cpumask(
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
 
-#endif /* CONFIG_X86_64 */
+/* Returns the number of the first CPU on Node 'node'. */
+static inline int node_to_first_cpu(int node)
+{
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
+}
 
 /*
  * Returns the number of the node containing Node 'node'. This
@@ -204,15 +204,6 @@ static inline int node_to_first_cpu(int 
 
 #include <asm-generic/topology.h>
 
-#ifdef CONFIG_NUMA
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
-}
-#endif
-
 extern cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
_

