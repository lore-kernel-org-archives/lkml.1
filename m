Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbXH0XzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbXH0XzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXH0Xy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:54:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3056 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbXH0Xyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:54:54 -0400
Subject: [PATCH] trivial - convert "for(foo=0;foo<NR_CPUS;foo++)" to
	"for_each_possible_cpu(foo)"
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Mike Travis <travis@sgi.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 16:54:47 -0700
Message-Id: <1188258887.18004.173.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Done via grep/sed and compile tested i386 with xen

Changed the foo++ and ++foo forms

$ egrep -r -l "for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\1\+\+[[:space:]]*[[:space:]]*\)" * | xargs sed -i -r -e "s/for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\1[[:space:]]*\+\+[[:space:]]*\)/for_each_possible_cpu\(\1\)/g"
$ egrep -r -l "for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\+\+[[:space:]]*\1[[:space:]]*\)" * | xargs sed -i -r -e "s/for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\+\+[[:space:]]*\1[[:space:]]*\)/for_each_possible_cpu\(\1\)/g"

There are 3 more lines that could be modified:

arch/powerpc/sysdev/mpic.c:     for (i = 0; i < NR_CPUS; ++i, cpumask >>= 1)
arch/sparc/kernel/smp.c:        for (cpu = 0, num = 0; cpu < NR_CPUS; cpu++)
arch/sparc64/kernel/smp.c:      for (i = 0; i < NR_CPUS; i++, ptr += size)

Also available for git pull:

git pull git://repo.or.cz/linux-2.6/trivial-mods.git for_each_possible_cpu

Signed-off-by: Joe Perches <joe@perches.com>

--

 arch/alpha/kernel/core_t2.c            |    2 +-
 arch/alpha/kernel/smp.c                |   10 +++++-----
 arch/cris/arch-v32/kernel/irq.c        |    2 +-
 arch/i386/kernel/smp.c                 |    2 +-
 arch/i386/kernel/smpboot.c             |    4 ++--
 arch/i386/mach-voyager/voyager_smp.c   |   10 +++++-----
 arch/i386/xen/smp.c                    |    6 +++---
 arch/ia64/kernel/mca.c                 |    4 ++--
 arch/ia64/kernel/numa.c                |    4 ++--
 arch/ia64/kernel/perfmon.c             |    4 ++--
 arch/ia64/kernel/salinfo.c             |    2 +-
 arch/ia64/kernel/smpboot.c             |    2 +-
 arch/ia64/mm/contig.c                  |    2 +-
 arch/ia64/mm/discontig.c               |    8 ++++----
 arch/ia64/sn/kernel/setup.c            |    2 +-
 arch/m32r/kernel/smpboot.c             |    6 +++---
 arch/mips/kernel/gdb-stub.c            |    2 +-
 arch/mips/kernel/setup.c               |    2 +-
 arch/mips/kernel/smtc-proc.c           |    6 +++---
 arch/mips/kernel/smtc.c                |   12 ++++++------
 arch/mips/sibyte/bcm1480/irq.c         |    2 +-
 arch/mips/sibyte/sb1250/irq.c          |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 arch/powerpc/mm/numa.c                 |    2 +-
 arch/powerpc/platforms/iseries/dt.c    |    2 +-
 arch/powerpc/xmon/xmon.c               |    2 +-
 arch/ppc/syslib/open_pic.c             |    2 +-
 arch/ppc/xmon/xmon.c                   |    2 +-
 arch/sparc/kernel/sun4d_smp.c          |    4 ++--
 arch/sparc/kernel/sun4m_smp.c          |    2 +-
 arch/sparc64/kernel/traps.c            |    2 +-
 arch/x86_64/kernel/apic.c              |    2 +-
 arch/x86_64/kernel/head64.c            |    2 +-
 arch/x86_64/kernel/nmi.c               |    2 +-
 arch/x86_64/mm/numa.c                  |    6 +++---
 arch/x86_64/mm/srat.c                  |    2 +-
 drivers/acpi/processor_core.c          |    2 +-
 drivers/acpi/processor_thermal.c       |    2 +-
 drivers/cpufreq/cpufreq.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_irq.c  |    2 +-
 drivers/pnp/pnpbios/bioscalls.c        |    2 +-
 include/asm-ia64/smp.h                 |    2 +-
 kernel/module.c                        |    4 ++--
 mm/page_alloc.c                        |    2 +-
 net/core/dev.c                         |    4 ++--
 45 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index f5ca525..99ad08b 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -413,7 +413,7 @@ t2_init_arch(void)
 	unsigned long temp;
 	unsigned int i;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		mcheck_expected(i) = 0;
 		mcheck_taken(i) = 0;
 	}
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index ad17644..be95c1b 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -247,7 +247,7 @@ recv_secondary_console_msg(void)
 
 	mycpu = hard_smp_processor_id();
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (!(txrdy & (1UL << i)))
 			continue;
 
@@ -502,7 +502,7 @@ smp_cpus_done(unsigned int max_cpus)
 	int cpu;
 	unsigned long bogosum = 0;
 
-	for(cpu = 0; cpu < NR_CPUS; cpu++) 
+	for_each_possible_cpu(cpu) 
 		if (cpu_online(cpu))
 			bogosum += cpu_data[cpu].loops_per_jiffy;
 	
@@ -854,7 +854,7 @@ flush_tlb_mm(struct mm_struct *mm)
 		flush_tlb_current(mm);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
+			for_each_possible_cpu(cpu) {
 				if (!cpu_online(cpu) || cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
@@ -903,7 +903,7 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
+			for_each_possible_cpu(cpu) {
 				if (!cpu_online(cpu) || cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
@@ -959,7 +959,7 @@ flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 		__load_new_mm_context(mm);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
+			for_each_possible_cpu(cpu) {
 				if (!cpu_online(cpu) || cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index cc361bf..a06a560 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -197,7 +197,7 @@ mask_irq(int irq)
 {
 	int cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		block_irq(irq, cpu);
 }
 
diff --git a/arch/i386/kernel/smp.c b/arch/i386/kernel/smp.c
index 2d35d85..22e6295 100644
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -672,7 +672,7 @@ static int convert_apicid_to_cpu(int apic_id)
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (x86_cpu_to_apicid[i] == apic_id)
 			return i;
 	}
diff --git a/arch/i386/kernel/smpboot.c b/arch/i386/kernel/smpboot.c
index e4f61d1..cf60df0 100644
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -1074,7 +1074,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 	 * Allow the user to impress friends.
 	 */
 	Dprintk("Before bogomips.\n");
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		if (cpu_isset(cpu, cpu_callout_map))
 			bogosum += cpu_data[cpu].loops_per_jiffy;
 	printk(KERN_INFO
@@ -1105,7 +1105,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 	 * construct cpu_sibling_map[], so that we can tell sibling CPUs
 	 * efficiently.
 	 */
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(cpu_sibling_map[cpu]);
 		cpus_clear(cpu_core_map[cpu]);
 	}
diff --git a/arch/i386/mach-voyager/voyager_smp.c b/arch/i386/mach-voyager/voyager_smp.c
index b87f854..0403acb 100644
--- a/arch/i386/mach-voyager/voyager_smp.c
+++ b/arch/i386/mach-voyager/voyager_smp.c
@@ -382,7 +382,7 @@ find_smp_config(void)
 	printk("VOYAGER SMP: Boot cpu is %d\n", boot_cpu_id);
 
 	/* initialize the CPU structures (moved from smp_boot_cpus) */
-	for(i=0; i<NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		cpu_irq_affinity[i] = ~0;
 	}
 	cpu_online_map = cpumask_of_cpu(boot_cpu_id);
@@ -700,7 +700,7 @@ smp_boot_cpus(void)
 	
 	/* loop over all the extended VIC CPUs and boot them.  The 
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
-	for(i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if(i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
@@ -712,7 +712,7 @@ smp_boot_cpus(void)
 	 * Code added from smpboot.c */
 	{
 		unsigned long bogosum = 0;
-		for (i = 0; i < NR_CPUS; i++)
+		for_each_possible_cpu(i)
 			if (cpu_isset(i, cpu_online_map))
 				bogosum += cpu_data[i].loops_per_jiffy;
 		printk(KERN_INFO "Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
@@ -1357,7 +1357,7 @@ setup_profiling_timer(unsigned int multiplier)
 	 * new values until the next timer interrupt in which they do process
 	 * accounting.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
@@ -1390,7 +1390,7 @@ smp_intr_init(void)
 	int i;
 
 	/* initialize the per cpu irq mask to all disabled */
-	for(i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		vic_irq_mask[i] = 0xFFFF;
 
 	VIC_SET_GATE(VIC_CPI_LEVEL0, vic_cpi_interrupt);
diff --git a/arch/i386/xen/smp.c b/arch/i386/xen/smp.c
index 557b8e2..6fb78a0 100644
--- a/arch/i386/xen/smp.c
+++ b/arch/i386/xen/smp.c
@@ -128,7 +128,7 @@ void __init xen_fill_possible_map(void)
 {
 	int i, rc;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0)
 			cpu_set(i, cpu_possible_map);
@@ -146,7 +146,7 @@ void __init xen_smp_prepare_boot_cpu(void)
 	   old memory can be recycled */
 	make_lowmem_page_readwrite(&per_cpu__gdt_page);
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(cpu_sibling_map[cpu]);
 		cpus_clear(cpu_core_map[cpu]);
 	}
@@ -158,7 +158,7 @@ void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(cpu_sibling_map[cpu]);
 		cpus_clear(cpu_core_map[cpu]);
 	}
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 63b73f3..6d372e2 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1773,7 +1773,7 @@ ia64_mca_cpu_init(void *cpu_data)
 
 		first_time = 0;
 		mca_data = mca_bootmem();
-		for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		for_each_possible_cpu(cpu) {
 			format_mca_init_stack(mca_data,
 					offsetof(struct ia64_mca_cpu, mca_stack),
 					"MCA", cpu);
@@ -1851,7 +1851,7 @@ ia64_mca_init(void)
 	IA64_MCA_DEBUG("%s: begin\n", __FUNCTION__);
 
 	/* Clear the Rendez checkin flag for all cpus */
-	for(i = 0 ; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		ia64_mc_info.imi_rendez_checkin[i] = IA64_MCA_RENDEZ_CHECKIN_NOTDONE;
 
 	/*
diff --git a/arch/ia64/kernel/numa.c b/arch/ia64/kernel/numa.c
index a78b45f..16693f0 100644
--- a/arch/ia64/kernel/numa.c
+++ b/arch/ia64/kernel/numa.c
@@ -73,9 +73,9 @@ void __init build_cpu_to_node_map(void)
 	for(node=0; node < MAX_NUMNODES; node++)
 		cpus_clear(node_to_cpu_mask[node]);
 
-	for(cpu = 0; cpu < NR_CPUS; ++cpu) {
+	for_each_possible_cpu(cpu) {
 		node = -1;
-		for (i = 0; i < NR_CPUS; ++i)
+		for_each_possible_cpu(i)
 			if (cpu_physical_id(cpu) == node_cpuid[i].phys_id) {
 				node = node_cpuid[i].nid;
 				break;
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 14b8e5a..de26c3c 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -3750,7 +3750,7 @@ pfm_debug(pfm_context_t *ctx, void *arg, int count, struct pt_regs *regs)
 
 	if (m == 0) {
 		memset(pfm_stats, 0, sizeof(pfm_stats));
-		for(m=0; m < NR_CPUS; m++) pfm_stats[m].pfm_ovfl_intr_cycles_min = ~0UL;
+		for_each_possible_cpu(m) pfm_stats[m].pfm_ovfl_intr_cycles_min = ~0UL;
 	}
 	return 0;
 }
@@ -6738,7 +6738,7 @@ pfm_init(void)
 
 	init_pfm_fs();
 
-	for(i=0; i < NR_CPUS; i++) pfm_stats[i].pfm_ovfl_intr_cycles_min = ~0UL;
+	for_each_possible_cpu(i) pfm_stats[i].pfm_ovfl_intr_cycles_min = ~0UL;
 
 	return 0;
 }
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 25cd75f..9c9c9d9 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -317,7 +317,7 @@ retry:
 	}
 
 	n = data->cpu_check;
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (cpu_isset(n, data->cpu_event)) {
 			if (!cpu_online(n)) {
 				cpu_clear(n, data->cpu_event);
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 62209dc..504e39d 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -575,7 +575,7 @@ smp_build_cpu_map (void)
 	int sapicid, cpu, i;
 	int boot_cpu_id = hard_smp_processor_id();
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		ia64_cpu_to_sapicid[cpu] = -1;
 	}
 
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 7ac8592..4e29001 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -203,7 +203,7 @@ per_cpu_init (void)
 		first_time=0;
 		cpu_data = __alloc_bootmem(PERCPU_PAGE_SIZE * NR_CPUS,
 					   PERCPU_PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-		for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		for_each_possible_cpu(cpu) {
 			memcpy(cpu_data, __phys_per_cpu_start, __per_cpu_end - __per_cpu_start);
 			__per_cpu_offset[cpu] = (char *) cpu_data - __per_cpu_start;
 			cpu_data += PERCPU_PAGE_SIZE;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 0dbf0e8..6b43cc6 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -103,7 +103,7 @@ static int __meminit early_nr_cpus_node(int node)
 {
 	int cpu, n = 0;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		if (node == node_cpuid[cpu].nid)
 			n++;
 
@@ -141,7 +141,7 @@ static void *per_cpu_node_setup(void *cpu_data, int node)
 #ifdef CONFIG_SMP
 	int cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		if (node == node_cpuid[cpu].nid) {
 			memcpy(__va(cpu_data), __phys_per_cpu_start,
 			       __per_cpu_end - __per_cpu_start);
@@ -344,7 +344,7 @@ static void __init initialize_pernode_data(void)
 
 #ifdef CONFIG_SMP
 	/* Set the node_data pointer for each per-cpu struct */
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		node = node_cpuid[cpu].nid;
 		per_cpu(cpu_info, cpu).node_data = mem_data[node].node_data;
 	}
@@ -498,7 +498,7 @@ void __cpuinit *per_cpu_init(void)
 
 	if (first_time) {
 		first_time = 0;
-		for (cpu = 0; cpu < NR_CPUS; cpu++)
+		for_each_possible_cpu(cpu)
 			per_cpu(local_per_cpu_offset, cpu) = __per_cpu_offset[cpu];
 	}
 
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index 1f38a3a..b9c9684 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -764,7 +764,7 @@ nasid_slice_to_cpuid(int nasid, int slice)
 {
 	long cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		if (cpuid_to_nasid(cpu) == nasid &&
 					cpuid_to_slice(cpu) == slice)
 			return cpu;
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 9dae410..462a5a5 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -207,7 +207,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	Dprintk("CPU present map : %lx\n", physids_coerce(phys_cpu_present_map));
 
-	for (phys_id = 0 ; phys_id < NR_CPUS ; phys_id++) {
+	for_each_possible_cpu(phys_id) {
 		/*
 		 * Don't even attempt to start the boot CPU!
 		 */
@@ -594,7 +594,7 @@ int setup_profiling_timer(unsigned int multiplier)
 	 * accounting. At that time they also adjust their APIC timers
 	 * accordingly.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
@@ -605,7 +605,7 @@ static void __init init_cpu_to_physid(void)
 {
 	int  i;
 
-	for (i = 0 ; i < NR_CPUS ; i++) {
+	for_each_possible_cpu(i) {
 		cpu_2_physid[i] = -1;
 		physid_2_cpu[i] = -1;
 	}
diff --git a/arch/mips/kernel/gdb-stub.c b/arch/mips/kernel/gdb-stub.c
index cb5623a..d365122 100644
--- a/arch/mips/kernel/gdb-stub.c
+++ b/arch/mips/kernel/gdb-stub.c
@@ -712,7 +712,7 @@ static int kgdb_smp_call_kgdb_wait(void)
 	mb();
 
 	/* Send a message to all other CPUs and wait for them to respond */
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		if (cpu_online(i) && i != cpu)
 			core_send_ipi(i, SMP_CALL_FUNCTION);
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 316685f..4d695ef 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -556,7 +556,7 @@ static int __init fpu_disable(char *s)
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		cpu_data[i].options &= ~MIPS_CPU_FPU;
 
 	return 1;
diff --git a/arch/mips/kernel/smtc-proc.c b/arch/mips/kernel/smtc-proc.c
index 6f37099..ad70b08 100644
--- a/arch/mips/kernel/smtc-proc.c
+++ b/arch/mips/kernel/smtc-proc.c
@@ -56,7 +56,7 @@ static int proc_read_smtc(char *page, char **start, off_t off,
 	len = sprintf(page, "Counter Interrupts taken per CPU (TC)\n");
 	totalen += len;
 	page += len;
-	for (i=0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		len = sprintf(page, "%d: %ld\n", i, smtc_cpu_stats[i].timerints);
 		totalen += len;
 		page += len;
@@ -64,7 +64,7 @@ static int proc_read_smtc(char *page, char **start, off_t off,
 	len = sprintf(page, "Self-IPIs by CPU:\n");
 	totalen += len;
 	page += len;
-	for(i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		len = sprintf(page, "%d: %ld\n", i, smtc_cpu_stats[i].selfipis);
 		totalen += len;
 		page += len;
@@ -81,7 +81,7 @@ void init_smtc_stats(void)
 {
 	int i;
 
-	for (i=0; i<NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		smtc_cpu_stats[i].timerints = 0;
 		smtc_cpu_stats[i].selfipis = 0;
 	}
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 16aa5d3..b3e4d98 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -354,7 +354,7 @@ void mipsmt_prepare_cpus(void)
 	 * We probably don't have as many VPEs as we do SMP "CPUs",
 	 * but it's possible - and in any case we'll never use more!
 	 */
-	for (i=0; i<NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		IPIQ[i].head = IPIQ[i].tail = NULL;
 		spin_lock_init(&IPIQ[i].lock);
 		IPIQ[i].depth = 0;
@@ -632,7 +632,7 @@ static void smtc_ipi_qdump(void)
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS ;i++) {
+	for_each_possible_cpu(i) {
 		printk("IPIQ[%d]: head = 0x%x, tail = 0x%x, depth = %d\n",
 			i, (unsigned)IPIQ[i].head, (unsigned)IPIQ[i].tail,
 			IPIQ[i].depth);
@@ -1113,7 +1113,7 @@ void smtc_idle_loop_hook(void)
 	/*
 	 * Now that we limit outstanding timer IPIs, check for hung TC
 	 */
-	for (tc = 0; tc < NR_CPUS; tc++) {
+	for_each_possible_cpu(tc) {
 		/* Don't check ourself - we'll dequeue IPIs just below */
 		if ((tc != smp_processor_id()) &&
 		    ipi_timer_latch[tc] > timerq_limit) {
@@ -1151,16 +1151,16 @@ void smtc_soft_dump(void)
 	int i;
 
 	printk("Counter Interrupts taken per CPU (TC)\n");
-	for (i=0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		printk("%d: %ld\n", i, smtc_cpu_stats[i].timerints);
 	}
 	printk("Self-IPI invocations:\n");
-	for (i=0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		printk("%d: %ld\n", i, smtc_cpu_stats[i].selfipis);
 	}
 	smtc_ipi_qdump();
 	printk("Timer IPI Backlogs:\n");
-	for (i=0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		printk("%d: %d\n", i, ipi_timer_latch[i]);
 	}
 	printk("%d Recoveries of \"stolen\" FPU\n",
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index ba0c4b7..4e03277 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -219,7 +219,7 @@ static void ack_bcm1480_irq(unsigned int irq)
 		if (pending) {
 #ifdef CONFIG_SMP
 			int i;
-			for (i=0; i<NR_CPUS; i++) {
+			for_each_possible_cpu(i) {
 				/*
 				 * Clear for all CPUs so an affinity switch
 				 * doesn't find an old status
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 0e6a13c..b1e96cb 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -187,7 +187,7 @@ static void ack_sb1250_irq(unsigned int irq)
 	pending &= ((u64)1 << (irq));
 	if (pending) {
 		int i;
-		for (i=0; i<NR_CPUS; i++) {
+		for_each_possible_cpu(i) {
 			int cpu;
 #ifdef CONFIG_SMP
 			cpu = cpu_logical_map(i);
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 704375b..135e435 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -176,7 +176,7 @@ static void kexec_prepare_cpus(void)
 	my_cpu = get_cpu();
 
 	/* check the others cpus are now down (via paca hw cpu id == -1) */
-	for (i=0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (i == my_cpu)
 			continue;
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index c12adc3..7a6e4a8 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -492,7 +492,7 @@ void __init dump_numa_cpu_topology(void)
 		 * If we used a CPU iterator here we would miss printing
 		 * the holes in the cpumap.
 		 */
-		for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		for_each_possible_cpu(cpu) {
 			if (cpu_isset(cpu, numa_cpumask_lookup_table[node])) {
 				if (count == 0)
 					printk(" %u", cpu);
diff --git a/arch/powerpc/platforms/iseries/dt.c b/arch/powerpc/platforms/iseries/dt.c
index 9e8a334..68220de 100644
--- a/arch/powerpc/platforms/iseries/dt.c
+++ b/arch/powerpc/platforms/iseries/dt.c
@@ -251,7 +251,7 @@ static void __init dt_cpus(struct iseries_flat_dt *dt)
 	pft_size[0] = 0; /* NUMA CEC cookie, 0 for non NUMA  */
 	pft_size[1] = __ilog2(HvCallHpt_getHptPages() * HW_PAGE_SIZE);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (lppaca[i].dyn_proc_status >= 2)
 			continue;
 
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 121b04d..6422e9c 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -926,7 +926,7 @@ static int cpu_cmd(void)
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		count = 0;
-		for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		for_each_possible_cpu(cpu) {
 			if (cpu_isset(cpu, cpus_in_xmon)) {
 				if (count == 0)
 					printf(" %x", cpu);
diff --git a/arch/ppc/syslib/open_pic.c b/arch/ppc/syslib/open_pic.c
index 18ec947..c8dbfb7 100644
--- a/arch/ppc/syslib/open_pic.c
+++ b/arch/ppc/syslib/open_pic.c
@@ -510,7 +510,7 @@ static inline cpumask_t physmask(cpumask_t cpumask)
 
 	cpus_and(cpumask, cpu_online_map, cpumask);
 
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		if (cpu_isset(i, cpumask))
 			cpu_set(smp_hw_index[i], mask);
 
diff --git a/arch/ppc/xmon/xmon.c b/arch/ppc/xmon/xmon.c
index b1a9174..8e52068 100644
--- a/arch/ppc/xmon/xmon.c
+++ b/arch/ppc/xmon/xmon.c
@@ -590,7 +590,7 @@ static void cpu_cmd(void)
 	if (!scanhex(&cpu)) {
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
-		for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		for_each_possible_cpu(cpu) {
 			if (test_bit(cpu, &cpus_in_xmon)) {
 				printf(" %d", cpu);
 				if (cpu == smp_processor_id())
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 89a6de9..169b79f 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -218,7 +218,7 @@ void __init smp4d_smp_done(void)
 	/* setup cpu list for irq rotation */
 	first = 0;
 	prev = &first;
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		if (cpu_online(i)) {
 			*prev = i;
 			prev = &cpu_data(i).next;
@@ -444,7 +444,7 @@ void __init sun4d_init_smp(void)
 	BTFIXUPSET_CALL(smp_message_pass, smp4d_message_pass, BTFIXUPCALL_NORM);
 	BTFIXUPSET_CALL(__hard_smp_processor_id, __smp4d_processor_id, BTFIXUPCALL_NORM);
 	
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		ccall_info.processors_in[i] = 1;
 		ccall_info.processors_out[i] = 1;
 	}
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 730eb57..1355b41 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -185,7 +185,7 @@ void __init smp4m_smp_done(void)
 	/* setup cpu list for irq rotation */
 	first = 0;
 	prev = &first;
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (cpu_online(i)) {
 			*prev = i;
 			prev = &cpu_data(i).next;
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
diff --git a/arch/sparc64/kernel/traps.c b/arch/sparc64/kernel/traps.c
index 6ef42b8..eb40c9e 100644
--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -804,7 +804,7 @@ void __init cheetah_ecache_flush_init(void)
 	largest_size = 0UL;
 	smallest_linesize = ~0UL;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		unsigned long val;
 
 		val = cpu_data(i).ecache_size;
diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 925758d..cbd4355 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -1080,7 +1080,7 @@ __cpuinit int apic_is_clustered_box(void)
 
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		id = bios_cpu_apicid[i];
 		if (id != BAD_APICID)
 			__set_bit(APIC_CLUSTERID(id), clustermap);
diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
index 6c34bdd..2fdc101 100644
--- a/arch/x86_64/kernel/head64.c
+++ b/arch/x86_64/kernel/head64.c
@@ -74,7 +74,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	early_printk("Kernel alive\n");
 
- 	for (i = 0; i < NR_CPUS; i++)
+ 	for_each_possible_cpu(i)
  		cpu_pda(i) = &boot_cpu_pda[i];
 
 	pda_init(0);
diff --git a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
index 0ec6d2d..8a1d149 100644
--- a/arch/x86_64/kernel/nmi.c
+++ b/arch/x86_64/kernel/nmi.c
@@ -102,7 +102,7 @@ int __init check_nmi_watchdog (void)
 		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
 #endif
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		counts[cpu] = cpu_pda(cpu)->__nmi_count;
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 6da2355..0253097 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -260,7 +260,7 @@ void __init numa_init_array(void)
 	   CPUs, as the number of CPUs is not known yet. 
 	   We round robin the existing nodes. */
 	rr = first_node(node_online_map);
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (cpu_to_node[i] != NUMA_NO_NODE)
 			continue;
  		numa_set_node(i, rr);
@@ -528,7 +528,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	nodes_clear(node_online_map);
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		numa_set_node(i, 0);
 	node_to_cpumask[0] = cpumask_of_cpu(0);
 	e820_register_active_regions(0, start_pfn, end_pfn);
@@ -611,7 +611,7 @@ early_param("numa", numa_setup);
 void __init init_cpu_to_node(void)
 {
 	int i;
- 	for (i = 0; i < NR_CPUS; i++) {
+ 	for_each_possible_cpu(i) {
 		u8 apicid = x86_cpu_to_apicid[i];
 		if (apicid == BAD_APICID)
 			continue;
diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
index acdf03e..7f198c5 100644
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -430,7 +430,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		if (!node_online(i))
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (cpu_to_node[i] == NUMA_NO_NODE)
 			continue;
 		if (!node_isset(cpu_to_node[i], node_possible_map))
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e944aae..2d763ff 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -497,7 +497,7 @@ static int get_cpu_id(acpi_handle handle, u32 acpi_id)
 	if (apic_id == -1)
 		return apic_id;
 
-	for (i = 0; i < NR_CPUS; ++i) {
+	for_each_possible_cpu(i) {
 		if (arch_cpu_to_apicid[i] == apic_id)
 			return i;
 	}
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 06e6f3f..9549dbb 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -159,7 +159,7 @@ void acpi_thermal_cpufreq_init(void)
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		cpufreq_thermal_reduction_pctg[i] = 0;
 
 	i = cpufreq_register_notifier(&acpi_thermal_cpufreq_notifier_block,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2f6a73c..d80568e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1780,7 +1780,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		ret = -ENODEV;
 
 		/* check for at least one working CPU */
-		for (i=0; i<NR_CPUS; i++)
+		for_each_possible_cpu(i)
 			if (cpufreq_cpu_data[i])
 				ret = 0;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index ee06d8b..cb8eb0d 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -872,7 +872,7 @@ void ehca_destroy_comp_pool(void)
 	unregister_cpu_notifier(&comp_pool_callback_nb);
 #endif
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (cpu_online(i))
 			destroy_comp_task(pool, i);
 	}
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 5dba68f..f77af2d 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -479,7 +479,7 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;
diff --git a/include/asm-ia64/smp.h b/include/asm-ia64/smp.h
index 6314b29..e4428e2 100644
--- a/include/asm-ia64/smp.h
+++ b/include/asm-ia64/smp.h
@@ -78,7 +78,7 @@ cpu_logical_id (int cpuid)
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		if (cpu_physical_id(i) == cpuid)
 			break;
 	return i;
diff --git a/kernel/module.c b/kernel/module.c
index db0ead0..cbb3450 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -503,7 +503,7 @@ static void module_unload_init(struct module *mod)
 	unsigned int i;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		local_set(&mod->ref[i].count, 0);
 	/* Hold reference count during initialization. */
 	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
@@ -629,7 +629,7 @@ unsigned int module_refcount(struct module *mod)
 {
 	unsigned int i, total = 0;
 
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i)
 		total += local_read(&mod->ref[i].count);
 	return total;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6427653..b226aa3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2458,7 +2458,7 @@ static __meminit void zone_pcp_init(struct zone *zone)
 	int cpu;
 	unsigned long batch = zone_batchsize(zone);
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 #ifdef CONFIG_NUMA
 		/* Early boot. Slab allocator not functional yet */
 		zone_pcp(zone, cpu) = &boot_pageset[cpu];
diff --git a/net/core/dev.c b/net/core/dev.c
index a76021c..91e997e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3940,7 +3940,7 @@ netdev_dma_event(struct dma_client *client, struct dma_chan *chan,
 	spin_lock(&net_dma->lock);
 	switch (state) {
 	case DMA_RESOURCE_AVAILABLE:
-		for (i = 0; i < NR_CPUS; i++)
+		for_each_possible_cpu(i)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				break;
@@ -3955,7 +3955,7 @@ netdev_dma_event(struct dma_client *client, struct dma_chan *chan,
 		}
 		break;
 	case DMA_RESOURCE_REMOVED:
-		for (i = 0; i < NR_CPUS; i++)
+		for_each_possible_cpu(i)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				pos = i;


