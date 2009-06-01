Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZFAJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZFAJE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZFAJEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:04:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:53999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbZFAJEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:04:46 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>, "blackfin: Mike Frysinger" <vapier@gentoo.org>,
       "block: Jens Axboe" <axboe@kernel.dk>,
       "crypto: Herbert Xu" <herbert@gondor.apana.org.au>,
       "acpi: Len Brown" <lenb@kernel.org>,
       "xen: Jeremy Fitzhardinge" <jeremy@xensource.com>,
       "cpu: Mike Travis" <travis@sgi.com>,
       "cpufreq: Dave Jones" <davej@redhat.com>,
       "cpuidle: Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "fs: Alexander Viro" <viro@zeniv.linux.org.uk>,
       "kprobes: Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       "lockdep: Peter Zijlstra" <peterz@infradead.org>,
       "rcu: Dipankar Sarma" <dipankar@in.ibm.com>,
       "rcutorture: Josh Triplett" <josh@freedesktop.org>,
       "trace: Frederic Weisbecker" <fweisbec@gmail.com>,
       "mm,radix-tree: Nick Piggin" <nickpiggin@yahoo.com.au>,
       "slub: Christoph Lameter" <cl@linux-foundation.org>,
       "random32: Stephen Hemminger" <shemminger@osdl.org>,
       "kernel/*: Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 4/7] percpu: enforce global definition
Date: Mon,  1 Jun 2009 17:58:25 +0900
Message-Id: <1243846708-805-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243846708-805-1-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:58:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs (alpha and s390) need to add 'weak' attribute to percpu
variable definitions so that the compiler generates external
references for them.  To allow this, enforce global definition of all
percpu variables.

This patch makes DEFINE_PER_CPU_SECTION() do DECLARE_PERCPU_SECTION()
implicitly and drop static from all percpu definitions.

[ Impact: all percpu variables are forced to be global ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: arm: Russell King <linux@arm.linux.org.uk>
Cc: avr32: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: blackfin: Mike Frysinger <vapier@gentoo.org>
Cc: ia64: Tony Luck <tony.luck@intel.com>
Cc: mips: Ralf Baechle <ralf@linux-mips.org>
Cc: parisc: Kyle McMartin <kyle@mcmartin.ca>
Cc: powerpc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: s390: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: superh: Paul Mundt <lethal@linux-sh.org>
Cc: sparc: David S. Miller <davem@davemloft.net>
Cc: x86,timer: Thomas Gleixner <tglx@linutronix.de>
Cc: block: Jens Axboe <axboe@kernel.dk>
Cc: crypto: Herbert Xu <herbert@gondor.apana.org.au>
Cc: acpi: Len Brown <lenb@kernel.org>
Cc: xen: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: cpu: Mike Travis <travis@sgi.com>
Cc: cpufreq: Dave Jones <davej@redhat.com>
Cc: cpuidle: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: lguest: Rusty Russell <rusty@rustcorp.com.au>
Cc: fs: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: kprobes: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lockdep: Peter Zijlstra <peterz@infradead.org>
Cc: rcu: Dipankar Sarma <dipankar@in.ibm.com>
Cc: rcutorture: Josh Triplett <josh@freedesktop.org>
Cc: trace: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mm,radix-tree: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: slub: Christoph Lameter <cl@linux-foundation.org>
Cc: random32: Stephen Hemminger <shemminger@osdl.org>
Cc: net: David S. Miller <davem@davemloft.net>
Cc: kernel/*: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/kernel/smp.c                            |    2 +-
 arch/arm/mach-realview/localtimer.c              |    2 +-
 arch/avr32/kernel/cpu.c                          |    2 +-
 arch/blackfin/mach-common/smp.c                  |    2 +-
 arch/blackfin/mm/sram-alloc.c                    |   22 ++++++++--------
 arch/ia64/kernel/crash.c                         |    2 +-
 arch/ia64/kernel/smp.c                           |    4 +-
 arch/ia64/kernel/traps.c                         |    2 +-
 arch/ia64/kvm/kvm-ia64.c                         |    2 +-
 arch/ia64/xen/irq_xen.c                          |   24 ++++++++--------
 arch/mips/kernel/cevt-bcm1480.c                  |    6 ++--
 arch/mips/kernel/cevt-sb1250.c                   |    6 ++--
 arch/mips/kernel/topology.c                      |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c                  |    4 +-
 arch/parisc/kernel/irq.c                         |    2 +-
 arch/parisc/kernel/topology.c                    |    2 +-
 arch/powerpc/kernel/cacheinfo.c                  |    2 +-
 arch/powerpc/kernel/process.c                    |    2 +-
 arch/powerpc/kernel/sysfs.c                      |    4 +-
 arch/powerpc/kernel/time.c                       |    6 ++--
 arch/powerpc/mm/pgtable.c                        |    2 +-
 arch/powerpc/mm/stab.c                           |    4 +-
 arch/powerpc/oprofile/op_model_cell.c            |    2 +-
 arch/powerpc/platforms/cell/cpufreq_spudemand.c  |    2 +-
 arch/powerpc/platforms/cell/interrupt.c          |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c           |    2 +-
 arch/powerpc/platforms/ps3/smp.c                 |    2 +-
 arch/powerpc/platforms/pseries/dtl.c             |    2 +-
 arch/powerpc/platforms/pseries/iommu.c           |    2 +-
 arch/s390/appldata/appldata_base.c               |    2 +-
 arch/s390/kernel/nmi.c                           |    2 +-
 arch/s390/kernel/smp.c                           |    2 +-
 arch/s390/kernel/time.c                          |    4 +-
 arch/s390/kernel/vtime.c                         |    2 +-
 arch/sh/kernel/timers/timer-broadcast.c          |    2 +-
 arch/sh/kernel/topology.c                        |    2 +-
 arch/sparc/kernel/nmi.c                          |    6 ++--
 arch/sparc/kernel/pci_sun4v.c                    |    2 +-
 arch/sparc/kernel/sysfs.c                        |    4 +-
 arch/sparc/kernel/time_64.c                      |    4 +-
 arch/x86/kernel/apic/apic.c                      |    2 +-
 arch/x86/kernel/apic/nmi.c                       |    8 +++---
 arch/x86/kernel/cpu/common.c                     |    2 +-
 arch/x86/kernel/cpu/cpu_debug.c                  |   10 +++---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    4 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    6 ++--
 arch/x86/kernel/cpu/mcheck/mce_64.c              |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c        |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c         |    4 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c           |    2 +-
 arch/x86/kernel/ds.c                             |    4 +-
 arch/x86/kernel/hpet.c                           |    2 +-
 arch/x86/kernel/irq_32.c                         |    8 +++---
 arch/x86/kernel/kvm.c                            |    2 +-
 arch/x86/kernel/kvmclock.c                       |    2 +-
 arch/x86/kernel/paravirt.c                       |    2 +-
 arch/x86/kernel/process_64.c                     |    2 +-
 arch/x86/kernel/smpboot.c                        |    2 +-
 arch/x86/kernel/tlb_uv.c                         |    6 ++--
 arch/x86/kernel/topology.c                       |    2 +-
 arch/x86/kernel/uv_time.c                        |    2 +-
 arch/x86/kernel/vmiclock_32.c                    |    2 +-
 arch/x86/kvm/svm.c                               |    2 +-
 arch/x86/kvm/vmx.c                               |    6 ++--
 arch/x86/kvm/x86.c                               |    2 +-
 arch/x86/mm/kmmio.c                              |    2 +-
 arch/x86/mm/mmio-mod.c                           |    4 +-
 arch/x86/oprofile/nmi_int.c                      |    4 +-
 arch/x86/xen/enlighten.c                         |    2 +-
 arch/x86/xen/multicalls.c                        |    2 +-
 arch/x86/xen/smp.c                               |    8 +++---
 arch/x86/xen/spinlock.c                          |    4 +-
 arch/x86/xen/time.c                              |   10 +++---
 block/as-iosched.c                               |    2 +-
 block/blk-softirq.c                              |    2 +-
 block/cfq-iosched.c                              |    2 +-
 crypto/sha512_generic.c                          |    2 +-
 drivers/acpi/processor_core.c                    |    2 +-
 drivers/acpi/processor_thermal.c                 |    2 +-
 drivers/base/cpu.c                               |    2 +-
 drivers/char/random.c                            |    2 +-
 drivers/connector/cn_proc.c                      |    2 +-
 drivers/cpufreq/cpufreq.c                        |    8 +++---
 drivers/cpufreq/cpufreq_conservative.c           |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c               |    2 +-
 drivers/cpufreq/cpufreq_stats.c                  |    2 +-
 drivers/cpufreq/cpufreq_userspace.c              |   11 +++----
 drivers/cpufreq/freq_table.c                     |    2 +-
 drivers/cpuidle/governors/ladder.c               |    2 +-
 drivers/cpuidle/governors/menu.c                 |    2 +-
 drivers/crypto/padlock-aes.c                     |    2 +-
 drivers/lguest/page_tables.c                     |    2 +-
 drivers/lguest/x86/core.c                        |    2 +-
 drivers/xen/events.c                             |    6 ++--
 fs/buffer.c                                      |    4 +-
 fs/file.c                                        |    2 +-
 fs/namespace.c                                   |    2 +-
 include/linux/percpu-defs.h                      |   10 +++++--
 kernel/kprobes.c                                 |    2 +-
 kernel/lockdep.c                                 |    2 +-
 kernel/printk.c                                  |    2 +-
 kernel/profile.c                                 |    4 +-
 kernel/rcuclassic.c                              |    4 +-
 kernel/rcupdate.c                                |    2 +-
 kernel/rcupreempt.c                              |   10 +++---
 kernel/rcutorture.c                              |    4 +-
 kernel/sched.c                                   |   30 +++++++++++-----------
 kernel/sched_clock.c                             |    2 +-
 kernel/sched_rt.c                                |    2 +-
 kernel/smp.c                                     |    6 ++--
 kernel/softirq.c                                 |    6 ++--
 kernel/softlockup.c                              |    6 ++--
 kernel/taskstats.c                               |    4 +-
 kernel/time/tick-sched.c                         |    2 +-
 kernel/time/timer_stats.c                        |    2 +-
 kernel/timer.c                                   |    2 +-
 kernel/trace/ring_buffer.c                       |    2 +-
 kernel/trace/trace.c                             |    6 ++--
 kernel/trace/trace_hw_branches.c                 |    4 +-
 kernel/trace/trace_irqsoff.c                     |    2 +-
 kernel/trace/trace_stack.c                       |    2 +-
 kernel/trace/trace_sysprof.c                     |    2 +-
 kernel/trace/trace_workqueue.c                   |    2 +-
 lib/radix-tree.c                                 |    2 +-
 lib/random32.c                                   |    2 +-
 mm/page-writeback.c                              |    2 +-
 mm/slab.c                                        |    4 +-
 mm/slub.c                                        |    6 +---
 mm/swap.c                                        |    4 +-
 mm/vmalloc.c                                     |    2 +-
 mm/vmstat.c                                      |    2 +-
 net/core/drop_monitor.c                          |    2 +-
 net/core/flow.c                                  |    6 ++--
 net/core/sock.c                                  |    2 +-
 net/ipv4/route.c                                 |    2 +-
 net/ipv4/syncookies.c                            |    3 +-
 net/ipv6/syncookies.c                            |    3 +-
 net/socket.c                                     |    2 +-
 141 files changed, 261 insertions(+), 262 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 6014dfd..eb1026e 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -50,7 +50,7 @@ struct ipi_data {
 	unsigned long bits;
 };
 
-static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
+DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
 	.lock	= SPIN_LOCK_UNLOCKED,
 };
 
diff --git a/arch/arm/mach-realview/localtimer.c b/arch/arm/mach-realview/localtimer.c
index 1c01d13..4afd165 100644
--- a/arch/arm/mach-realview/localtimer.c
+++ b/arch/arm/mach-realview/localtimer.c
@@ -24,7 +24,7 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 
-static DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
+DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
 
 /*
  * Used on SMP for either the local timer or IPI_TIMER
diff --git a/arch/avr32/kernel/cpu.c b/arch/avr32/kernel/cpu.c
index e84faff..fbc8c92 100644
--- a/arch/avr32/kernel/cpu.c
+++ b/arch/avr32/kernel/cpu.c
@@ -18,7 +18,7 @@
 #include <asm/setup.h>
 #include <asm/sysreg.h>
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 #ifdef CONFIG_PERFORMANCE_COUNTERS
 
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 93eab61..0527cba 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -93,7 +93,7 @@ struct ipi_message_queue {
 	unsigned long count;
 };
 
-static DEFINE_PER_CPU(struct ipi_message_queue, ipi_msg_queue);
+DEFINE_PER_CPU(struct ipi_message_queue, ipi_msg_queue);
 
 static void ipi_cpu_stop(unsigned int cpu)
 {
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 530d139..e954244 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -42,9 +42,9 @@
 #include <asm/mem_map.h>
 #include "blackfin_sram.h"
 
-static DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
+DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
+DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
+DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
 static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
 
 /* the data structure for L1 scratchpad and DATA SRAM */
@@ -55,22 +55,22 @@ struct sram_piece {
 	struct sram_piece *next;
 };
 
-static DEFINE_PER_CPU(struct sram_piece, free_l1_ssram_head);
-static DEFINE_PER_CPU(struct sram_piece, used_l1_ssram_head);
+DEFINE_PER_CPU(struct sram_piece, free_l1_ssram_head);
+DEFINE_PER_CPU(struct sram_piece, used_l1_ssram_head);
 
 #if L1_DATA_A_LENGTH != 0
-static DEFINE_PER_CPU(struct sram_piece, free_l1_data_A_sram_head);
-static DEFINE_PER_CPU(struct sram_piece, used_l1_data_A_sram_head);
+DEFINE_PER_CPU(struct sram_piece, free_l1_data_A_sram_head);
+DEFINE_PER_CPU(struct sram_piece, used_l1_data_A_sram_head);
 #endif
 
 #if L1_DATA_B_LENGTH != 0
-static DEFINE_PER_CPU(struct sram_piece, free_l1_data_B_sram_head);
-static DEFINE_PER_CPU(struct sram_piece, used_l1_data_B_sram_head);
+DEFINE_PER_CPU(struct sram_piece, free_l1_data_B_sram_head);
+DEFINE_PER_CPU(struct sram_piece, used_l1_data_B_sram_head);
 #endif
 
 #if L1_CODE_LENGTH != 0
-static DEFINE_PER_CPU(struct sram_piece, free_l1_inst_sram_head);
-static DEFINE_PER_CPU(struct sram_piece, used_l1_inst_sram_head);
+DEFINE_PER_CPU(struct sram_piece, free_l1_inst_sram_head);
+DEFINE_PER_CPU(struct sram_piece, used_l1_inst_sram_head);
 #endif
 
 #if L2_LENGTH != 0
diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index f065093..9ba4aa4 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -50,7 +50,7 @@ final_note(void *buf)
 
 extern void ia64_dump_cpu_regs(void *);
 
-static DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus);
+DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus);
 
 void
 crash_save_this_cpu(void)
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 3e0840c..0681840 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -58,7 +58,7 @@ static struct local_tlb_flush_counts {
 	unsigned int count;
 } __attribute__((__aligned__(32))) local_tlb_flush_counts[NR_CPUS];
 
-static DEFINE_PER_CPU(unsigned short [NR_CPUS], shadow_flush_counts) ____cacheline_aligned;
+DEFINE_PER_CPU(unsigned short [NR_CPUS], shadow_flush_counts) ____cacheline_aligned;
 
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
@@ -66,7 +66,7 @@ static DEFINE_PER_CPU(unsigned short [NR_CPUS], shadow_flush_counts) ____cacheli
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
-static DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
+DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index f0cda76..08274f1 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -276,7 +276,7 @@ struct fpu_swa_msg {
 	unsigned long count;
 	unsigned long time;
 };
-static DEFINE_PER_CPU(struct fpu_swa_msg, cpulast);
+DEFINE_PER_CPU(struct fpu_swa_msg, cpulast);
 DECLARE_PER_CPU(struct fpu_swa_msg, cpulast);
 static struct fpu_swa_msg last __cacheline_aligned;
 
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d20a5db..64d414f 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -59,7 +59,7 @@ static long vp_env_info;
 
 static struct kvm_vmm_info *kvm_vmm_info;
 
-static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
+DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index af93aad..92e2c2f 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -63,19 +63,19 @@ xen_free_irq_vector(int vector)
 }
 
 
-static DEFINE_PER_CPU(int, timer_irq) = -1;
-static DEFINE_PER_CPU(int, ipi_irq) = -1;
-static DEFINE_PER_CPU(int, resched_irq) = -1;
-static DEFINE_PER_CPU(int, cmc_irq) = -1;
-static DEFINE_PER_CPU(int, cmcp_irq) = -1;
-static DEFINE_PER_CPU(int, cpep_irq) = -1;
+DEFINE_PER_CPU(int, timer_irq) = -1;
+DEFINE_PER_CPU(int, ipi_irq) = -1;
+DEFINE_PER_CPU(int, resched_irq) = -1;
+DEFINE_PER_CPU(int, cmc_irq) = -1;
+DEFINE_PER_CPU(int, cmcp_irq) = -1;
+DEFINE_PER_CPU(int, cpep_irq) = -1;
 #define NAME_SIZE	15
-static DEFINE_PER_CPU(char[NAME_SIZE], timer_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], ipi_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], resched_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cmc_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cmcp_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cpep_name);
+DEFINE_PER_CPU(char[NAME_SIZE], timer_name);
+DEFINE_PER_CPU(char[NAME_SIZE], ipi_name);
+DEFINE_PER_CPU(char[NAME_SIZE], resched_name);
+DEFINE_PER_CPU(char[NAME_SIZE], cmc_name);
+DEFINE_PER_CPU(char[NAME_SIZE], cmcp_name);
+DEFINE_PER_CPU(char[NAME_SIZE], cpep_name);
 #undef NAME_SIZE
 
 struct saved_irq {
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index a5182a2..cf43bc7 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -103,9 +103,9 @@ static irqreturn_t sibyte_counter_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
-static DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
-static DEFINE_PER_CPU(char [18], sibyte_hpt_name);
+DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
+DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
+DEFINE_PER_CPU(char [18], sibyte_hpt_name);
 
 void __cpuinit sb1480_clockevent_init(void)
 {
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index 340f53e..e3c7dce 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -101,9 +101,9 @@ static irqreturn_t sibyte_counter_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
-static DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
-static DEFINE_PER_CPU(char [18], sibyte_hpt_name);
+DEFINE_PER_CPU(struct clock_event_device, sibyte_hpt_clockevent);
+DEFINE_PER_CPU(struct irqaction, sibyte_hpt_irqaction);
+DEFINE_PER_CPU(char [18], sibyte_hpt_name);
 
 void __cpuinit sb1250_clockevent_init(void)
 {
diff --git a/arch/mips/kernel/topology.c b/arch/mips/kernel/topology.c
index 660e44e..38f9a0b 100644
--- a/arch/mips/kernel/topology.c
+++ b/arch/mips/kernel/topology.c
@@ -5,7 +5,7 @@
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static int __init topology_init(void)
 {
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index f10a7cd..af7379d 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -84,8 +84,8 @@ static void rt_set_mode(enum clock_event_mode mode,
 
 int rt_timer_irq;
 
-static DEFINE_PER_CPU(struct clock_event_device, hub_rt_clockevent);
-static DEFINE_PER_CPU(char [11], hub_rt_name);
+DEFINE_PER_CPU(struct clock_event_device, hub_rt_clockevent);
+DEFINE_PER_CPU(char [11], hub_rt_name);
 
 static irqreturn_t hub_rt_counter_handler(int irq, void *dev_id)
 {
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 4ea4229..f32c727 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -50,7 +50,7 @@ static volatile unsigned long cpu_eiem = 0;
 ** between ->ack() and ->end() of the interrupt to prevent
 ** re-interruption of a processing interrupt.
 */
-static DEFINE_PER_CPU(unsigned long, local_ack_eiem) = ~0UL;
+DEFINE_PER_CPU(unsigned long, local_ack_eiem) = ~0UL;
 
 static void cpu_disable_irq(unsigned int irq)
 {
diff --git a/arch/parisc/kernel/topology.c b/arch/parisc/kernel/topology.c
index f515938..4f61986 100644
--- a/arch/parisc/kernel/topology.c
+++ b/arch/parisc/kernel/topology.c
@@ -22,7 +22,7 @@
 #include <linux/cpu.h>
 #include <linux/cache.h>
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static int __init topology_init(void)
 {
diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index bb37b1d..ec89cdc 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -113,7 +113,7 @@ struct cache {
 	struct cache *next_local;      /* next cache of >= level */
 };
 
-static DEFINE_PER_CPU(struct cache_dir *, cache_dir_pcpu);
+DEFINE_PER_CPU(struct cache_dir *, cache_dir_pcpu);
 
 /* traversal/modification of this list occurs only at cpu hotplug time;
  * access is serialized by cpu hotplug locking
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 7b44a33..a1fc420 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -274,7 +274,7 @@ void do_dabr(struct pt_regs *regs, unsigned long address,
 	force_sig_info(SIGTRAP, &info, current);
 }
 
-static DEFINE_PER_CPU(unsigned long, current_dabr);
+DEFINE_PER_CPU(unsigned long, current_dabr);
 
 int set_dabr(unsigned long dabr)
 {
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index f41aec8..d5d4925 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -25,7 +25,7 @@
 #include <asm/lppaca.h>
 #endif
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 /*
  * SMT snooze delay stuff, 64-bit only for now
@@ -119,7 +119,7 @@ __setup("smt-snooze-delay=", setup_smt_snooze_delay);
  * it the first time we write to the PMCs.
  */
 
-static DEFINE_PER_CPU(char, pmcs_enabled);
+DEFINE_PER_CPU(char, pmcs_enabled);
 
 void ppc_enable_pmcs(void)
 {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 48571ac..d0c72a7 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -122,7 +122,7 @@ struct decrementer_clock {
 	u64 next_tb;
 };
 
-static DEFINE_PER_CPU(struct decrementer_clock, decrementers);
+DEFINE_PER_CPU(struct decrementer_clock, decrementers);
 
 #ifdef CONFIG_PPC_ISERIES
 static unsigned long __initdata iSeries_recal_titan;
@@ -172,7 +172,7 @@ EXPORT_SYMBOL(ppc_proc_freq);
 unsigned long ppc_tb_freq;
 
 static u64 tb_last_jiffy __cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(u64, last_jiffy);
+DEFINE_PER_CPU(u64, last_jiffy);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
@@ -298,7 +298,7 @@ struct cpu_purr_data {
  * each others' cpu_purr_data, disabling local interrupts is
  * sufficient to serialize accesses.
  */
-static DEFINE_PER_CPU(struct cpu_purr_data, cpu_purr_data);
+DEFINE_PER_CPU(struct cpu_purr_data, cpu_purr_data);
 
 static void snapshot_tb_and_purr(void *data)
 {
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index ae1d67c..5454968 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -30,7 +30,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 
-static DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
+DEFINE_PER_CPU(struct pte_freelist_batch *, pte_freelist_cur);
 static unsigned long pte_freelist_forced_free;
 
 struct pte_freelist_batch
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 6e9b69c..0124998 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -30,8 +30,8 @@ struct stab_entry {
 };
 
 #define NR_STAB_CACHE_ENTRIES 8
-static DEFINE_PER_CPU(long, stab_cache_ptr);
-static DEFINE_PER_CPU(long [NR_STAB_CACHE_ENTRIES], stab_cache);
+DEFINE_PER_CPU(long, stab_cache_ptr);
+DEFINE_PER_CPU(long [NR_STAB_CACHE_ENTRIES], stab_cache);
 
 /*
  * Create a segment table entry for the given esid/vsid pair.
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index ae06c62..424e263 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -139,7 +139,7 @@ static struct {
 #define GET_COUNT_CYCLES(x) (x & 0x00000001)
 #define GET_INPUT_CONTROL(x) ((x & 0x00000004) >> 2)
 
-static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
+DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
 static unsigned long spu_pm_cnt[MAX_NUMNODES * NUM_SPUS_PER_NODE];
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
diff --git a/arch/powerpc/platforms/cell/cpufreq_spudemand.c b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
index 968c1c0..beee12e 100644
--- a/arch/powerpc/platforms/cell/cpufreq_spudemand.c
+++ b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
@@ -37,7 +37,7 @@ struct spu_gov_info_struct {
 	struct delayed_work work;
 	unsigned int poll_int;		/* µs */
 };
-static DEFINE_PER_CPU(struct spu_gov_info_struct, spu_gov_info);
+DEFINE_PER_CPU(struct spu_gov_info_struct, spu_gov_info);
 
 static struct workqueue_struct *kspugov_wq;
 
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 882e470..2b1d1bd 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -54,7 +54,7 @@ struct iic {
 	struct device_node *node;
 };
 
-static DEFINE_PER_CPU(struct iic, iic);
+DEFINE_PER_CPU(struct iic, iic);
 #define IIC_NODE_COUNT	2
 static struct irq_host *iic_host;
 
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 8ec5ccf..fe5499e 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -90,7 +90,7 @@ struct ps3_private {
 	u64 thread_id;
 };
 
-static DEFINE_PER_CPU(struct ps3_private, ps3_private);
+DEFINE_PER_CPU(struct ps3_private, ps3_private);
 
 /**
  * ps3_chip_mask - Set an interrupt mask bit in ps3_bmp.
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index 6fcc499..29539b1 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -43,7 +43,7 @@ static irqreturn_t ipi_function_handler(int irq, void *msg)
   */
 
 #define MSG_COUNT 4
-static DEFINE_PER_CPU(unsigned int [MSG_COUNT], ps3_ipi_virqs);
+DEFINE_PER_CPU(unsigned int [MSG_COUNT], ps3_ipi_virqs);
 
 static const char *names[MSG_COUNT] = {
 	"ipi call",
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index ab69925..9da02d5 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -54,7 +54,7 @@ struct dtl {
 	int			buf_entries;
 	u64			last_idx;
 };
-static DEFINE_PER_CPU(struct dtl, dtl);
+DEFINE_PER_CPU(struct dtl, dtl);
 
 /*
  * Dispatch trace log event mask:
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 3ee01b4..c250cb4 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -140,7 +140,7 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	return ret;
 }
 
-static DEFINE_PER_CPU(u64 *, tce_page) = NULL;
+DEFINE_PER_CPU(u64 *, tce_page) = NULL;
 
 static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				     long npages, unsigned long uaddr,
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 1dfc710..23a0bac 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -80,7 +80,7 @@ static struct ctl_table appldata_dir_table[] = {
 /*
  * Timer
  */
-static DEFINE_PER_CPU(struct vtimer_list, appldata_timer);
+DEFINE_PER_CPU(struct vtimer_list, appldata_timer);
 static atomic_t appldata_expire_count = ATOMIC_INIT(0);
 
 static DEFINE_SPINLOCK(appldata_timer_lock);
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 28cf196..9ae4930 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -27,7 +27,7 @@ struct mcck_struct {
 	unsigned long long mcck_code;
 };
 
-static DEFINE_PER_CPU(struct mcck_struct, cpu_mcck);
+DEFINE_PER_CPU(struct mcck_struct, cpu_mcck);
 
 static NORET_TYPE void s390_handle_damage(char *msg)
 {
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index a985a3b..ef32579 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -66,7 +66,7 @@ int smp_cpu_polarization[NR_CPUS];
 static int smp_cpu_state[NR_CPUS];
 static int cpu_management;
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static void smp_ext_bitcall(int, ec_bit_sig);
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index ef596d0..6a91235 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -65,7 +65,7 @@ u64 sched_clock_base_cc = -1;	/* Force to data section. */
 static ext_int_info_t ext_int_info_cc;
 static ext_int_info_t ext_int_etr_cc;
 
-static DEFINE_PER_CPU(struct clock_event_device, comparators);
+DEFINE_PER_CPU(struct clock_event_device, comparators);
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -340,7 +340,7 @@ static unsigned long long adjust_time(unsigned long long old,
 	return delta;
 }
 
-static DEFINE_PER_CPU(atomic_t, clock_sync_word);
+DEFINE_PER_CPU(atomic_t, clock_sync_word);
 static DEFINE_MUTEX(clock_sync_mutex);
 static unsigned long clock_sync_flags;
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index c87f59b..1e73fb7 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -27,7 +27,7 @@
 
 static ext_int_info_t ext_int_info_timer;
 
-static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
+DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
 
 DEFINE_PER_CPU(struct s390_idle_data, s390_idle) = {
 	.lock = __SPIN_LOCK_UNLOCKED(s390_idle.lock)
diff --git a/arch/sh/kernel/timers/timer-broadcast.c b/arch/sh/kernel/timers/timer-broadcast.c
index 96e8eae..1339dcb 100644
--- a/arch/sh/kernel/timers/timer-broadcast.c
+++ b/arch/sh/kernel/timers/timer-broadcast.c
@@ -24,7 +24,7 @@
 #include <linux/clockchips.h>
 #include <linux/irq.h>
 
-static DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
+DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
 
 /*
  * Used on SMP for either the local timer or SMP_MSG_TIMER
diff --git a/arch/sh/kernel/topology.c b/arch/sh/kernel/topology.c
index 0838942..743dee7 100644
--- a/arch/sh/kernel/topology.c
+++ b/arch/sh/kernel/topology.c
@@ -14,7 +14,7 @@
 #include <linux/node.h>
 #include <linux/nodemask.h>
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static int __init topology_init(void)
 {
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index 2c0cc72..24d4243 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -39,9 +39,9 @@ EXPORT_SYMBOL_GPL(nmi_usable);
 
 static unsigned int nmi_hz = HZ;
 
-static DEFINE_PER_CPU(unsigned int, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
-static DEFINE_PER_CPU(int, nmi_touch);
+DEFINE_PER_CPU(unsigned int, last_irq_sum);
+DEFINE_PER_CPU(local_t, alert_counter);
+DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
 {
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 5db5ebe..4f86704 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -41,7 +41,7 @@ struct iommu_batch {
 	unsigned long	npages;		/* Number of pages in list.	*/
 };
 
-static DEFINE_PER_CPU(struct iommu_batch, iommu_batch);
+DEFINE_PER_CPU(struct iommu_batch, iommu_batch);
 static int iommu_batch_initialized;
 
 /* Interrupts must be disabled.  */
diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
index d28f496..fa55243 100644
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -12,7 +12,7 @@
 #include <asm/hypervisor.h>
 #include <asm/spitfire.h>
 
-static DEFINE_PER_CPU(struct hv_mmu_statistics, mmu_stats) __attribute__((aligned(64)));
+DEFINE_PER_CPU(struct hv_mmu_statistics, mmu_stats) __attribute__((aligned(64)));
 
 #define SHOW_MMUSTAT_ULONG(NAME) \
 static ssize_t show_##NAME(struct sys_device *dev, \
@@ -217,7 +217,7 @@ static struct sysdev_attribute cpu_core_attrs[] = {
 	_SYSDEV_ATTR(l2_cache_line_size,  0444, show_l2_cache_line_size, NULL),
 };
 
-static DEFINE_PER_CPU(struct cpu, cpu_devices);
+DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static void register_cpu_online(unsigned int cpu)
 {
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 5c12e79..3416f4a 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -630,7 +630,7 @@ struct freq_table {
 	unsigned long clock_tick_ref;
 	unsigned int ref_freq;
 };
-static DEFINE_PER_CPU(struct freq_table, sparc64_freq_table) = { 0, 0 };
+DEFINE_PER_CPU(struct freq_table, sparc64_freq_table) = { 0, 0 };
 
 unsigned long sparc64_get_clock_tick(unsigned int cpu)
 {
@@ -716,7 +716,7 @@ static struct clock_event_device sparc64_clockevent = {
 	.shift		= 30,
 	.irq		= -1,
 };
-static DEFINE_PER_CPU(struct clock_event_device, sparc64_events);
+DEFINE_PER_CPU(struct clock_event_device, sparc64_events);
 
 void timer_interrupt(int irq, struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..d4e1c16 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -173,7 +173,7 @@ static struct clock_event_device lapic_clockevent = {
 	.rating		= 100,
 	.irq		= -1,
 };
-static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static unsigned long apic_phys;
 
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index ce4fbfa..81fff0e 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(nmi_watchdog);
 static int panic_on_timeout;
 
 static unsigned int nmi_hz = HZ;
-static DEFINE_PER_CPU(short, wd_enabled);
+DEFINE_PER_CPU(short, wd_enabled);
 static int endflag __initdata;
 
 static inline unsigned int get_nmi_count(int cpu)
@@ -360,9 +360,9 @@ void stop_apic_nmi_watchdog(void *unused)
  * [when there will be more tty-related locks, break them up here too!]
  */
 
-static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
-static DEFINE_PER_CPU(int, nmi_touch);
+DEFINE_PER_CPU(unsigned, last_irq_sum);
+DEFINE_PER_CPU(local_t, alert_counter);
+DEFINE_PER_CPU(int, nmi_touch);
 
 void touch_nmi_watchdog(void)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 77848d9..5770059 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -997,7 +997,7 @@ static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
 };
 
-static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
+DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
 	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
 	__aligned(PAGE_SIZE);
 
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 66f7471..1a97ae7 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -30,11 +30,11 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base [CPU_REG_ALL_BIT], cpu_arr);
-static DEFINE_PER_CPU(struct cpu_private * [MAX_CPU_FILES], priv_arr);
-static DEFINE_PER_CPU(unsigned, cpu_modelflag);
-static DEFINE_PER_CPU(int, cpu_priv_count);
-static DEFINE_PER_CPU(unsigned, cpu_model);
+DEFINE_PER_CPU(struct cpu_cpuX_base [CPU_REG_ALL_BIT], cpu_arr);
+DEFINE_PER_CPU(struct cpu_private * [MAX_CPU_FILES], priv_arr);
+DEFINE_PER_CPU(unsigned, cpu_modelflag);
+DEFINE_PER_CPU(int, cpu_priv_count);
+DEFINE_PER_CPU(unsigned, cpu_model);
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 208ecf6..5cf61ea 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -69,13 +69,13 @@ struct acpi_cpufreq_data {
 	unsigned int cpu_feature;
 };
 
-static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
+DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
 struct acpi_msr_data {
 	u64 saved_aperf, saved_mperf;
 };
 
-static DEFINE_PER_CPU(struct acpi_msr_data, msr_data);
+DEFINE_PER_CPU(struct acpi_msr_data, msr_data);
 
 DEFINE_TRACE(power_mark);
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index f6b32d1..ab2a342 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -49,7 +49,7 @@
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
 
-static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
+DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index c9f1fdc..6e57f01 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -71,8 +71,8 @@ static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c,
 				  const struct cpu_id *x);
 
 /* Operating points for current CPU */
-static DEFINE_PER_CPU(struct cpu_model *, centrino_model);
-static DEFINE_PER_CPU(const struct cpu_id *, centrino_cpu);
+DEFINE_PER_CPU(struct cpu_model *, centrino_model);
+DEFINE_PER_CPU(const struct cpu_id *, centrino_cpu);
 
 static struct cpufreq_driver centrino_driver;
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 483eda9..3a4261d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -502,7 +502,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #ifdef CONFIG_SYSFS
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
-static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
+DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
@@ -620,7 +620,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
 
 /* pointer to kobject for cpuX/cache */
-static DEFINE_PER_CPU(struct kobject *, cache_kobject);
+DEFINE_PER_CPU(struct kobject *, cache_kobject);
 
 struct _index_kobject {
 	struct kobject kobj;
@@ -629,7 +629,7 @@ struct _index_kobject {
 };
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
-static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
+DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
 #define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 6fb0b35..5785175 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -453,9 +453,9 @@ void mce_log_therm_throt_event(__u64 status)
  */
 
 static int check_interval = 5 * 60; /* 5 minutes */
-static DEFINE_PER_CPU(int, next_interval); /* in jiffies */
+DEFINE_PER_CPU(int, next_interval); /* in jiffies */
 static void mcheck_timer(unsigned long);
-static DEFINE_PER_CPU(struct timer_list, mce_timer);
+DEFINE_PER_CPU(struct timer_list, mce_timer);
 
 static void mcheck_timer(unsigned long data)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 9fd9bf6..a4d7a81 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -69,7 +69,7 @@ struct threshold_bank {
 	struct threshold_block *blocks;
 	cpumask_var_t cpus;
 };
-static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
+DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
 #ifdef CONFIG_SMP
 static unsigned char shared_bank[NR_BANKS] = {
@@ -77,7 +77,7 @@ static unsigned char shared_bank[NR_BANKS] = {
 };
 #endif
 
-static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
+DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
 static void amd_threshold_interrupt(void);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index cef3ee3..007b542 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -95,7 +95,7 @@ static void intel_init_thermal(struct cpuinfo_x86 *c)
  * Also supports reliable discovery of shared banks.
  */
 
-static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
+DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*
  * cmci_discover_lock protects against parallel discovery attempts
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d5ae224..42a85e1 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -25,8 +25,8 @@
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL              (300 * HZ)
 
-static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
-static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
+DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
+DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
 atomic_t therm_throt_en = ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index f6c70a1..ea636fa 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -60,7 +60,7 @@ static const struct wd_ops *wd_ops;
 static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
 static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
 
-static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
+DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
 
 /* converts an msr to an appropriate reservation bit */
 static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 87b67e3..a1d487c 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -46,7 +46,7 @@ struct ds_configuration {
 	 * by enum ds_feature */
 	unsigned long ctl[dsf_ctl_max];
 };
-static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
 
 #define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
@@ -228,7 +228,7 @@ struct ds_context {
 	struct task_struct *task;
 };
 
-static DEFINE_PER_CPU(struct ds_context *, system_context_array);
+DEFINE_PER_CPU(struct ds_context *, system_context_array);
 
 #define system_context per_cpu(system_context_array, smp_processor_id())
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 81408b9..c76488d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -409,7 +409,7 @@ static int hpet_legacy_next_event(unsigned long delta,
  */
 #ifdef CONFIG_PCI_MSI
 
-static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
+DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
 void hpet_msi_unmask(unsigned int irq)
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b09634..85827e3 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -58,11 +58,11 @@ union irq_ctx {
 	u32                     stack[THREAD_SIZE/sizeof(u32)];
 } __attribute__((aligned(PAGE_SIZE)));
 
-static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
-static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
+DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
+DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
 
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
-static DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);
+DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, hardirq_stack);
+DEFINE_PER_CPU_PAGE_ALIGNED(union irq_ctx, softirq_stack);
 
 static void call_on_stack(void *func, void *stack)
 {
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33019dd..acffaf2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -36,7 +36,7 @@ struct kvm_para_state {
 	enum paravirt_lazy_mode mode;
 };
 
-static DEFINE_PER_CPU(struct kvm_para_state, para_state);
+DEFINE_PER_CPU(struct kvm_para_state, para_state);
 
 static struct kvm_para_state *kvm_para_state(void)
 {
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 223af43..abe4ab8 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -36,7 +36,7 @@ static int parse_no_kvmclock(char *arg)
 early_param("no-kvmclock", parse_no_kvmclock);
 
 /* The hypervisor will put information about time periodically here */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
 static struct pvclock_wall_clock wall_clock;
 
 /*
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 9faf43b..f889b91 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -244,7 +244,7 @@ int paravirt_disable_iospace(void)
 	return request_resource(&ioport_resource, &reserve_ioports);
 }
 
-static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..4abbc34 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -62,7 +62,7 @@ DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
-static DEFINE_PER_CPU(unsigned char, is_idle);
+DEFINE_PER_CPU(unsigned char, is_idle);
 
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..19f8b7f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -84,7 +84,7 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
  * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
  * removed after init for !CONFIG_HOTPLUG_CPU.
  */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
+DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
 #define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
 #define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
 #else
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index ed0c337..0252522 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -30,8 +30,8 @@ static int			uv_partition_base_pnode __read_mostly;
 
 static unsigned long		uv_mmask __read_mostly;
 
-static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
-static DEFINE_PER_CPU(struct bau_control, bau_control);
+DEFINE_PER_CPU(struct ptc_stats, ptcstats);
+DEFINE_PER_CPU(struct bau_control, bau_control);
 
 /*
  * Determine the first node on a blade.
@@ -305,7 +305,7 @@ const struct cpumask *uv_flush_send_and_wait(int cpu, int this_pnode,
 	return NULL;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
+DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
 
 /**
  * uv_flush_tlb_others - globally purge translation cache of a virtual
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 7e45159..a5d2d41 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -31,7 +31,7 @@
 #include <linux/smp.h>
 #include <asm/cpu.h>
 
-static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
+DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
 int __ref arch_register_cpu(int num)
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 583f11d..73c9287 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -54,7 +54,7 @@ static struct clock_event_device clock_event_device_uv = {
 	.event_handler	= NULL,
 };
 
-static DEFINE_PER_CPU(struct clock_event_device, cpu_ced);
+DEFINE_PER_CPU(struct clock_event_device, cpu_ced);
 
 /* There is one of these allocated per node */
 struct uv_rtc_timer_head {
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 2b3eb82..2cbc815 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -37,7 +37,7 @@
 #define VMI_ONESHOT  (VMI_ALARM_IS_ONESHOT  | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
 #define VMI_PERIODIC (VMI_ALARM_IS_PERIODIC | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
 
-static DEFINE_PER_CPU(struct clock_event_device, local_events);
+DEFINE_PER_CPU(struct clock_event_device, local_events);
 
 static inline u32 vmi_counter(u32 flags)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f8510c..f0b596c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -111,7 +111,7 @@ struct svm_cpu_data {
 	struct page *save_area;
 };
 
-static DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
 static uint32_t svm_features;
 
 struct svm_init_data {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bb48133..d9ebe9b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -107,9 +107,9 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 static int init_rmode(struct kvm *kvm);
 static u64 construct_eptp(unsigned long root_hpa);
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
-static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
-static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
+DEFINE_PER_CPU(struct vmcs *, vmxarea);
+DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
 
 static struct page *vmx_io_bitmap_a;
 static struct page *vmx_io_bitmap_b;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3944e91..00e8a6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -622,7 +622,7 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 		 hv_clock->tsc_to_system_mul);
 }
 
-static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
+DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
 static void kvm_write_guest_time(struct kvm_vcpu *v)
 {
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 50dc802..d7ce69c 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -72,7 +72,7 @@ static struct list_head *kmmio_page_list(unsigned long page)
 }
 
 /* Accessed per-cpu */
-static DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
+DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
 
 /*
  * this is basically a dynamic stabbing problem:
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index c9342ed..4b143e8 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -53,8 +53,8 @@ struct remap_trace {
 };
 
 /* Accessed per-cpu. */
-static DEFINE_PER_CPU(struct trap_reason, pf_reason);
-static DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
+DEFINE_PER_CPU(struct trap_reason, pf_reason);
+DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
 
 static DEFINE_MUTEX(mmiotrace_mutex);
 static DEFINE_SPINLOCK(trace_lock);
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 202864a..ea53f07 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -25,8 +25,8 @@
 #include "op_x86_model.h"
 
 static struct op_x86_model_spec const *model;
-static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
-static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
+DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
+DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f09e8c3..72af3ed 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -443,7 +443,7 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 }
 
 /* Locations of each CPU's IDT */
-static DEFINE_PER_CPU(struct desc_ptr, idt_desc);
+DEFINE_PER_CPU(struct desc_ptr, idt_desc);
 
 /* Set an IDT entry.  If the entry is part of the current IDT, then
    also update Xen. */
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 8bff7e7..3fba46a 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -49,7 +49,7 @@ struct mc_buffer {
 	unsigned mcidx, argidx, cbidx;
 };
 
-static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
+DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
 DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
 /* flush reasons 0- slots, 1- args, 2- callbacks */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 429834e..e6ed68b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -35,10 +35,10 @@
 
 cpumask_var_t xen_cpu_initialized_map;
 
-static DEFINE_PER_CPU(int, resched_irq);
-static DEFINE_PER_CPU(int, callfunc_irq);
-static DEFINE_PER_CPU(int, callfuncsingle_irq);
-static DEFINE_PER_CPU(int, debug_irq) = -1;
+DEFINE_PER_CPU(int, resched_irq);
+DEFINE_PER_CPU(int, callfunc_irq);
+DEFINE_PER_CPU(int, callfuncsingle_irq);
+DEFINE_PER_CPU(int, debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 5601506..75be10d 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -147,8 +147,8 @@ static int xen_spin_trylock(struct raw_spinlock *lock)
 	return old == 0;
 }
 
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
+DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
 /*
  * Mark a cpu as interested in a lock.  Returns the CPU's previous
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..eca663a 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -31,14 +31,14 @@
 #define NS_PER_TICK	(1000000000LL / HZ)
 
 /* runstate info updated by Xen */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
+DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
 
 /* snapshots of runstate info */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate_snapshot);
+DEFINE_PER_CPU(struct vcpu_runstate_info, runstate_snapshot);
 
 /* unused ns of stolen and blocked time */
-static DEFINE_PER_CPU(u64, residual_stolen);
-static DEFINE_PER_CPU(u64, residual_blocked);
+DEFINE_PER_CPU(u64, residual_stolen);
+DEFINE_PER_CPU(u64, residual_blocked);
 
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
@@ -403,7 +403,7 @@ static const struct clock_event_device xen_vcpuop_clockevent = {
 
 static const struct clock_event_device *xen_clockevent =
 	&xen_timerop_clockevent;
-static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events);
+DEFINE_PER_CPU(struct clock_event_device, xen_clock_events);
 
 static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 {
diff --git a/block/as-iosched.c b/block/as-iosched.c
index 96ff4d1..59c6935 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -146,7 +146,7 @@ enum arq_state {
 #define RQ_STATE(rq)	((enum arq_state)(rq)->elevator_private2)
 #define RQ_SET_STATE(rq, state)	((rq)->elevator_private2 = (void *) state)
 
-static DEFINE_PER_CPU(unsigned long, as_ioc_count);
+DEFINE_PER_CPU(unsigned long, as_ioc_count);
 static struct completion *ioc_gone;
 static DEFINE_SPINLOCK(ioc_gone_lock);
 
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..412e064 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -11,7 +11,7 @@
 
 #include "blk.h"
 
-static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
+DEFINE_PER_CPU(struct list_head, blk_cpu_done);
 
 /*
  * Softirq action handler - move entries to local list and loop over them
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index deea748..0792ce6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -48,7 +48,7 @@ static int cfq_slice_idle = HZ / 125;
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
 
-static DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
+DEFINE_PER_CPU(unsigned long, cfq_ioc_count);
 static struct completion *ioc_gone;
 static DEFINE_SPINLOCK(ioc_gone_lock);
 
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 3bea38d..c208a1e 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -27,7 +27,7 @@ struct sha512_ctx {
 	u8 buf[128];
 };
 
-static DEFINE_PER_CPU(u64[80], msg_schedule);
+DEFINE_PER_CPU(u64[80], msg_schedule);
 
 static inline u64 Ch(u64 x, u64 y, u64 z)
 {
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 45ad328..99d7820 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -687,7 +687,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	return 0;
 }
 
-static DEFINE_PER_CPU(void *, processor_device_array);
+DEFINE_PER_CPU(void *, processor_device_array);
 
 static int __cpuinit acpi_processor_start(struct acpi_device *device)
 {
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 39838c6..0687f2e 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -96,7 +96,7 @@ static int acpi_processor_apply_limit(struct acpi_processor *pr)
 #define CPUFREQ_THERMAL_MIN_STEP 0
 #define CPUFREQ_THERMAL_MAX_STEP 3
 
-static DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
+DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
 static unsigned int acpi_thermal_cpufreq_is_init = 0;
 
 static int cpu_has_cpufreq(unsigned int cpu)
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..ef46a16 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -18,7 +18,7 @@ struct sysdev_class cpu_sysdev_class = {
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
-static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
+DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8c74448..612b9fc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -277,7 +277,7 @@ static int random_write_wakeup_thresh = 128;
 
 static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 
-static DEFINE_PER_CPU(int, trickle_count);
+DEFINE_PER_CPU(int, trickle_count);
 
 /*
  * A pool of size .poolwords is stirred with a primitive polynomial
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index c5afc98..88f43c9 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -38,7 +38,7 @@ static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id = { CN_IDX_PROC, CN_VAL_PROC };
 
 /* proc_event_counts is used as the sequence number of the netlink message */
-static DEFINE_PER_CPU(__u32, proc_event_counts) = { 0 };
+DEFINE_PER_CPU(__u32, proc_event_counts) = { 0 };
 
 static inline void get_seq(__u32 *ts, int *cpu)
 {
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 47d2ad0..b5088c4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -38,10 +38,10 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
-static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
+DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
-static DEFINE_PER_CPU(struct cpufreq_governor *, cpufreq_cpu_governor);
+DEFINE_PER_CPU(struct cpufreq_governor *, cpufreq_cpu_governor);
 #endif
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
@@ -62,8 +62,8 @@ static DEFINE_SPINLOCK(cpufreq_driver_lock);
  * - Governor routines that can be called in cpufreq hotplug path should not
  *   take this sem as top level hotplug notifier handler takes this.
  */
-static DEFINE_PER_CPU(int, policy_cpu);
-static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
+DEFINE_PER_CPU(int, policy_cpu);
+DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
 int lock_policy_rwsem_##mode						\
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 8191d04..8d3b1f7 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -80,7 +80,7 @@ struct cpu_dbs_info_s {
 	int cpu;
 	unsigned int enable:1;
 };
-static DEFINE_PER_CPU(struct cpu_dbs_info_s, cs_cpu_dbs_info);
+DEFINE_PER_CPU(struct cpu_dbs_info_s, cs_cpu_dbs_info);
 
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 04de476..56525c0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -87,7 +87,7 @@ struct cpu_dbs_info_s {
 	unsigned int enable:1,
 		sample_type:1;
 };
-static DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
+DEFINE_PER_CPU(struct cpu_dbs_info_s, od_cpu_dbs_info);
 
 static unsigned int dbs_enable;	/* number of CPUs using this policy */
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5a62d67..4cda242 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -43,7 +43,7 @@ struct cpufreq_stats {
 #endif
 };
 
-static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
+DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
 
 struct cpufreq_stats_attribute {
 	struct attribute attr;
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 66d2d1d..9170939 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -27,12 +27,11 @@
 /**
  * A few values needed by the userspace governor
  */
-static DEFINE_PER_CPU(unsigned int, cpu_max_freq);
-static DEFINE_PER_CPU(unsigned int, cpu_min_freq);
-static DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
-static DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by
-							userspace */
-static DEFINE_PER_CPU(unsigned int, cpu_is_managed);
+DEFINE_PER_CPU(unsigned int, cpu_max_freq);
+DEFINE_PER_CPU(unsigned int, cpu_min_freq);
+DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
+DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by userspace */
+DEFINE_PER_CPU(unsigned int, cpu_is_managed);
 
 static DEFINE_MUTEX(userspace_mutex);
 static int cpus_using_userspace_governor;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index a9bd3a0..b3873b1 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -174,7 +174,7 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
-static DEFINE_PER_CPU(struct cpufreq_frequency_table *, show_table);
+DEFINE_PER_CPU(struct cpufreq_frequency_table *, show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index a4bec3f..2ec4150 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -42,7 +42,7 @@ struct ladder_device {
 	int last_state_idx;
 };
 
-static DEFINE_PER_CPU(struct ladder_device, ladder_devices);
+DEFINE_PER_CPU(struct ladder_device, ladder_devices);
 
 /**
  * ladder_do_selection - prepares private data for a state change
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f1df59f..7a44366 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -27,7 +27,7 @@ struct menu_device {
 	unsigned int	elapsed_us;
 };
 
-static DEFINE_PER_CPU(struct menu_device, menu_devices);
+DEFINE_PER_CPU(struct menu_device, menu_devices);
 
 /**
  * menu_select - selects the next idle state to enter
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 856b3cc..692ed44 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -51,7 +51,7 @@ struct aes_ctx {
 	u32 *D;
 };
 
-static DEFINE_PER_CPU(struct cword *, last_cword);
+DEFINE_PER_CPU(struct cword *, last_cword);
 
 /* Tells whether the ACE is capable to generate
    the extended key for a given key_len. */
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index a059cf9..cccc8ca 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -56,7 +56,7 @@
 /* We actually need a separate PTE page for each CPU.  Remember that after the
  * Switcher code itself comes two pages for each CPU, and we don't want this
  * CPU's guest to see the pages of any other CPU. */
-static DEFINE_PER_CPU(pte_t *, switcher_pte_pages);
+DEFINE_PER_CPU(pte_t *, switcher_pte_pages);
 #define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
 
 /*H:320 The page table code is curly enough to need helper functions to keep it
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index eaf722f..27662e6 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -67,7 +67,7 @@ static struct lguest_pages *lguest_pages(unsigned int cpu)
 		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
 }
 
-static DEFINE_PER_CPU(struct lg_cpu *, last_cpu);
+DEFINE_PER_CPU(struct lg_cpu *, last_cpu);
 
 /*S:010
  * We approach the Switcher.
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index dbfed85..6ac2e0e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -47,10 +47,10 @@
 static DEFINE_SPINLOCK(irq_mapping_update_lock);
 
 /* IRQ <-> VIRQ mapping. */
-static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
+DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
 
 /* IRQ <-> IPI mapping */
-static DEFINE_PER_CPU(int [XEN_NR_IPIS], ipi_to_irq) = {[0 ... XEN_NR_IPIS-1] = -1};
+DEFINE_PER_CPU(int [XEN_NR_IPIS], ipi_to_irq) = {[0 ... XEN_NR_IPIS-1] = -1};
 
 /* Interrupt types. */
 enum xen_irq_type {
@@ -596,7 +596,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static DEFINE_PER_CPU(unsigned, xed_nesting_count);
+DEFINE_PER_CPU(unsigned, xed_nesting_count);
 
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
diff --git a/fs/buffer.c b/fs/buffer.c
index aed2977..707a934 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1242,7 +1242,7 @@ struct bh_lru {
 	struct buffer_head *bhs[BH_LRU_SIZE];
 };
 
-static DEFINE_PER_CPU(struct bh_lru, bh_lrus) = {{ NULL }};
+DEFINE_PER_CPU(struct bh_lru, bh_lrus) = {{ NULL }};
 
 #ifdef CONFIG_SMP
 #define bh_lru_lock()	local_irq_disable()
@@ -3224,7 +3224,7 @@ struct bh_accounting {
 	int ratelimit;		/* Limit cacheline bouncing */
 };
 
-static DEFINE_PER_CPU(struct bh_accounting, bh_accounting) = {0, 0};
+DEFINE_PER_CPU(struct bh_accounting, bh_accounting) = {0, 0};
 
 static void recalc_bh_state(void)
 {
diff --git a/fs/file.c b/fs/file.c
index f313314..62e29d9 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -36,7 +36,7 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
  * the work_struct in fdtable itself which avoids a 64 byte (i386) increase in
  * this per-task structure.
  */
-static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
+DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
 static inline void * alloc_fdmem(unsigned int size)
 {
diff --git a/fs/namespace.c b/fs/namespace.c
index 134d494..5feb512 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -181,7 +181,7 @@ struct mnt_writer {
 	unsigned long count;
 	struct vfsmount *mnt;
 } ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(struct mnt_writer, mnt_writers);
+DEFINE_PER_CPU(struct mnt_writer, mnt_writers);
 
 static int __init init_mnt_writers(void)
 {
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 8f921d7..c51e51b 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -13,9 +13,12 @@
  * 'section' argument.  This may be used to affect the parameters governing the
  * variable's storage.
  *
- * NOTE!  The sections for the DECLARE and for the DEFINE must match, lest
- * linkage errors occur due the compiler generating the wrong code to access
- * that section.
+ * Some architectures (alpha and s390) need 'weak' attribute for percpu
+ * variables to force external references as space for percpu variables is
+ * allocated differently from regular variables.  To allow this, static percpu
+ * variables are not allowed - all perpcu variables must be global.  This is
+ * forced by implicitly doing DECLARE_PERCPU_SECTION() from
+ * DEFINE_PER_CPU_SECTION().
  */
 #define DECLARE_PER_CPU_SECTION(type, name, section)			\
 	extern								\
@@ -23,6 +26,7 @@
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SECTION(type, name, section)			\
+	DECLARE_PER_CPU_SECTION(type, name, section);			\
 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c0fa54b..92f67ff 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -71,7 +71,7 @@ static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 static bool kprobes_all_disarmed;
 
 static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
-static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index accb40c..4e6ae0e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -137,7 +137,7 @@ static inline struct lock_class *hlock_class(struct held_lock *hlock)
 }
 
 #ifdef CONFIG_LOCK_STAT
-static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
+DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
 static int lock_point(unsigned long points[], unsigned long ip)
 {
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..ac90df5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -959,7 +959,7 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-static DEFINE_PER_CPU(int, printk_pending);
+DEFINE_PER_CPU(int, printk_pending);
 
 void printk_tick(void)
 {
diff --git a/kernel/profile.c b/kernel/profile.c
index 7724e04..e68fd20 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -47,8 +47,8 @@ EXPORT_SYMBOL_GPL(prof_on);
 
 static cpumask_var_t prof_cpu_mask;
 #ifdef CONFIG_SMP
-static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
-static DEFINE_PER_CPU(int, cpu_profile_flip);
+DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
+DEFINE_PER_CPU(int, cpu_profile_flip);
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 0f2b0b3..f913cb9 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -74,8 +74,8 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cpumask = CPU_BITS_NONE,
 };
 
-static DEFINE_PER_CPU(struct rcu_data, rcu_data);
-static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+DEFINE_PER_CPU(struct rcu_data, rcu_data);
+DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 /*
  * Increment the quiescent state counter.
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a967c9f..7b80734 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -52,7 +52,7 @@ enum rcu_barrier {
 	RCU_BARRIER_SCHED,
 };
 
-static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
+DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ce97a4d..4bb39c0 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -155,7 +155,7 @@ struct rcu_dyntick_sched {
 	int sched_dynticks_snap;
 };
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
 	.dynticks = 1,
 };
 
@@ -190,7 +190,7 @@ void rcu_exit_nohz(void)
 #endif /* CONFIG_NO_HZ */
 
 
-static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+DEFINE_PER_CPU(struct rcu_data, rcu_data);
 
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
@@ -222,7 +222,7 @@ enum rcu_flip_flag_values {
 	rcu_flipped		/* Flip just completed, need confirmation. */
 				/* Only corresponding CPU can update. */
 };
-static DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_flip_flag_values, rcu_flip_flag)
+DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_flip_flag_values, rcu_flip_flag)
 								= rcu_flip_seen;
 
 /*
@@ -237,7 +237,7 @@ enum rcu_mb_flag_values {
 	rcu_mb_needed		/* Flip just completed, need an mb(). */
 				/* Only corresponding CPU can update. */
 };
-static DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_mb_flag_values, rcu_mb_flag)
+DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_mb_flag_values, rcu_mb_flag)
 								= rcu_mb_done;
 
 /*
@@ -472,7 +472,7 @@ static void __rcu_advance_callbacks(struct rcu_data *rdp)
 }
 
 #ifdef CONFIG_NO_HZ
-static DEFINE_PER_CPU(int, rcu_update_flag);
+DEFINE_PER_CPU(int, rcu_update_flag);
 
 /**
  * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9b4a975..1fcf4fe 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -114,9 +114,9 @@ static struct rcu_torture *rcu_torture_current = NULL;
 static long rcu_torture_current_version = 0;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
-static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
+DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
 	{ 0 };
-static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_batch) =
+DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_batch) =
 	{ 0 };
 static atomic_t rcu_torture_wcount[RCU_TORTURE_PIPE_LEN + 1];
 static atomic_t n_rcu_torture_alloc;
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..73a2246 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -320,14 +320,14 @@ struct task_group root_task_group;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /* Default task group's sched entity on each cpu */
-static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
+DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
+DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
@@ -661,7 +661,7 @@ struct rq {
 #endif
 };
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
 {
@@ -3839,7 +3839,7 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
@@ -7770,8 +7770,8 @@ struct static_sched_domain {
  * SMT sched-domains:
  */
 #ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
+DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
+DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
 
 static int
 cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
@@ -7787,8 +7787,8 @@ cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
  * multi-core sched-domains:
  */
 #ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+DEFINE_PER_CPU(struct static_sched_domain, core_domains);
+DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
 #endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
@@ -7815,8 +7815,8 @@ cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 }
 #endif
 
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
+DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
+DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
 
 static int
 cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
@@ -7843,11 +7843,11 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
  * groups, so roll our own. Now each node has its own list of groups which
  * gets dynamically allocated.
  */
-static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
+DEFINE_PER_CPU(struct static_sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
+DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
+DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
 static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
 				 struct sched_group **sg,
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..759f269 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -60,7 +60,7 @@ struct sched_clock_data {
 	u64			clock;
 };
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
 
 static inline struct sched_clock_data *this_scd(void)
 {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f2c66f8..339ab0b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1113,7 +1113,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 	return next;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
+DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static inline int pick_optimal_cpu(int this_cpu,
 				   const struct cpumask *mask)
diff --git a/kernel/smp.c b/kernel/smp.c
index 858baac..4ef26e5 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,7 +12,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
-static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
+DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
 static struct {
 	struct list_head	queue;
@@ -39,7 +39,7 @@ struct call_single_queue {
 	spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
+DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
 	.lock			= __SPIN_LOCK_UNLOCKED(cfd_data.lock),
 };
 
@@ -257,7 +257,7 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
-static DEFINE_PER_CPU(struct call_single_data, csd_data);
+DEFINE_PER_CPU(struct call_single_data, csd_data);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b525dd3..55f9452 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
@@ -352,8 +352,8 @@ struct tasklet_head
 	struct tasklet_struct **tail;
 };
 
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
+DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
+DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
 
 void __tasklet_schedule(struct tasklet_struct *t)
 {
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 88796c3..997cf10 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -22,9 +22,9 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
-static DEFINE_PER_CPU(unsigned long, touch_timestamp);
-static DEFINE_PER_CPU(unsigned long, print_timestamp);
-static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
+DEFINE_PER_CPU(unsigned long, touch_timestamp);
+DEFINE_PER_CPU(unsigned long, print_timestamp);
+DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int __read_mostly did_panic;
 int __read_mostly softlockup_thresh = 60;
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 888adbc..e7fc2cb 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -35,7 +35,7 @@
  */
 #define TASKSTATS_CPUMASK_MAXLEN	(100+6*NR_CPUS)
 
-static DEFINE_PER_CPU(__u32, taskstats_seqnum);
+DEFINE_PER_CPU(__u32, taskstats_seqnum);
 static int family_registered;
 struct kmem_cache *taskstats_cache;
 
@@ -68,7 +68,7 @@ struct listener_list {
 	struct rw_semaphore sem;
 	struct list_head list;
 };
-static DEFINE_PER_CPU(struct listener_list, listener_array);
+DEFINE_PER_CPU(struct listener_list, listener_array);
 
 enum actions {
 	REGISTER,
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..9d4b954 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -29,7 +29,7 @@
 /*
  * Per cpu nohz control structure
  */
-static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 /*
  * The time, when the last jiffy update happened. Protected by xtime_lock.
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index c994530..2a6fdb7 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -86,7 +86,7 @@ static DEFINE_SPINLOCK(table_lock);
 /*
  * Per-CPU lookup locks for fast hash lookup:
  */
-static DEFINE_PER_CPU(spinlock_t, lookup_lock);
+DEFINE_PER_CPU(spinlock_t, lookup_lock);
 
 /*
  * Mutex to serialize state changes with show-stats activities:
diff --git a/kernel/timer.c b/kernel/timer.c
index cffffad..3dd1d5d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -79,7 +79,7 @@ struct tvec_base {
 
 struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
-static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
+DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
 /*
  * Note that all tvec_bases are 2 byte aligned and lower bit of
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 960cbf4..91d73b3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1458,7 +1458,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 }
 
-static DEFINE_PER_CPU(int, rb_need_resched);
+DEFINE_PER_CPU(int, rb_need_resched);
 
 /**
  * ring_buffer_lock_reserve - reserve a part of the buffer
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cda81ec..10635e0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -88,7 +88,7 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
  */
 static int tracing_disabled = 1;
 
-static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 static inline void ftrace_disable_cpu(void)
 {
@@ -169,7 +169,7 @@ unsigned long long ns2usecs(cycle_t nsec)
  */
 static struct trace_array	global_trace;
 
-static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
+DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
 cycle_t ftrace_now(int cpu)
 {
@@ -197,7 +197,7 @@ cycle_t ftrace_now(int cpu)
  */
 static struct trace_array	max_tr;
 
-static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
+DEFINE_PER_CPU(struct trace_array_cpu, max_data);
 
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 7bfdf4c..34cea28 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -32,8 +32,8 @@
  * - read the trace from a single cpu
  */
 static DEFINE_SPINLOCK(bts_tracer_lock);
-static DEFINE_PER_CPU(struct bts_tracer *, tracer);
-static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
+DEFINE_PER_CPU(struct bts_tracer *, tracer);
+DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
 #define this_buffer per_cpu(buffer, smp_processor_id())
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b923d13..8f3661d 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -21,7 +21,7 @@
 static struct trace_array		*irqsoff_trace __read_mostly;
 static int				tracer_enabled __read_mostly;
 
-static DEFINE_PER_CPU(int, tracing_cpu);
+DEFINE_PER_CPU(int, tracing_cpu);
 
 static DEFINE_SPINLOCK(max_trace_lock);
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..bd78e95 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -31,7 +31,7 @@ static raw_spinlock_t max_stack_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 static int stack_trace_disabled __read_mostly;
-static DEFINE_PER_CPU(int, trace_active);
+DEFINE_PER_CPU(int, trace_active);
 static DEFINE_MUTEX(stack_sysctl_mutex);
 
 int stack_tracer_enabled;
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 91fd19c..e27b8dd 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -31,7 +31,7 @@ static DEFINE_MUTEX(sample_timer_lock);
 /*
  * Per CPU hrtimers that do the profiling:
  */
-static DEFINE_PER_CPU(struct hrtimer, stack_trace_hrtimer);
+DEFINE_PER_CPU(struct hrtimer, stack_trace_hrtimer);
 
 struct stack_frame {
 	const void __user	*next_fp;
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 797201e..a70e65c 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -38,7 +38,7 @@ struct workqueue_global_stats {
 /* Don't need a global lock because allocated before the workqueues, and
  * never freed.
  */
-static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
+DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
 #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
 
 /* Insertion of a work */
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 4bb42a0..a7f5217 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -81,7 +81,7 @@ struct radix_tree_preload {
 	int nr;
 	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
 };
-static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
+DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
diff --git a/lib/random32.c b/lib/random32.c
index 217d5c4..ce97c36 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -43,7 +43,7 @@ struct rnd_state {
 	u32 s1, s2, s3;
 };
 
-static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
+DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 static u32 __random32(struct rnd_state *state)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0e0c9de..23d6015 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -606,7 +606,7 @@ void set_page_dirty_balance(struct page *page, int page_mkwrite)
 	}
 }
 
-static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
+DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
 
 /**
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..42ccf81 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -763,7 +763,7 @@ int slab_is_available(void)
 	return g_cpucache_up == FULL;
 }
 
-static DEFINE_PER_CPU(struct delayed_work, reap_work);
+DEFINE_PER_CPU(struct delayed_work, reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 {
@@ -905,7 +905,7 @@ __setup("noaliencache", noaliencache_setup);
  * objects freed on different nodes from which they were allocated) and the
  * flushing of remote pcps by calling drain_node_pages.
  */
-static DEFINE_PER_CPU(unsigned long, reap_node);
+DEFINE_PER_CPU(unsigned long, reap_node);
 
 static void init_reap_node(int cpu)
 {
diff --git a/mm/slub.c b/mm/slub.c
index fbcf929..2c130e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1987,10 +1987,8 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
  */
 #define NR_KMEM_CACHE_CPU 100
 
-static DEFINE_PER_CPU(struct kmem_cache_cpu [NR_KMEM_CACHE_CPU],
-		      kmem_cache_cpu);
-
-static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
+DEFINE_PER_CPU(struct kmem_cache_cpu [NR_KMEM_CACHE_CPU], kmem_cache_cpu);
+DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
 static DECLARE_BITMAP(kmem_cach_cpu_free_init_once, CONFIG_NR_CPUS);
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
diff --git a/mm/swap.c b/mm/swap.c
index cb29ae5..c92109a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -36,8 +36,8 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
-static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
+DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
+DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 083716e..9e0ad21 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -678,7 +678,7 @@ struct vmap_block {
 };
 
 /* Queue of free and dirty vmap blocks, for allocation and flushing purposes */
-static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
+DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
  * Radix tree of vmap blocks, indexed by address, to quickly find a vmap block
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 74d66db..809c5c8 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -873,7 +873,7 @@ static const struct file_operations proc_vmstat_file_operations = {
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
-static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
+DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
 
 static void vmstat_update(struct work_struct *w)
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9fd0dc3..c2ae1ec 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -55,7 +55,7 @@ static struct genl_family net_drop_monitor_family = {
 	.maxattr        = NET_DM_CMD_MAX,
 };
 
-static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
+DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
 
 static int dm_hit_limit = 64;
 static int dm_delay = 1;
diff --git a/net/core/flow.c b/net/core/flow.c
index 9601587..4254804 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -39,7 +39,7 @@ atomic_t flow_cache_genid = ATOMIC_INIT(0);
 
 static u32 flow_hash_shift;
 #define flow_hash_size	(1 << flow_hash_shift)
-static DEFINE_PER_CPU(struct flow_cache_entry **, flow_tables) = { NULL };
+DEFINE_PER_CPU(struct flow_cache_entry **, flow_tables) = { NULL };
 
 #define flow_table(cpu) (per_cpu(flow_tables, cpu))
 
@@ -52,7 +52,7 @@ struct flow_percpu_info {
 	u32 hash_rnd;
 	int count;
 };
-static DEFINE_PER_CPU(struct flow_percpu_info, flow_hash_info) = { 0 };
+DEFINE_PER_CPU(struct flow_percpu_info, flow_hash_info) = { 0 };
 
 #define flow_hash_rnd_recalc(cpu) \
 	(per_cpu(flow_hash_info, cpu).hash_rnd_recalc)
@@ -69,7 +69,7 @@ struct flow_flush_info {
 	atomic_t cpuleft;
 	struct completion completion;
 };
-static DEFINE_PER_CPU(struct tasklet_struct, flow_flush_tasklets) = { NULL };
+DEFINE_PER_CPU(struct tasklet_struct, flow_flush_tasklets) = { NULL };
 
 #define flow_flush_tasklet(cpu) (&per_cpu(flow_flush_tasklets, cpu))
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 7dbf3ff..4ea4d1f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2049,7 +2049,7 @@ static __init int net_inuse_init(void)
 
 core_initcall(net_inuse_init);
 #else
-static DEFINE_PER_CPU(struct prot_inuse, prot_inuse);
+DEFINE_PER_CPU(struct prot_inuse, prot_inuse);
 
 void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
 {
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 28205e5..9bd897e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -253,7 +253,7 @@ static struct rt_hash_bucket 	*rt_hash_table __read_mostly;
 static unsigned			rt_hash_mask __read_mostly;
 static unsigned int		rt_hash_log  __read_mostly;
 
-static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
+DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
 #define RT_CACHE_STAT_INC(field) \
 	(__raw_get_cpu_var(rt_cache_stat).field++)
 
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index a3c045c..c72b127 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -37,8 +37,7 @@ __initcall(init_syncookies);
 #define COOKIEBITS 24	/* Upper bits store count */
 #define COOKIEMASK (((__u32)1 << COOKIEBITS) - 1)
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv4_cookie_scratch);
+DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS], ipv4_cookie_scratch);
 
 static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 		       u32 count, int c)
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e2bcff0..6043c63 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -74,8 +74,7 @@ static inline struct sock *get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	return child;
 }
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv6_cookie_scratch);
+DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS], ipv6_cookie_scratch);
 
 static u32 cookie_hash(struct in6_addr *saddr, struct in6_addr *daddr,
 		       __be16 sport, __be16 dport, u32 count, int c)
diff --git a/net/socket.c b/net/socket.c
index 791d71a..4249ae8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -153,7 +153,7 @@ static const struct net_proto_family *net_families[NPROTO] __read_mostly;
  *	Statistics counters of the socket lists
  */
 
-static DEFINE_PER_CPU(int, sockets_in_use) = 0;
+DEFINE_PER_CPU(int, sockets_in_use) = 0;
 
 /*
  * Support routines.
-- 
1.6.0.2

