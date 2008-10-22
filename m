Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbYJVWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbYJVWbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYJVWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:30:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:33481 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbYJVWan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:30:43 -0400
Date: Wed, 22 Oct 2008 15:30:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] get rid if __cpuinit and __cpuexit
Message-ID: <20081022153054.335ce51e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b62f70d43d3e9a9a70775b40cb4ecba058f07a01 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 22 Oct 2008 15:29:00 -0700
Subject: [PATCH] get rid if __cpuinit and __cpuexit

as discussed briefly at the kernel summit; __cpuinit and __cpuexit are
causing a ton more complexity than they're worth (just see how many
section warnings an average build has); and the *vast* majority
of people using linux have CPU hotplug enabled anyway (since it's required
for suspend/resume). The code size saved is also very minimal, since although
many files are touched, very few are actually present in a kernel image at a time.

For now, __cpuinit and __cpuexit are left behind as empty skelletons to not break
in-flight stuff using it, it should be removed in a release or two entirely.

Signed-off-by Arjan van de Ven <arjan@linux.intel.com>
---
 Documentation/cpu-hotplug.txt              |    4 +-
 arch/alpha/kernel/smp.c                    |    4 +-
 arch/arm/common/gic.c                      |    2 +-
 arch/arm/kernel/smp.c                      |   12 ++--
 arch/arm/mach-realview/localtimer.c        |    8 ++--
 arch/arm/mach-realview/platsmp.c           |    6 +-
 arch/cris/arch-v32/kernel/smp.c            |    2 +-
 arch/frv/kernel/setup.c                    |    2 +-
 arch/ia64/kernel/err_inject.c              |    8 ++--
 arch/ia64/kernel/mca.c                     |   12 ++--
 arch/ia64/kernel/numa.c                    |    4 +-
 arch/ia64/kernel/palinfo.c                 |    4 +-
 arch/ia64/kernel/salinfo.c                 |    4 +-
 arch/ia64/kernel/setup.c                   |   10 ++--
 arch/ia64/kernel/smpboot.c                 |   12 ++--
 arch/ia64/kernel/topology.c                |   18 ++++----
 arch/ia64/mm/contig.c                      |    2 +-
 arch/ia64/mm/discontig.c                   |    2 +-
 arch/ia64/sn/kernel/setup.c                |    4 +-
 arch/m32r/kernel/smpboot.c                 |    2 +-
 arch/mips/kernel/cevt-bcm1480.c            |    2 +-
 arch/mips/kernel/cevt-r4k.c                |    2 +-
 arch/mips/kernel/cevt-sb1250.c             |    2 +-
 arch/mips/kernel/cevt-smtc.c               |    2 +-
 arch/mips/kernel/cpu-bugs64.c              |    4 +-
 arch/mips/kernel/cpu-probe.c               |   10 ++--
 arch/mips/kernel/smp-mt.c                  |    6 +-
 arch/mips/kernel/smp-up.c                  |    6 +-
 arch/mips/kernel/smp.c                     |    6 +-
 arch/mips/kernel/smtc.c                    |    2 +-
 arch/mips/kernel/spram.c                   |   14 +++---
 arch/mips/kernel/time.c                    |    2 +-
 arch/mips/kernel/traps.c                   |    8 ++--
 arch/mips/kernel/watch.c                   |    2 +-
 arch/mips/lib/uncached.c                   |    2 +-
 arch/mips/mipssim/sim_smtc.c               |    6 +-
 arch/mips/mipssim/sim_time.c               |    2 +-
 arch/mips/mm/c-r3k.c                       |    8 ++--
 arch/mips/mm/c-r4k.c                       |   34 +++++++-------
 arch/mips/mm/c-tx39.c                      |    2 +-
 arch/mips/mm/page.c                        |   40 ++++++++--------
 arch/mips/mm/sc-ip22.c                     |    2 +-
 arch/mips/mm/sc-mips.c                     |    2 +-
 arch/mips/mm/sc-r5k.c                      |    2 +-
 arch/mips/mm/sc-rm7k.c                     |    6 +-
 arch/mips/mm/tlb-r3k.c                     |    2 +-
 arch/mips/mm/tlb-r4k.c                     |    8 ++--
 arch/mips/mm/tlb-r8k.c                     |    4 +-
 arch/mips/mm/tlbex.c                       |   70 ++++++++++++++--------------
 arch/mips/mm/uasm.c                        |   70 ++++++++++++++--------------
 arch/mips/mm/uasm.h                        |   24 +++++-----
 arch/mips/mti-malta/malta-smtc.c           |    6 +-
 arch/mips/mti-malta/malta-time.c           |    2 +-
 arch/mips/pci/pci-ip27.c                   |    2 +-
 arch/mips/pmc-sierra/yosemite/smp.c        |   12 ++--
 arch/mips/sgi-ip27/ip27-init.c             |    4 +-
 arch/mips/sgi-ip27/ip27-smp.c              |    6 +-
 arch/mips/sgi-ip27/ip27-timer.c            |    6 +-
 arch/mips/sgi-ip27/ip27-xtalk.c            |    6 +-
 arch/mips/sibyte/bcm1480/smp.c             |    8 ++--
 arch/mips/sibyte/sb1250/smp.c              |    8 ++--
 arch/parisc/kernel/hardware.c              |    2 +-
 arch/parisc/kernel/processor.c             |    2 +-
 arch/parisc/kernel/smp.c                   |    4 +-
 arch/powerpc/kernel/smp.c                  |    2 +-
 arch/powerpc/kernel/sysfs.c                |   12 ++--
 arch/powerpc/mm/numa.c                     |   12 ++--
 arch/s390/appldata/appldata_base.c         |    8 ++--
 arch/s390/kernel/entry.h                   |    2 +-
 arch/s390/kernel/setup.c                   |    4 +-
 arch/s390/kernel/smp.c                     |   10 ++--
 arch/sh/kernel/smp.c                       |    4 +-
 arch/sh/kernel/traps_32.c                  |    2 +-
 arch/sparc/kernel/smp.c                    |    8 ++--
 arch/sparc/kernel/sun4d_smp.c              |    2 +-
 arch/sparc/kernel/sun4m_smp.c              |    4 +-
 arch/sparc64/kernel/ds.c                   |    4 +-
 arch/sparc64/kernel/entry.h                |    2 +-
 arch/sparc64/kernel/irq.c                  |    4 +-
 arch/sparc64/kernel/mdesc.c                |    2 +-
 arch/sparc64/kernel/smp.c                  |    4 +-
 arch/sparc64/kernel/sysfs.c                |    4 +-
 arch/sparc64/mm/init.c                     |    2 +-
 arch/x86/kernel/acpi/boot.c                |    4 +-
 arch/x86/kernel/apic_32.c                  |   12 ++--
 arch/x86/kernel/apic_64.c                  |   18 ++++----
 arch/x86/kernel/cpu/addon_cpuid_features.c |    6 +-
 arch/x86/kernel/cpu/amd.c                  |   22 ++++----
 arch/x86/kernel/cpu/centaur.c              |   26 +++++-----
 arch/x86/kernel/cpu/centaur_64.c           |    6 +-
 arch/x86/kernel/cpu/common.c               |   58 +++++++++++-----------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    4 +-
 arch/x86/kernel/cpu/cyrix.c                |   40 ++++++++--------
 arch/x86/kernel/cpu/intel.c                |   22 ++++----
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   44 +++++++++---------
 arch/x86/kernel/cpu/mcheck/mce_64.c        |   16 +++---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |   10 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c  |    4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |    8 ++--
 arch/x86/kernel/cpu/transmeta.c            |    6 +-
 arch/x86/kernel/cpu/umc.c                  |    2 +-
 arch/x86/kernel/cpuid.c                    |    4 +-
 arch/x86/kernel/ds.c                       |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c           |    4 +-
 arch/x86/kernel/i387.c                     |    6 +-
 arch/x86/kernel/irq_32.c                   |    2 +-
 arch/x86/kernel/microcode_core.c           |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c         |   14 +++---
 arch/x86/kernel/msr.c                      |    4 +-
 arch/x86/kernel/numaq_32.c                 |    4 +-
 arch/x86/kernel/process.c                  |    8 ++--
 arch/x86/kernel/ptrace.c                   |    2 +-
 arch/x86/kernel/setup.c                    |    2 +-
 arch/x86/kernel/setup_percpu.c             |   16 +++---
 arch/x86/kernel/smpboot.c                  |   28 ++++++------
 arch/x86/kernel/smpcommon.c                |    2 +-
 arch/x86/kernel/tlb_64.c                   |    2 +-
 arch/x86/kernel/tsc.c                      |    2 +-
 arch/x86/kernel/tsc_sync.c                 |   18 ++++----
 arch/x86/kernel/vsyscall_64.c              |    6 +-
 arch/x86/kernel/xsave.c                    |    2 +-
 arch/x86/mach-voyager/voyager_smp.c        |    4 +-
 arch/x86/mm/init_64.c                      |    4 +-
 arch/x86/mm/numa_64.c                      |    2 +-
 arch/x86/mm/pat.c                          |    2 +-
 arch/x86/pci/amd_bus.c                     |    4 +-
 arch/x86/xen/setup.c                       |    6 +-
 arch/x86/xen/smp.c                         |    8 ++--
 arch/x86/xen/spinlock.c                    |    2 +-
 arch/x86/xen/xen-ops.h                     |    2 +-
 arch/xtensa/kernel/time.c                  |    2 +-
 block/blk-softirq.c                        |    4 +-
 drivers/acpi/ec.c                          |    2 +-
 drivers/acpi/numa.c                        |    2 +-
 drivers/acpi/processor_core.c              |    4 +-
 drivers/acpi/processor_idle.c              |    4 +-
 drivers/base/cpu.c                         |    4 +-
 drivers/base/topology.c                    |    8 ++--
 drivers/cpufreq/cpufreq.c                  |    2 +-
 drivers/cpufreq/cpufreq_stats.c            |    2 +-
 drivers/hwmon/coretemp.c                   |    4 +-
 drivers/infiniband/hw/ehca/ehca_irq.c      |    6 +-
 drivers/s390/sysinfo.c                     |    2 +-
 include/asm-x86/ds.h                       |    2 +-
 include/asm-x86/mmconfig.h                 |    4 +-
 include/asm-x86/mpspec.h                   |    2 +-
 include/asm-x86/numa_64.h                  |    8 ++--
 include/asm-x86/ptrace.h                   |    2 +-
 include/asm-x86/smp.h                      |    4 +-
 include/linux/cpu.h                        |    2 +-
 include/linux/init.h                       |    9 +--
 init/calibrate.c                           |    6 +-
 kernel/cpu.c                               |    6 +-
 kernel/fork.c                              |    4 +-
 kernel/hrtimer.c                           |    6 +-
 kernel/rcuclassic.c                        |    6 +-
 kernel/rcupreempt.c                        |    6 +-
 kernel/relay.c                             |    2 +-
 kernel/sched.c                             |    8 ++--
 kernel/smp.c                               |    2 +-
 kernel/softirq.c                           |    8 ++--
 kernel/softlockup.c                        |    4 +-
 kernel/timer.c                             |   10 ++--
 lib/percpu_counter.c                       |    2 +-
 mm/page-writeback.c                        |    4 +-
 mm/page_alloc.c                            |    6 +-
 mm/slab.c                                  |   10 ++--
 mm/slub.c                                  |    4 +-
 mm/vmstat.c                                |    6 +-
 net/iucv/iucv.c                            |    2 +-
 170 files changed, 642 insertions(+), 645 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 94bbc27..50f7609 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -236,7 +236,7 @@ Q: If i have some kernel code that needs to be aware of CPU arrival and
 A: This is what you would need in your kernel code to receive notifications.
 
 	#include <linux/cpu.h>
-	static int __cpuinit foobar_cpu_callback(struct notifier_block *nfb,
+	static int foobar_cpu_callback(struct notifier_block *nfb,
 					    unsigned long action, void *hcpu)
 	{
 		unsigned int cpu = (unsigned long)hcpu;
@@ -254,7 +254,7 @@ A: This is what you would need in your kernel code to receive notifications.
 		return NOTIFY_OK;
 	}
 
-	static struct notifier_block __cpuinitdata foobar_cpu_notifer =
+	static struct notifier_block foobar_cpu_notifer =
 	{
 	   .notifier_call = foobar_cpu_callback,
 	};
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index e657c45..b9eef22 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -360,7 +360,7 @@ secondary_cpu_start(int cpuid, struct task_struct *idle)
 /*
  * Bring one cpu online.
  */
-static int __cpuinit
+static int 
 smp_boot_one_cpu(int cpuid)
 {
 	struct task_struct *idle;
@@ -488,7 +488,7 @@ smp_prepare_boot_cpu(void)
 {
 }
 
-int __cpuinit
+int 
 __cpu_up(unsigned int cpu)
 {
 	smp_boot_one_cpu(cpu);
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 7fc9860..fb37983 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -241,7 +241,7 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	writel(1, base + GIC_DIST_CTRL);
 }
 
-void __cpuinit gic_cpu_init(unsigned int gic_nr, void __iomem *base)
+void gic_cpu_init(unsigned int gic_nr, void __iomem *base)
 {
 	if (gic_nr >= MAX_GIC_NR)
 		BUG();
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e42a749..3dd3029 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -72,7 +72,7 @@ enum ipi_msg_type {
 	IPI_CPU_STOP,
 };
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
 	struct task_struct *idle = ci->idle;
@@ -157,7 +157,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 /*
  * __cpu_disable runs on the processor to be shutdown.
  */
-int __cpuexit __cpu_disable(void)
+int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct task_struct *p;
@@ -204,7 +204,7 @@ int __cpuexit __cpu_disable(void)
  * called on the thread which is asking for a CPU to be shutdown -
  * waits until shutdown has completed, or it is timed out.
  */
-void __cpuexit __cpu_die(unsigned int cpu)
+void __cpu_die(unsigned int cpu)
 {
 	if (!platform_cpu_kill(cpu))
 		printk("CPU%u: unable to kill\n", cpu);
@@ -218,7 +218,7 @@ void __cpuexit __cpu_die(unsigned int cpu)
  * of the other hotplug-cpu capable cores, so presumably coming
  * out of idle fixes this.
  */
-void __cpuexit cpu_die(void)
+void cpu_die(void)
 {
 	unsigned int cpu = smp_processor_id();
 
@@ -247,7 +247,7 @@ void __cpuexit cpu_die(void)
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void __cpuinit secondary_start_kernel(void)
+asmlinkage void secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu = smp_processor_id();
@@ -305,7 +305,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
  * Called by both boot and secondaries to move global data into
  * per-processor storage.
  */
-void __cpuinit smp_store_cpu_info(unsigned int cpuid)
+void smp_store_cpu_info(unsigned int cpuid)
 {
 	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpuid);
 
diff --git a/arch/arm/mach-realview/localtimer.c b/arch/arm/mach-realview/localtimer.c
index 44d178c..2133507 100644
--- a/arch/arm/mach-realview/localtimer.c
+++ b/arch/arm/mach-realview/localtimer.c
@@ -101,7 +101,7 @@ int local_timer_ack(void)
 	return 0;
 }
 
-static void __cpuinit twd_calibrate_rate(unsigned int cpu)
+static void twd_calibrate_rate(unsigned int cpu)
 {
 	void __iomem *base = TWD_BASE(cpu);
 	unsigned long load, count;
@@ -148,7 +148,7 @@ static void __cpuinit twd_calibrate_rate(unsigned int cpu)
 /*
  * Setup the local clock events for a CPU.
  */
-void __cpuinit local_timer_setup(unsigned int cpu)
+void local_timer_setup(unsigned int cpu)
 {
 	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
 	unsigned long flags;
@@ -178,7 +178,7 @@ void __cpuinit local_timer_setup(unsigned int cpu)
 /*
  * take a local timer down
  */
-void __cpuexit local_timer_stop(unsigned int cpu)
+void local_timer_stop(unsigned int cpu)
 {
 	__raw_writel(0, TWD_BASE(cpu) + TWD_TIMER_CONTROL);
 }
@@ -190,7 +190,7 @@ static void dummy_timer_set_mode(enum clock_event_mode mode,
 {
 }
 
-void __cpuinit local_timer_setup(unsigned int cpu)
+void local_timer_setup(unsigned int cpu)
 {
 	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
 
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index e102aeb..3525a8e 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -29,7 +29,7 @@ extern void realview_secondary_startup(void);
  * control for which core is the next to come out of the secondary
  * boot "holding pen"
  */
-volatile int __cpuinitdata pen_release = -1;
+volatile int pen_release = -1;
 
 static unsigned int __init get_core_count(void)
 {
@@ -72,7 +72,7 @@ static void scu_enable(void)
 
 static DEFINE_SPINLOCK(boot_lock);
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+void platform_secondary_init(unsigned int cpu)
 {
 	trace_hardirqs_off();
 
@@ -107,7 +107,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+int boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 52e16c6..b93b3d0 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -211,7 +211,7 @@ int setup_profiling_timer(unsigned int multiplier)
  */
 unsigned long cache_decay_ticks = 1;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	smp_boot_one_cpu(cpu);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 0669e13..ad2714a 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -708,7 +708,7 @@ static void __init reserve_dma_coherent(void)
 /*
  * calibrate the delay loop
  */
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	loops_per_jiffy = __delay_loops_MHz * (1000000 / HZ);
 
diff --git a/arch/ia64/kernel/err_inject.c b/arch/ia64/kernel/err_inject.c
index c539c68..aadc440 100644
--- a/arch/ia64/kernel/err_inject.c
+++ b/arch/ia64/kernel/err_inject.c
@@ -225,17 +225,17 @@ static struct attribute_group err_inject_attr_group = {
 	.name = "err_inject"
 };
 /* Add/Remove err_inject interface for CPU device */
-static int __cpuinit err_inject_add_dev(struct sys_device * sys_dev)
+static int err_inject_add_dev(struct sys_device * sys_dev)
 {
 	return sysfs_create_group(&sys_dev->kobj, &err_inject_attr_group);
 }
 
-static int __cpuinit err_inject_remove_dev(struct sys_device * sys_dev)
+static int err_inject_remove_dev(struct sys_device * sys_dev)
 {
 	sysfs_remove_group(&sys_dev->kobj, &err_inject_attr_group);
 	return 0;
 }
-static int __cpuinit err_inject_cpu_callback(struct notifier_block *nfb,
+static int err_inject_cpu_callback(struct notifier_block *nfb,
 		unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -256,7 +256,7 @@ static int __cpuinit err_inject_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata err_inject_cpu_notifier =
+static struct notifier_block err_inject_cpu_notifier =
 {
 	.notifier_call = err_inject_cpu_callback,
 };
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 7dd96c1..c886f95 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -629,7 +629,7 @@ ia64_mca_register_cpev (int cpev)
  * Outputs
  *	None
  */
-void __cpuinit
+void 
 ia64_mca_cmc_vector_setup (void)
 {
 	cmcv_reg_t	cmcv;
@@ -1779,7 +1779,7 @@ static struct irqaction mca_cpep_irqaction = {
  * format most of the fields.
  */
 
-static void __cpuinit
+static void 
 format_mca_init_stack(void *mca_data, unsigned long offset,
 		const char *type, int cpu)
 {
@@ -1809,7 +1809,7 @@ static void * __init_refok mca_bootmem(void)
 }
 
 /* Do per-CPU MCA-related initialization.  */
-void __cpuinit
+void 
 ia64_mca_cpu_init(void *cpu_data)
 {
 	void *pal_vaddr;
@@ -1861,7 +1861,7 @@ ia64_mca_cpu_init(void *cpu_data)
 							      PAGE_KERNEL));
 }
 
-static void __cpuinit ia64_mca_cmc_vector_adjust(void *dummy)
+static void ia64_mca_cmc_vector_adjust(void *dummy)
 {
 	unsigned long flags;
 
@@ -1871,7 +1871,7 @@ static void __cpuinit ia64_mca_cmc_vector_adjust(void *dummy)
 	local_irq_restore(flags);
 }
 
-static int __cpuinit mca_cpu_callback(struct notifier_block *nfb,
+static int mca_cpu_callback(struct notifier_block *nfb,
 				      unsigned long action,
 				      void *hcpu)
 {
@@ -1887,7 +1887,7 @@ static int __cpuinit mca_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mca_cpu_notifier __cpuinitdata = {
+static struct notifier_block mca_cpu_notifier = {
 	.notifier_call = mca_cpu_callback
 };
 
diff --git a/arch/ia64/kernel/numa.c b/arch/ia64/kernel/numa.c
index c93420c..d288cde 100644
--- a/arch/ia64/kernel/numa.c
+++ b/arch/ia64/kernel/numa.c
@@ -30,7 +30,7 @@ EXPORT_SYMBOL(cpu_to_node_map);
 cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
 EXPORT_SYMBOL(node_to_cpu_mask);
 
-void __cpuinit map_cpu_to_node(int cpu, int nid)
+void map_cpu_to_node(int cpu, int nid)
 {
 	int oldnid;
 	if (nid < 0) { /* just initialize by zero */
@@ -51,7 +51,7 @@ void __cpuinit map_cpu_to_node(int cpu, int nid)
 	return;
 }
 
-void __cpuinit unmap_cpu_from_node(int cpu, int nid)
+void unmap_cpu_from_node(int cpu, int nid)
 {
 	WARN_ON(!cpu_isset(cpu, node_to_cpu_mask[nid]));
 	WARN_ON(cpu_to_node_map[cpu] != nid);
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index e5c57f4..3a8c519 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -968,7 +968,7 @@ palinfo_read_entry(char *page, char **start, off_t off, int count, int *eof, voi
 	return len;
 }
 
-static void __cpuinit
+static void 
 create_palinfo_proc_entries(unsigned int cpu)
 {
 #	define CPUSTR	"cpu%d"
@@ -1029,7 +1029,7 @@ remove_palinfo_proc_entries(unsigned int hcpu)
 	}
 }
 
-static int __cpuinit palinfo_cpu_callback(struct notifier_block *nfb,
+static int palinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int hotcpu = (unsigned long)hcpu;
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index ecb9eb7..84eba7a 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -574,7 +574,7 @@ static const struct file_operations salinfo_data_fops = {
 	.write   = salinfo_log_write,
 };
 
-static int __cpuinit
+static int 
 salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int i, cpu = (unsigned long)hcpu;
@@ -615,7 +615,7 @@ salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu
 	return NOTIFY_OK;
 }
 
-static struct notifier_block salinfo_cpu_notifier __cpuinitdata =
+static struct notifier_block salinfo_cpu_notifier =
 {
 	.notifier_call = salinfo_cpu_callback,
 	.priority = 0,
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index de636b2..3699432 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -742,7 +742,7 @@ const struct seq_operations cpuinfo_op = {
 #define MAX_BRANDS	8
 static char brandname[MAX_BRANDS][128];
 
-static char * __cpuinit
+static char * 
 get_model_name(__u8 family, __u8 model)
 {
 	static int overflow;
@@ -772,7 +772,7 @@ get_model_name(__u8 family, __u8 model)
 	return "Unknown";
 }
 
-static void __cpuinit
+static void 
 identify_cpu (struct cpuinfo_ia64 *c)
 {
 	union {
@@ -852,7 +852,7 @@ setup_per_cpu_areas (void)
  * In addition, the minimum of the i-cache stride sizes is calculated for
  * "flush_icache_range()".
  */
-static void __cpuinit
+static void 
 get_max_cacheline_size (void)
 {
 	unsigned long line_size, max = 1;
@@ -909,10 +909,10 @@ get_max_cacheline_size (void)
  * cpu_init() initializes state that is per-CPU.  This function acts
  * as a 'CPU state barrier', nothing should get across.
  */
-void __cpuinit
+void 
 cpu_init (void)
 {
-	extern void __cpuinit ia64_mmu_init (void *);
+	extern void ia64_mmu_init (void *);
 	static unsigned long max_num_phys_stacked = IA64_NUM_PHYS_STACK_REG;
 	unsigned long num_phys_stacked;
 	pal_vm_info_2_u_t vmi;
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 1dcbb85..5fd38c7 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -373,7 +373,7 @@ smp_setup_percpu_timer (void)
 {
 }
 
-static void __cpuinit
+static void 
 smp_callin (void)
 {
 	int cpuid, phys_id, itc_master;
@@ -464,7 +464,7 @@ smp_callin (void)
 /*
  * Activate a secondary processor.  head.S calls this.
  */
-int __cpuinit
+int 
 start_secondary (void *unused)
 {
 	/* Early console may use I/O ports */
@@ -481,7 +481,7 @@ start_secondary (void *unused)
 	return 0;
 }
 
-struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
+struct pt_regs * idle_regs(struct pt_regs *regs)
 {
 	return NULL;
 }
@@ -493,7 +493,7 @@ struct create_idle {
 	int cpu;
 };
 
-void __cpuinit
+void 
 do_fork_idle(struct work_struct *work)
 {
 	struct create_idle *c_idle =
@@ -503,7 +503,7 @@ do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
-static int __cpuinit
+static int 
 do_boot_cpu (int sapicid, int cpu)
 {
 	int timeout;
@@ -807,7 +807,7 @@ set_cpu_sibling_map(int cpu)
 	}
 }
 
-int __cpuinit
+int 
 __cpu_up (unsigned int cpu)
 {
 	int ret;
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 26228e2..913e1ad 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -131,11 +131,11 @@ struct cpu_cache_info {
 	struct kobject kobj;
 };
 
-static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS] __cpuinitdata;
+static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS];
 #define LEAF_KOBJECT_PTR(x,y)    (&all_cpu_cache_info[x].cache_leaves[y])
 
 #ifdef CONFIG_SMP
-static void __cpuinit cache_shared_cpu_map_setup( unsigned int cpu,
+static void cache_shared_cpu_map_setup( unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	pal_cache_shared_info_t	csi;
@@ -170,7 +170,7 @@ static void __cpuinit cache_shared_cpu_map_setup( unsigned int cpu,
 				&csi) == PAL_STATUS_SUCCESS);
 }
 #else
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu,
+static void cache_shared_cpu_map_setup(unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	cpu_set(cpu, this_leaf->shared_cpu_map);
@@ -293,7 +293,7 @@ static struct kobj_type cache_ktype_percpu_entry = {
 	.sysfs_ops	= &cache_sysfs_ops,
 };
 
-static void __cpuinit cpu_cache_sysfs_exit(unsigned int cpu)
+static void cpu_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(all_cpu_cache_info[cpu].cache_leaves);
 	all_cpu_cache_info[cpu].cache_leaves = NULL;
@@ -302,7 +302,7 @@ static void __cpuinit cpu_cache_sysfs_exit(unsigned int cpu)
 	return;
 }
 
-static int __cpuinit cpu_cache_sysfs_init(unsigned int cpu)
+static int cpu_cache_sysfs_init(unsigned int cpu)
 {
 	u64 i, levels, unique_caches;
 	pal_cache_config_info_t cci;
@@ -346,7 +346,7 @@ static int __cpuinit cpu_cache_sysfs_init(unsigned int cpu)
 }
 
 /* Add cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
+static int cache_add_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
@@ -392,7 +392,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 }
 
 /* Remove cache interface for CPU device */
-static int __cpuinit cache_remove_dev(struct sys_device * sys_dev)
+static int cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
@@ -416,7 +416,7 @@ static int __cpuinit cache_remove_dev(struct sys_device * sys_dev)
  * When a cpu is hot-plugged, do a check and initiate
  * cache kobject if necessary
  */
-static int __cpuinit cache_cpu_callback(struct notifier_block *nfb,
+static int cache_cpu_callback(struct notifier_block *nfb,
 		unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -436,7 +436,7 @@ static int __cpuinit cache_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cache_cpu_notifier =
+static struct notifier_block cache_cpu_notifier =
 {
 	.notifier_call = cache_cpu_callback
 };
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 0ee085e..72cb323 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -151,7 +151,7 @@ static void *cpu_data;
  *
  * Allocate and setup per-cpu data areas.
  */
-void * __cpuinit
+void * 
 per_cpu_init (void)
 {
 	int cpu;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index d8c5fcd..c3bead8 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -493,7 +493,7 @@ void __init find_memory(void)
  * find_pernode_space() does most of this already, we just need to set
  * local_per_cpu_offset
  */
-void __cpuinit *per_cpu_init(void)
+void *per_cpu_init(void)
 {
 	int cpu;
 	static int first_time = 1;
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index bb1d249..b248b7d 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -192,7 +192,7 @@ void __init early_sn_setup(void)
 }
 
 extern int platform_intr_list[];
-static int __cpuinitdata shub_1_1_found;
+static int shub_1_1_found;
 
 /*
  * sn_check_for_wars
@@ -561,7 +561,7 @@ static void __init sn_init_pdas(char **cmdline_p)
  * Also sets up a few fields in the nodepda.  Also known as
  * platform_cpu_init() by the ia64 machvec code.
  */
-void __cpuinit sn_cpu_init(void)
+void sn_cpu_init(void)
 {
 	int cpuid;
 	int cpuphyid;
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index fc29948..1bc5a47 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -352,7 +352,7 @@ static void __init do_boot_cpu(int phys_id)
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu_id)
+int __cpu_up(unsigned int cpu_id)
 {
 	int timeout;
 
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index 0a57f86..9cf0790 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -107,7 +107,7 @@ static DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
 static DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
 static DEFINE_PER_CPU(char [18], sibyte_hpt_name);
 
-void __cpuinit sb1480_clockevent_init(void)
+void sb1480_clockevent_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned int irq = K_BCM1480_INT_TIMER_0 + cpu;
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 4a4c59f..3812578 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -160,7 +160,7 @@ int c0_compare_int_usable(void)
 
 #ifndef CONFIG_MIPS_MT_SMTC
 
-int __cpuinit mips_clockevent_init(void)
+int mips_clockevent_init(void)
 {
 	uint64_t mips_freq = mips_hpt_frequency;
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index 63ac3ad..fb68565 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -105,7 +105,7 @@ static DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
 static DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
 static DEFINE_PER_CPU(char [18], sibyte_hpt_name);
 
-void __cpuinit sb1250_clockevent_init(void)
+void sb1250_clockevent_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned int irq = K_INT_TIMER_0 + cpu;
diff --git a/arch/mips/kernel/cevt-smtc.c b/arch/mips/kernel/cevt-smtc.c
index 5162fe4..673d467 100644
--- a/arch/mips/kernel/cevt-smtc.c
+++ b/arch/mips/kernel/cevt-smtc.c
@@ -245,7 +245,7 @@ irqreturn_t c0_compare_interrupt(int irq, void *dev_id)
 }
 
 
-int __cpuinit mips_clockevent_init(void)
+int mips_clockevent_init(void)
 {
 	uint64_t mips_freq = mips_hpt_frequency;
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/mips/kernel/cpu-bugs64.c b/arch/mips/kernel/cpu-bugs64.c
index 02b7713..a4ce82a 100644
--- a/arch/mips/kernel/cpu-bugs64.c
+++ b/arch/mips/kernel/cpu-bugs64.c
@@ -167,7 +167,7 @@ static inline void check_mult_sh(void)
 	panic(bug64hit, !R4000_WAR ? r4kwar : nowar);
 }
 
-static volatile int daddi_ov __cpuinitdata = 0;
+static volatile int daddi_ov = 0;
 
 asmlinkage void __init do_daddi_ov(struct pt_regs *regs)
 {
@@ -239,7 +239,7 @@ static inline void check_daddi(void)
 	panic(bug64hit, !DADDI_WAR ? daddiwar : nowar);
 }
 
-int daddiu_bug __cpuinitdata = -1;
+int daddiu_bug = -1;
 
 static inline void check_daddiu(void)
 {
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 0cf1545..12dbcd6 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -544,7 +544,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c)
 	}
 }
 
-static char unknown_isa[] __cpuinitdata = KERN_ERR \
+static char unknown_isa[] = KERN_ERR \
 	"Unsupported ISA type, c0.config0: %d.";
 
 static inline unsigned int decode_config0(struct cpuinfo_mips *c)
@@ -650,7 +650,7 @@ static inline unsigned int decode_config3(struct cpuinfo_mips *c)
 	return config3 & MIPS_CONF_M;
 }
 
-static void __cpuinit decode_configs(struct cpuinfo_mips *c)
+static void decode_configs(struct cpuinfo_mips *c)
 {
 	/* MIPS32 or MIPS64 compliant CPU.  */
 	c->options = MIPS_CPU_4KEX | MIPS_CPU_4K_CACHE | MIPS_CPU_COUNTER |
@@ -820,7 +820,7 @@ const char *__cpu_name[NR_CPUS];
 /*
  * Name a CPU
  */
-static __cpuinit const char *cpu_to_name(struct cpuinfo_mips *c)
+static const char *cpu_to_name(struct cpuinfo_mips *c)
 {
 	const char *name = NULL;
 
@@ -903,7 +903,7 @@ static __cpuinit const char *cpu_to_name(struct cpuinfo_mips *c)
 	return name;
 }
 
-__cpuinit void cpu_probe(void)
+void cpu_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int cpu = smp_processor_id();
@@ -966,7 +966,7 @@ __cpuinit void cpu_probe(void)
 		c->srsets = 1;
 }
 
-__cpuinit void cpu_report(void)
+void cpu_report(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 87a1816..6a5c3af 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -149,7 +149,7 @@ static void vsmp_send_ipi_mask(cpumask_t mask, unsigned int action)
 		vsmp_send_ipi_single(i, action);
 }
 
-static void __cpuinit vsmp_init_secondary(void)
+static void vsmp_init_secondary(void)
 {
 	extern int gic_present;
 
@@ -162,7 +162,7 @@ static void __cpuinit vsmp_init_secondary(void)
 					 STATUSF_IP6 | STATUSF_IP7);
 }
 
-static void __cpuinit vsmp_smp_finish(void)
+static void vsmp_smp_finish(void)
 {
 	/* CDFIXME: remove this? */
 	write_c0_compare(read_c0_count() + (8* mips_hpt_frequency/HZ));
@@ -188,7 +188,7 @@ static void vsmp_cpus_done(void)
  * (unsigned long)idle->thread_info the gp
  * assumes a 1:1 mapping of TC => VPE
  */
-static void __cpuinit vsmp_boot_secondary(int cpu, struct task_struct *idle)
+static void vsmp_boot_secondary(int cpu, struct task_struct *idle)
 {
 	struct thread_info *gp = task_thread_info(idle);
 	dvpe();
diff --git a/arch/mips/kernel/smp-up.c b/arch/mips/kernel/smp-up.c
index ead6c30..372f575 100644
--- a/arch/mips/kernel/smp-up.c
+++ b/arch/mips/kernel/smp-up.c
@@ -27,11 +27,11 @@ static inline void up_send_ipi_mask(cpumask_t mask, unsigned int action)
  *  After we've done initial boot, this function is called to allow the
  *  board code to clean up state, if needed
  */
-void __cpuinit up_init_secondary(void)
+void up_init_secondary(void)
 {
 }
 
-void __cpuinit up_smp_finish(void)
+void up_smp_finish(void)
 {
 }
 
@@ -43,7 +43,7 @@ void up_cpus_done(void)
 /*
  * Firmware CPU startup hook
  */
-void __cpuinit up_boot_secondary(int cpu, struct task_struct *idle)
+void up_boot_secondary(int cpu, struct task_struct *idle)
 {
 }
 
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 7b59cfb..7c392d4 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -85,7 +85,7 @@ static inline void set_cpu_sibling_map(int cpu)
 
 struct plat_smp_ops *mp_ops;
 
-__cpuinit void register_smp_ops(struct plat_smp_ops *ops)
+void register_smp_ops(struct plat_smp_ops *ops)
 {
 	if (mp_ops)
 		printk(KERN_WARNING "Overriding previously set SMP ops\n");
@@ -97,7 +97,7 @@ __cpuinit void register_smp_ops(struct plat_smp_ops *ops)
  * First C code run on the secondary CPUs after being started up by
  * the master.
  */
-asmlinkage __cpuinit void start_secondary(void)
+asmlinkage void start_secondary(void)
 {
 	unsigned int cpu;
 
@@ -209,7 +209,7 @@ void __devinit smp_prepare_boot_cpu(void)
  * and keep control until "cpu_online(cpu)" is set.  Note: cpu is
  * physical, not logical.
  */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle;
 
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 897fb2b..1355da7 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -578,7 +578,7 @@ void smtc_prepare_cpus(int cpus)
  * (unsigned long)idle->thread_info the gp
  *
  */
-void __cpuinit smtc_boot_secondary(int cpu, struct task_struct *idle)
+void smtc_boot_secondary(int cpu, struct task_struct *idle)
 {
 	extern u32 kernelsp[NR_CPUS];
 	unsigned long flags;
diff --git a/arch/mips/kernel/spram.c b/arch/mips/kernel/spram.c
index 6ddb507..f52f588 100644
--- a/arch/mips/kernel/spram.c
+++ b/arch/mips/kernel/spram.c
@@ -39,7 +39,7 @@
 /*
  * Different semantics to the set_c0_* function built by __BUILD_SET_C0
  */
-static __cpuinit unsigned int bis_c0_errctl(unsigned int set)
+static unsigned int bis_c0_errctl(unsigned int set)
 {
 	unsigned int res;
 	res = read_c0_errctl();
@@ -47,7 +47,7 @@ static __cpuinit unsigned int bis_c0_errctl(unsigned int set)
 	return res;
 }
 
-static __cpuinit void ispram_store_tag(unsigned int offset, unsigned int data)
+static void ispram_store_tag(unsigned int offset, unsigned int data)
 {
 	unsigned int errctl;
 
@@ -66,7 +66,7 @@ static __cpuinit void ispram_store_tag(unsigned int offset, unsigned int data)
 }
 
 
-static __cpuinit unsigned int ispram_load_tag(unsigned int offset)
+static unsigned int ispram_load_tag(unsigned int offset)
 {
 	unsigned int data;
 	unsigned int errctl;
@@ -84,7 +84,7 @@ static __cpuinit unsigned int ispram_load_tag(unsigned int offset)
 	return data;
 }
 
-static __cpuinit void dspram_store_tag(unsigned int offset, unsigned int data)
+static void dspram_store_tag(unsigned int offset, unsigned int data)
 {
 	unsigned int errctl;
 
@@ -100,7 +100,7 @@ static __cpuinit void dspram_store_tag(unsigned int offset, unsigned int data)
 }
 
 
-static __cpuinit unsigned int dspram_load_tag(unsigned int offset)
+static unsigned int dspram_load_tag(unsigned int offset)
 {
 	unsigned int data;
 	unsigned int errctl;
@@ -117,7 +117,7 @@ static __cpuinit unsigned int dspram_load_tag(unsigned int offset)
 	return data;
 }
 
-static __cpuinit void probe_spram(char *type,
+static void probe_spram(char *type,
 	    unsigned int base,
 	    unsigned int (*read)(unsigned int),
 	    void (*write)(unsigned int, unsigned int))
@@ -199,7 +199,7 @@ static __cpuinit void probe_spram(char *type,
 	}
 }
 
-__cpuinit void spram_config(void)
+void spram_config(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config0;
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index 1f467d5..edc657d 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -87,7 +87,7 @@ void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
 	cs->mult = (u32) temp;
 }
 
-void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
+void clockevent_set_clock(struct clock_event_device *cd,
 	unsigned int clock)
 {
 	u64 temp;
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 80b9e07..9546269 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1416,7 +1416,7 @@ int cp0_compare_irq;
 int cp0_perfcount_irq;
 EXPORT_SYMBOL_GPL(cp0_perfcount_irq);
 
-static int __cpuinitdata noulri;
+static int noulri;
 
 static int __init ulri_disable(char *s)
 {
@@ -1427,7 +1427,7 @@ static int __init ulri_disable(char *s)
 }
 __setup("noulri", ulri_disable);
 
-void __cpuinit per_cpu_trap_init(void)
+void per_cpu_trap_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned int status_set = ST0_CU0;
@@ -1542,11 +1542,11 @@ void __init set_handler(unsigned long offset, void *addr, unsigned long size)
 	local_flush_icache_range(ebase + offset, ebase + offset + size);
 }
 
-static char panic_null_cerr[] __cpuinitdata =
+static char panic_null_cerr[] =
 	"Trying to set NULL cache error exception handler";
 
 /* Install uncached CPU exception handler */
-void __cpuinit set_uncached_handler(unsigned long offset, void *addr,
+void set_uncached_handler(unsigned long offset, void *addr,
 	unsigned long size)
 {
 #ifdef CONFIG_32BIT
diff --git a/arch/mips/kernel/watch.c b/arch/mips/kernel/watch.c
index c154069..63ddb10 100644
--- a/arch/mips/kernel/watch.c
+++ b/arch/mips/kernel/watch.c
@@ -100,7 +100,7 @@ void mips_clear_watch_registers(void)
 	}
 }
 
-__cpuinit void mips_probe_watch_registers(struct cpuinfo_mips *c)
+void mips_probe_watch_registers(struct cpuinfo_mips *c)
 {
 	unsigned int t;
 
diff --git a/arch/mips/lib/uncached.c b/arch/mips/lib/uncached.c
index a6d1c77..12b2ede 100644
--- a/arch/mips/lib/uncached.c
+++ b/arch/mips/lib/uncached.c
@@ -36,7 +36,7 @@
  * values, so we can avoid sharing the same stack area between a cached
  * and the uncached mode.
  */
-unsigned long __cpuinit run_uncached(void *func)
+unsigned long run_uncached(void *func)
 {
 	register long sp __asm__("$sp");
 	register long ret __asm__("$2");
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
index d6e4f65..d40d38f 100644
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -54,7 +54,7 @@ static inline void ssmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
 /*
  * Post-config but pre-boot cleanup entry point
  */
-static void __cpuinit ssmtc_init_secondary(void)
+static void ssmtc_init_secondary(void)
 {
 	void smtc_init_secondary(void);
 
@@ -64,7 +64,7 @@ static void __cpuinit ssmtc_init_secondary(void)
 /*
  * SMP initialization finalization entry point
  */
-static void __cpuinit ssmtc_smp_finish(void)
+static void ssmtc_smp_finish(void)
 {
 	smtc_smp_finish();
 }
@@ -79,7 +79,7 @@ static void ssmtc_cpus_done(void)
 /*
  * Platform "CPU" startup hook
  */
-static void __cpuinit ssmtc_boot_secondary(int cpu, struct task_struct *idle)
+static void ssmtc_boot_secondary(int cpu, struct task_struct *idle)
 {
 	smtc_boot_secondary(cpu, idle);
 }
diff --git a/arch/mips/mipssim/sim_time.c b/arch/mips/mipssim/sim_time.c
index 881ecbc..7cf1061 100644
--- a/arch/mips/mipssim/sim_time.c
+++ b/arch/mips/mipssim/sim_time.c
@@ -83,7 +83,7 @@ static void mips_timer_dispatch(void)
 }
 
 
-unsigned __cpuinit get_c0_compare_int(void)
+unsigned get_c0_compare_int(void)
 {
 #ifdef MSC01E_INT_BASE
 	if (cpu_has_veic) {
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 5500c20..00d499e 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -26,7 +26,7 @@
 static unsigned long icache_size, dcache_size;		/* Size in bytes */
 static unsigned long icache_lsize, dcache_lsize;	/* Size in bytes */
 
-unsigned long __cpuinit r3k_cache_size(unsigned long ca_flags)
+unsigned long r3k_cache_size(unsigned long ca_flags)
 {
 	unsigned long flags, status, dummy, size;
 	volatile unsigned long *p;
@@ -61,7 +61,7 @@ unsigned long __cpuinit r3k_cache_size(unsigned long ca_flags)
 	return size * sizeof(*p);
 }
 
-unsigned long __cpuinit r3k_cache_lsize(unsigned long ca_flags)
+unsigned long r3k_cache_lsize(unsigned long ca_flags)
 {
 	unsigned long flags, status, lsize, i;
 	volatile unsigned long *p;
@@ -90,7 +90,7 @@ unsigned long __cpuinit r3k_cache_lsize(unsigned long ca_flags)
 	return lsize * sizeof(*p);
 }
 
-static void __cpuinit r3k_probe_cache(void)
+static void r3k_probe_cache(void)
 {
 	dcache_size = r3k_cache_size(ST0_ISC);
 	if (dcache_size)
@@ -307,7 +307,7 @@ static void r3k_dma_cache_wback_inv(unsigned long start, unsigned long size)
 	r3k_flush_dcache_range(start, start + size);
 }
 
-void __cpuinit r3k_cache_init(void)
+void r3k_cache_init(void)
 {
 	extern void build_clear_page(void);
 	extern void build_copy_page(void);
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 6e99665..7c14836 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -100,7 +100,7 @@ static inline void r4k_blast_dcache_page_dc32(unsigned long addr)
 	blast_dcache32_page(addr);
 }
 
-static void __cpuinit r4k_blast_dcache_page_setup(void)
+static void r4k_blast_dcache_page_setup(void)
 {
 	unsigned long  dc_lsize = cpu_dcache_line_size();
 
@@ -114,7 +114,7 @@ static void __cpuinit r4k_blast_dcache_page_setup(void)
 
 static void (* r4k_blast_dcache_page_indexed)(unsigned long addr);
 
-static void __cpuinit r4k_blast_dcache_page_indexed_setup(void)
+static void r4k_blast_dcache_page_indexed_setup(void)
 {
 	unsigned long dc_lsize = cpu_dcache_line_size();
 
@@ -128,7 +128,7 @@ static void __cpuinit r4k_blast_dcache_page_indexed_setup(void)
 
 static void (* r4k_blast_dcache)(void);
 
-static void __cpuinit r4k_blast_dcache_setup(void)
+static void r4k_blast_dcache_setup(void)
 {
 	unsigned long dc_lsize = cpu_dcache_line_size();
 
@@ -213,7 +213,7 @@ static inline void tx49_blast_icache32_page_indexed(unsigned long page)
 
 static void (* r4k_blast_icache_page)(unsigned long addr);
 
-static void __cpuinit r4k_blast_icache_page_setup(void)
+static void r4k_blast_icache_page_setup(void)
 {
 	unsigned long ic_lsize = cpu_icache_line_size();
 
@@ -230,7 +230,7 @@ static void __cpuinit r4k_blast_icache_page_setup(void)
 
 static void (* r4k_blast_icache_page_indexed)(unsigned long addr);
 
-static void __cpuinit r4k_blast_icache_page_indexed_setup(void)
+static void r4k_blast_icache_page_indexed_setup(void)
 {
 	unsigned long ic_lsize = cpu_icache_line_size();
 
@@ -254,7 +254,7 @@ static void __cpuinit r4k_blast_icache_page_indexed_setup(void)
 
 static void (* r4k_blast_icache)(void);
 
-static void __cpuinit r4k_blast_icache_setup(void)
+static void r4k_blast_icache_setup(void)
 {
 	unsigned long ic_lsize = cpu_icache_line_size();
 
@@ -275,7 +275,7 @@ static void __cpuinit r4k_blast_icache_setup(void)
 
 static void (* r4k_blast_scache_page)(unsigned long addr);
 
-static void __cpuinit r4k_blast_scache_page_setup(void)
+static void r4k_blast_scache_page_setup(void)
 {
 	unsigned long sc_lsize = cpu_scache_line_size();
 
@@ -293,7 +293,7 @@ static void __cpuinit r4k_blast_scache_page_setup(void)
 
 static void (* r4k_blast_scache_page_indexed)(unsigned long addr);
 
-static void __cpuinit r4k_blast_scache_page_indexed_setup(void)
+static void r4k_blast_scache_page_indexed_setup(void)
 {
 	unsigned long sc_lsize = cpu_scache_line_size();
 
@@ -311,7 +311,7 @@ static void __cpuinit r4k_blast_scache_page_indexed_setup(void)
 
 static void (* r4k_blast_scache)(void);
 
-static void __cpuinit r4k_blast_scache_setup(void)
+static void r4k_blast_scache_setup(void)
 {
 	unsigned long sc_lsize = cpu_scache_line_size();
 
@@ -718,11 +718,11 @@ static inline void rm7k_erratum31(void)
 	}
 }
 
-static char *way_string[] __cpuinitdata = { NULL, "direct mapped", "2-way",
+static char *way_string[] = { NULL, "direct mapped", "2-way",
 	"3-way", "4-way", "5-way", "6-way", "7-way", "8-way"
 };
 
-static void __cpuinit probe_pcache(void)
+static void probe_pcache(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config = read_c0_config();
@@ -1044,7 +1044,7 @@ static void __cpuinit probe_pcache(void)
  * executes in KSEG1 space or else you will crash and burn badly.  You have
  * been warned.
  */
-static int __cpuinit probe_scache(void)
+static int probe_scache(void)
 {
 	unsigned long flags, addr, begin, end, pow2;
 	unsigned int config = read_c0_config();
@@ -1123,7 +1123,7 @@ extern int r5k_sc_init(void);
 extern int rm7k_sc_init(void);
 extern int mips_sc_init(void);
 
-static void __cpuinit setup_scache(void)
+static void setup_scache(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config = read_c0_config();
@@ -1256,7 +1256,7 @@ static void nxp_pr4450_fixup_config(void)
 	NXP_BARRIER();
 }
 
-static int __cpuinitdata cca = -1;
+static int cca = -1;
 
 static int __init cca_setup(char *str)
 {
@@ -1267,7 +1267,7 @@ static int __init cca_setup(char *str)
 
 __setup("cca=", cca_setup);
 
-static void __cpuinit coherency_setup(void)
+static void coherency_setup(void)
 {
 	if (cca < 0 || cca > 7)
 		cca = read_c0_config() & CONF_CM_CMASK;
@@ -1310,7 +1310,7 @@ static void __cpuinit coherency_setup(void)
 
 #if defined(CONFIG_DMA_NONCOHERENT)
 
-static int __cpuinitdata coherentio;
+static int coherentio;
 
 static int __init setcoherentio(char *str)
 {
@@ -1322,7 +1322,7 @@ static int __init setcoherentio(char *str)
 __setup("coherentio", setcoherentio);
 #endif
 
-void __cpuinit r4k_cache_init(void)
+void r4k_cache_init(void)
 {
 	extern void build_clear_page(void);
 	extern void build_copy_page(void);
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index f7c8f9c..d602f86 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -339,7 +339,7 @@ static __init void tx39_probe_cache(void)
 	}
 }
 
-void __cpuinit tx39_cache_init(void)
+void tx39_cache_init(void)
 {
 	extern void build_clear_page(void);
 	extern void build_copy_page(void);
diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
index 1417c64..c8aad63 100644
--- a/arch/mips/mm/page.c
+++ b/arch/mips/mm/page.c
@@ -65,8 +65,8 @@ UASM_L_LA(_copy_pref_both)
 UASM_L_LA(_copy_pref_store)
 
 /* We need one branch and therefore one relocation per target label. */
-static struct uasm_label __cpuinitdata labels[5];
-static struct uasm_reloc __cpuinitdata relocs[5];
+static struct uasm_label labels[5];
+static struct uasm_reloc relocs[5];
 
 #define cpu_is_r4600_v1_x()	((read_c0_prid() & 0xfffffff0) == 0x00002010)
 #define cpu_is_r4600_v2_x()	((read_c0_prid() & 0xfffffff0) == 0x00002020)
@@ -110,23 +110,23 @@ void copy_page(void *to, void *from) __attribute__((alias("copy_page_array")));
 EXPORT_SYMBOL(copy_page);
 
 
-static int pref_bias_clear_store __cpuinitdata;
-static int pref_bias_copy_load __cpuinitdata;
-static int pref_bias_copy_store __cpuinitdata;
+static int pref_bias_clear_store;
+static int pref_bias_copy_load;
+static int pref_bias_copy_store;
 
-static u32 pref_src_mode __cpuinitdata;
-static u32 pref_dst_mode __cpuinitdata;
+static u32 pref_src_mode;
+static u32 pref_dst_mode;
 
-static int clear_word_size __cpuinitdata;
-static int copy_word_size __cpuinitdata;
+static int clear_word_size;
+static int copy_word_size;
 
-static int half_clear_loop_size __cpuinitdata;
-static int half_copy_loop_size __cpuinitdata;
+static int half_clear_loop_size;
+static int half_copy_loop_size;
 
-static int cache_line_size __cpuinitdata;
+static int cache_line_size;
 #define cache_line_mask() (cache_line_size - 1)
 
-static inline void __cpuinit
+static inline void 
 pg_addiu(u32 **buf, unsigned int reg1, unsigned int reg2, unsigned int off)
 {
 	if (cpu_has_64bit_gp_regs && DADDI_WAR && r4k_daddiu_bug()) {
@@ -146,7 +146,7 @@ pg_addiu(u32 **buf, unsigned int reg1, unsigned int reg2, unsigned int off)
 	}
 }
 
-static void __cpuinit set_prefetch_parameters(void)
+static void set_prefetch_parameters(void)
 {
 	if (cpu_has_64bit_gp_regs || cpu_has_64bit_zero_reg)
 		clear_word_size = 8;
@@ -245,7 +245,7 @@ static void __cpuinit set_prefetch_parameters(void)
 				      4 * copy_word_size));
 }
 
-static void __cpuinit build_clear_store(u32 **buf, int off)
+static void build_clear_store(u32 **buf, int off)
 {
 	if (cpu_has_64bit_gp_regs || cpu_has_64bit_zero_reg) {
 		uasm_i_sd(buf, ZERO, off, A0);
@@ -254,7 +254,7 @@ static void __cpuinit build_clear_store(u32 **buf, int off)
 	}
 }
 
-static inline void __cpuinit build_clear_pref(u32 **buf, int off)
+static inline void build_clear_pref(u32 **buf, int off)
 {
 	if (off & cache_line_mask())
 		return;
@@ -281,7 +281,7 @@ static inline void __cpuinit build_clear_pref(u32 **buf, int off)
 		}
 }
 
-void __cpuinit build_clear_page(void)
+void build_clear_page(void)
 {
 	int off;
 	u32 *buf = (u32 *)&clear_page_array;
@@ -369,7 +369,7 @@ void __cpuinit build_clear_page(void)
 	pr_debug("\t.set pop\n");
 }
 
-static void __cpuinit build_copy_load(u32 **buf, int reg, int off)
+static void build_copy_load(u32 **buf, int reg, int off)
 {
 	if (cpu_has_64bit_gp_regs) {
 		uasm_i_ld(buf, reg, off, A1);
@@ -378,7 +378,7 @@ static void __cpuinit build_copy_load(u32 **buf, int reg, int off)
 	}
 }
 
-static void __cpuinit build_copy_store(u32 **buf, int reg, int off)
+static void build_copy_store(u32 **buf, int reg, int off)
 {
 	if (cpu_has_64bit_gp_regs) {
 		uasm_i_sd(buf, reg, off, A0);
@@ -423,7 +423,7 @@ static inline void build_copy_store_pref(u32 **buf, int off)
 	}
 }
 
-void __cpuinit build_copy_page(void)
+void build_copy_page(void)
 {
 	int off;
 	u32 *buf = (u32 *)&copy_page_array;
diff --git a/arch/mips/mm/sc-ip22.c b/arch/mips/mm/sc-ip22.c
index 1f602a1..96ef449 100644
--- a/arch/mips/mm/sc-ip22.c
+++ b/arch/mips/mm/sc-ip22.c
@@ -168,7 +168,7 @@ struct bcache_ops indy_sc_ops = {
 	.bc_inv = indy_sc_wback_invalidate
 };
 
-void __cpuinit indy_sc_init(void)
+void indy_sc_init(void)
 {
 	if (indy_sc_probe()) {
 		indy_sc_enable();
diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index b55c2d1..22b361f 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -100,7 +100,7 @@ static inline int __init mips_sc_probe(void)
 	return 1;
 }
 
-int __cpuinit mips_sc_init(void)
+int mips_sc_init(void)
 {
 	int found = mips_sc_probe();
 	if (found) {
diff --git a/arch/mips/mm/sc-r5k.c b/arch/mips/mm/sc-r5k.c
index f330d38..c1cdfe3 100644
--- a/arch/mips/mm/sc-r5k.c
+++ b/arch/mips/mm/sc-r5k.c
@@ -99,7 +99,7 @@ static struct bcache_ops r5k_sc_ops = {
 	.bc_inv = r5k_dma_cache_inv_sc
 };
 
-void __cpuinit r5k_sc_init(void)
+void r5k_sc_init(void)
 {
 	if (r5k_sc_probe()) {
 		r5k_sc_enable();
diff --git a/arch/mips/mm/sc-rm7k.c b/arch/mips/mm/sc-rm7k.c
index e3abfb2..91cbc23 100644
--- a/arch/mips/mm/sc-rm7k.c
+++ b/arch/mips/mm/sc-rm7k.c
@@ -86,7 +86,7 @@ static void rm7k_sc_inv(unsigned long addr, unsigned long size)
 /*
  * This function is executed in uncached address space.
  */
-static __cpuinit void __rm7k_sc_enable(void)
+static void __rm7k_sc_enable(void)
 {
 	int i;
 
@@ -107,7 +107,7 @@ static __cpuinit void __rm7k_sc_enable(void)
 	}
 }
 
-static __cpuinit void rm7k_sc_enable(void)
+static void rm7k_sc_enable(void)
 {
 	if (read_c0_config() & RM7K_CONF_SE)
 		return;
@@ -128,7 +128,7 @@ struct bcache_ops rm7k_sc_ops = {
 	.bc_inv = rm7k_sc_inv
 };
 
-void __cpuinit rm7k_sc_init(void)
+void rm7k_sc_init(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config = read_c0_config();
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index f0cf46a..3766088 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -277,7 +277,7 @@ void __init add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 	}
 }
 
-void __cpuinit tlb_init(void)
+void tlb_init(void)
 {
 	local_flush_tlb_all();
 
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 5ce2fa7..e983cb8 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -388,7 +388,7 @@ void __init add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
  * lifetime of the system
  */
 
-static int temp_tlb_entry __cpuinitdata;
+static int temp_tlb_entry;
 
 __init int add_temporary_entry(unsigned long entrylo0, unsigned long entrylo1,
 			       unsigned long entryhi, unsigned long pagemask)
@@ -427,7 +427,7 @@ out:
 	return ret;
 }
 
-static void __cpuinit probe_tlb(unsigned long config)
+static void probe_tlb(unsigned long config)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int reg;
@@ -455,7 +455,7 @@ static void __cpuinit probe_tlb(unsigned long config)
 	c->tlbsize = ((reg >> 25) & 0x3f) + 1;
 }
 
-static int __cpuinitdata ntlb = 0;
+static int ntlb = 0;
 static int __init set_ntlb(char *str)
 {
 	get_option(&str, &ntlb);
@@ -464,7 +464,7 @@ static int __init set_ntlb(char *str)
 
 __setup("ntlb=", set_ntlb);
 
-void __cpuinit tlb_init(void)
+void tlb_init(void)
 {
 	unsigned int config = read_c0_config();
 
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 4f01a3b..7b884ba 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -214,14 +214,14 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 	local_irq_restore(flags);
 }
 
-static void __cpuinit probe_tlb(unsigned long config)
+static void probe_tlb(unsigned long config)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 
 	c->tlbsize = 3 * 128;		/* 3 sets each 128 entries */
 }
 
-void __cpuinit tlb_init(void)
+void tlb_init(void)
 {
 	unsigned int config = read_c0_config();
 	unsigned long status;
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 979cf91..d9b00df 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -60,7 +60,7 @@ static inline int __maybe_unused r10000_llsc_war(void)
  * why; it's not an issue caused by the core RTL.
  *
  */
-static int __cpuinit m4kc_tlbp_war(void)
+static int m4kc_tlbp_war(void)
 {
 	return (current_cpu_data.processor_id & 0xffff00) ==
 	       (PRID_COMP_MIPS | PRID_IMP_4KC);
@@ -144,16 +144,16 @@ static inline void dump_handler(const u32 *handler, int count)
  * We deliberately chose a buffer size of 128, so we won't scribble
  * over anything important on overflow before we panic.
  */
-static u32 tlb_handler[128] __cpuinitdata;
+static u32 tlb_handler[128];
 
 /* simply assume worst case size for labels and relocs */
-static struct uasm_label labels[128] __cpuinitdata;
-static struct uasm_reloc relocs[128] __cpuinitdata;
+static struct uasm_label labels[128];
+static struct uasm_reloc relocs[128];
 
 /*
  * The R3000 TLB handler is simple.
  */
-static void __cpuinit build_r3000_tlb_refill_handler(void)
+static void build_r3000_tlb_refill_handler(void)
 {
 	long pgdc = (long)pgd_current;
 	u32 *p;
@@ -197,7 +197,7 @@ static void __cpuinit build_r3000_tlb_refill_handler(void)
  * other one.To keep things simple, we first assume linear space,
  * then we relocate it to the final handler layout as needed.
  */
-static u32 final_handler[64] __cpuinitdata;
+static u32 final_handler[64];
 
 /*
  * Hazards
@@ -221,7 +221,7 @@ static u32 final_handler[64] __cpuinitdata;
  *
  * As if we MIPS hackers wouldn't know how to nop pipelines happy ...
  */
-static void __cpuinit __maybe_unused build_tlb_probe_entry(u32 **p)
+static void __maybe_unused build_tlb_probe_entry(u32 **p)
 {
 	switch (current_cpu_type()) {
 	/* Found by experiment: R4600 v2.0/R4700 needs this, too.  */
@@ -246,7 +246,7 @@ static void __cpuinit __maybe_unused build_tlb_probe_entry(u32 **p)
  */
 enum tlb_write_entry { tlb_random, tlb_indexed };
 
-static void __cpuinit build_tlb_write_entry(u32 **p, struct uasm_label **l,
+static void build_tlb_write_entry(u32 **p, struct uasm_label **l,
 					 struct uasm_reloc **r,
 					 enum tlb_write_entry wmode)
 {
@@ -391,7 +391,7 @@ static void __cpuinit build_tlb_write_entry(u32 **p, struct uasm_label **l,
  * TMP and PTR are scratch.
  * TMP will be clobbered, PTR will hold the pmd entry.
  */
-static void __cpuinit
+static void 
 build_get_pmde64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		 unsigned int tmp, unsigned int ptr)
 {
@@ -452,7 +452,7 @@ build_get_pmde64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
  * BVADDR is the faulting address, PTR is scratch.
  * PTR will hold the pgd for vmalloc.
  */
-static void __cpuinit
+static void 
 build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 			unsigned int bvaddr, unsigned int ptr)
 {
@@ -524,7 +524,7 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
  * TMP and PTR are scratch.
  * TMP will be clobbered, PTR will hold the pgd entry.
  */
-static void __cpuinit __maybe_unused
+static void __maybe_unused
 build_get_pgde32(u32 **p, unsigned int tmp, unsigned int ptr)
 {
 	long pgdc = (long)pgd_current;
@@ -559,7 +559,7 @@ build_get_pgde32(u32 **p, unsigned int tmp, unsigned int ptr)
 
 #endif /* !CONFIG_64BIT */
 
-static void __cpuinit build_adjust_context(u32 **p, unsigned int ctx)
+static void build_adjust_context(u32 **p, unsigned int ctx)
 {
 	unsigned int shift = 4 - (PTE_T_LOG2 + 1) + PAGE_SHIFT - 12;
 	unsigned int mask = (PTRS_PER_PTE / 2 - 1) << (PTE_T_LOG2 + 1);
@@ -585,7 +585,7 @@ static void __cpuinit build_adjust_context(u32 **p, unsigned int ctx)
 	uasm_i_andi(p, ctx, ctx, mask);
 }
 
-static void __cpuinit build_get_ptep(u32 **p, unsigned int tmp, unsigned int ptr)
+static void build_get_ptep(u32 **p, unsigned int tmp, unsigned int ptr)
 {
 	/*
 	 * Bug workaround for the Nevada. It seems as if under certain
@@ -610,7 +610,7 @@ static void __cpuinit build_get_ptep(u32 **p, unsigned int tmp, unsigned int ptr
 	UASM_i_ADDU(p, ptr, ptr, tmp); /* add in offset */
 }
 
-static void __cpuinit build_update_entries(u32 **p, unsigned int tmp,
+static void build_update_entries(u32 **p, unsigned int tmp,
 					unsigned int ptep)
 {
 	/*
@@ -653,7 +653,7 @@ static void __cpuinit build_update_entries(u32 **p, unsigned int tmp,
 #endif
 }
 
-static void __cpuinit build_r4000_tlb_refill_handler(void)
+static void build_r4000_tlb_refill_handler(void)
 {
 	u32 *p = tlb_handler;
 	struct uasm_label *l = labels;
@@ -785,7 +785,7 @@ u32 handle_tlbl[FASTPATH_SIZE] __cacheline_aligned;
 u32 handle_tlbs[FASTPATH_SIZE] __cacheline_aligned;
 u32 handle_tlbm[FASTPATH_SIZE] __cacheline_aligned;
 
-static void __cpuinit
+static void 
 iPTE_LW(u32 **p, struct uasm_label **l, unsigned int pte, unsigned int ptr)
 {
 #ifdef CONFIG_SMP
@@ -805,7 +805,7 @@ iPTE_LW(u32 **p, struct uasm_label **l, unsigned int pte, unsigned int ptr)
 #endif
 }
 
-static void __cpuinit
+static void 
 iPTE_SW(u32 **p, struct uasm_reloc **r, unsigned int pte, unsigned int ptr,
 	unsigned int mode)
 {
@@ -865,7 +865,7 @@ iPTE_SW(u32 **p, struct uasm_reloc **r, unsigned int pte, unsigned int ptr,
  * the page table where this PTE is located, PTE will be re-loaded
  * with it's original value.
  */
-static void __cpuinit
+static void 
 build_pte_present(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		  unsigned int pte, unsigned int ptr, enum label_id lid)
 {
@@ -876,7 +876,7 @@ build_pte_present(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 }
 
 /* Make PTE valid, store result in PTR. */
-static void __cpuinit
+static void 
 build_make_valid(u32 **p, struct uasm_reloc **r, unsigned int pte,
 		 unsigned int ptr)
 {
@@ -889,7 +889,7 @@ build_make_valid(u32 **p, struct uasm_reloc **r, unsigned int pte,
  * Check if PTE can be written to, if not branch to LABEL. Regardless
  * restore PTE with value from PTR when done.
  */
-static void __cpuinit
+static void 
 build_pte_writable(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		   unsigned int pte, unsigned int ptr, enum label_id lid)
 {
@@ -902,7 +902,7 @@ build_pte_writable(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 /* Make PTE writable, update software status bits as well, then store
  * at PTR.
  */
-static void __cpuinit
+static void 
 build_make_write(u32 **p, struct uasm_reloc **r, unsigned int pte,
 		 unsigned int ptr)
 {
@@ -916,7 +916,7 @@ build_make_write(u32 **p, struct uasm_reloc **r, unsigned int pte,
  * Check if PTE can be modified, if not branch to LABEL. Regardless
  * restore PTE with value from PTR when done.
  */
-static void __cpuinit
+static void 
 build_pte_modifiable(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		     unsigned int pte, unsigned int ptr, enum label_id lid)
 {
@@ -933,7 +933,7 @@ build_pte_modifiable(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
  * This places the pte into ENTRYLO0 and writes it with tlbwi.
  * Then it returns.
  */
-static void __cpuinit
+static void 
 build_r3000_pte_reload_tlbwi(u32 **p, unsigned int pte, unsigned int tmp)
 {
 	uasm_i_mtc0(p, pte, C0_ENTRYLO0); /* cp0 delay */
@@ -949,7 +949,7 @@ build_r3000_pte_reload_tlbwi(u32 **p, unsigned int pte, unsigned int tmp)
  * may have the probe fail bit set as a result of a trap on a
  * kseg2 access, i.e. without refill.  Then it returns.
  */
-static void __cpuinit
+static void 
 build_r3000_tlb_reload_write(u32 **p, struct uasm_label **l,
 			     struct uasm_reloc **r, unsigned int pte,
 			     unsigned int tmp)
@@ -967,7 +967,7 @@ build_r3000_tlb_reload_write(u32 **p, struct uasm_label **l,
 	uasm_i_rfe(p); /* branch delay */
 }
 
-static void __cpuinit
+static void 
 build_r3000_tlbchange_handler_head(u32 **p, unsigned int pte,
 				   unsigned int ptr)
 {
@@ -987,7 +987,7 @@ build_r3000_tlbchange_handler_head(u32 **p, unsigned int pte,
 	uasm_i_tlbp(p); /* load delay */
 }
 
-static void __cpuinit build_r3000_tlb_load_handler(void)
+static void build_r3000_tlb_load_handler(void)
 {
 	u32 *p = handle_tlbl;
 	struct uasm_label *l = labels;
@@ -1017,7 +1017,7 @@ static void __cpuinit build_r3000_tlb_load_handler(void)
 	dump_handler(handle_tlbl, ARRAY_SIZE(handle_tlbl));
 }
 
-static void __cpuinit build_r3000_tlb_store_handler(void)
+static void build_r3000_tlb_store_handler(void)
 {
 	u32 *p = handle_tlbs;
 	struct uasm_label *l = labels;
@@ -1047,7 +1047,7 @@ static void __cpuinit build_r3000_tlb_store_handler(void)
 	dump_handler(handle_tlbs, ARRAY_SIZE(handle_tlbs));
 }
 
-static void __cpuinit build_r3000_tlb_modify_handler(void)
+static void build_r3000_tlb_modify_handler(void)
 {
 	u32 *p = handle_tlbm;
 	struct uasm_label *l = labels;
@@ -1080,7 +1080,7 @@ static void __cpuinit build_r3000_tlb_modify_handler(void)
 /*
  * R4000 style TLB load/store/modify handlers.
  */
-static void __cpuinit
+static void 
 build_r4000_tlbchange_handler_head(u32 **p, struct uasm_label **l,
 				   struct uasm_reloc **r, unsigned int pte,
 				   unsigned int ptr)
@@ -1105,7 +1105,7 @@ build_r4000_tlbchange_handler_head(u32 **p, struct uasm_label **l,
 		build_tlb_probe_entry(p);
 }
 
-static void __cpuinit
+static void 
 build_r4000_tlbchange_handler_tail(u32 **p, struct uasm_label **l,
 				   struct uasm_reloc **r, unsigned int tmp,
 				   unsigned int ptr)
@@ -1122,7 +1122,7 @@ build_r4000_tlbchange_handler_tail(u32 **p, struct uasm_label **l,
 #endif
 }
 
-static void __cpuinit build_r4000_tlb_load_handler(void)
+static void build_r4000_tlb_load_handler(void)
 {
 	u32 *p = handle_tlbl;
 	struct uasm_label *l = labels;
@@ -1162,7 +1162,7 @@ static void __cpuinit build_r4000_tlb_load_handler(void)
 	dump_handler(handle_tlbl, ARRAY_SIZE(handle_tlbl));
 }
 
-static void __cpuinit build_r4000_tlb_store_handler(void)
+static void build_r4000_tlb_store_handler(void)
 {
 	u32 *p = handle_tlbs;
 	struct uasm_label *l = labels;
@@ -1193,7 +1193,7 @@ static void __cpuinit build_r4000_tlb_store_handler(void)
 	dump_handler(handle_tlbs, ARRAY_SIZE(handle_tlbs));
 }
 
-static void __cpuinit build_r4000_tlb_modify_handler(void)
+static void build_r4000_tlb_modify_handler(void)
 {
 	u32 *p = handle_tlbm;
 	struct uasm_label *l = labels;
@@ -1225,7 +1225,7 @@ static void __cpuinit build_r4000_tlb_modify_handler(void)
 	dump_handler(handle_tlbm, ARRAY_SIZE(handle_tlbm));
 }
 
-void __cpuinit build_tlb_refill_handler(void)
+void build_tlb_refill_handler(void)
 {
 	/*
 	 * The refill handler is generated per-CPU, multi-node systems
@@ -1271,7 +1271,7 @@ void __cpuinit build_tlb_refill_handler(void)
 	}
 }
 
-void __cpuinit flush_tlb_handlers(void)
+void flush_tlb_handlers(void)
 {
 	local_flush_icache_range((unsigned long)handle_tlbl,
 			   (unsigned long)handle_tlbl + sizeof(handle_tlbl));
diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
index f467199..d7730e7 100644
--- a/arch/mips/mm/uasm.c
+++ b/arch/mips/mm/uasm.c
@@ -82,7 +82,7 @@ struct insn {
 	 | (e) << RE_SH						\
 	 | (f) << FUNC_SH)
 
-static struct insn insn_table[] __cpuinitdata = {
+static struct insn insn_table[] = {
 	{ insn_addiu, M(addiu_op, 0, 0, 0, 0, 0), RS | RT | SIMM },
 	{ insn_addu, M(spec_op, 0, 0, 0, 0, addu_op), RS | RT | RD },
 	{ insn_and, M(spec_op, 0, 0, 0, 0, and_op), RS | RT | RD },
@@ -137,7 +137,7 @@ static struct insn insn_table[] __cpuinitdata = {
 
 #undef M
 
-static inline __cpuinit u32 build_rs(u32 arg)
+static inline u32 build_rs(u32 arg)
 {
 	if (arg & ~RS_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -145,7 +145,7 @@ static inline __cpuinit u32 build_rs(u32 arg)
 	return (arg & RS_MASK) << RS_SH;
 }
 
-static inline __cpuinit u32 build_rt(u32 arg)
+static inline u32 build_rt(u32 arg)
 {
 	if (arg & ~RT_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -153,7 +153,7 @@ static inline __cpuinit u32 build_rt(u32 arg)
 	return (arg & RT_MASK) << RT_SH;
 }
 
-static inline __cpuinit u32 build_rd(u32 arg)
+static inline u32 build_rd(u32 arg)
 {
 	if (arg & ~RD_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -161,7 +161,7 @@ static inline __cpuinit u32 build_rd(u32 arg)
 	return (arg & RD_MASK) << RD_SH;
 }
 
-static inline __cpuinit u32 build_re(u32 arg)
+static inline u32 build_re(u32 arg)
 {
 	if (arg & ~RE_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -169,7 +169,7 @@ static inline __cpuinit u32 build_re(u32 arg)
 	return (arg & RE_MASK) << RE_SH;
 }
 
-static inline __cpuinit u32 build_simm(s32 arg)
+static inline u32 build_simm(s32 arg)
 {
 	if (arg > 0x7fff || arg < -0x8000)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -177,7 +177,7 @@ static inline __cpuinit u32 build_simm(s32 arg)
 	return arg & 0xffff;
 }
 
-static inline __cpuinit u32 build_uimm(u32 arg)
+static inline u32 build_uimm(u32 arg)
 {
 	if (arg & ~IMM_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -185,7 +185,7 @@ static inline __cpuinit u32 build_uimm(u32 arg)
 	return arg & IMM_MASK;
 }
 
-static inline __cpuinit u32 build_bimm(s32 arg)
+static inline u32 build_bimm(s32 arg)
 {
 	if (arg > 0x1ffff || arg < -0x20000)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -196,7 +196,7 @@ static inline __cpuinit u32 build_bimm(s32 arg)
 	return ((arg < 0) ? (1 << 15) : 0) | ((arg >> 2) & 0x7fff);
 }
 
-static inline __cpuinit u32 build_jimm(u32 arg)
+static inline u32 build_jimm(u32 arg)
 {
 	if (arg & ~((JIMM_MASK) << 2))
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -204,7 +204,7 @@ static inline __cpuinit u32 build_jimm(u32 arg)
 	return (arg >> 2) & JIMM_MASK;
 }
 
-static inline __cpuinit u32 build_func(u32 arg)
+static inline u32 build_func(u32 arg)
 {
 	if (arg & ~FUNC_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -212,7 +212,7 @@ static inline __cpuinit u32 build_func(u32 arg)
 	return arg & FUNC_MASK;
 }
 
-static inline __cpuinit u32 build_set(u32 arg)
+static inline u32 build_set(u32 arg)
 {
 	if (arg & ~SET_MASK)
 		printk(KERN_WARNING "Micro-assembler field overflow\n");
@@ -224,7 +224,7 @@ static inline __cpuinit u32 build_set(u32 arg)
  * The order of opcode arguments is implicitly left to right,
  * starting with RS and ending with FUNC or IMM.
  */
-static void __cpuinit build_insn(u32 **buf, enum opcode opc, ...)
+static void build_insn(u32 **buf, enum opcode opc, ...)
 {
 	struct insn *ip = NULL;
 	unsigned int i;
@@ -379,14 +379,14 @@ I_u3u1u2(_xor)
 I_u2u1u3(_xori)
 
 /* Handle labels. */
-void __cpuinit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid)
+void uasm_build_label(struct uasm_label **lab, u32 *addr, int lid)
 {
 	(*lab)->addr = addr;
 	(*lab)->lab = lid;
 	(*lab)++;
 }
 
-int __cpuinit uasm_in_compat_space_p(long addr)
+int uasm_in_compat_space_p(long addr)
 {
 	/* Is this address in 32bit compat space? */
 #ifdef CONFIG_64BIT
@@ -396,7 +396,7 @@ int __cpuinit uasm_in_compat_space_p(long addr)
 #endif
 }
 
-static int __cpuinit uasm_rel_highest(long val)
+static int uasm_rel_highest(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x800080008000L) >> 48) & 0xffff) ^ 0x8000) - 0x8000;
@@ -405,7 +405,7 @@ static int __cpuinit uasm_rel_highest(long val)
 #endif
 }
 
-static int __cpuinit uasm_rel_higher(long val)
+static int uasm_rel_higher(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x80008000L) >> 32) & 0xffff) ^ 0x8000) - 0x8000;
@@ -414,17 +414,17 @@ static int __cpuinit uasm_rel_higher(long val)
 #endif
 }
 
-int __cpuinit uasm_rel_hi(long val)
+int uasm_rel_hi(long val)
 {
 	return ((((val + 0x8000L) >> 16) & 0xffff) ^ 0x8000) - 0x8000;
 }
 
-int __cpuinit uasm_rel_lo(long val)
+int uasm_rel_lo(long val)
 {
 	return ((val & 0xffff) ^ 0x8000) - 0x8000;
 }
 
-void __cpuinit UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
+void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
 {
 	if (!uasm_in_compat_space_p(addr)) {
 		uasm_i_lui(buf, rs, uasm_rel_highest(addr));
@@ -440,7 +440,7 @@ void __cpuinit UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr)
 		uasm_i_lui(buf, rs, uasm_rel_hi(addr));
 }
 
-void __cpuinit UASM_i_LA(u32 **buf, unsigned int rs, long addr)
+void UASM_i_LA(u32 **buf, unsigned int rs, long addr)
 {
 	UASM_i_LA_mostly(buf, rs, addr);
 	if (uasm_rel_lo(addr)) {
@@ -452,7 +452,7 @@ void __cpuinit UASM_i_LA(u32 **buf, unsigned int rs, long addr)
 }
 
 /* Handle relocations. */
-void __cpuinit
+void 
 uasm_r_mips_pc16(struct uasm_reloc **rel, u32 *addr, int lid)
 {
 	(*rel)->addr = addr;
@@ -461,7 +461,7 @@ uasm_r_mips_pc16(struct uasm_reloc **rel, u32 *addr, int lid)
 	(*rel)++;
 }
 
-static inline void __cpuinit
+static inline void 
 __resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 {
 	long laddr = (long)lab->addr;
@@ -478,7 +478,7 @@ __resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 	}
 }
 
-void __cpuinit
+void 
 uasm_resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 {
 	struct uasm_label *l;
@@ -489,7 +489,7 @@ uasm_resolve_relocs(struct uasm_reloc *rel, struct uasm_label *lab)
 				__resolve_relocs(rel, l);
 }
 
-void __cpuinit
+void 
 uasm_move_relocs(struct uasm_reloc *rel, u32 *first, u32 *end, long off)
 {
 	for (; rel->lab != UASM_LABEL_INVALID; rel++)
@@ -497,7 +497,7 @@ uasm_move_relocs(struct uasm_reloc *rel, u32 *first, u32 *end, long off)
 			rel->addr += off;
 }
 
-void __cpuinit
+void 
 uasm_move_labels(struct uasm_label *lab, u32 *first, u32 *end, long off)
 {
 	for (; lab->lab != UASM_LABEL_INVALID; lab++)
@@ -505,7 +505,7 @@ uasm_move_labels(struct uasm_label *lab, u32 *first, u32 *end, long off)
 			lab->addr += off;
 }
 
-void __cpuinit
+void 
 uasm_copy_handler(struct uasm_reloc *rel, struct uasm_label *lab, u32 *first,
 		  u32 *end, u32 *target)
 {
@@ -517,7 +517,7 @@ uasm_copy_handler(struct uasm_reloc *rel, struct uasm_label *lab, u32 *first,
 	uasm_move_labels(lab, first, end, off);
 }
 
-int __cpuinit uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
+int uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
 {
 	for (; rel->lab != UASM_LABEL_INVALID; rel++) {
 		if (rel->addr == addr
@@ -530,35 +530,35 @@ int __cpuinit uasm_insn_has_bdelay(struct uasm_reloc *rel, u32 *addr)
 }
 
 /* Convenience functions for labeled branches. */
-void __cpuinit
+void 
 uasm_il_bltz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bltz(p, reg, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_b(u32 **p, struct uasm_reloc **r, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_b(p, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_beqz(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_beqz(p, reg, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_beqzl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_beqzl(p, reg, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_bne(u32 **p, struct uasm_reloc **r, unsigned int reg1,
 	unsigned int reg2, int lid)
 {
@@ -566,21 +566,21 @@ uasm_il_bne(u32 **p, struct uasm_reloc **r, unsigned int reg1,
 	uasm_i_bne(p, reg1, reg2, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_bnez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bnez(p, reg, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_bgezl(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
 	uasm_i_bgezl(p, reg, 0);
 }
 
-void __cpuinit
+void 
 uasm_il_bgez(u32 **p, struct uasm_reloc **r, unsigned int reg, int lid)
 {
 	uasm_r_mips_pc16(r, *p, lid);
diff --git a/arch/mips/mm/uasm.h b/arch/mips/mm/uasm.h
index c6d1e3d..4a25440 100644
--- a/arch/mips/mm/uasm.h
+++ b/arch/mips/mm/uasm.h
@@ -11,38 +11,38 @@
 #include <linux/types.h>
 
 #define Ip_u1u2u3(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u2u1u3(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u3u1u2(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, unsigned int c)
 
 #define Ip_u1u2s3(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, signed int c)
 
 #define Ip_u2s3u1(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, signed int b, unsigned int c)
 
 #define Ip_u2u1s3(op)							\
-void __cpuinit								\
+void 									\
 uasm_i##op(u32 **buf, unsigned int a, unsigned int b, signed int c)
 
 #define Ip_u1u2(op)							\
-void __cpuinit uasm_i##op(u32 **buf, unsigned int a, unsigned int b)
+void uasm_i##op(u32 **buf, unsigned int a, unsigned int b)
 
 #define Ip_u1s2(op)							\
-void __cpuinit uasm_i##op(u32 **buf, unsigned int a, signed int b)
+void uasm_i##op(u32 **buf, unsigned int a, signed int b)
 
-#define Ip_u1(op) void __cpuinit uasm_i##op(u32 **buf, unsigned int a)
+#define Ip_u1(op) void uasm_i##op(u32 **buf, unsigned int a)
 
-#define Ip_0(op) void __cpuinit uasm_i##op(u32 **buf)
+#define Ip_0(op) void uasm_i##op(u32 **buf)
 
 Ip_u2u1s3(_addiu);
 Ip_u3u1u2(_addu);
@@ -100,7 +100,7 @@ struct uasm_label {
 	int lab;
 };
 
-void __cpuinit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid);
+void uasm_build_label(struct uasm_label **lab, u32 *addr, int lid);
 #ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
 #endif
@@ -110,7 +110,7 @@ void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr);
 void UASM_i_LA(u32 **buf, unsigned int rs, long addr);
 
 #define UASM_L_LA(lb)							\
-static inline void __cpuinit uasm_l##lb(struct uasm_label **lab, u32 *addr) \
+static inline void uasm_l##lb(struct uasm_label **lab, u32 *addr) \
 {									\
 	uasm_build_label(lab, addr, label##lb);				\
 }
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index f84a46a..2761a7a 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -32,7 +32,7 @@ static void msmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
 /*
  * Post-config but pre-boot cleanup entry point
  */
-static void __cpuinit msmtc_init_secondary(void)
+static void msmtc_init_secondary(void)
 {
 	void smtc_init_secondary(void);
 	int myvpe;
@@ -54,7 +54,7 @@ static void __cpuinit msmtc_init_secondary(void)
 /*
  * Platform "CPU" startup hook
  */
-static void __cpuinit msmtc_boot_secondary(int cpu, struct task_struct *idle)
+static void msmtc_boot_secondary(int cpu, struct task_struct *idle)
 {
 	smtc_boot_secondary(cpu, idle);
 }
@@ -62,7 +62,7 @@ static void __cpuinit msmtc_boot_secondary(int cpu, struct task_struct *idle)
 /*
  * SMP initialization finalization entry point
  */
-static void __cpuinit msmtc_smp_finish(void)
+static void msmtc_smp_finish(void)
 {
 	smtc_smp_finish();
 }
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 0b97d47..4b4ca93 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -123,7 +123,7 @@ static void __init plat_perf_setup(void)
 	}
 }
 
-unsigned int __cpuinit get_c0_compare_int(void)
+unsigned int get_c0_compare_int(void)
 {
 #ifdef MSC01E_INT_BASE
 	if (cpu_has_veic) {
diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
index f97ab14..26fe96a 100644
--- a/arch/mips/pci/pci-ip27.c
+++ b/arch/mips/pci/pci-ip27.c
@@ -40,7 +40,7 @@ int irq_to_slot[MAX_PCI_BUSSES * MAX_DEVICES_PER_PCIBUS];
 
 extern struct pci_ops bridge_pci_ops;
 
-int __cpuinit bridge_probe(nasid_t nasid, int widget_id, int masterwid)
+int bridge_probe(nasid_t nasid, int widget_id, int masterwid)
 {
 	unsigned long offset = NODE_OFFSET(nasid);
 	struct bridge_controller *bc;
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index 3a7df64..b33fdf6 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -7,10 +7,10 @@
 
 #define LAUNCHSTACK_SIZE 256
 
-static __cpuinitdata DEFINE_SPINLOCK(launch_lock);
+static DEFINE_SPINLOCK(launch_lock);
 
-static unsigned long secondary_sp __cpuinitdata;
-static unsigned long secondary_gp __cpuinitdata;
+static unsigned long secondary_sp;
+static unsigned long secondary_gp;
 
 static unsigned char launchstack[LAUNCHSTACK_SIZE] __initdata
 	__attribute__((aligned(2 * sizeof(long))));
@@ -108,12 +108,12 @@ static void yos_send_ipi_mask(cpumask_t mask, unsigned int action)
  *  After we've done initial boot, this function is called to allow the
  *  board code to clean up state, if needed
  */
-static void __cpuinit yos_init_secondary(void)
+static void yos_init_secondary(void)
 {
 	set_c0_status(ST0_CO | ST0_IE | ST0_IM);
 }
 
-static void __cpuinit yos_smp_finish(void)
+static void yos_smp_finish(void)
 {
 }
 
@@ -129,7 +129,7 @@ static void yos_cpus_done(void)
  * stack so the first thing we do is throw away that stuff and load useful
  * values into the registers ...
  */
-static void __cpuinit yos_boot_secondary(int cpu, struct task_struct *idle)
+static void yos_boot_secondary(int cpu, struct task_struct *idle)
 {
 	unsigned long gp = (unsigned long) task_thread_info(idle);
 	unsigned long sp = __KSTK_TOS(idle);
diff --git a/arch/mips/sgi-ip27/ip27-init.c b/arch/mips/sgi-ip27/ip27-init.c
index 4a500e8..446a35d 100644
--- a/arch/mips/sgi-ip27/ip27-init.c
+++ b/arch/mips/sgi-ip27/ip27-init.c
@@ -53,7 +53,7 @@ extern void pcibr_setup(cnodeid_t);
 
 extern void xtalk_probe_node(cnodeid_t nid);
 
-static void __cpuinit per_hub_init(cnodeid_t cnode)
+static void per_hub_init(cnodeid_t cnode)
 {
 	struct hub_data *hub = hub_data(cnode);
 	nasid_t nasid = COMPACT_TO_NASID_NODEID(cnode);
@@ -109,7 +109,7 @@ static void __cpuinit per_hub_init(cnodeid_t cnode)
 	}
 }
 
-void __cpuinit per_cpu_init(void)
+void per_cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	int slice = LOCAL_HUB_L(PI_CPU_NUM);
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
index ba5cdeb..4511a5e 100644
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -173,12 +173,12 @@ static void ip27_send_ipi_mask(cpumask_t mask, unsigned int action)
 		ip27_send_ipi_single(i, action);
 }
 
-static void __cpuinit ip27_init_secondary(void)
+static void ip27_init_secondary(void)
 {
 	per_cpu_init();
 }
 
-static void __cpuinit ip27_smp_finish(void)
+static void ip27_smp_finish(void)
 {
 	extern void hub_rt_clock_event_init(void);
 
@@ -195,7 +195,7 @@ static void __init ip27_cpus_done(void)
  * set sp to the kernel stack of the newly created idle process, gp to the proc
  * struct so that current_thread_info() will work.
  */
-static void __cpuinit ip27_boot_secondary(int cpu, struct task_struct *idle)
+static void ip27_boot_secondary(int cpu, struct task_struct *idle)
 {
 	unsigned long gp = (unsigned long)task_thread_info(idle);
 	unsigned long sp = __KSTK_TOS(idle);
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index 1327c27..33eee21 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -119,7 +119,7 @@ struct irqaction hub_rt_irqaction = {
 #define NSEC_PER_CYCLE		800
 #define CYCLES_PER_SEC		(NSEC_PER_SEC / NSEC_PER_CYCLE)
 
-void __cpuinit hub_rt_clock_event_init(void)
+void hub_rt_clock_event_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *cd = &per_cpu(hub_rt_clockevent, cpu);
@@ -187,7 +187,7 @@ void __init plat_time_init(void)
 	hub_rt_clock_event_init();
 }
 
-void __cpuinit cpu_time_init(void)
+void cpu_time_init(void)
 {
 	lboard_t *board;
 	klcpu_t *cpu;
@@ -208,7 +208,7 @@ void __cpuinit cpu_time_init(void)
 	set_c0_status(SRB_TIMOCLK);
 }
 
-void __cpuinit hub_rtc_init(cnodeid_t cnode)
+void hub_rtc_init(cnodeid_t cnode)
 {
 
 	/*
diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index 6ae64e8..2125a30 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -22,7 +22,7 @@
 
 extern int bridge_probe(nasid_t nasid, int widget, int masterwid);
 
-static int __cpuinit probe_one_port(nasid_t nasid, int widget, int masterwid)
+static int probe_one_port(nasid_t nasid, int widget, int masterwid)
 {
 	widgetreg_t 		widget_id;
 	xwidget_part_num_t	partnum;
@@ -46,7 +46,7 @@ static int __cpuinit probe_one_port(nasid_t nasid, int widget, int masterwid)
 	return 0;
 }
 
-static int __cpuinit xbow_probe(nasid_t nasid)
+static int xbow_probe(nasid_t nasid)
 {
 	lboard_t *brd;
 	klxbow_t *xbow_p;
@@ -99,7 +99,7 @@ static int __cpuinit xbow_probe(nasid_t nasid)
 	return 0;
 }
 
-void __cpuinit xtalk_probe_node(cnodeid_t nid)
+void xtalk_probe_node(cnodeid_t nid)
 {
 	volatile u64 		hubreg;
 	nasid_t	 		nasid;
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index bd9eeb4..0577eb2 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -59,7 +59,7 @@ static void *mailbox_0_regs[] = {
 /*
  * SMP init and finish on secondary CPUs
  */
-void __cpuinit bcm1480_smp_init(void)
+void bcm1480_smp_init(void)
 {
 	unsigned int imask = STATUSF_IP4 | STATUSF_IP3 | STATUSF_IP2 |
 		STATUSF_IP1 | STATUSF_IP0;
@@ -93,7 +93,7 @@ static void bcm1480_send_ipi_mask(cpumask_t mask, unsigned int action)
 /*
  * Code to run on secondary just after probing the CPU
  */
-static void __cpuinit bcm1480_init_secondary(void)
+static void bcm1480_init_secondary(void)
 {
 	extern void bcm1480_smp_init(void);
 
@@ -104,7 +104,7 @@ static void __cpuinit bcm1480_init_secondary(void)
  * Do any tidying up before marking online and running the idle
  * loop
  */
-static void __cpuinit bcm1480_smp_finish(void)
+static void bcm1480_smp_finish(void)
 {
 	extern void sb1480_clockevent_init(void);
 
@@ -123,7 +123,7 @@ static void bcm1480_cpus_done(void)
  * Setup the PC, SP, and GP of a secondary processor and start it
  * running!
  */
-static void __cpuinit bcm1480_boot_secondary(int cpu, struct task_struct *idle)
+static void bcm1480_boot_secondary(int cpu, struct task_struct *idle)
 {
 	int retval;
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 0734b93..1100c7b 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -47,7 +47,7 @@ static void *mailbox_regs[] = {
 /*
  * SMP init and finish on secondary CPUs
  */
-void __cpuinit sb1250_smp_init(void)
+void sb1250_smp_init(void)
 {
 	unsigned int imask = STATUSF_IP4 | STATUSF_IP3 | STATUSF_IP2 |
 		STATUSF_IP1 | STATUSF_IP0;
@@ -81,7 +81,7 @@ static inline void sb1250_send_ipi_mask(cpumask_t mask, unsigned int action)
 /*
  * Code to run on secondary just after probing the CPU
  */
-static void __cpuinit sb1250_init_secondary(void)
+static void sb1250_init_secondary(void)
 {
 	extern void sb1250_smp_init(void);
 
@@ -92,7 +92,7 @@ static void __cpuinit sb1250_init_secondary(void)
  * Do any tidying up before marking online and running the idle
  * loop
  */
-static void __cpuinit sb1250_smp_finish(void)
+static void sb1250_smp_finish(void)
 {
 	extern void sb1250_clockevent_init(void);
 
@@ -111,7 +111,7 @@ static void sb1250_cpus_done(void)
  * Setup the PC, SP, and GP of a secondary processor and start it
  * running!
  */
-static void __cpuinit sb1250_boot_secondary(int cpu, struct task_struct *idle)
+static void sb1250_boot_secondary(int cpu, struct task_struct *idle)
 {
 	int retval;
 
diff --git a/arch/parisc/kernel/hardware.c b/arch/parisc/kernel/hardware.c
index f48a640..11c174d 100644
--- a/arch/parisc/kernel/hardware.c
+++ b/arch/parisc/kernel/hardware.c
@@ -1366,7 +1366,7 @@ parisc_hardware_description(struct parisc_device_id *id)
 
 
 /* Interpret hversion (ret[0]) from PDC_MODEL(4)/PDC_MODEL_INFO(0) */
-enum cpu_type __cpuinit
+enum cpu_type 
 parisc_get_cpu_type(unsigned long hversion)
 {
 	struct hp_cpu_type_mask *ptr;
diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
index 370086f..04ee0f2 100644
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -76,7 +76,7 @@ extern int update_cr16_clocksource(void);	/* from time.c */
  * (return 1).  If so, initialize the chip and tell other partners in crime 
  * they have work to do.
  */
-static int __cpuinit processor_probe(struct parisc_device *dev)
+static int processor_probe(struct parisc_device *dev)
 {
 	unsigned long txn_addr;
 	unsigned long cpuid;
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index d47f397..0e5e284 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -358,7 +358,7 @@ void __init smp_callin(void)
 /*
  * Bring one cpu online.
  */
-int __cpuinit smp_boot_one_cpu(int cpuid)
+int smp_boot_one_cpu(int cpuid)
 {
 	struct task_struct *idle;
 	long timeout;
@@ -468,7 +468,7 @@ void smp_cpus_done(unsigned int cpu_max)
 }
 
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	if (cpu != 0 && cpu < parisc_max_cpus)
 		smp_boot_one_cpu(cpu);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index ff9f701..937690d 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -316,7 +316,7 @@ static int __devinit cpu_enable(unsigned int cpu)
 	return -ENOSYS;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	int c;
 
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 86a2ffc..8c8cbf3 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -481,7 +481,7 @@ static struct cache_desc_info icache_info = {
 	.nr_sets_prop = "i-cache-sets",
 };
 
-static struct cache_desc * __cpuinit create_cache_desc(struct device_node *np, struct kobject *parent, int index, int level, struct cache_desc_info *info)
+static struct cache_desc * create_cache_desc(struct device_node *np, struct kobject *parent, int index, int level, struct cache_desc_info *info)
 {
 	const u32 *cache_line_size;
 	struct cache_desc *new;
@@ -564,7 +564,7 @@ static bool cache_is_unified(struct device_node *np)
 	return of_get_property(np, "cache-unified", NULL);
 }
 
-static struct cache_desc * __cpuinit create_cache_index_info(struct device_node *np, struct kobject *parent, int index, int level)
+static struct cache_desc * create_cache_index_info(struct device_node *np, struct kobject *parent, int index, int level)
 {
 	const phandle *next_cache_phandle;
 	struct device_node *next_cache;
@@ -606,7 +606,7 @@ out:
 	return new;
 }
 
-static void __cpuinit create_cache_info(struct sys_device *sysdev)
+static void create_cache_info(struct sys_device *sysdev)
 {
 	struct kobject *cache_toplevel;
 	struct device_node *np = NULL;
@@ -625,7 +625,7 @@ static void __cpuinit create_cache_info(struct sys_device *sysdev)
 	return;
 }
 
-static void __cpuinit register_cpu_online(unsigned int cpu)
+static void register_cpu_online(unsigned int cpu)
 {
 	struct cpu *c = &per_cpu(cpu_devices, cpu);
 	struct sys_device *s = &c->sysdev;
@@ -776,7 +776,7 @@ static void unregister_cpu_online(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
+static int sysfs_cpu_notify(struct notifier_block *self,
 				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
@@ -796,7 +796,7 @@ static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata sysfs_cpu_nb = {
+static struct notifier_block sysfs_cpu_nb = {
 	.notifier_call	= sysfs_cpu_notify,
 };
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 6cf5c71..a61acb7 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(node_data);
 static int min_common_depth;
 static int n_mem_addr_cells, n_mem_size_cells;
 
-static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
+static int fake_numa_create_new_node(unsigned long end_pfn,
 						unsigned int *nid)
 {
 	unsigned long long mem;
@@ -129,7 +129,7 @@ static void __init get_node_active_region(unsigned long start_pfn,
 	work_with_active_regions(nid, get_active_region_work_fn, node_ar);
 }
 
-static void __cpuinit map_cpu_to_node(int cpu, int node)
+static void map_cpu_to_node(int cpu, int node)
 {
 	numa_cpu_lookup_table[cpu] = node;
 
@@ -155,7 +155,7 @@ static void unmap_cpu_from_node(unsigned long cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static struct device_node * __cpuinit find_cpu_node(unsigned int cpu)
+static struct device_node * find_cpu_node(unsigned int cpu)
 {
 	unsigned int hw_cpuid = get_hard_smp_processor_id(cpu);
 	struct device_node *cpu_node = NULL;
@@ -464,7 +464,7 @@ static int of_drconf_to_nid_single(struct of_drconf_cell *drmem,
  * Figure out to which domain a cpu belongs and stick it there.
  * Return the id of the domain used.
  */
-static int __cpuinit numa_setup_cpu(unsigned long lcpu)
+static int numa_setup_cpu(unsigned long lcpu)
 {
 	int nid = 0;
 	struct device_node *cpu = find_cpu_node(lcpu);
@@ -486,7 +486,7 @@ out:
 	return nid;
 }
 
-static int __cpuinit cpu_numa_callback(struct notifier_block *nfb,
+static int cpu_numa_callback(struct notifier_block *nfb,
 			     unsigned long action,
 			     void *hcpu)
 {
@@ -860,7 +860,7 @@ static void __init *careful_allocation(int nid, unsigned long size,
 	return (void *)ret;
 }
 
-static struct notifier_block __cpuinitdata ppc64_numa_nb = {
+static struct notifier_block ppc64_numa_nb = {
 	.notifier_call = cpu_numa_callback,
 	.priority = 1 /* Must run before sched domains notifier. */
 };
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index a7f8979..c7dc606 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -475,7 +475,7 @@ void appldata_unregister_ops(struct appldata_ops *ops)
 
 /******************************* init / exit *********************************/
 
-static void __cpuinit appldata_online_cpu(int cpu)
+static void appldata_online_cpu(int cpu)
 {
 	init_virt_timer(&per_cpu(appldata_timer, cpu));
 	per_cpu(appldata_timer, cpu).function = appldata_timer_function;
@@ -487,7 +487,7 @@ static void __cpuinit appldata_online_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static void __cpuinit appldata_offline_cpu(int cpu)
+static void appldata_offline_cpu(int cpu)
 {
 	del_virt_timer(&per_cpu(appldata_timer, cpu));
 	if (atomic_dec_and_test(&appldata_expire_count)) {
@@ -499,7 +499,7 @@ static void __cpuinit appldata_offline_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static int __cpuinit appldata_cpu_notify(struct notifier_block *self,
+static int appldata_cpu_notify(struct notifier_block *self,
 					 unsigned long action,
 					 void *hcpu)
 {
@@ -518,7 +518,7 @@ static int __cpuinit appldata_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata appldata_nb = {
+static struct notifier_block appldata_nb = {
 	.notifier_call = appldata_cpu_notify,
 };
 
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 6b18963..d20cc7e 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -20,7 +20,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs);
 
 void do_extint(struct pt_regs *regs, unsigned short code);
-int __cpuinit start_secondary(void *cpuvoid);
+int start_secondary(void *cpuvoid);
 void __init startup_init(void);
 void die(const char * str, struct pt_regs * regs, long err);
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 62122ba..6a942da 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -103,7 +103,7 @@ static struct resource data_resource = {
 /*
  * cpu_init() initializes state that is per-CPU.
  */
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
         int addr = hard_smp_processor_id();
 
@@ -819,7 +819,7 @@ setup_arch(char **cmdline_p)
 	setup_zfcpdump(console_devno);
 }
 
-void __cpuinit print_cpu_info(struct cpuinfo_S390 *cpuinfo)
+void print_cpu_info(struct cpuinfo_S390 *cpuinfo)
 {
    printk(KERN_INFO "cpu %d "
 #ifdef CONFIG_SMP
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 9e8b1f9..2c2b86c 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -571,7 +571,7 @@ out:
 /*
  *	Activate a secondary processor.
  */
-int __cpuinit start_secondary(void *cpuvoid)
+int start_secondary(void *cpuvoid)
 {
 	/* Setup the cpu */
 	cpu_init();
@@ -614,7 +614,7 @@ static void __init smp_create_idle(unsigned int cpu)
 	current_set[cpu] = p;
 }
 
-static int __cpuinit smp_alloc_lowcore(int cpu)
+static int smp_alloc_lowcore(int cpu)
 {
 	unsigned long async_stack, panic_stack;
 	struct _lowcore *lowcore;
@@ -676,7 +676,7 @@ static void smp_free_lowcore(int cpu)
 #endif /* CONFIG_HOTPLUG_CPU */
 
 /* Upping and downing of CPUs */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle;
 	struct _lowcore *cpu_lowcore;
@@ -1031,7 +1031,7 @@ static struct attribute_group cpu_online_attr_group = {
 	.attrs = cpu_online_attrs,
 };
 
-static int __cpuinit smp_cpu_notify(struct notifier_block *self,
+static int smp_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
@@ -1059,7 +1059,7 @@ static int __cpuinit smp_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata smp_cpu_nb = {
+static struct notifier_block smp_cpu_nb = {
 	.notifier_call = smp_cpu_notify,
 };
 
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 001778f..22c1895 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -67,7 +67,7 @@ void __devinit smp_prepare_boot_cpu(void)
 	cpu_set(cpu, cpu_possible_map);
 }
 
-asmlinkage void __cpuinit start_secondary(void)
+asmlinkage void start_secondary(void)
 {
 	unsigned int cpu;
 	struct mm_struct *mm = &init_mm;
@@ -105,7 +105,7 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	struct task_struct *tsk;
 	unsigned long timeout;
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 511a942..428e412 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -793,7 +793,7 @@ static inline void __init gdb_vbr_init(void)
 }
 #endif
 
-void __cpuinit per_cpu_trap_init(void)
+void per_cpu_trap_init(void)
 {
 	extern void *vbr_base;
 
diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
index 1619ec1..41ab1f2 100644
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -51,7 +51,7 @@ cpumask_t smp_commenced_mask = CPU_MASK_NONE;
  * instruction which is much better...
  */
 
-void __cpuinit smp_store_cpu_info(int id)
+void smp_store_cpu_info(int id)
 {
 	int cpu_node;
 
@@ -357,10 +357,10 @@ void __init smp_prepare_boot_cpu(void)
 	cpu_set(cpuid, phys_cpu_present_map);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
-	extern int __cpuinit smp4m_boot_one_cpu(int);
-	extern int __cpuinit smp4d_boot_one_cpu(int);
+	extern int smp4m_boot_one_cpu(int);
+	extern int smp4d_boot_one_cpu(int);
 	int ret=0;
 
 	switch(sparc_cpu_model) {
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 7a6a5e7..75cba5e 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -174,7 +174,7 @@ void __init smp4d_boot_cpus(void)
 	local_flush_cache_all();
 }
 
-int __cpuinit smp4d_boot_one_cpu(int i)
+int smp4d_boot_one_cpu(int i)
 {
 			extern unsigned long sun4d_cpu_startup;
 			unsigned long *entry = &sun4d_cpu_startup;
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 5fc386d..45b05be 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -65,7 +65,7 @@ static inline unsigned long swap(volatile unsigned long *ptr, unsigned long val)
 static void smp_setup_percpu_timer(void);
 extern void cpu_probe(void);
 
-void __cpuinit smp4m_callin(void)
+void smp4m_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -130,7 +130,7 @@ void __init smp4m_boot_cpus(void)
 	local_flush_cache_all();
 }
 
-int __cpuinit smp4m_boot_one_cpu(int i)
+int smp4m_boot_one_cpu(int i)
 {
 	extern unsigned long sun4m_cpu_startup;
 	unsigned long *entry = &sun4m_cpu_startup;
diff --git a/arch/sparc64/kernel/ds.c b/arch/sparc64/kernel/ds.c
index f52e053..be0849b 100644
--- a/arch/sparc64/kernel/ds.c
+++ b/arch/sparc64/kernel/ds.c
@@ -525,7 +525,7 @@ static void dr_cpu_mark(struct ds_data *resp, int cpu, int ncpus,
 	}
 }
 
-static int __cpuinit dr_cpu_configure(struct ds_info *dp,
+static int dr_cpu_configure(struct ds_info *dp,
 				      struct ds_cap_state *cp,
 				      u64 req_num,
 				      cpumask_t *mask)
@@ -623,7 +623,7 @@ static int dr_cpu_unconfigure(struct ds_info *dp,
 	return 0;
 }
 
-static void __cpuinit dr_cpu_data(struct ds_info *dp,
+static void dr_cpu_data(struct ds_info *dp,
 				  struct ds_cap_state *cp,
 				  void *buf, int len)
 {
diff --git a/arch/sparc64/kernel/entry.h b/arch/sparc64/kernel/entry.h
index 34d7ab5..b4768a5 100644
--- a/arch/sparc64/kernel/entry.h
+++ b/arch/sparc64/kernel/entry.h
@@ -190,6 +190,6 @@ extern unsigned long ivector_table_pa;
 
 extern void handler_irq(int irq, struct pt_regs *regs);
 extern void init_irqwork_curcpu(void);
-extern void __cpuinit sun4v_register_mondo_queues(int this_cpu);
+extern void sun4v_register_mondo_queues(int this_cpu);
 
 #endif /* _ENTRY_H */
diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index 52fc836..5815cd6 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -884,7 +884,7 @@ void notrace init_irqwork_curcpu(void)
  * Therefore you cannot make any OBP calls, not even prom_printf,
  * from these two routines.
  */
-static void __cpuinit register_one_mondo(unsigned long paddr, unsigned long type, unsigned long qmask)
+static void register_one_mondo(unsigned long paddr, unsigned long type, unsigned long qmask)
 {
 	unsigned long num_entries = (qmask + 1) / 64;
 	unsigned long status;
@@ -897,7 +897,7 @@ static void __cpuinit register_one_mondo(unsigned long paddr, unsigned long type
 	}
 }
 
-void __cpuinit notrace sun4v_register_mondo_queues(int this_cpu)
+void notrace sun4v_register_mondo_queues(int this_cpu)
 {
 	struct trap_per_cpu *tb = &trap_block[this_cpu];
 
diff --git a/arch/sparc64/kernel/mdesc.c b/arch/sparc64/kernel/mdesc.c
index dde52bc..18aae90 100644
--- a/arch/sparc64/kernel/mdesc.c
+++ b/arch/sparc64/kernel/mdesc.c
@@ -762,7 +762,7 @@ static void __devinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 	get_one_mondo_bits(val, &tb->nonresum_qmask, 2);
 }
 
-void __cpuinit mdesc_fill_in_cpu_data(cpumask_t mask)
+void mdesc_fill_in_cpu_data(cpumask_t mask)
 {
 	struct mdesc_handle *hp = mdesc_grab();
 	u64 mp;
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index e562711..3d03b93 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -85,7 +85,7 @@ extern void setup_sparc64_timer(void);
 
 static volatile unsigned long callin_flag = 0;
 
-void __cpuinit smp_callin(void)
+void smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -1231,7 +1231,7 @@ void __devinit smp_fill_in_sib_core_maps(void)
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu)
 {
 	int ret = smp_boot_one_cpu(cpu);
 
diff --git a/arch/sparc64/kernel/sysfs.c b/arch/sparc64/kernel/sysfs.c
index 84e5ce1..7c899d6 100644
--- a/arch/sparc64/kernel/sysfs.c
+++ b/arch/sparc64/kernel/sysfs.c
@@ -243,7 +243,7 @@ static void unregister_cpu_online(unsigned int cpu)
 }
 #endif
 
-static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
+static int sysfs_cpu_notify(struct notifier_block *self,
 				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
@@ -263,7 +263,7 @@ static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata sysfs_cpu_nb = {
+static struct notifier_block sysfs_cpu_nb = {
 	.notifier_call	= sysfs_cpu_notify,
 };
 
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index 3c10daf..e8df976 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1645,7 +1645,7 @@ static void __init sun4v_ktsb_init(void)
 #endif
 }
 
-void __cpuinit sun4v_ktsb_register(void)
+void sun4v_ktsb_register(void)
 {
 	unsigned long pa, ret;
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index eb875cd..b075380 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -243,7 +243,7 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 	return 0;
 }
 
-static void __cpuinit acpi_register_lapic(int id, u8 enabled)
+static void acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
@@ -532,7 +532,7 @@ int acpi_register_gsi(u32 gsi, int triggering, int polarity)
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 
-static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
+static int _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 21c831d..0389dd0 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -61,7 +61,7 @@ static int force_enable_local_apic;
 int disable_apic;
 
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -205,7 +205,7 @@ EXPORT_SYMBOL_GPL(apic_ops);
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
-void __cpuinit enable_NMI_through_LVT0(void)
+void enable_NMI_through_LVT0(void)
 {
 	unsigned int v;
 
@@ -989,7 +989,7 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-static void __cpuinit lapic_setup_esr(void)
+static void lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
@@ -1031,7 +1031,7 @@ static void __cpuinit lapic_setup_esr(void)
 /**
  * setup_local_APIC - setup the local APIC
  */
-void __cpuinit setup_local_APIC(void)
+void setup_local_APIC(void)
 {
 	unsigned long value, integrated;
 	int i, j;
@@ -1159,7 +1159,7 @@ void __cpuinit setup_local_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit end_local_APIC_setup(void)
+void end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
 
@@ -1487,7 +1487,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit generic_processor_info(int apicid, int version)
+void generic_processor_info(int apicid, int version)
 {
 	int cpu;
 	cpumask_t tmp_map;
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 94ddb69..44152b7 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -46,7 +46,7 @@
 #include <mach_apic.h>
 
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
 int disable_x2apic;
@@ -225,7 +225,7 @@ static struct apic_ops x2apic_ops = {
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
-void __cpuinit enable_NMI_through_LVT0(void)
+void enable_NMI_through_LVT0(void)
 {
 	unsigned int v;
 
@@ -535,7 +535,7 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __cpuinit setup_secondary_APIC_clock(void)
+void setup_secondary_APIC_clock(void)
 {
 	setup_APIC_timer();
 }
@@ -874,7 +874,7 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-static void __cpuinit lapic_setup_esr(void)
+static void lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
@@ -916,7 +916,7 @@ static void __cpuinit lapic_setup_esr(void)
 /**
  * setup_local_APIC - setup the local APIC
  */
-void __cpuinit setup_local_APIC(void)
+void setup_local_APIC(void)
 {
 	unsigned int value;
 	int i, j;
@@ -1018,7 +1018,7 @@ void __cpuinit setup_local_APIC(void)
 	preempt_enable();
 }
 
-void __cpuinit end_local_APIC_setup(void)
+void end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
 
@@ -1425,7 +1425,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit generic_processor_info(int apicid, int version)
+void generic_processor_info(int apicid, int version)
 {
 	int cpu;
 	cpumask_t tmp_map;
@@ -1645,7 +1645,7 @@ static struct sys_device device_lapic = {
 	.cls	= &lapic_sysclass,
 };
 
-static void __cpuinit apic_pm_activate(void)
+static void apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
 }
@@ -1680,7 +1680,7 @@ static void apic_pm_activate(void) { }
  * multi-chassis. Use available data to take a good guess.
  * If in doubt, go HPET.
  */
-__cpuinit int apic_is_clustered_box(void)
+int apic_is_clustered_box(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 0d9c993..0376bb1 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -23,7 +23,7 @@ enum cpuid_regs {
 	CR_EBX
 };
 
-void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
+void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 {
 	u32 max_level;
 	u32 regs[4];
@@ -67,7 +67,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
  * exists, use it for populating initial_apicid and cpu topology
  * detection.
  */
-void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+void detect_extended_topology(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
@@ -137,7 +137,7 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_PAT
-void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
+void validate_pat_support(struct cpuinfo_x86 *c)
 {
 	if (!cpu_has_pat)
 		pat_disable("PAT not supported by CPU.");
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 32e7352..885ab7b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -33,7 +33,7 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
+static void init_amd_k5(struct cpuinfo_x86 *c)
 {
 /*
  * General Systems BIOSen alias the cpu frequency registers
@@ -51,7 +51,7 @@ static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
 }
 
 
-static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
+static void init_amd_k6(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int mbytes = num_physpages >> (20-PAGE_SHIFT);
@@ -143,7 +143,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
+static void init_amd_k7(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 
@@ -181,7 +181,7 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 #endif
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-static int __cpuinit nearby_node(int apicid)
+static int nearby_node(int apicid)
 {
 	int i, node;
 
@@ -203,7 +203,7 @@ static int __cpuinit nearby_node(int apicid)
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
-static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+static void amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
@@ -217,7 +217,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+static void srat_detect_node(struct cpuinfo_x86 *c)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
@@ -253,7 +253,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+static void early_init_amd_mc(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits, ecx;
@@ -279,7 +279,7 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
@@ -298,7 +298,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+static void init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned long long value;
@@ -433,7 +433,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_32
-static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+static unsigned int amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 == 6)) {
@@ -447,7 +447,7 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int
 }
 #endif
 
-static struct cpu_dev amd_cpu_dev __cpuinitdata = {
+static struct cpu_dev amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 89bfdd9..c2a562e 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_X86_OOSTORE
 
-static u32 __cpuinit power2(u32 x)
+static u32 power2(u32 x)
 {
 	u32 s = 1;
 
@@ -25,7 +25,7 @@ static u32 __cpuinit power2(u32 x)
 /*
  * Set up an actual MCR
  */
-static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
+static void centaur_mcr_insert(int reg, u32 base, u32 size, int key)
 {
 	u32 lo, hi;
 
@@ -42,7 +42,7 @@ static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
  *
  * Shortcut: We know you can't put 4Gig of RAM on a winchip
  */
-static u32 __cpuinit ramtop(void)
+static u32 ramtop(void)
 {
 	u32 clip = 0xFFFFFFFFUL;
 	u32 top = 0;
@@ -91,7 +91,7 @@ static u32 __cpuinit ramtop(void)
 /*
  * Compute a set of MCR's to give maximum coverage
  */
-static int __cpuinit centaur_mcr_compute(int nr, int key)
+static int centaur_mcr_compute(int nr, int key)
 {
 	u32 mem = ramtop();
 	u32 root = power2(mem);
@@ -157,7 +157,7 @@ static int __cpuinit centaur_mcr_compute(int nr, int key)
 	return ct;
 }
 
-static void __cpuinit centaur_create_optimal_mcr(void)
+static void centaur_create_optimal_mcr(void)
 {
 	int used;
 	int i;
@@ -181,7 +181,7 @@ static void __cpuinit centaur_create_optimal_mcr(void)
 		wrmsr(MSR_IDT_MCR0+i, 0, 0);
 }
 
-static void __cpuinit winchip2_create_optimal_mcr(void)
+static void winchip2_create_optimal_mcr(void)
 {
 	u32 lo, hi;
 	int used;
@@ -217,7 +217,7 @@ static void __cpuinit winchip2_create_optimal_mcr(void)
 /*
  * Handle the MCR key on the Winchip 2.
  */
-static void __cpuinit winchip2_unprotect_mcr(void)
+static void winchip2_unprotect_mcr(void)
 {
 	u32 lo, hi;
 	u32 key;
@@ -229,7 +229,7 @@ static void __cpuinit winchip2_unprotect_mcr(void)
 	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
 }
 
-static void __cpuinit winchip2_protect_mcr(void)
+static void winchip2_protect_mcr(void)
 {
 	u32 lo, hi;
 
@@ -247,7 +247,7 @@ static void __cpuinit winchip2_protect_mcr(void)
 #define RNG_ENABLED	(1 << 3)
 #define RNG_ENABLE	(1 << 6)	/* MSR_VIA_RNG */
 
-static void __cpuinit init_c3(struct cpuinfo_x86 *c)
+static void init_c3(struct cpuinfo_x86 *c)
 {
 	u32  lo, hi;
 
@@ -313,7 +313,7 @@ enum {
 		EAMD3D		= 1<<20,
 };
 
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+static void early_init_centaur(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
 	case 5:
@@ -323,7 +323,7 @@ static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
+static void init_centaur(struct cpuinfo_x86 *c)
 {
 
 	char *name;
@@ -449,7 +449,7 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 	}
 }
 
-static unsigned int __cpuinit
+static unsigned int 
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* VIA C3 CPUs (670-68F) need further shifting. */
@@ -468,7 +468,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	return size;
 }
 
-static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+static struct cpu_dev centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
index a1625f5..3845b3b 100644
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -6,7 +6,7 @@
 
 #include "cpu.h"
 
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+static void early_init_centaur(struct cpuinfo_x86 *c)
 {
 	if (c->x86 == 0x6 && c->x86_model >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
@@ -14,7 +14,7 @@ static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 }
 
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
+static void init_centaur(struct cpuinfo_x86 *c)
 {
 	early_init_centaur(c);
 
@@ -25,7 +25,7 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 }
 
-static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+static struct cpu_dev centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25581dc..e82b123 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -38,7 +38,7 @@
 
 #include "cpu.h"
 
-static struct cpu_dev *this_cpu __cpuinitdata;
+static struct cpu_dev *this_cpu;
 
 #ifdef CONFIG_X86_64
 /* We need valid kernel segments for data and code in long mode too
@@ -94,8 +94,8 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 #ifdef CONFIG_X86_32
-static int cachesize_override __cpuinitdata = -1;
-static int disable_x86_serial_nr __cpuinitdata = 1;
+static int cachesize_override = -1;
+static int disable_x86_serial_nr = 1;
 
 static int __init cachesize_setup(char *str)
 {
@@ -148,12 +148,12 @@ static inline int flag_is_changeable_p(u32 flag)
 }
 
 /* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
+static int have_cpuid_p(void)
 {
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
 
-static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+static void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
 		/* Disable processor serial number */
@@ -198,7 +198,7 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
  */
 
 /* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+static char *table_lookup_model(struct cpuinfo_x86 *c)
 {
 	struct cpu_model_info *info;
 
@@ -218,7 +218,7 @@ static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cleared_cpu_caps[NCAPINTS];
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
@@ -236,7 +236,7 @@ void switch_to_new_gdt(void)
 
 static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
+static void default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
 	display_cacheinfo(c);
@@ -253,13 +253,13 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 #endif
 }
 
-static struct cpu_dev __cpuinitdata default_cpu = {
+static struct cpu_dev default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
 	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
 
-static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
+static void get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 	char *p, *q;
@@ -286,7 +286,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void display_cacheinfo(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
@@ -330,7 +330,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 			l2size, ecx & 0xFF);
 }
 
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
+void detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
@@ -392,7 +392,7 @@ out:
 #endif
 }
 
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
+static void get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
@@ -421,7 +421,7 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 	this_cpu = &default_cpu;
 }
 
-void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
+void cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
@@ -448,7 +448,7 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+static void get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
@@ -485,7 +485,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 
 }
 
-static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
+static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
 	int i;
@@ -585,12 +585,12 @@ void __init early_cpu_init(void)
  * reliably, so probing for it doesn't even work.  Disable it completely
  * unless we can find a reliable way to detect all the broken cases.
  */
-static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
+static void detect_nopl(struct cpuinfo_x86 *c)
 {
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
 }
 
-static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
+static void generic_identify(struct cpuinfo_x86 *c)
 {
 	c->extended_cpuid_level = 0;
 
@@ -631,7 +631,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
@@ -747,7 +747,7 @@ void __init identify_boot_cpu(void)
 #endif
 }
 
-void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+void identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
@@ -762,14 +762,14 @@ struct msr_range {
 	unsigned max;
 };
 
-static struct msr_range msr_range_array[] __cpuinitdata = {
+static struct msr_range msr_range_array[] = {
 	{ 0x00000000, 0x00000418},
 	{ 0xc0000000, 0xc000040b},
 	{ 0xc0010000, 0xc0010142},
 	{ 0xc0011000, 0xc001103b},
 };
 
-static void __cpuinit print_cpu_msr(void)
+static void print_cpu_msr(void)
 {
 	unsigned index;
 	u64 val;
@@ -787,7 +787,7 @@ static void __cpuinit print_cpu_msr(void)
 	}
 }
 
-static int show_msr __cpuinitdata;
+static int show_msr;
 static __init int setup_show_msr(char *arg)
 {
 	int num;
@@ -807,7 +807,7 @@ static __init int setup_noclflush(char *arg)
 }
 __setup("noclflush", setup_noclflush);
 
-void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
+void print_cpu_info(struct cpuinfo_x86 *c)
 {
 	char *vendor = NULL;
 
@@ -849,7 +849,7 @@ static __init int setup_disablecpuid(char *arg)
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
+cpumask_t cpu_initialized = CPU_MASK_NONE;
 
 #ifdef CONFIG_X86_64
 struct x8664_pda **_cpu_pda __read_mostly;
@@ -859,7 +859,7 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
-void __cpuinit pda_init(int cpu)
+void pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
 
@@ -935,7 +935,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 #else
 
 /* Make sure %fs is initialized properly in idle threads */
-struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
+struct pt_regs * idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->fs = __KERNEL_PERCPU;
@@ -951,7 +951,7 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
  * A lot of state is already set up in PDA init for 64 bit
  */
 #ifdef CONFIG_X86_64
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
 	int cpu = stack_smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
@@ -1071,7 +1071,7 @@ void __cpuinit cpu_init(void)
 
 #else
 
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	struct task_struct *curr = current;
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 84bb395..c24137e 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1098,7 +1098,7 @@ static int powernowk8_verify(struct cpufreq_policy *pol)
 }
 
 /* per CPU init entry point to the driver */
-static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
+static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
@@ -1290,7 +1290,7 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 };
 
 /* driver entry point for init */
-static int __cpuinit powernowk8_init(void)
+static int powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
 
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index ffd0f5e..7d9aff5 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -15,7 +15,7 @@
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
  */
-static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
 
@@ -44,7 +44,7 @@ static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 	}
 }
 
-static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned long flags;
 
@@ -59,25 +59,25 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
  * Actually since bugs.h doesn't even reference this perhaps someone should
  * fix the documentation ???
  */
-static unsigned char Cx86_dir0_msb __cpuinitdata = 0;
+static unsigned char Cx86_dir0_msb = 0;
 
-static char Cx86_model[][9] __cpuinitdata = {
+static char Cx86_model[][9] = {
 	"Cx486", "Cx486", "5x86 ", "6x86", "MediaGX ", "6x86MX ",
 	"M II ", "Unknown"
 };
-static char Cx486_name[][5] __cpuinitdata = {
+static char Cx486_name[][5] = {
 	"SLC", "DLC", "SLC2", "DLC2", "SRx", "DRx",
 	"SRx2", "DRx2"
 };
-static char Cx486S_name[][4] __cpuinitdata = {
+static char Cx486S_name[][4] = {
 	"S", "S2", "Se", "S2e"
 };
-static char Cx486D_name[][4] __cpuinitdata = {
+static char Cx486D_name[][4] = {
 	"DX", "DX2", "?", "?", "?", "DX4"
 };
-static char Cx86_cb[] __cpuinitdata = "?.5x Core/Bus Clock";
-static char cyrix_model_mult1[] __cpuinitdata = "12??43";
-static char cyrix_model_mult2[] __cpuinitdata = "12233445";
+static char Cx86_cb[] = "?.5x Core/Bus Clock";
+static char cyrix_model_mult1[] = "12??43";
+static char cyrix_model_mult2[] = "12233445";
 
 /*
  * Reset the slow-loop (SLOP) bit on the 686(L) which is set by some old
@@ -87,7 +87,7 @@ static char cyrix_model_mult2[] __cpuinitdata = "12233445";
  * FIXME: our newer udelay uses the tsc. We don't need to frob with SLOP
  */
 
-static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
+static void check_cx686_slop(struct cpuinfo_x86 *c)
 {
 	unsigned long flags;
 
@@ -112,7 +112,7 @@ static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 }
 
 
-static void __cpuinit set_cx86_reorder(void)
+static void set_cx86_reorder(void)
 {
 	u8 ccr3;
 
@@ -127,7 +127,7 @@ static void __cpuinit set_cx86_reorder(void)
 	setCx86(CX86_CCR3, ccr3);
 }
 
-static void __cpuinit set_cx86_memwb(void)
+static void set_cx86_memwb(void)
 {
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
@@ -143,7 +143,7 @@ static void __cpuinit set_cx86_memwb(void)
  *	Configure later MediaGX and/or Geode processor.
  */
 
-static void __cpuinit geode_configure(void)
+static void geode_configure(void)
 {
 	unsigned long flags;
 	u8 ccr3;
@@ -166,7 +166,7 @@ static void __cpuinit geode_configure(void)
 	local_irq_restore(flags);
 }
 
-static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
+static void early_init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir1 = 0;
 
@@ -185,7 +185,7 @@ static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
+static void init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir0_lsn, dir1 = 0;
 	char *buf = c->x86_model_id;
@@ -353,7 +353,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 /*
  * Handle National Semiconductor branded processors
  */
-static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
+static void init_nsc(struct cpuinfo_x86 *c)
 {
 	/*
 	 * There may be GX1 processors in the wild that are branded
@@ -402,7 +402,7 @@ static inline int test_cyrix_52div(void)
 	return (unsigned char) (test >> 8) == 0x02;
 }
 
-static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
+static void cyrix_identify(struct cpuinfo_x86 *c)
 {
 	/* Detect Cyrix with disabled CPUID */
 	if (c->x86 == 4 && test_cyrix_52div()) {
@@ -435,7 +435,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 	}
 }
 
-static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
+static struct cpu_dev cyrix_cpu_dev = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
 	.c_early_init	= early_init_cyrix,
@@ -446,7 +446,7 @@ static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 
 cpu_dev_register(cyrix_cpu_dev);
 
-static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
+static struct cpu_dev nsc_cpu_dev = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 99468db..7a5a600 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -28,7 +28,7 @@
 #include <mach_apic.h>
 #endif
 
-static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
@@ -50,7 +50,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
  *	This is called before we do cpu ident work
  */
 
-int __cpuinit ppro_with_ram_bug(void)
+int ppro_with_ram_bug(void)
 {
 	/* Uses data from early_cpu_detect now */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
@@ -64,7 +64,7 @@ int __cpuinit ppro_with_ram_bug(void)
 }
 
 #ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
+static void trap_init_f00f_bug(void)
 {
 	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
 
@@ -77,7 +77,7 @@ static void __cpuinit trap_init_f00f_bug(void)
 }
 #endif
 
-static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
@@ -155,12 +155,12 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 #endif
 }
 #else
-static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 }
 #endif
 
-static void __cpuinit srat_detect_node(void)
+static void srat_detect_node(void)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	unsigned node;
@@ -181,7 +181,7 @@ static void __cpuinit srat_detect_node(void)
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
+static int intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -196,7 +196,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
+static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 {
 	/* Intel VMX MSR indicated features */
 #define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
@@ -234,7 +234,7 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_intel(struct cpuinfo_x86 *c)
+static void init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
 
@@ -333,7 +333,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_32
-static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/*
 	 * Intel PIII Tualatin. This comes in two flavours.
@@ -347,7 +347,7 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 }
 #endif
 
-static struct cpu_dev intel_cpu_dev __cpuinitdata = {
+static struct cpu_dev intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3f46afb..27d86f7 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -32,7 +32,7 @@ struct _cache_table
 };
 
 /* all the cache descriptor types we care about (no TLB or trace cache entries) */
-static struct _cache_table cache_table[] __cpuinitdata =
+static struct _cache_table cache_table[] =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
@@ -182,17 +182,17 @@ union l3_cache {
 	unsigned val;
 };
 
-static unsigned short assocs[] __cpuinitdata = {
+static unsigned short assocs[] = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
-static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
+static unsigned char levels[] = { 1, 1, 2, 3 };
+static unsigned char types[] = { 1, 2, 3, 3 };
 
-static void __cpuinit
+static void 
 amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		     union _cpuid4_leaf_ebx *ebx,
 		     union _cpuid4_leaf_ecx *ecx)
@@ -262,7 +262,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
-static void __cpuinit
+static void 
 amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
 {
 	if (index < 3)
@@ -271,7 +271,7 @@ amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
 }
 
 static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
 {
 	union _cpuid4_leaf_eax 	eax;
 	union _cpuid4_leaf_ebx 	ebx;
@@ -299,7 +299,7 @@ __cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
 	return 0;
 }
 
-static int __cpuinit find_num_cache_leaves(void)
+static int find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
 	union _cpuid4_leaf_eax	cache_eax;
@@ -314,7 +314,7 @@ static int __cpuinit find_num_cache_leaves(void)
 	return i;
 }
 
-unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
+unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
 	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0; /* Cache sizes */
 	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
@@ -480,7 +480,7 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+static void cache_shared_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
@@ -507,7 +507,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 		}
 	}
 }
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+static void cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	int sibling;
@@ -519,11 +519,11 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	}
 }
 #else
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
+static void cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
+static void cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
 #endif
 
-static void __cpuinit free_cache_attributes(unsigned int cpu)
+static void free_cache_attributes(unsigned int cpu)
 {
 	int i;
 
@@ -534,7 +534,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
+static int detect_cache_attributes(unsigned int cpu)
 {
 	struct _cpuid4_info	*this_leaf;
 	unsigned long		j;
@@ -831,7 +831,7 @@ static struct kobj_type ktype_percpu_entry = {
 	.sysfs_ops	= &sysfs_ops,
 };
 
-static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
+static void cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(per_cpu(cache_kobject, cpu));
 	kfree(per_cpu(index_kobject, cpu));
@@ -840,7 +840,7 @@ static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 	free_cache_attributes(cpu);
 }
 
-static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
+static int cpuid4_cache_sysfs_init(unsigned int cpu)
 {
 	int err;
 
@@ -872,7 +872,7 @@ err_out:
 static cpumask_t cache_dev_map = CPU_MASK_NONE;
 
 /* Add/Remove cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
+static int cache_add_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i, j;
@@ -915,7 +915,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	return 0;
 }
 
-static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
+static void cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
@@ -932,7 +932,7 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 	cpuid4_cache_sysfs_exit(cpu);
 }
 
-static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
+static int cacheinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -952,12 +952,12 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
+static struct notifier_block cacheinfo_cpu_notifier =
 {
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int cache_sysfs_init(void)
 {
 	int i;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 4b031a4..c5ab3d9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -474,7 +474,7 @@ static void mce_init(void *dummy)
 }
 
 /* Add per CPU specific workarounds here */
-static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
+static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
@@ -490,7 +490,7 @@ static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 
 }
 
-static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
+static void mce_cpu_features(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
@@ -508,7 +508,7 @@ static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off.
  */
-void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
+void mcheck_init(struct cpuinfo_x86 *c)
 {
 	static cpumask_t mce_cpus = CPU_MASK_NONE;
 
@@ -759,7 +759,7 @@ static struct sysdev_class mce_sysclass = {
 };
 
 DEFINE_PER_CPU(struct sys_device, device_mce);
-void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu) __cpuinitdata;
+void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 /* Why are there no generic functions for this? */
 #define ACCESSOR(name, var, start) \
@@ -825,7 +825,7 @@ static struct sysdev_attribute *mce_attributes[] = {
 static cpumask_t mce_device_initialized = CPU_MASK_NONE;
 
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
-static __cpuinit int mce_create_device(unsigned int cpu)
+static int mce_create_device(unsigned int cpu)
 {
 	int err;
 	int i;
@@ -860,7 +860,7 @@ error:
 	return err;
 }
 
-static __cpuinit void mce_remove_device(unsigned int cpu)
+static void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
@@ -875,7 +875,7 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
+static int mce_cpu_callback(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -897,7 +897,7 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier __cpuinitdata = {
+static struct notifier_block mce_cpu_notifier = {
 	.notifier_call = mce_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 5eb390a..4f97a5a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -114,7 +114,7 @@ static void threshold_restart_bank(struct threshold_block *b,
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
-void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
+void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
 	unsigned int bank, block;
 	unsigned int cpu = smp_processor_id();
@@ -387,7 +387,7 @@ static struct kobj_type threshold_ktype = {
 	.default_attrs = default_attrs,
 };
 
-static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
+static int allocate_threshold_blocks(unsigned int cpu,
 					       unsigned int bank,
 					       unsigned int block,
 					       u32 address)
@@ -464,7 +464,7 @@ out_free:
 }
 
 /* symlinks sibling shared banks to first core.  first core owns dir/files. */
-static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
+static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
@@ -549,7 +549,7 @@ out:
 }
 
 /* create dir/files for all valid threshold banks */
-static __cpuinit int threshold_create_device(unsigned int cpu)
+static int threshold_create_device(unsigned int cpu)
 {
 	unsigned int bank;
 	int err = 0;
@@ -646,7 +646,7 @@ static void threshold_remove_device(unsigned int cpu)
 }
 
 /* get notified when a cpu comes on/off */
-static void __cpuinit amd_64_threshold_cpu_callback(unsigned long action,
+static void amd_64_threshold_cpu_callback(unsigned long action,
 						     unsigned int cpu)
 {
 	if (cpu >= NR_CPUS)
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index c17eaf5..20d8938 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -30,7 +30,7 @@ asmlinkage void smp_thermal_interrupt(void)
 	irq_exit();
 }
 
-static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
+static void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int tm2 = 0;
@@ -84,7 +84,7 @@ static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
 	return;
 }
 
-void __cpuinit mce_intel_feature_init(struct cpuinfo_x86 *c)
+void mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
 	intel_init_thermal(c);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d5ae224..08d363b 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -111,12 +111,12 @@ int therm_throt_process(int curr)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static int thermal_throttle_add_dev(struct sys_device *sys_dev)
 {
 	return sysfs_create_group(&sys_dev->kobj, &thermal_throttle_attr_group);
 }
 
-static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
+static void thermal_throttle_remove_dev(struct sys_device *sys_dev)
 {
 	sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
 }
@@ -125,7 +125,7 @@ static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
 static DEFINE_MUTEX(therm_cpu_lock);
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
+static int thermal_throttle_cpu_callback(struct notifier_block *nfb,
 						   unsigned long action,
 						   void *hcpu)
 {
@@ -154,7 +154,7 @@ static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
+static struct notifier_block thermal_throttle_cpu_notifier =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 52b3fef..f692a81 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -5,7 +5,7 @@
 #include <asm/msr.h>
 #include "cpu.h"
 
-static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
+static void early_init_transmeta(struct cpuinfo_x86 *c)
 {
 	u32 xlvl;
 
@@ -17,7 +17,7 @@ static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
+static void init_transmeta(struct cpuinfo_x86 *c)
 {
 	unsigned int cap_mask, uk, max, dummy;
 	unsigned int cms_rev1, cms_rev2;
@@ -98,7 +98,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
+static struct cpu_dev transmeta_cpu_dev = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
 	.c_early_init	= early_init_transmeta,
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index e777f79..504a81d 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -8,7 +8,7 @@
  * so no special init takes place.
  */
 
-static struct cpu_dev umc_cpu_dev __cpuinitdata = {
+static struct cpu_dev umc_cpu_dev = {
 	.c_vendor	= "UMC",
 	.c_ident	= { "UMC UMC UMC" },
 	.c_models = {
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 72cefd1..b397d61 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static const struct file_operations cpuid_fops = {
 	.open = cpuid_open,
 };
 
-static __cpuinit int cpuid_device_create(int cpu)
+static int cpuid_device_create(int cpu)
 {
 	struct device *dev;
 
@@ -157,7 +157,7 @@ static void cpuid_device_destroy(int cpu)
 	device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 }
 
-static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
+static int cpuid_class_cpu_callback(struct notifier_block *nfb,
 					      unsigned long action,
 					      void *hcpu)
 {
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 2b69994..98190c5 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -816,7 +816,7 @@ ds_configure(const struct ds_configuration *cfg)
 	ds_cfg = *cfg;
 }
 
-void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
+void ds_init_intel(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
 	case 0x6:
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 33581d9..5303e63 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -227,7 +227,7 @@ struct genapic apic_x2apic_uv_x = {
 	.apic_id_mask = (0xFFFFFFFFu),
 };
 
-static __cpuinit void set_x2apic_extra_bits(int pnode)
+static void set_x2apic_extra_bits(int pnode)
 {
 	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
 }
@@ -455,7 +455,7 @@ void __init uv_system_init(void)
  * Called on each cpu to initialize the per_cpu UV data area.
  * 	ZZZ hotplug not supported yet
  */
-void __cpuinit uv_cpu_init(void)
+void uv_cpu_init(void)
 {
 	BUG_ON(!uv_system_inited);
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f20608..81dc1bd 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -40,9 +40,9 @@
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
-static struct i387_fxsave_struct fx_scratch __cpuinitdata;
+static struct i387_fxsave_struct fx_scratch;
 
-void __cpuinit mxcsr_feature_mask_init(void)
+void mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
@@ -83,7 +83,7 @@ void __init init_thread_xstate(void)
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
  */
-void __cpuinit fpu_init(void)
+void fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index b71e02d..1f8ab75 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -144,7 +144,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
  */
-void __cpuinit irq_ctx_init(int cpu)
+void irq_ctx_init(int cpu)
 {
 	union irq_ctx *irqctx;
 
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 936d8d5..dd0dd06 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -405,7 +405,7 @@ static struct sysdev_driver mc_sysdev_driver = {
 	.resume = mc_sysdev_resume,
 };
 
-static __cpuinit int
+static int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index efc2f36..e2b0185 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -23,10 +23,10 @@ struct pci_hostbridge_probe {
 	u32 device;
 };
 
-static u64 __cpuinitdata fam10h_pci_mmconf_base;
-static int __cpuinitdata fam10h_pci_mmconf_base_status;
+static u64 fam10h_pci_mmconf_base;
+static int fam10h_pci_mmconf_base_status;
 
-static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
+static struct pci_hostbridge_probe pci_probes[] = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
 };
@@ -36,7 +36,7 @@ struct range {
 	u64 end;
 };
 
-static int __cpuinit cmp_range(const void *x1, const void *x2)
+static int cmp_range(const void *x1, const void *x2)
 {
 	const struct range *r1 = x1;
 	const struct range *r2 = x2;
@@ -52,7 +52,7 @@ static int __cpuinit cmp_range(const void *x1, const void *x2)
 /* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
 #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
 #define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
-static void __cpuinit get_fam10h_pci_mmconf_base(void)
+static void get_fam10h_pci_mmconf_base(void)
 {
 	int i;
 	unsigned bus;
@@ -175,7 +175,7 @@ out:
 	fam10h_pci_mmconf_base_status = 1;
 }
 
-void __cpuinit fam10h_check_enable_mmcfg(void)
+void fam10h_check_enable_mmcfg(void)
 {
 	u64 val;
 	u32 address;
@@ -238,7 +238,7 @@ static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
 	{}
 };
 
-void __cpuinit check_enable_amd_mmconf_dmi(void)
+void check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
 }
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 82a7c7e..b99cdae 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -159,7 +159,7 @@ static const struct file_operations msr_fops = {
 	.open = msr_open,
 };
 
-static int __cpuinit msr_device_create(int cpu)
+static int msr_device_create(int cpu)
 {
 	struct device *dev;
 
@@ -173,7 +173,7 @@ static void msr_device_destroy(int cpu)
 	device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 }
 
-static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
+static int msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 4caff39..61508a6 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -73,7 +73,7 @@ static void __init smp_dump_qct(void)
 }
 
 
-void __cpuinit numaq_tsc_disable(void)
+void numaq_tsc_disable(void)
 {
 	if (!found_numaq)
 		return;
@@ -109,7 +109,7 @@ struct mpc_config_translation {
 /* x86_quirks member */
 static int mpc_record;
 static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY]
-    __cpuinitdata;
+   ;
 
 static inline int generate_logical_apicid(int quad, int phys_apicid)
 {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c622772..8954024 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -200,13 +200,13 @@ static void poll_idle(void)
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
-static int __cpuinitdata force_mwait;
+static int force_mwait;
 
 #define MWAIT_INFO			0x05
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+static int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
@@ -231,7 +231,7 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 /*
  * Check for AMD CPUs, which have potentially C1E support
  */
-static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
+static int check_c1e_idle(const struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
@@ -309,7 +309,7 @@ static void c1e_idle(void)
 		default_idle();
 }
 
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+void select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a6d8c1..b06514e 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -924,7 +924,7 @@ static inline void bts_configure(const struct bts_configuration *cfg)
 	bts_cfg = *cfg;
 }
 
-void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *c)
+void ptrace_bts_init_intel(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
 	case 0x6:
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2255782..5c7e78b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -156,7 +156,7 @@ static struct resource video_ram_resource = {
 };
 
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 new_cpu_data = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 EXPORT_SYMBOL(boot_cpu_data);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0e67f72..2f2c38b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
-unsigned disabled_cpus __cpuinitdata;
+unsigned disabled_cpus;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 unsigned int max_physical_apicid;
@@ -220,7 +220,7 @@ static void __init setup_node_to_cpumask_map(void)
 	node_to_cpumask_map = map;
 }
 
-void __cpuinit numa_set_node(int cpu, int node)
+void numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
@@ -237,19 +237,19 @@ void __cpuinit numa_set_node(int cpu, int node)
 		pr_debug("Setting node for non-present cpu %d\n", cpu);
 }
 
-void __cpuinit numa_clear_node(int cpu)
+void numa_clear_node(int cpu)
 {
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
 
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
 }
@@ -259,7 +259,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 /*
  * --------- debug versions of the numa functions ---------
  */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
+static void numa_set_cpumask(int cpu, int enable)
 {
 	int node = cpu_to_node(cpu);
 	cpumask_t *mask;
@@ -282,12 +282,12 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
 
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, 1);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, 0);
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7ed9e07..def019b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -82,14 +82,14 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
 */
 #ifdef CONFIG_HOTPLUG_CPU
 /*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
+ * Needed only for CONFIG_HOTPLUG_CPU because is
  * removed after init for !CONFIG_HOTPLUG_CPU.
  */
 static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
 #define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
 #define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
 #else
-static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
+static struct task_struct *idle_thread_array[NR_CPUS] ;
 #define get_idle_for_cpu(x)      (idle_thread_array[(x)])
 #define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
@@ -129,7 +129,7 @@ static atomic_t init_deasserted;
 static cpumask_t cpu_sibling_setup_map;
 
 /* Set if we find a B stepping CPU */
-static int __cpuinitdata smp_b_stepping;
+static int smp_b_stepping;
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
 
@@ -196,7 +196,7 @@ void numa_remove_cpu(int cpu)
  * Report back to the Boot Processor.
  * Running on AP.
  */
-static void __cpuinit smp_callin(void)
+static void smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
@@ -282,12 +282,12 @@ static void __cpuinit smp_callin(void)
 	cpu_set(cpuid, cpu_callin_map);
 }
 
-static int __cpuinitdata unsafe_smp;
+static int unsafe_smp;
 
 /*
  * Activate a secondary processor.
  */
-static void __cpuinit start_secondary(void *unused)
+static void start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
@@ -353,7 +353,7 @@ static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
-static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
+static void smp_apply_quirks(struct cpuinfo_x86 *c)
 {
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
@@ -406,7 +406,7 @@ valid_k7:
 	;
 }
 
-static void __cpuinit smp_checks(void)
+static void smp_checks(void)
 {
 	if (smp_b_stepping)
 		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
@@ -428,7 +428,7 @@ static void __cpuinit smp_checks(void)
  * a given CPU
  */
 
-void __cpuinit smp_store_cpu_info(int id)
+void smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
@@ -440,7 +440,7 @@ void __cpuinit smp_store_cpu_info(int id)
 }
 
 
-void __cpuinit set_cpu_sibling_map(int cpu)
+void set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -746,7 +746,7 @@ struct create_idle {
 	int cpu;
 };
 
-static void __cpuinit do_fork_idle(struct work_struct *work)
+static void do_fork_idle(struct work_struct *work)
 {
 	struct create_idle *c_idle =
 		container_of(work, struct create_idle, work);
@@ -769,7 +769,7 @@ static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
  *
  * Must be called after the _cpu_pda pointer table is initialized.
  */
-int __cpuinit get_local_pda(int cpu)
+int get_local_pda(int cpu)
 {
 	struct x8664_pda *oldpda, *newpda;
 	unsigned long size = sizeof(struct x8664_pda);
@@ -801,7 +801,7 @@ int __cpuinit get_local_pda(int cpu)
 }
 #endif /* CONFIG_X86_64 */
 
-static int __cpuinit do_boot_cpu(int apicid, int cpu)
+static int do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -962,7 +962,7 @@ restore_state:
 	return boot_error;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu)
+int native_cpu_up(unsigned int cpu)
 {
 	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 397e309..28cb893 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -13,7 +13,7 @@ EXPORT_PER_CPU_SYMBOL(this_cpu_off);
  * (still using the master per-cpu area), or a CPU doing it for a
  * secondary which will soon come up.
  */
-__cpuinit void init_gdt(int cpu)
+void init_gdt(int cpu)
 {
 	struct desc_struct gdt;
 
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index dcbf7a1..2bb4dd7 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -196,7 +196,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	spin_unlock(&f->tlbstate_lock);
 }
 
-static int __cpuinit init_smp_flush(void)
+static int init_smp_flush(void)
 {
 	int i;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 161bb85..b37da5c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -754,7 +754,7 @@ static inline void check_geode_tsc_reliable(void) { }
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
  */
-__cpuinit int unsynchronized_tsc(void)
+int unsynchronized_tsc(void)
 {
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..eddbc63 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -25,23 +25,23 @@
  * Entry/exit counters that make sure that both CPUs
  * run the measurement code at once:
  */
-static __cpuinitdata atomic_t start_count;
-static __cpuinitdata atomic_t stop_count;
+static atomic_t start_count;
+static atomic_t stop_count;
 
 /*
  * We use a raw spinlock in this exceptional case, because
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
  */
-static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static __cpuinitdata cycles_t last_tsc;
-static __cpuinitdata cycles_t max_warp;
-static __cpuinitdata int nr_warps;
+static raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static cycles_t last_tsc;
+static cycles_t max_warp;
+static int nr_warps;
 
 /*
  * TSC-warp measurement loop running on both CPUs:
  */
-static __cpuinit void check_tsc_warp(void)
+static void check_tsc_warp(void)
 {
 	cycles_t start, now, prev, end;
 	int i;
@@ -97,7 +97,7 @@ static __cpuinit void check_tsc_warp(void)
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
  */
-void __cpuinit check_tsc_sync_source(int cpu)
+void check_tsc_sync_source(int cpu)
 {
 	int cpus = 2;
 
@@ -157,7 +157,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 /*
  * Freshly booted CPUs call into this:
  */
-void __cpuinit check_tsc_sync_target(void)
+void check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 0b8b669..6eeea35 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -248,7 +248,7 @@ static ctl_table kernel_root_table2[] = {
 
 /* Assume __initcall executes before all user space. Hopefully kmod
    doesn't violate that. We'll find out if it does. */
-static void __cpuinit vsyscall_set_cpu(int cpu)
+static void vsyscall_set_cpu(int cpu)
 {
 	unsigned long d;
 	unsigned long node = 0;
@@ -268,13 +268,13 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
-static void __cpuinit cpu_vsyscall_init(void *arg)
+static void cpu_vsyscall_init(void *arg)
 {
 	/* preemption should be already off */
 	vsyscall_set_cpu(raw_smp_processor_id());
 }
 
-static int __cpuinit
+static int 
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9abac8a..8361a2d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -284,7 +284,7 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
 /*
  * Enable the extended processor state save/restore feature
  */
-void __cpuinit xsave_init(void)
+void xsave_init(void)
 {
 	if (!cpu_has_xsave)
 		return;
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 199a5f4..ac996b5 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1742,7 +1742,7 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 	smp_boot_cpus();
 }
 
-static void __cpuinit voyager_smp_prepare_boot_cpu(void)
+static void voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
@@ -1753,7 +1753,7 @@ static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 	cpu_set(smp_processor_id(), cpu_present_map);
 }
 
-static int __cpuinit voyager_cpu_up(unsigned int cpu)
+static int voyager_cpu_up(unsigned int cpu)
 {
 	/* This only works at boot for x86.  See "rewrite" above. */
 	if (cpu_isset(cpu, smp_commenced_mask))
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b8e461d..2f6ad0e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -92,7 +92,7 @@ int after_bootmem;
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-static int do_not_nx __cpuinitdata;
+static int do_not_nx;
 
 /*
  * noexec=on|off
@@ -116,7 +116,7 @@ static int __init nonx_setup(char *str)
 }
 early_param("noexec", nonx_setup);
 
-void __cpuinit check_efer(void)
+void check_efer(void)
 {
 	unsigned long efer;
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index cebcbf1..ab1a599 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -25,7 +25,7 @@ EXPORT_SYMBOL(node_data);
 
 struct memnode memnode;
 
-s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
+s16 apicid_to_node[MAX_LOCAL_APIC] = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 738fd0f..12a337e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -30,7 +30,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-void __cpuinit pat_disable(char *reason)
+void pat_disable(char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 22e0576..e8019c5 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -576,7 +576,7 @@ static void enable_pci_io_ecs(void *unused)
 	}
 }
 
-static int __cpuinit amd_cpu_notify(struct notifier_block *self,
+static int amd_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
@@ -591,7 +591,7 @@ static int __cpuinit amd_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata amd_cpu_notifier = {
+static struct notifier_block amd_cpu_notifier = {
 	.notifier_call	= amd_cpu_notify,
 };
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d679010..5f975bd 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -97,7 +97,7 @@ static void __init fiddle_vdso(void)
 #endif
 }
 
-static __cpuinit int register_callback(unsigned type, const void *func)
+static int register_callback(unsigned type, const void *func)
 {
 	struct callback_register callback = {
 		.type = type,
@@ -108,7 +108,7 @@ static __cpuinit int register_callback(unsigned type, const void *func)
 	return HYPERVISOR_callback_op(CALLBACKOP_register, &callback);
 }
 
-void __cpuinit xen_enable_sysenter(void)
+void xen_enable_sysenter(void)
 {
 	extern void xen_sysenter_target(void);
 	int ret;
@@ -128,7 +128,7 @@ void __cpuinit xen_enable_sysenter(void)
 		setup_clear_cpu_cap(sysenter_feature);
 }
 
-void __cpuinit xen_enable_syscall(void)
+void xen_enable_syscall(void)
 {
 #ifdef CONFIG_X86_64
 	int ret;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index d77da61..2679c2b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -59,7 +59,7 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static __cpuinit void cpu_bringup(void)
+static void cpu_bringup(void)
 {
 	int cpu = smp_processor_id();
 
@@ -87,7 +87,7 @@ static __cpuinit void cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-static __cpuinit void cpu_bringup_and_idle(void)
+static void cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
 	cpu_idle();
@@ -215,7 +215,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static __cpuinit int
+static int
 cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 {
 	struct vcpu_guest_context *ctxt;
@@ -275,7 +275,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
-static int __cpuinit xen_cpu_up(unsigned int cpu)
+static int xen_cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index dd71e3a..df07469 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -336,7 +336,7 @@ static irqreturn_t dummy_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void __cpuinit xen_init_lock_cpu(int cpu)
+void xen_init_lock_cpu(int cpu)
 {
 	int irq;
 	const char *name;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index d7422dc..3ffca2d 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -55,7 +55,7 @@ void __init xen_setup_vcpu_info_placement(void);
 void xen_smp_init(void);
 
 void __init xen_init_spinlocks(void);
-__cpuinit void xen_init_lock_cpu(int cpu);
+void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 
 extern cpumask_t xen_cpu_initialized_map;
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8df1e84..36fe9c3 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -204,7 +204,7 @@ again:
 }
 
 #ifndef CONFIG_GENERIC_CALIBRATE_DELAY
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	loops_per_jiffy = CCOUNT_PER_JIFFY;
 	printk("Calibrating delay loop (skipped)... "
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index e660d26..b91164b 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -77,7 +77,7 @@ static int raise_blk_irq(int cpu, struct request *rq)
 }
 #endif
 
-static int __cpuinit blk_cpu_notify(struct notifier_block *self,
+static int blk_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	/*
@@ -97,7 +97,7 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_cpu_notifier = {
+static struct notifier_block blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 13593f9..9cedb0c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -121,7 +121,7 @@ static int print_ecdt_error(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id __cpuinitdata ec_dmi_table[] = {
+static struct dmi_system_id ec_dmi_table[] = {
 	{
 	print_ecdt_error, "Asus L4R", {
 	DMI_MATCH(DMI_BIOS_VERSION, "1008.006"),
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index cb9864e..064ffa2 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -79,7 +79,7 @@ int acpi_map_pxm_to_node(int pxm)
 }
 
 #if 0
-void __cpuinit acpi_unmap_pxm_to_node(int node)
+void acpi_unmap_pxm_to_node(int node)
 {
 	int pxm = node_to_pxm_map[node];
 	pxm_to_node_map[pxm] = NID_INVAL;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ee68ac5..d0bb742 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -128,7 +128,7 @@ static int set_no_mwait(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
+static struct dmi_system_id processor_idle_dmi_table[] = {
 	{
 	set_no_mwait, "IFL91 board", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
@@ -652,7 +652,7 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
 
 static DEFINE_PER_CPU(void *, processor_device_array);
 
-static int __cpuinit acpi_processor_start(struct acpi_device *device)
+static int acpi_processor_start(struct acpi_device *device)
 {
 	int result = 0;
 	acpi_status status = AE_OK;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index cf5b1b7..c007f61 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -126,7 +126,7 @@ static int set_max_cstate(const struct dmi_system_id *id)
 
 /* Actually this shouldn't be __cpuinitdata, would be better to fix the
    callers to only run once -AK */
-static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
+static struct dmi_system_id processor_power_dmi_table[] = {
 	{ set_max_cstate, "IBM ThinkPad R40e", {
 	  DMI_MATCH(DMI_BIOS_VENDOR,"IBM"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"1SET70WW")}, (void *)1},
@@ -1796,7 +1796,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 
 #endif /* CONFIG_CPU_IDLE */
 
-int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
+int acpi_processor_power_init(struct acpi_processor *pr,
 			      struct acpi_device *device)
 {
 	acpi_status status = 0;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 64f5d54..187bbd1 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -56,7 +56,7 @@ static ssize_t __ref store_online(struct sys_device *dev, struct sysdev_attribut
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
-static void __cpuinit register_cpu_control(struct cpu *cpu)
+static void register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
 }
@@ -157,7 +157,7 @@ static int cpu_states_init(void)
  *
  * Initialize and register the CPU device.
  */
-int __cpuinit register_cpu(struct cpu *cpu, int num)
+int register_cpu(struct cpu *cpu, int num)
 {
 	int error;
 	cpu->node_id = cpu_to_node(num);
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 199cd97..c997e86 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -130,21 +130,21 @@ static struct attribute_group topology_attr_group = {
 };
 
 /* Add/Remove cpu_topology interface for CPU device */
-static int __cpuinit topology_add_dev(unsigned int cpu)
+static int topology_add_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
 	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
 }
 
-static void __cpuinit topology_remove_dev(unsigned int cpu)
+static void topology_remove_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
 	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
 }
 
-static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
+static int topology_cpu_callback(struct notifier_block *nfb,
 					   unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -165,7 +165,7 @@ static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
 	return rc ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static int __cpuinit topology_sysfs_init(void)
+static int topology_sysfs_init(void)
 {
 	int cpu;
 	int rc;
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 31d6f53..6dd9eb2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1763,7 +1763,7 @@ no_policy:
 }
 EXPORT_SYMBOL(cpufreq_update_policy);
 
-static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
+static int cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index c0ff97d..de1c6ed 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -308,7 +308,7 @@ cpufreq_stat_notifier_trans (struct notifier_block *nb, unsigned long val,
 	return 0;
 }
 
-static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
+static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..74d7bcf 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -318,7 +318,7 @@ struct pdev_entry {
 static LIST_HEAD(pdev_list);
 static DEFINE_MUTEX(pdev_list_mutex);
 
-static int __cpuinit coretemp_device_add(unsigned int cpu)
+static int coretemp_device_add(unsigned int cpu)
 {
 	int err;
 	struct platform_device *pdev;
@@ -375,7 +375,7 @@ static void coretemp_device_remove(unsigned int cpu)
 	mutex_unlock(&pdev_list_mutex);
 }
 
-static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
+static int coretemp_cpu_callback(struct notifier_block *nfb,
 				 unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long) hcpu;
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index cb55be0..5535565 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -800,7 +800,7 @@ static void destroy_comp_task(struct ehca_comp_pool *pool,
 		kthread_stop(task);
 }
 
-static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
+static void take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
@@ -823,7 +823,7 @@ static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 
 }
 
-static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
+static int comp_pool_callback(struct notifier_block *nfb,
 					unsigned long action,
 					void *hcpu)
 {
@@ -872,7 +872,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
+static struct notifier_block comp_pool_callback_nb = {
 	.notifier_call	= comp_pool_callback,
 	.priority	= 0,
 };
diff --git a/drivers/s390/sysinfo.c b/drivers/s390/sysinfo.c
index c3e4ab0..82910ff 100644
--- a/drivers/s390/sysinfo.c
+++ b/drivers/s390/sysinfo.c
@@ -336,7 +336,7 @@ void s390_adjust_jiffies(void)
 /*
  * calibrate the delay loop
  */
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	s390_adjust_jiffies();
 	/* Print the good old Bogomips line .. */
diff --git a/include/asm-x86/ds.h b/include/asm-x86/ds.h
index c3c953a..5679463 100644
--- a/include/asm-x86/ds.h
+++ b/include/asm-x86/ds.h
@@ -199,7 +199,7 @@ extern int ds_set_pebs_reset(struct task_struct *task, u64 value);
  * Initialization
  */
 struct cpuinfo_x86;
-extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
+extern void ds_init_intel(struct cpuinfo_x86 *);
 
 
 
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index fb79b1c..74e3b7d 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -2,8 +2,8 @@
 #define ASM_X86__MMCONFIG_H
 
 #ifdef CONFIG_PCI_MMCONFIG
-extern void __cpuinit fam10h_check_enable_mmcfg(void);
-extern void __cpuinit check_enable_amd_mmconf_dmi(void);
+extern void fam10h_check_enable_mmcfg(void);
+extern void check_enable_amd_mmconf_dmi(void);
 #else
 static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index be2241a..5151454 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -53,7 +53,7 @@ extern void early_reserve_e820_mpc_new(void);
 static inline void early_reserve_e820_mpc_new(void) { }
 #endif
 
-void __cpuinit generic_processor_info(int apicid, int version);
+void generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
diff --git a/include/asm-x86/numa_64.h b/include/asm-x86/numa_64.h
index 15c9903..db18a4b 100644
--- a/include/asm-x86/numa_64.h
+++ b/include/asm-x86/numa_64.h
@@ -28,10 +28,10 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 
 #ifdef CONFIG_NUMA
 extern void __init init_cpu_to_node(void);
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
-extern void __cpuinit numa_add_cpu(int cpu);
-extern void __cpuinit numa_remove_cpu(int cpu);
+extern void numa_set_node(int cpu, int node);
+extern void numa_clear_node(int cpu);
+extern void numa_add_cpu(int cpu);
+extern void numa_remove_cpu(int cpu);
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline void numa_set_node(int cpu, int node)	{ }
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index a202552..111cf65 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -164,7 +164,7 @@ struct cpuinfo_x86;
 struct task_struct;
 
 #ifdef CONFIG_X86_PTRACE_BTS
-extern void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *);
+extern void ptrace_bts_init_intel(struct cpuinfo_x86 *);
 extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
 #else
 #define ptrace_bts_init_intel(config) do {} while (0)
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index a6afc29..ebd0c4f 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -25,7 +25,7 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
 
-extern int __cpuinit get_local_pda(int cpu);
+extern int get_local_pda(int cpu);
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
@@ -157,7 +157,7 @@ static inline void prefill_possible_map(void)
 }
 #endif /* CONFIG_SMP */
 
-extern unsigned disabled_cpus __cpuinitdata;
+extern unsigned disabled_cpus;
 
 #ifdef CONFIG_X86_32_SMP
 /*
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c2747ac..a4337c2 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -116,7 +116,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
+	static struct notifier_block fn##_nb =			\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
diff --git a/include/linux/init.h b/include/linux/init.h
index ad63824..02fe6e5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -91,12 +91,9 @@
 #define __devexitconst   __section(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
-#define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold
-#define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+#define __cpuinit        __cold
+#define __cpuinitdata    
+#define __cpuexit        __exitused __cold
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold
diff --git a/init/calibrate.c b/init/calibrate.c
index a379c90..1cf009b 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -30,7 +30,7 @@ __setup("lpj=", lpj_setup);
 #define DELAY_CALIBRATION_TICKS			((HZ < 100) ? 1 : (HZ/100))
 #define MAX_DIRECT_CALIBRATION_RETRIES		5
 
-static unsigned long __cpuinit calibrate_delay_direct(void)
+static unsigned long calibrate_delay_direct(void)
 {
 	unsigned long pre_start, start, post_start;
 	unsigned long pre_end, end, post_end;
@@ -105,7 +105,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 	return 0;
 }
 #else
-static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
+static unsigned long calibrate_delay_direct(void) {return 0;}
 #endif
 
 /*
@@ -119,7 +119,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
  */
 #define LPS_PREC 8
 
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 86d4904..0d4422c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL(cpu_possible_map);
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(cpu_down);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
+static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	int ret, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
@@ -364,7 +364,7 @@ out_notify:
 	return ret;
 }
 
-int __cpuinit cpu_up(unsigned int cpu)
+int cpu_up(unsigned int cpu)
 {
 	int err = 0;
 	if (!cpu_isset(cpu, cpu_possible_map)) {
diff --git a/kernel/fork.c b/kernel/fork.c
index 7cace29..a438f57 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1306,13 +1306,13 @@ fork_out:
 	return ERR_PTR(retval);
 }
 
-noinline struct pt_regs * __cpuinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
+noinline struct pt_regs * __attribute__((weak)) idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	return regs;
 }
 
-struct task_struct * __cpuinit fork_idle(int cpu)
+struct task_struct * fork_idle(int cpu)
 {
 	struct task_struct *task;
 	struct pt_regs regs;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2b465df..34af2c6 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1639,7 +1639,7 @@ sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
 /*
  * Functions related to boot-time initialization:
  */
-static void __cpuinit init_hrtimers_cpu(int cpu)
+static void init_hrtimers_cpu(int cpu)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
@@ -1775,7 +1775,7 @@ static void migrate_hrtimers(int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
+static int hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
@@ -1802,7 +1802,7 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata hrtimers_nb = {
+static struct notifier_block hrtimers_nb = {
 	.notifier_call = hrtimer_cpu_notify,
 };
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 37f72e5..1a2559f 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -730,7 +730,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 	spin_unlock_irqrestore(&rcp->lock, flags);
 }
 
-static void __cpuinit rcu_online_cpu(int cpu)
+static void rcu_online_cpu(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
@@ -740,7 +740,7 @@ static void __cpuinit rcu_online_cpu(int cpu)
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+static int rcu_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -760,7 +760,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata rcu_nb = {
+static struct notifier_block rcu_nb = {
 	.notifier_call	= rcu_cpu_notify,
 };
 
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ca4bbbe..d41a1d9 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1056,7 +1056,7 @@ void rcu_offline_cpu(int cpu)
 
 #endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
 
-void __cpuinit rcu_online_cpu(int cpu)
+void rcu_online_cpu(int cpu)
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
@@ -1360,7 +1360,7 @@ int rcu_pending(int cpu)
 	return 0;
 }
 
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+static int rcu_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1382,7 +1382,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata rcu_nb = {
+static struct notifier_block rcu_nb = {
 	.notifier_call = rcu_cpu_notify,
 };
 
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..6ee92d5 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -519,7 +519,7 @@ static void setup_callbacks(struct rchan *chan,
  *
  * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
  */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+static int relay_hotcpu_callback(struct notifier_block *nb,
 				unsigned long action,
 				void *hcpu)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 7c093df..a4c9370 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5844,7 +5844,7 @@ void show_state_filter(unsigned long state_filter)
 		debug_show_all_locks();
 }
 
-void __cpuinit init_idle_bootup_task(struct task_struct *idle)
+void init_idle_bootup_task(struct task_struct *idle)
 {
 	idle->sched_class = &idle_sched_class;
 }
@@ -5857,7 +5857,7 @@ void __cpuinit init_idle_bootup_task(struct task_struct *idle)
  * NOTE: this function does not set the idle thread's NEED_RESCHED
  * flag, to make booting more robust.
  */
-void __cpuinit init_idle(struct task_struct *idle, int cpu)
+void init_idle(struct task_struct *idle, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -6494,7 +6494,7 @@ static void set_rq_offline(struct rq *rq)
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
  */
-static int __cpuinit
+static int 
 migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	struct task_struct *p;
@@ -6601,7 +6601,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 /* Register at highest priority so that task migration (migrate_all_tasks)
  * happens before everything else.
  */
-static struct notifier_block __cpuinitdata migration_notifier = {
+static struct notifier_block migration_notifier = {
 	.notifier_call = migration_call,
 	.priority = 10
 };
diff --git a/kernel/smp.c b/kernel/smp.c
index f362a85..1042164 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,7 +33,7 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
-static int __cpuinit init_call_single_data(void)
+static int init_call_single_data(void)
 {
 	int i;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7110dae..2cd3fcb 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -560,7 +560,7 @@ void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
 }
 EXPORT_SYMBOL(send_remote_softirq);
 
-static int __cpuinit remote_softirq_cpu_notify(struct notifier_block *self,
+static int remote_softirq_cpu_notify(struct notifier_block *self,
 					       unsigned long action, void *hcpu)
 {
 	/*
@@ -589,7 +589,7 @@ static int __cpuinit remote_softirq_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata remote_softirq_cpu_notifier = {
+static struct notifier_block remote_softirq_cpu_notifier = {
 	.notifier_call	= remote_softirq_cpu_notify,
 };
 
@@ -716,7 +716,7 @@ static void takeover_tasklets(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit cpu_callback(struct notifier_block *nfb,
+static int cpu_callback(struct notifier_block *nfb,
 				  unsigned long action,
 				  void *hcpu)
 {
@@ -762,7 +762,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_nfb = {
+static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 3953e4a..6407358 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -282,7 +282,7 @@ static int watchdog(void *__bind_cpu)
 /*
  * Create/destroy watchdog threads as CPUs come and go:
  */
-static int __cpuinit
+static int 
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -335,7 +335,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_nfb = {
+static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 56becf3..ae274b1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1358,11 +1358,11 @@ asmlinkage long sys_sysinfo(struct sysinfo __user *info)
 	return 0;
 }
 
-static int __cpuinit init_timers_cpu(int cpu)
+static int init_timers_cpu(int cpu)
 {
 	int j;
 	struct tvec_base *base;
-	static char __cpuinitdata tvec_base_done[NR_CPUS];
+	static char tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;
@@ -1427,7 +1427,7 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 	}
 }
 
-static void __cpuinit migrate_timers(int cpu)
+static void migrate_timers(int cpu)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
@@ -1460,7 +1460,7 @@ static void __cpuinit migrate_timers(int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int __cpuinit timer_cpu_notify(struct notifier_block *self,
+static int timer_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1482,7 +1482,7 @@ static int __cpuinit timer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata timers_nb = {
+static struct notifier_block timers_nb = {
 	.notifier_call	= timer_cpu_notify,
 };
 
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..37b6fdb 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -115,7 +115,7 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 EXPORT_SYMBOL(percpu_counter_destroy);
 
 #ifdef CONFIG_HOTPLUG_CPU
-static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
+static int percpu_counter_hotcpu_callback(struct notifier_block *nb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b40f6d5..b78bcda 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -805,14 +805,14 @@ void writeback_set_ratelimit(void)
 		ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
 }
 
-static int __cpuinit
+static int 
 ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
 {
 	writeback_set_ratelimit();
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block __cpuinitdata ratelimit_nb = {
+static struct notifier_block ratelimit_nb = {
 	.notifier_call	= ratelimit_handler,
 	.next		= NULL,
 };
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9eb9eb9..b8521c8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2718,7 +2718,7 @@ static struct per_cpu_pageset boot_pageset[NR_CPUS];
  * Dynamically allocate memory for the
  * per cpu pageset array in struct zone.
  */
-static int __cpuinit process_zones(int cpu)
+static int process_zones(int cpu)
 {
 	struct zone *zone, *dzone;
 	int node = cpu_to_node(cpu);
@@ -2769,7 +2769,7 @@ static inline void free_zone_pagesets(int cpu)
 	}
 }
 
-static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
+static int pageset_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
 {
@@ -2794,7 +2794,7 @@ static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
 	return ret;
 }
 
-static struct notifier_block __cpuinitdata pageset_notifier =
+static struct notifier_block pageset_notifier =
 	{ &pageset_cpuup_callback, NULL, 0 };
 
 void __init setup_per_cpu_pageset(void)
diff --git a/mm/slab.c b/mm/slab.c
index e76eee4..b4295e1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -930,7 +930,7 @@ static void next_reap_node(void)
  * the CPUs getting into lockstep and contending for the global cache chain
  * lock.
  */
-static void __cpuinit start_cpu_timer(int cpu)
+static void start_cpu_timer(int cpu)
 {
 	struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
 
@@ -1154,7 +1154,7 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 }
 #endif
 
-static void __cpuinit cpuup_canceled(long cpu)
+static void cpuup_canceled(long cpu)
 {
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
@@ -1219,7 +1219,7 @@ free_array_cache:
 	}
 }
 
-static int __cpuinit cpuup_prepare(long cpu)
+static int cpuup_prepare(long cpu)
 {
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
@@ -1321,7 +1321,7 @@ bad:
 	return -ENOMEM;
 }
 
-static int __cpuinit cpuup_callback(struct notifier_block *nfb,
+static int cpuup_callback(struct notifier_block *nfb,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1377,7 +1377,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpucache_notifier = {
+static struct notifier_block cpucache_notifier = {
 	&cpuup_callback, NULL, 0
 };
 
diff --git a/mm/slub.c b/mm/slub.c
index 0c83e6a..55c36a7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3153,7 +3153,7 @@ EXPORT_SYMBOL(kmem_cache_create);
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
  */
-static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
+static int slab_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -3193,7 +3193,7 @@ static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata slab_notifier = {
+static struct notifier_block slab_notifier = {
 	.notifier_call = slab_cpuup_callback
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d7826af..c864dac 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -833,7 +833,7 @@ static void vmstat_update(struct work_struct *w)
 		sysctl_stat_interval);
 }
 
-static void __cpuinit start_cpu_timer(int cpu)
+static void start_cpu_timer(int cpu)
 {
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
@@ -845,7 +845,7 @@ static void __cpuinit start_cpu_timer(int cpu)
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
  */
-static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
+static int vmstat_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
 {
@@ -875,7 +875,7 @@ static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata vmstat_notifier =
+static struct notifier_block vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
 
 static int __init setup_vmstat(void)
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index d7b54b5..8a117fe 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -552,7 +552,7 @@ static void iucv_disable(void)
 	kfree(iucv_path_table);
 }
 
-static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
+static int iucv_cpu_notify(struct notifier_block *self,
 				     unsigned long action, void *hcpu)
 {
 	cpumask_t cpumask;
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
