Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYGOU0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYGOU0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYGOU0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:26:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42402 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244AbYGOUZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:25:59 -0400
Date: Tue, 15 Jul 2008 22:24:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] generic IPI tree for v2.6.27
Message-ID: <20080715202454.GA29745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 2.0
X-ELTE-SpamLevel: ss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=2.0 required=5.9 tests=URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: csd.info]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest generic-ipi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git generic-ipi-for-linus

This is a "guest topic" of -tip, pulled from Jens. It was mostly written 
by Jens but Jens is on vacation now so he has asked us to handle its 
integration via the -tip tree.

This tree adds generic IPI helpers and an optimized and generalized SMP 
co-routine implementation in kernel/smp.c.

We've been testing it for the past few weeks and it was offered to 
linux-next via -tip as well via the tip/generic-ipi-next branch so we 
are reasonably sure about its quality and will take the blame if it 
breaks anything ;-)

I've done a grep half an hour ago for newly arrived uses of the changed 
API in your latest tree, the last two commits fix up those instances.

Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      generic-ipi: fix s390 build bug

Ingo Molnar (7):
      fix "smp_call_function: get rid of the unused nonatomic/retry argument"
      fix: "smp_call_function: get rid of the unused nonatomic/retry argument"
      fix: "smp_call_function: get rid of the unused nonatomic/retry argument"
      x86, visws: fix generic-ipi build
      x86, visws: use mach-default/entry_arch.h
      generic-ipi: merge fix
      generic-ipi: more merge fallout

Jens Axboe (13):
      Add generic helpers for arch IPI function calls
      x86: convert to generic helpers for IPI function calls
      powerpc: convert to generic helpers for IPI function calls
      ia64: convert to generic helpers for IPI function calls
      alpha: convert to generic helpers for IPI function calls
      arm: convert to generic helpers for IPI function calls
      m32r: convert to generic helpers for IPI function calls
      mips: convert to generic helpers for IPI function calls
      parisc: convert to generic helpers for IPI function calls
      sh: convert to generic helpers for IPI function calls
      smp_call_function: get rid of the unused nonatomic/retry argument
      on_each_cpu(): kill unused 'retry' parameter
      generic-ipi: fixlet

Stephen Rothwell (1):
      generic-ipi: fix linux-next tree build failure


 arch/Kconfig                              |    3 +
 arch/alpha/Kconfig                        |    1 +
 arch/alpha/kernel/core_marvel.c           |    6 +-
 arch/alpha/kernel/process.c               |    2 +-
 arch/alpha/kernel/smp.c                   |  180 ++-------------
 arch/alpha/oprofile/common.c              |    6 +-
 arch/arm/Kconfig                          |    1 +
 arch/arm/kernel/smp.c                     |  163 ++-----------
 arch/arm/oprofile/op_model_mpcore.c       |    2 +-
 arch/arm/vfp/vfpmodule.c                  |    2 +-
 arch/cris/arch-v32/kernel/smp.c           |    5 +-
 arch/ia64/Kconfig                         |    1 +
 arch/ia64/kernel/mca.c                    |    6 +-
 arch/ia64/kernel/palinfo.c                |    2 +-
 arch/ia64/kernel/perfmon.c                |    6 +-
 arch/ia64/kernel/process.c                |    2 +-
 arch/ia64/kernel/smp.c                    |  254 ++------------------
 arch/ia64/kernel/smpboot.c                |    6 +-
 arch/ia64/kernel/uncached.c               |    5 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c       |    2 +-
 arch/m32r/Kconfig                         |    1 +
 arch/m32r/kernel/m32r_ksyms.c             |    3 -
 arch/m32r/kernel/smp.c                    |  132 ++---------
 arch/m32r/kernel/traps.c                  |    3 +-
 arch/mips/Kconfig                         |    1 +
 arch/mips/kernel/irq-rm9000.c             |    4 +-
 arch/mips/kernel/smp.c                    |  149 ++----------
 arch/mips/kernel/smtc.c                   |    1 -
 arch/mips/mm/c-r4k.c                      |   18 +-
 arch/mips/oprofile/common.c               |    6 +-
 arch/mips/oprofile/op_model_mipsxx.c      |    4 +-
 arch/mips/pmc-sierra/yosemite/prom.c      |    2 +-
 arch/mips/sibyte/cfe/setup.c              |    2 +-
 arch/mips/sibyte/sb1250/prom.c            |    2 +-
 arch/parisc/Kconfig                       |    1 +
 arch/parisc/kernel/cache.c                |    6 +-
 arch/parisc/kernel/smp.c                  |  136 ++---------
 arch/parisc/mm/init.c                     |    2 +-
 arch/powerpc/Kconfig                      |    1 +
 arch/powerpc/kernel/machine_kexec_64.c    |    2 +-
 arch/powerpc/kernel/rtas.c                |    2 +-
 arch/powerpc/kernel/smp.c                 |  234 ++----------------
 arch/powerpc/kernel/tau_6xx.c             |    4 +-
 arch/powerpc/kernel/time.c                |    2 +-
 arch/powerpc/mm/slice.c                   |    2 +-
 arch/powerpc/mm/tlb_64.c                  |    2 +-
 arch/powerpc/oprofile/common.c            |    6 +-
 arch/powerpc/platforms/cell/interrupt.c   |    1 +
 arch/powerpc/platforms/ps3/smp.c          |    7 +-
 arch/powerpc/platforms/pseries/xics.c     |    6 +-
 arch/powerpc/sysdev/mpic.c                |    2 +-
 arch/ppc/kernel/smp.c                     |    2 +-
 arch/s390/appldata/appldata_base.c        |    4 +-
 arch/s390/kernel/smp.c                    |   22 +-
 arch/s390/kernel/time.c                   |   10 +-
 arch/sh/Kconfig                           |    1 +
 arch/sh/kernel/smp.c                      |   62 ++----
 arch/sparc64/kernel/smp.c                 |   13 +-
 arch/sparc64/mm/hugetlbpage.c             |    2 +-
 arch/um/kernel/smp.c                      |    3 +-
 arch/x86/Kconfig                          |    1 +
 arch/x86/kernel/apic_32.c                 |    4 +
 arch/x86/kernel/cpu/mcheck/mce_64.c       |    6 +-
 arch/x86/kernel/cpu/mcheck/non-fatal.c    |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c           |    4 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c    |    4 +-
 arch/x86/kernel/cpuid.c                   |    2 +-
 arch/x86/kernel/entry_64.S                |    3 +
 arch/x86/kernel/io_apic_32.c              |    2 +-
 arch/x86/kernel/io_apic_64.c              |    2 +-
 arch/x86/kernel/irqinit_64.c              |    4 +
 arch/x86/kernel/ldt.c                     |    2 +-
 arch/x86/kernel/nmi.c                     |    6 +-
 arch/x86/kernel/process.c                 |    2 +-
 arch/x86/kernel/smp.c                     |  158 ++-----------
 arch/x86/kernel/smpboot.c                 |    4 +-
 arch/x86/kernel/smpcommon.c               |   56 -----
 arch/x86/kernel/tlb_32.c                  |    2 +-
 arch/x86/kernel/tlb_64.c                  |    2 +-
 arch/x86/kernel/vsyscall_64.c             |    4 +-
 arch/x86/kvm/vmx.c                        |    4 +-
 arch/x86/kvm/x86.c                        |    2 +-
 arch/x86/lib/msr-on-cpu.c                 |    8 +-
 arch/x86/mach-voyager/voyager_smp.c       |   98 ++------
 arch/x86/mm/pageattr.c                    |    4 +-
 arch/x86/oprofile/nmi_int.c               |   10 +-
 arch/x86/pci/amd_bus.c                    |    2 +-
 arch/x86/xen/enlighten.c                  |    4 +-
 arch/x86/xen/mmu.c                        |    2 +-
 arch/x86/xen/smp.c                        |  135 ++++-------
 arch/x86/xen/xen-ops.h                    |    9 +-
 drivers/acpi/processor_idle.c             |    2 +-
 drivers/char/agp/generic.c                |    2 +-
 drivers/char/sysrq.c                      |    2 +-
 drivers/cpuidle/cpuidle.c                 |    2 +-
 drivers/lguest/x86/core.c                 |    4 +-
 drivers/watchdog/booke_wdt.c              |    6 +-
 fs/buffer.c                               |    2 +-
 include/asm-alpha/smp.h                   |    5 +-
 include/asm-arm/smp.h                     |    3 +
 include/asm-ia64/smp.h                    |    8 +-
 include/asm-m32r/smp.h                    |    4 +
 include/asm-mips/smp.h                    |   13 +-
 include/asm-parisc/smp.h                  |    3 +
 include/asm-powerpc/smp.h                 |    8 +-
 include/asm-sh/smp.h                      |   14 +-
 include/asm-sparc/smp.h                   |    2 +-
 include/asm-x86/hw_irq.h                  |    1 +
 include/asm-x86/irq_vectors.h             |    6 +-
 include/asm-x86/mach-default/entry_arch.h |    1 +
 include/asm-x86/mach-visws/entry_arch.h   |   22 +--
 include/asm-x86/mach-voyager/entry_arch.h |    2 +-
 include/asm-x86/smp.h                     |   21 +-
 include/asm-x86/xen/events.h              |    1 +
 include/linux/smp.h                       |   46 +++-
 init/main.c                               |    2 +
 kernel/Makefile                           |    1 +
 kernel/hrtimer.c                          |    2 +-
 kernel/profile.c                          |    6 +-
 kernel/rcupdate.c                         |    2 +-
 kernel/smp.c                              |  381 +++++++++++++++++++++++++++++
 kernel/softirq.c                          |    4 +-
 kernel/time/tick-broadcast.c              |    2 +-
 mm/page_alloc.c                           |    2 +-
 mm/slab.c                                 |    4 +-
 mm/slub.c                                 |    2 +-
 net/core/flow.c                           |    2 +-
 net/iucv/iucv.c                           |   16 +-
 virt/kvm/kvm_main.c                       |   14 +-
 129 files changed, 890 insertions(+), 1796 deletions(-)
 create mode 100644 kernel/smp.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 3ea332b..ad89a33 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -39,3 +39,6 @@ config HAVE_KRETPROBES
 
 config HAVE_DMA_ATTRS
 	def_bool n
+
+config USE_GENERIC_SMP_HELPERS
+	def_bool n
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..dbe8c28 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -528,6 +528,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index b04f1fe..04dcc5e 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -660,9 +660,9 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 
 #ifdef CONFIG_SMP
 		if (smp_processor_id() != boot_cpuid)
-			smp_call_function_on_cpu(__marvel_access_rtc,
-						 &rtc_access, 1, 1,
-						 cpumask_of_cpu(boot_cpuid));
+			smp_call_function_single(boot_cpuid,
+						 __marvel_access_rtc,
+						 &rtc_access, 1);
 		else
 			__marvel_access_rtc(&rtc_access);
 #else
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 96ed82f..351407e 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -160,7 +160,7 @@ common_shutdown(int mode, char *restart_cmd)
 	struct halt_info args;
 	args.mode = mode;
 	args.restart_cmd = restart_cmd;
-	on_each_cpu(common_shutdown_1, &args, 1, 0);
+	on_each_cpu(common_shutdown_1, &args, 0);
 }
 
 void
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 2525692..83df541 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -62,6 +62,7 @@ static struct {
 enum ipi_message_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
@@ -558,51 +559,6 @@ send_ipi_message(cpumask_t to_whom, enum ipi_message_type operation)
 		wripir(i);
 }
 
-/* Structure and data for smp_call_function.  This is designed to 
-   minimize static memory requirements.  Plus it looks cleaner.  */
-
-struct smp_call_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t unstarted_count;
-	atomic_t unfinished_count;
-};
-
-static struct smp_call_struct *smp_call_function_data;
-
-/* Atomicly drop data into a shared pointer.  The pointer is free if
-   it is initially locked.  If retry, spin until free.  */
-
-static int
-pointer_lock (void *lock, void *data, int retry)
-{
-	void *old, *tmp;
-
-	mb();
- again:
-	/* Compare and swap with zero.  */
-	asm volatile (
-	"1:	ldq_l	%0,%1\n"
-	"	mov	%3,%2\n"
-	"	bne	%0,2f\n"
-	"	stq_c	%2,%1\n"
-	"	beq	%2,1b\n"
-	"2:"
-	: "=&r"(old), "=m"(*(void **)lock), "=&r"(tmp)
-	: "r"(data)
-	: "memory");
-
-	if (old == 0)
-		return 0;
-	if (! retry)
-		return -EBUSY;
-
-	while (*(void **)lock)
-		barrier();
-	goto again;
-}
-
 void
 handle_ipi(struct pt_regs *regs)
 {
@@ -632,31 +588,12 @@ handle_ipi(struct pt_regs *regs)
 			break;
 
 		case IPI_CALL_FUNC:
-		    {
-			struct smp_call_struct *data;
-			void (*func)(void *info);
-			void *info;
-			int wait;
-
-			data = smp_call_function_data;
-			func = data->func;
-			info = data->info;
-			wait = data->wait;
-
-			/* Notify the sending CPU that the data has been
-			   received, and execution is about to begin.  */
-			mb();
-			atomic_dec (&data->unstarted_count);
-
-			/* At this point the structure may be gone unless
-			   wait is true.  */
-			(*func)(info);
-
-			/* Notify the sending CPU that the task is done.  */
-			mb();
-			if (wait) atomic_dec (&data->unfinished_count);
+			generic_smp_call_function_interrupt();
+			break;
+
+		case IPI_CALL_FUNC_SINGLE:
+			generic_smp_call_function_single_interrupt();
 			break;
-		    }
 
 		case IPI_CPU_STOP:
 			halt();
@@ -700,102 +637,15 @@ smp_send_stop(void)
 	send_ipi_message(to_whom, IPI_CPU_STOP);
 }
 
-/*
- * Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <retry>	If true, keep retrying until ready.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or are or have executed.
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-
-int
-smp_call_function_on_cpu (void (*func) (void *info), void *info, int retry,
-			  int wait, cpumask_t to_whom)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct smp_call_struct data;
-	unsigned long timeout;
-	int num_cpus_to_call;
-	
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-
-	cpu_clear(smp_processor_id(), to_whom);
-	num_cpus_to_call = cpus_weight(to_whom);
-
-	atomic_set(&data.unstarted_count, num_cpus_to_call);
-	atomic_set(&data.unfinished_count, num_cpus_to_call);
-
-	/* Acquire the smp_call_function_data mutex.  */
-	if (pointer_lock(&smp_call_function_data, &data, retry))
-		return -EBUSY;
-
-	/* Send a message to the requested CPUs.  */
-	send_ipi_message(to_whom, IPI_CALL_FUNC);
-
-	/* Wait for a minimal response.  */
-	timeout = jiffies + HZ;
-	while (atomic_read (&data.unstarted_count) > 0
-	       && time_before (jiffies, timeout))
-		barrier();
-
-	/* If there's no response yet, log a message but allow a longer
-	 * timeout period -- if we get a response this time, log
-	 * a message saying when we got it.. 
-	 */
-	if (atomic_read(&data.unstarted_count) > 0) {
-		long start_time = jiffies;
-		printk(KERN_ERR "%s: initial timeout -- trying long wait\n",
-		       __func__);
-		timeout = jiffies + 30 * HZ;
-		while (atomic_read(&data.unstarted_count) > 0
-		       && time_before(jiffies, timeout))
-			barrier();
-		if (atomic_read(&data.unstarted_count) <= 0) {
-			long delta = jiffies - start_time;
-			printk(KERN_ERR 
-			       "%s: response %ld.%ld seconds into long wait\n",
-			       __func__, delta / HZ,
-			       (100 * (delta - ((delta / HZ) * HZ))) / HZ);
-		}
-	}
-
-	/* We either got one or timed out -- clear the lock. */
-	mb();
-	smp_call_function_data = NULL;
-
-	/* 
-	 * If after both the initial and long timeout periods we still don't
-	 * have a response, something is very wrong...
-	 */
-	BUG_ON(atomic_read (&data.unstarted_count) > 0);
-
-	/* Wait for a complete response, if needed.  */
-	if (wait) {
-		while (atomic_read (&data.unfinished_count) > 0)
-			barrier();
-	}
-
-	return 0;
+	send_ipi_message(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL(smp_call_function_on_cpu);
 
-int
-smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_on_cpu (func, info, retry, wait,
-					 cpu_online_map);
+	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function);
 
 static void
 ipi_imb(void *ignored)
@@ -807,7 +657,7 @@ void
 smp_imb(void)
 {
 	/* Must wait other processors to flush their icache before continue. */
-	if (on_each_cpu(ipi_imb, NULL, 1, 1))
+	if (on_each_cpu(ipi_imb, NULL, 1))
 		printk(KERN_CRIT "smp_imb: timed out\n");
 }
 EXPORT_SYMBOL(smp_imb);
@@ -823,7 +673,7 @@ flush_tlb_all(void)
 {
 	/* Although we don't have any data to pass, we do want to
 	   synchronize with the other processors.  */
-	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1)) {
+	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1)) {
 		printk(KERN_CRIT "flush_tlb_all: timed out\n");
 	}
 }
@@ -860,7 +710,7 @@ flush_tlb_mm(struct mm_struct *mm)
 		}
 	}
 
-	if (smp_call_function(ipi_flush_tlb_mm, mm, 1, 1)) {
+	if (smp_call_function(ipi_flush_tlb_mm, mm, 1)) {
 		printk(KERN_CRIT "flush_tlb_mm: timed out\n");
 	}
 
@@ -913,7 +763,7 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	data.mm = mm;
 	data.addr = addr;
 
-	if (smp_call_function(ipi_flush_tlb_page, &data, 1, 1)) {
+	if (smp_call_function(ipi_flush_tlb_page, &data, 1)) {
 		printk(KERN_CRIT "flush_tlb_page: timed out\n");
 	}
 
@@ -965,7 +815,7 @@ flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 		}
 	}
 
-	if (smp_call_function(ipi_flush_icache_page, mm, 1, 1)) {
+	if (smp_call_function(ipi_flush_icache_page, mm, 1)) {
 		printk(KERN_CRIT "flush_icache_page: timed out\n");
 	}
 
diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index 9fc0eeb..7c3d5ec 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -65,7 +65,7 @@ op_axp_setup(void)
 	model->reg_setup(&reg, ctr, &sys);
 
 	/* Configure the registers on all cpus.  */
-	(void)smp_call_function(model->cpu_setup, &reg, 0, 1);
+	(void)smp_call_function(model->cpu_setup, &reg, 1);
 	model->cpu_setup(&reg);
 	return 0;
 }
@@ -86,7 +86,7 @@ op_axp_cpu_start(void *dummy)
 static int
 op_axp_start(void)
 {
-	(void)smp_call_function(op_axp_cpu_start, NULL, 0, 1);
+	(void)smp_call_function(op_axp_cpu_start, NULL, 1);
 	op_axp_cpu_start(NULL);
 	return 0;
 }
@@ -101,7 +101,7 @@ op_axp_cpu_stop(void *dummy)
 static void
 op_axp_stop(void)
 {
-	(void)smp_call_function(op_axp_cpu_stop, NULL, 0, 1);
+	(void)smp_call_function(op_axp_cpu_stop, NULL, 1);
 	op_axp_cpu_stop(NULL);
 }
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 258f136..c7ad324 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -701,6 +701,7 @@ source "kernel/time/Kconfig"
 config SMP
 	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP)
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index eefae1d..5a7c095 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -68,20 +68,10 @@ enum ipi_msg_type {
 	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
-struct smp_call_struct {
-	void (*func)(void *info);
-	void *info;
-	int wait;
-	cpumask_t pending;
-	cpumask_t unfinished;
-};
-
-static struct smp_call_struct * volatile smp_call_function_data;
-static DEFINE_SPINLOCK(smp_call_function_lock);
-
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
@@ -366,114 +356,15 @@ static void send_ipi_message(cpumask_t callmap, enum ipi_msg_type msg)
 	local_irq_restore(flags);
 }
 
-/*
- * You must not call this function with disabled interrupts, from a
- * hardware interrupt handler, nor from a bottom half handler.
- */
-static int smp_call_function_on_cpu(void (*func)(void *info), void *info,
-				    int retry, int wait, cpumask_t callmap)
-{
-	struct smp_call_struct data;
-	unsigned long timeout;
-	int ret = 0;
-
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-
-	cpu_clear(smp_processor_id(), callmap);
-	if (cpus_empty(callmap))
-		goto out;
-
-	data.pending = callmap;
-	if (wait)
-		data.unfinished = callmap;
-
-	/*
-	 * try to get the mutex on smp_call_function_data
-	 */
-	spin_lock(&smp_call_function_lock);
-	smp_call_function_data = &data;
-
-	send_ipi_message(callmap, IPI_CALL_FUNC);
-
-	timeout = jiffies + HZ;
-	while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
-		barrier();
-
-	/*
-	 * did we time out?
-	 */
-	if (!cpus_empty(data.pending)) {
-		/*
-		 * this may be causing our panic - report it
-		 */
-		printk(KERN_CRIT
-		       "CPU%u: smp_call_function timeout for %p(%p)\n"
-		       "      callmap %lx pending %lx, %swait\n",
-		       smp_processor_id(), func, info, *cpus_addr(callmap),
-		       *cpus_addr(data.pending), wait ? "" : "no ");
-
-		/*
-		 * TRACE
-		 */
-		timeout = jiffies + (5 * HZ);
-		while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
-			barrier();
-
-		if (cpus_empty(data.pending))
-			printk(KERN_CRIT "     RESOLVED\n");
-		else
-			printk(KERN_CRIT "     STILL STUCK\n");
-	}
-
-	/*
-	 * whatever happened, we're done with the data, so release it
-	 */
-	smp_call_function_data = NULL;
-	spin_unlock(&smp_call_function_lock);
-
-	if (!cpus_empty(data.pending)) {
-		ret = -ETIMEDOUT;
-		goto out;
-	}
-
-	if (wait)
-		while (!cpus_empty(data.unfinished))
-			barrier();
- out:
-
-	return 0;
-}
-
-int smp_call_function(void (*func)(void *info), void *info, int retry,
-                      int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	return smp_call_function_on_cpu(func, info, retry, wait,
-					cpu_online_map);
+	send_ipi_message(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL_GPL(smp_call_function);
 
-int smp_call_function_single(int cpu, void (*func)(void *info), void *info,
-			     int retry, int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	/* prevent preemption and reschedule on another processor */
-	int current_cpu = get_cpu();
-	int ret = 0;
-
-	if (cpu == current_cpu) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	} else
-		ret = smp_call_function_on_cpu(func, info, retry, wait,
-					       cpumask_of_cpu(cpu));
-
-	put_cpu();
-
-	return ret;
+	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL_GPL(smp_call_function_single);
 
 void show_ipi_list(struct seq_file *p)
 {
@@ -521,27 +412,6 @@ asmlinkage void __exception do_local_timer(struct pt_regs *regs)
 }
 #endif
 
-/*
- * ipi_call_function - handle IPI from smp_call_function()
- *
- * Note that we copy data out of the cross-call structure and then
- * let the caller know that we're here and have done with their data
- */
-static void ipi_call_function(unsigned int cpu)
-{
-	struct smp_call_struct *data = smp_call_function_data;
-	void (*func)(void *info) = data->func;
-	void *info = data->info;
-	int wait = data->wait;
-
-	cpu_clear(cpu, data->pending);
-
-	func(info);
-
-	if (wait)
-		cpu_clear(cpu, data->unfinished);
-}
-
 static DEFINE_SPINLOCK(stop_lock);
 
 /*
@@ -611,7 +481,11 @@ asmlinkage void __exception do_IPI(struct pt_regs *regs)
 				break;
 
 			case IPI_CALL_FUNC:
-				ipi_call_function(cpu);
+				generic_smp_call_function_interrupt();
+				break;
+
+			case IPI_CALL_FUNC_SINGLE:
+				generic_smp_call_function_single_interrupt();
 				break;
 
 			case IPI_CPU_STOP:
@@ -662,14 +536,13 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 static int
-on_each_cpu_mask(void (*func)(void *), void *info, int retry, int wait,
-		 cpumask_t mask)
+on_each_cpu_mask(void (*func)(void *), void *info, int wait, cpumask_t mask)
 {
 	int ret = 0;
 
 	preempt_disable();
 
-	ret = smp_call_function_on_cpu(func, info, retry, wait, mask);
+	ret = smp_call_function_mask(mask, func, info, wait);
 	if (cpu_isset(smp_processor_id(), mask))
 		func(info);
 
@@ -731,14 +604,14 @@ static inline void ipi_flush_tlb_kernel_range(void *arg)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(ipi_flush_tlb_all, NULL, 1);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
 	cpumask_t mask = mm->cpu_vm_mask;
 
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
@@ -749,7 +622,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -758,7 +631,7 @@ void flush_tlb_kernel_page(unsigned long kaddr)
 
 	ta.ta_start = kaddr;
 
-	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1, 1);
+	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma,
@@ -771,7 +644,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
@@ -781,5 +654,5 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1, 1);
+	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1);
 }
diff --git a/arch/arm/oprofile/op_model_mpcore.c b/arch/arm/oprofile/op_model_mpcore.c
index 74fae60..4458705 100644
--- a/arch/arm/oprofile/op_model_mpcore.c
+++ b/arch/arm/oprofile/op_model_mpcore.c
@@ -201,7 +201,7 @@ static int em_call_function(int (*fn)(void))
 	data.ret = 0;
 
 	preempt_disable();
-	smp_call_function(em_func, &data, 1, 1);
+	smp_call_function(em_func, &data, 1);
 	em_func(&data);
 	preempt_enable();
 
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 32455c6..c0d2c9b 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -352,7 +352,7 @@ static int __init vfp_init(void)
 	else if (vfpsid & FPSID_NODOUBLE) {
 		printk("no double precision support\n");
 	} else {
-		smp_call_function(vfp_enable, NULL, 1, 1);
+		smp_call_function(vfp_enable, NULL, 1);
 
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
 		printk("implementor %02x architecture %d part %02x variant %x rev %x\n",
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index a9c3334..952a24b 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -194,7 +194,7 @@ void stop_this_cpu(void* dummy)
 /* Other calls */
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 int setup_profiling_timer(unsigned int multiplier)
@@ -316,8 +316,7 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function(void (*func)(void *info), void *info,
-		      int nonatomic, int wait)
+int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
 	cpumask_t cpu_mask = CPU_MASK_ALL;
 	struct call_data_struct data;
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 16be414..18bcc10 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -303,6 +303,7 @@ config VIRT_CPU_ACCOUNTING
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N.  If you have a system with more
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 705176b..7dd96c1 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -707,7 +707,7 @@ ia64_mca_cmc_vector_enable (void *dummy)
 static void
 ia64_mca_cmc_vector_disable_keventd(struct work_struct *unused)
 {
-	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 1, 0);
+	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 0);
 }
 
 /*
@@ -719,7 +719,7 @@ ia64_mca_cmc_vector_disable_keventd(struct work_struct *unused)
 static void
 ia64_mca_cmc_vector_enable_keventd(struct work_struct *unused)
 {
-	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 1, 0);
+	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 0);
 }
 
 /*
@@ -1881,7 +1881,7 @@ static int __cpuinit mca_cpu_callback(struct notifier_block *nfb,
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		smp_call_function_single(hotcpu, ia64_mca_cmc_vector_adjust,
-					 NULL, 1, 0);
+					 NULL, 0);
 		break;
 	}
 	return NOTIFY_OK;
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 9dc00f7..e5c57f4 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -921,7 +921,7 @@ int palinfo_handle_smp(pal_func_cpu_u_t *f, char *page)
 
 
 	/* will send IPI to other CPU and wait for completion of remote call */
-	if ((ret=smp_call_function_single(f->req_cpu, palinfo_smp_call, &ptr, 0, 1))) {
+	if ((ret=smp_call_function_single(f->req_cpu, palinfo_smp_call, &ptr, 1))) {
 		printk(KERN_ERR "palinfo: remote CPU call from %d to %d on function %d: "
 		       "error %d\n", smp_processor_id(), f->req_cpu, f->func_id, ret);
 		return 0;
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 7714a97..19d4493 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1820,7 +1820,7 @@ pfm_syswide_cleanup_other_cpu(pfm_context_t *ctx)
 	int ret;
 
 	DPRINT(("calling CPU%d for cleanup\n", ctx->ctx_cpu));
-	ret = smp_call_function_single(ctx->ctx_cpu, pfm_syswide_force_stop, ctx, 0, 1);
+	ret = smp_call_function_single(ctx->ctx_cpu, pfm_syswide_force_stop, ctx, 1);
 	DPRINT(("called CPU%d for cleanup ret=%d\n", ctx->ctx_cpu, ret));
 }
 #endif /* CONFIG_SMP */
@@ -6508,7 +6508,7 @@ pfm_install_alt_pmu_interrupt(pfm_intr_handler_desc_t *hdl)
 	}
 
 	/* save the current system wide pmu states */
-	ret = on_each_cpu(pfm_alt_save_pmu_state, NULL, 0, 1);
+	ret = on_each_cpu(pfm_alt_save_pmu_state, NULL, 1);
 	if (ret) {
 		DPRINT(("on_each_cpu() failed: %d\n", ret));
 		goto cleanup_reserve;
@@ -6553,7 +6553,7 @@ pfm_remove_alt_pmu_interrupt(pfm_intr_handler_desc_t *hdl)
 
 	pfm_alt_intr_handler = NULL;
 
-	ret = on_each_cpu(pfm_alt_restore_pmu_state, NULL, 0, 1);
+	ret = on_each_cpu(pfm_alt_restore_pmu_state, NULL, 1);
 	if (ret) {
 		DPRINT(("on_each_cpu() failed: %d\n", ret));
 	}
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index a3a34b4..fabaf08 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -286,7 +286,7 @@ void cpu_idle_wait(void)
 {
 	smp_mb();
 	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 0, 1);
+	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 983296f..3676468 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -60,25 +60,9 @@ static struct local_tlb_flush_counts {
 
 static DEFINE_PER_CPU(unsigned int, shadow_flush_counts[NR_CPUS]) ____cacheline_aligned;
 
-
-/*
- * Structure and data for smp_call_function(). This is designed to minimise static memory
- * requirements. It also looks cleaner.
- */
-static  __cacheline_aligned DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t started;
-	atomic_t finished;
-};
-
-static volatile struct call_data_struct *call_data;
-
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
+#define IPI_CALL_FUNC_SINGLE	2
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
@@ -86,43 +70,6 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
-void
-lock_ipi_calllock(void)
-{
-	spin_lock_irq(&call_lock);
-}
-
-void
-unlock_ipi_calllock(void)
-{
-	spin_unlock_irq(&call_lock);
-}
-
-static inline void
-handle_call_data(void)
-{
-	struct call_data_struct *data;
-	void (*func)(void *info);
-	void *info;
-	int wait;
-
-	/* release the 'pointer lock' */
-	data = (struct call_data_struct *)call_data;
-	func = data->func;
-	info = data->info;
-	wait = data->wait;
-
-	mb();
-	atomic_inc(&data->started);
-	/* At this point the structure may be gone unless wait is true. */
-	(*func)(info);
-
-	/* Notify the sending CPU that the task is done. */
-	mb();
-	if (wait)
-		atomic_inc(&data->finished);
-}
-
 static void
 stop_this_cpu(void)
 {
@@ -163,13 +110,15 @@ handle_IPI (int irq, void *dev_id)
 			ops &= ~(1 << which);
 
 			switch (which) {
-			case IPI_CALL_FUNC:
-				handle_call_data();
-				break;
-
 			case IPI_CPU_STOP:
 				stop_this_cpu();
 				break;
+			case IPI_CALL_FUNC:
+				generic_smp_call_function_interrupt();
+				break;
+			case IPI_CALL_FUNC_SINGLE:
+				generic_smp_call_function_single_interrupt();
+				break;
 #ifdef CONFIG_KEXEC
 			case IPI_KDUMP_CPU_STOP:
 				unw_init_running(kdump_cpu_freeze, NULL);
@@ -187,6 +136,8 @@ handle_IPI (int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+
+
 /*
  * Called with preemption disabled.
  */
@@ -334,7 +285,7 @@ smp_flush_tlb_cpumask(cpumask_t xcpumask)
 void
 smp_flush_tlb_all (void)
 {
-	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1);
 }
 
 void
@@ -357,193 +308,18 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 	 * anyhow, and once a CPU is interrupted, the cost of local_flush_tlb_all() is
 	 * rather trivial.
 	 */
-	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
+	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1);
 }
 
-/*
- * Run a function on a specific CPU
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <nonatomic>	Currently unused.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int
-smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
-			  int wait)
-{
-	struct call_data_struct data;
-	int cpus = 1;
-	int me = get_cpu(); /* prevent preemption and reschedule on another processor */
-
-	if (cpuid == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock_bh(&call_lock);
-
-	call_data = &data;
-	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
-  	send_IPI_single(cpuid, IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock_bh(&call_lock);
-	put_cpu();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * <mask>	The set of cpus to run on.  Must not include the current cpu.
- * <func> 	The function to run. This must be fast and non-blocking.
- * <info>	An arbitrary pointer to pass to the function.
- * <wait>	If true, wait (atomically) until function
- *		has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function_mask(cpumask_t mask,
-			   void (*func)(void *), void *info,
-			   int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	struct call_data_struct data;
-	cpumask_t allbutself;
-	int cpus;
-
-	spin_lock(&call_lock);
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
-
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb(); /* ensure store to call_data precedes setting of IPI_CALL_FUNC*/
-
-	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
-		send_IPI_allbutself(IPI_CALL_FUNC);
-	else
-		send_IPI_mask(mask, IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock(&call_lock);
-	return 0;
-
+	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
-/*
- * this function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- */
-
-/*
- *  [SUMMARY]	Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <nonatomic>	currently unused.
- *  <wait>	If true, wait (atomically) until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func> or are or have
- * executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int
-smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpus;
-
-	spin_lock(&call_lock);
-	cpus = num_online_cpus() - 1;
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
-	send_IPI_allbutself(IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock(&call_lock);
-	return 0;
+	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL(smp_call_function);
 
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index d7ad42b..9d1d429 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -317,7 +317,7 @@ ia64_sync_itc (unsigned int master)
 
 	go[MASTER] = 1;
 
-	if (smp_call_function_single(master, sync_master, NULL, 1, 0) < 0) {
+	if (smp_call_function_single(master, sync_master, NULL, 0) < 0) {
 		printk(KERN_ERR "sync_itc: failed to get attention of CPU %u!\n", master);
 		return;
 	}
@@ -395,14 +395,14 @@ smp_callin (void)
 
 	fix_b0_for_bsp();
 
-	lock_ipi_calllock();
+	ipi_call_lock_irq();
 	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	cpu_set(cpuid, cpu_online_map);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
-	unlock_ipi_calllock();
+	ipi_call_unlock_irq();
 
 	smp_setup_percpu_timer();
 
diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index e77995a..8eff8c1 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -123,8 +123,7 @@ static int uncached_add_chunk(struct uncached_pool *uc_pool, int nid)
 	status = ia64_pal_prefetch_visibility(PAL_VISIBILITY_PHYSICAL);
 	if (status == PAL_VISIBILITY_OK_REMOTE_NEEDED) {
 		atomic_set(&uc_pool->status, 0);
-		status = smp_call_function(uncached_ipi_visibility, uc_pool,
-					   0, 1);
+		status = smp_call_function(uncached_ipi_visibility, uc_pool, 1);
 		if (status || atomic_read(&uc_pool->status))
 			goto failed;
 	} else if (status != PAL_VISIBILITY_OK)
@@ -146,7 +145,7 @@ static int uncached_add_chunk(struct uncached_pool *uc_pool, int nid)
 	if (status != PAL_STATUS_SUCCESS)
 		goto failed;
 	atomic_set(&uc_pool->status, 0);
-	status = smp_call_function(uncached_ipi_mc_drain, uc_pool, 0, 1);
+	status = smp_call_function(uncached_ipi_mc_drain, uc_pool, 1);
 	if (status || atomic_read(&uc_pool->status))
 		goto failed;
 
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 8cc0c47..636588e 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -629,7 +629,7 @@ static int sn_hwperf_op_cpu(struct sn_hwperf_op_info *op_info)
 		if (use_ipi) {
 			/* use an interprocessor interrupt to call SAL */
 			smp_call_function_single(cpu, sn_hwperf_call_sal,
-				op_info, 1, 1);
+				op_info, 1);
 		}
 		else {
 			/* migrate the task before calling SAL */ 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index de153de..a5f864c 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -296,6 +296,7 @@ config PREEMPT
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/m32r/kernel/m32r_ksyms.c b/arch/m32r/kernel/m32r_ksyms.c
index e6709fe..16bcb18 100644
--- a/arch/m32r/kernel/m32r_ksyms.c
+++ b/arch/m32r/kernel/m32r_ksyms.c
@@ -43,9 +43,6 @@ EXPORT_SYMBOL(dcache_dummy);
 #endif
 EXPORT_SYMBOL(cpu_data);
 
-/* Global SMP stuff */
-EXPORT_SYMBOL(smp_call_function);
-
 /* TLB flushing */
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index c837bc1..7577f97 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -35,22 +35,6 @@
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-} __attribute__ ((__aligned__(SMP_CACHE_BYTES)));
-
-static struct call_data_struct *call_data;
-
-/*
  * For flush_cache_all()
  */
 static DEFINE_SPINLOCK(flushcache_lock);
@@ -96,9 +80,6 @@ void smp_invalidate_interrupt(void);
 void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
-int smp_call_function(void (*) (void *), void *, int, int);
-void smp_call_function_interrupt(void);
-
 void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
@@ -231,7 +212,7 @@ void smp_flush_tlb_all(void)
 	local_irq_save(flags);
 	__flush_tlb_all();
 	local_irq_restore(flags);
-	smp_call_function(flush_tlb_all_ipi, NULL, 1, 1);
+	smp_call_function(flush_tlb_all_ipi, NULL, 1);
 	preempt_enable();
 }
 
@@ -524,7 +505,7 @@ void smp_invalidate_interrupt(void)
  *==========================================================================*/
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 /*==========================================================================*
@@ -565,86 +546,14 @@ static void stop_this_cpu(void *dummy)
 	for ( ; ; );
 }
 
-/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Call function Routines                                                    */
-/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-
-/*==========================================================================*
- * Name:         smp_call_function
- *
- * Description:  This routine sends a 'CALL_FUNCTION_IPI' to all other CPUs
- *               in the system.
- *
- * Born on Date: 2002.02.05
- *
- * Arguments:    *func - The function to run. This must be fast and
- *                       non-blocking.
- *               *info - An arbitrary pointer to pass to the function.
- *               nonatomic - currently unused.
- *               wait - If true, wait (atomically) until function has
- *                      completed on other CPUs.
- *
- * Returns:      0 on success, else a negative status code. Does not return
- *               until remote CPUs are nearly ready to execute <<func>> or
- *               are or have executed.
- *
- * Cautions:     You must not call this function with disabled interrupts or
- *               from a hardware interrupt handler, you may call it from a
- *               bottom half handler.
- *
- * Modification log:
- * Date       Who Description
- * ---------- --- --------------------------------------------------------
- *
- *==========================================================================*/
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-	int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpus;
-
-#ifdef DEBUG_SMP
-	unsigned long flags;
-	__save_flags(flags);
-	if (!(flags & 0x0040))	/* Interrupt Disable NONONO */
-		BUG();
-#endif /* DEBUG_SMP */
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-	cpus = num_online_cpus() - 1;
-
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();
-
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_IPI, 0);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			barrier();
-	spin_unlock(&call_lock);
+	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
+}
 
-	return 0;
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNC_SINGLE_IPI, 0);
 }
 
 /*==========================================================================*
@@ -666,27 +575,16 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
  *==========================================================================*/
 void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_interrupt();
 	irq_exit();
+}
 
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
+void smp_call_function_single_interrupt(void)
+{
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	irq_exit();
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index 89ba4a0..46159a4 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -40,6 +40,7 @@ extern void smp_invalidate_interrupt(void);
 extern void smp_call_function_interrupt(void);
 extern void smp_ipi_timer_interrupt(void);
 extern void smp_flush_cache_all_interrupt(void);
+extern void smp_call_function_single_interrupt(void);
 
 /*
  * for Boot AP function
@@ -103,7 +104,7 @@ void	set_eit_vector_entries(void)
 	eit_vector[186] = (unsigned long)smp_call_function_interrupt;
 	eit_vector[187] = (unsigned long)smp_ipi_timer_interrupt;
 	eit_vector[188] = (unsigned long)smp_flush_cache_all_interrupt;
-	eit_vector[189] = 0;
+	eit_vector[189] = (unsigned long)smp_call_function_single_interrupt;
 	eit_vector[190] = 0;
 	eit_vector[191] = 0;
 #endif
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 24c5dee..d2be3ff 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1763,6 +1763,7 @@ config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
 	select IRQ_PER_CPU
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/mips/kernel/irq-rm9000.c b/arch/mips/kernel/irq-rm9000.c
index ed9febe..b47e461 100644
--- a/arch/mips/kernel/irq-rm9000.c
+++ b/arch/mips/kernel/irq-rm9000.c
@@ -49,7 +49,7 @@ static void local_rm9k_perfcounter_irq_startup(void *args)
 
 static unsigned int rm9k_perfcounter_irq_startup(unsigned int irq)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 0, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 1);
 
 	return 0;
 }
@@ -66,7 +66,7 @@ static void local_rm9k_perfcounter_irq_shutdown(void *args)
 
 static void rm9k_perfcounter_irq_shutdown(unsigned int irq)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 0, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 1);
 }
 
 static struct irq_chip rm9k_irq_controller = {
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index cdf87a9..4410f17 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -131,148 +131,29 @@ asmlinkage __cpuinit void start_secondary(void)
 	cpu_idle();
 }
 
-DEFINE_SPINLOCK(smp_call_lock);
-
-struct call_data_struct *call_data;
-
-/*
- * Run a function on all other CPUs.
- *
- *  <mask>	cpuset_t of all processors to run the function on.
- *  <func>      The function to run. This must be fast and non-blocking.
- *  <info>      An arbitrary pointer to pass to the function.
- *  <retry>     If true, keep retrying until ready.
- *  <wait>      If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler:
- *
- * CPU A                               CPU B
- * Disable interrupts
- *                                     smp_call_function()
- *                                     Take call_lock
- *                                     Send IPIs
- *                                     Wait for all cpus to acknowledge IPI
- *                                     CPU A has not responded, spin waiting
- *                                     for cpu A to respond, holding call_lock
- * smp_call_function()
- * Spin waiting for call_lock
- * Deadlock                            Deadlock
- */
-int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
-	void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpu = smp_processor_id();
-	int cpus;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	BUG_ON(!cpu_online(cpu));
-
-	cpu_clear(cpu, mask);
-	cpus = cpus_weight(mask);
-	if (!cpus)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock(&smp_call_lock);
-	call_data = &data;
-	smp_mb();
-
-	/* Send a message to all other CPUs and wait for them to respond */
 	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
-
-	/* Wait for response */
-	/* FIXME: lock-up detection, backtrace on lock-up */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			barrier();
-	call_data = NULL;
-	spin_unlock(&smp_call_lock);
-
-	return 0;
 }
 
-int smp_call_function(void (*func) (void *info), void *info, int retry,
-	int wait)
+/*
+ * We reuse the same vector for the single IPI
+ */
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_mask(cpu_online_map, func, info, retry, wait);
+	mp_ops->send_ipi_mask(cpumask_of_cpu(cpu), SMP_CALL_FUNCTION);
 }
-EXPORT_SYMBOL(smp_call_function);
 
+/*
+ * Call into both interrupt handlers, as we share the IPI for them
+ */
 void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function.
-	 */
-	smp_mb();
-	atomic_inc(&call_data->started);
-
-	/*
-	 * At this point the info structure may be out of scope unless wait==1.
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_single_interrupt();
+	generic_smp_call_function_interrupt();
 	irq_exit();
-
-	if (wait) {
-		smp_mb();
-		atomic_inc(&call_data->finished);
-	}
-}
-
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int retry, int wait)
-{
-	int ret, me;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	if (!cpu_online(cpu))
-		return 0;
-
-	me = get_cpu();
-	BUG_ON(!cpu_online(me));
-
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, retry,
-				     wait);
-
-	put_cpu();
-	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_single);
 
 static void stop_this_cpu(void *dummy)
 {
@@ -286,7 +167,7 @@ static void stop_this_cpu(void *dummy)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
@@ -365,7 +246,7 @@ static void flush_tlb_all_ipi(void *info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(flush_tlb_all_ipi, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_ipi, NULL, 1);
 }
 
 static void flush_tlb_mm_ipi(void *mm)
@@ -385,7 +266,7 @@ static void flush_tlb_mm_ipi(void *mm)
 static inline void smp_on_other_tlbs(void (*func) (void *info), void *info)
 {
 #ifndef CONFIG_MIPS_MT_SMTC
-	smp_call_function(func, info, 1, 1);
+	smp_call_function(func, info, 1);
 #endif
 }
 
@@ -485,7 +366,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 		.addr2 = end,
 	};
 
-	on_each_cpu(flush_tlb_kernel_range_ipi, &fd, 1, 1);
+	on_each_cpu(flush_tlb_kernel_range_ipi, &fd, 1);
 }
 
 static void flush_tlb_page_ipi(void *info)
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 3e86318..a516286 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -877,7 +877,6 @@ static void ipi_resched_interrupt(void)
 	/* Return from interrupt should be enough to cause scheduler check */
 }
 
-
 static void ipi_call_interrupt(void)
 {
 	/* Invoke generic function invocation code in smp.c */
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 2709675..71df339 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -43,12 +43,12 @@
  *    primary cache.
  */
 static inline void r4k_on_each_cpu(void (*func) (void *info), void *info,
-                                   int retry, int wait)
+                                   int wait)
 {
 	preempt_disable();
 
 #if !defined(CONFIG_MIPS_MT_SMP) && !defined(CONFIG_MIPS_MT_SMTC)
-	smp_call_function(func, info, retry, wait);
+	smp_call_function(func, info, wait);
 #endif
 	func(info);
 	preempt_enable();
@@ -350,7 +350,7 @@ static inline void local_r4k___flush_cache_all(void * args)
 
 static void r4k___flush_cache_all(void)
 {
-	r4k_on_each_cpu(local_r4k___flush_cache_all, NULL, 1, 1);
+	r4k_on_each_cpu(local_r4k___flush_cache_all, NULL, 1);
 }
 
 static inline int has_valid_asid(const struct mm_struct *mm)
@@ -397,7 +397,7 @@ static void r4k_flush_cache_range(struct vm_area_struct *vma,
 	int exec = vma->vm_flags & VM_EXEC;
 
 	if (cpu_has_dc_aliases || (exec && !cpu_has_ic_fills_f_dc))
-		r4k_on_each_cpu(local_r4k_flush_cache_range, vma, 1, 1);
+		r4k_on_each_cpu(local_r4k_flush_cache_range, vma, 1);
 }
 
 static inline void local_r4k_flush_cache_mm(void * args)
@@ -429,7 +429,7 @@ static void r4k_flush_cache_mm(struct mm_struct *mm)
 	if (!cpu_has_dc_aliases)
 		return;
 
-	r4k_on_each_cpu(local_r4k_flush_cache_mm, mm, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_mm, mm, 1);
 }
 
 struct flush_cache_page_args {
@@ -521,7 +521,7 @@ static void r4k_flush_cache_page(struct vm_area_struct *vma,
 	args.addr = addr;
 	args.pfn = pfn;
 
-	r4k_on_each_cpu(local_r4k_flush_cache_page, &args, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_page, &args, 1);
 }
 
 static inline void local_r4k_flush_data_cache_page(void * addr)
@@ -535,7 +535,7 @@ static void r4k_flush_data_cache_page(unsigned long addr)
 		local_r4k_flush_data_cache_page((void *)addr);
 	else
 		r4k_on_each_cpu(local_r4k_flush_data_cache_page, (void *) addr,
-			        1, 1);
+			        1);
 }
 
 struct flush_icache_range_args {
@@ -571,7 +571,7 @@ static void r4k_flush_icache_range(unsigned long start, unsigned long end)
 	args.start = start;
 	args.end = end;
 
-	r4k_on_each_cpu(local_r4k_flush_icache_range, &args, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_icache_range, &args, 1);
 	instruction_hazard();
 }
 
@@ -672,7 +672,7 @@ static void local_r4k_flush_cache_sigtramp(void * arg)
 
 static void r4k_flush_cache_sigtramp(unsigned long addr)
 {
-	r4k_on_each_cpu(local_r4k_flush_cache_sigtramp, (void *) addr, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_sigtramp, (void *) addr, 1);
 }
 
 static void r4k_flush_icache_all(void)
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index b5f6f71..dd2fbd6 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -27,7 +27,7 @@ static int op_mips_setup(void)
 	model->reg_setup(ctr);
 
 	/* Configure the registers on all cpus.  */
-	on_each_cpu(model->cpu_setup, NULL, 0, 1);
+	on_each_cpu(model->cpu_setup, NULL, 1);
 
         return 0;
 }
@@ -58,7 +58,7 @@ static int op_mips_create_files(struct super_block * sb, struct dentry * root)
 
 static int op_mips_start(void)
 {
-	on_each_cpu(model->cpu_start, NULL, 0, 1);
+	on_each_cpu(model->cpu_start, NULL, 1);
 
 	return 0;
 }
@@ -66,7 +66,7 @@ static int op_mips_start(void)
 static void op_mips_stop(void)
 {
 	/* Disable performance monitoring for all counters.  */
-	on_each_cpu(model->cpu_stop, NULL, 0, 1);
+	on_each_cpu(model->cpu_stop, NULL, 1);
 }
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index b40df7d..54759f1 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -313,7 +313,7 @@ static int __init mipsxx_init(void)
 	if (!cpu_has_mipsmt_pertccounters)
 		counters = counters_total_to_per_cpu(counters);
 #endif
-	on_each_cpu(reset_counters, (void *)(long)counters, 0, 1);
+	on_each_cpu(reset_counters, (void *)(long)counters, 1);
 
 	op_model_mipsxx_ops.num_counters = counters;
 	switch (current_cpu_type()) {
@@ -382,7 +382,7 @@ static void mipsxx_exit(void)
 	int counters = op_model_mipsxx_ops.num_counters;
 
 	counters = counters_per_cpu_to_total(counters);
-	on_each_cpu(reset_counters, (void *)(long)counters, 0, 1);
+	on_each_cpu(reset_counters, (void *)(long)counters, 1);
 
 	perf_irq = save_perf_irq;
 }
diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index 35dc435..cf4c868 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -64,7 +64,7 @@ static void prom_exit(void)
 #ifdef CONFIG_SMP
 	if (smp_processor_id())
 		/* CPU 1 */
-		smp_call_function(prom_cpu0_exit, NULL, 1, 1);
+		smp_call_function(prom_cpu0_exit, NULL, 1);
 #endif
 	prom_cpu0_exit(NULL);
 }
diff --git a/arch/mips/sibyte/cfe/setup.c b/arch/mips/sibyte/cfe/setup.c
index 33fce82..fd9604d 100644
--- a/arch/mips/sibyte/cfe/setup.c
+++ b/arch/mips/sibyte/cfe/setup.c
@@ -74,7 +74,7 @@ static void __noreturn cfe_linux_exit(void *arg)
 		if (!reboot_smp) {
 			/* Get CPU 0 to do the cfe_exit */
 			reboot_smp = 1;
-			smp_call_function(cfe_linux_exit, arg, 1, 0);
+			smp_call_function(cfe_linux_exit, arg, 0);
 		}
 	} else {
 		printk("Passing control back to CFE...\n");
diff --git a/arch/mips/sibyte/sb1250/prom.c b/arch/mips/sibyte/sb1250/prom.c
index cf8f6b3..65b1af6 100644
--- a/arch/mips/sibyte/sb1250/prom.c
+++ b/arch/mips/sibyte/sb1250/prom.c
@@ -66,7 +66,7 @@ static void prom_linux_exit(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_processor_id()) {
-		smp_call_function(prom_cpu0_exit, NULL, 1, 1);
+		smp_call_function(prom_cpu0_exit, NULL, 1);
 	}
 #endif
 	while(1);
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index bc7a19d..a7d4fd3 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -199,6 +199,7 @@ endchoice
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index e10d25d..5259d8c 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -51,12 +51,12 @@ static struct pdc_btlb_info btlb_info __read_mostly;
 void
 flush_data_cache(void)
 {
-	on_each_cpu(flush_data_cache_local, NULL, 1, 1);
+	on_each_cpu(flush_data_cache_local, NULL, 1);
 }
 void 
 flush_instruction_cache(void)
 {
-	on_each_cpu(flush_instruction_cache_local, NULL, 1, 1);
+	on_each_cpu(flush_instruction_cache_local, NULL, 1);
 }
 #endif
 
@@ -515,7 +515,7 @@ static void cacheflush_h_tmp_function(void *dummy)
 
 void flush_cache_all(void)
 {
-	on_each_cpu(cacheflush_h_tmp_function, NULL, 1, 1);
+	on_each_cpu(cacheflush_h_tmp_function, NULL, 1);
 }
 
 void flush_cache_mm(struct mm_struct *mm)
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 85fc775..d47f397 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -84,19 +84,11 @@ EXPORT_SYMBOL(cpu_possible_map);
 
 DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
-struct smp_call_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t unstarted_count;
-	atomic_t unfinished_count;
-};
-static volatile struct smp_call_struct *smp_call_function_data;
-
 enum ipi_message_type {
 	IPI_NOP=0,
 	IPI_RESCHEDULE=1,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_START,
 	IPI_CPU_STOP,
 	IPI_CPU_TEST
@@ -187,33 +179,12 @@ ipi_interrupt(int irq, void *dev_id)
 
 			case IPI_CALL_FUNC:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC\n", this_cpu);
-				{
-					volatile struct smp_call_struct *data;
-					void (*func)(void *info);
-					void *info;
-					int wait;
-
-					data = smp_call_function_data;
-					func = data->func;
-					info = data->info;
-					wait = data->wait;
-
-					mb();
-					atomic_dec ((atomic_t *)&data->unstarted_count);
-
-					/* At this point, *data can't
-					 * be relied upon.
-					 */
-
-					(*func)(info);
-
-					/* Notify the sending CPU that the
-					 * task is done.
-					 */
-					mb();
-					if (wait)
-						atomic_dec ((atomic_t *)&data->unfinished_count);
-				}
+				generic_smp_call_function_interrupt();
+				break;
+
+			case IPI_CALL_FUNC_SINGLE:
+				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC_SINGLE\n", this_cpu);
+				generic_smp_call_function_single_interrupt();
 				break;
 
 			case IPI_CPU_START:
@@ -256,6 +227,14 @@ ipi_send(int cpu, enum ipi_message_type op)
 	spin_unlock_irqrestore(lock, flags);
 }
 
+static void
+send_IPI_mask(cpumask_t mask, enum ipi_message_type op)
+{
+	int cpu;
+
+	for_each_cpu_mask(cpu, mask)
+		ipi_send(cpu, op);
+}
 
 static inline void
 send_IPI_single(int dest_cpu, enum ipi_message_type op)
@@ -295,86 +274,15 @@ smp_send_all_nop(void)
 	send_IPI_allbutself(IPI_NOP);
 }
 
-
-/**
- * Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <retry>	If true, keep retrying until ready.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or have executed.
- */
-
-int
-smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct smp_call_struct data;
-	unsigned long timeout;
-	static DEFINE_SPINLOCK(lock);
-	int retries = 0;
-
-	if (num_online_cpus() < 2)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* can also deadlock if IPIs are disabled */
-	WARN_ON((get_eiem() & (1UL<<(CPU_IRQ_MAX - IPI_IRQ))) == 0);
-
-	
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-	atomic_set(&data.unstarted_count, num_online_cpus() - 1);
-	atomic_set(&data.unfinished_count, num_online_cpus() - 1);
-
-	if (retry) {
-		spin_lock (&lock);
-		while (smp_call_function_data != 0)
-			barrier();
-	}
-	else {
-		spin_lock (&lock);
-		if (smp_call_function_data) {
-			spin_unlock (&lock);
-			return -EBUSY;
-		}
-	}
-
-	smp_call_function_data = &data;
-	spin_unlock (&lock);
-	
-	/*  Send a message to all other CPUs and wait for them to respond  */
-	send_IPI_allbutself(IPI_CALL_FUNC);
-
- retry:
-	/*  Wait for response  */
-	timeout = jiffies + HZ;
-	while ( (atomic_read (&data.unstarted_count) > 0) &&
-		time_before (jiffies, timeout) )
-		barrier ();
-
-	if (atomic_read (&data.unstarted_count) > 0) {
-		printk(KERN_CRIT "SMP CALL FUNCTION TIMED OUT! (cpu=%d), try %d\n",
-		      smp_processor_id(), ++retries);
-		goto retry;
-	}
-	/* We either got one or timed out. Release the lock */
-
-	mb();
-	smp_call_function_data = NULL;
-
-	while (wait && atomic_read (&data.unfinished_count) > 0)
-			barrier ();
-
-	return 0;
+	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
 
-EXPORT_SYMBOL(smp_call_function);
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+}
 
 /*
  * Flush all other CPU's tlb and then mine.  Do this with on_each_cpu()
@@ -384,7 +292,7 @@ EXPORT_SYMBOL(smp_call_function);
 void
 smp_flush_tlb_all(void)
 {
-	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_local, NULL, 1);
 }
 
 /*
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index ce0da68..b4d6c87 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -1053,7 +1053,7 @@ void flush_tlb_all(void)
 	    do_recycle++;
 	}
 	spin_unlock(&sid_lock);
-	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_local, NULL, 1);
 	if (do_recycle) {
 	    spin_lock(&sid_lock);
 	    recycle_sids(recycle_ndirty,recycle_dirty_array);
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a5e9912..20eacf2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
 
 config EARLY_PRINTK
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 704375b..b732b5f 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -172,7 +172,7 @@ static void kexec_prepare_cpus(void)
 {
 	int my_cpu, i, notified=-1;
 
-	smp_call_function(kexec_smp_down, NULL, 0, /* wait */0);
+	smp_call_function(kexec_smp_down, NULL, /* wait */0);
 	my_cpu = get_cpu();
 
 	/* check the others cpus are now down (via paca hw cpu id == -1) */
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 34843c3..647f3e8 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -747,7 +747,7 @@ static int rtas_ibm_suspend_me(struct rtas_args *args)
 	/* Call function on all CPUs.  One of us will make the
 	 * rtas call
 	 */
-	if (on_each_cpu(rtas_percpu_suspend_me, &data, 1, 0))
+	if (on_each_cpu(rtas_percpu_suspend_me, &data, 0))
 		data.error = -EINVAL;
 
 	wait_for_completion(&done);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 1457aa0..5191b46 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -72,12 +72,8 @@ struct smp_ops_t *smp_ops;
 
 static volatile unsigned int cpu_callin_map[NR_CPUS];
 
-void smp_call_function_interrupt(void);
-
 int smt_enabled_at_boot = 1;
 
-static int ipi_fail_ok;
-
 static void (*crash_ipi_function_ptr)(struct pt_regs *) = NULL;
 
 #ifdef CONFIG_PPC64
@@ -99,12 +95,15 @@ void smp_message_recv(int msg)
 {
 	switch(msg) {
 	case PPC_MSG_CALL_FUNCTION:
-		smp_call_function_interrupt();
+		generic_smp_call_function_interrupt();
 		break;
 	case PPC_MSG_RESCHEDULE:
 		/* XXX Do we have to do this? */
 		set_need_resched();
 		break;
+	case PPC_MSG_CALL_FUNC_SINGLE:
+		generic_smp_call_function_single_interrupt();
+		break;
 	case PPC_MSG_DEBUGGER_BREAK:
 		if (crash_ipi_function_ptr) {
 			crash_ipi_function_ptr(get_irq_regs());
@@ -128,6 +127,19 @@ void smp_send_reschedule(int cpu)
 		smp_ops->message_pass(cpu, PPC_MSG_RESCHEDULE);
 }
 
+void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
+}
+
+void arch_send_call_function_ipi(cpumask_t mask)
+{
+	unsigned int cpu;
+
+	for_each_cpu_mask(cpu, mask)
+		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
+}
+
 #ifdef CONFIG_DEBUGGER
 void smp_send_debugger_break(int cpu)
 {
@@ -154,215 +166,9 @@ static void stop_this_cpu(void *dummy)
 		;
 }
 
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- * Stolen from the i386 version.
- */
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_lock);
-
-static struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-} *call_data;
-
-/* delay of at least 8 seconds */
-#define SMP_CALL_TIMEOUT	8
-
-/*
- * These functions send a 'generic call function' IPI to other online
- * CPUS in the system.
- *
- * [SUMMARY] Run a function on other CPUs.
- * <func> The function to run. This must be fast and non-blocking.
- * <info> An arbitrary pointer to pass to the function.
- * <nonatomic> currently unused.
- * <wait> If true, wait (atomically) until function has completed on other CPUs.
- * [RETURNS] 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- * <map> is a cpu map of the cpus to send IPI to.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-static int __smp_call_function_map(void (*func) (void *info), void *info,
-				   int nonatomic, int wait, cpumask_t map)
-{
-	struct call_data_struct data;
-	int ret = -1, num_cpus;
-	int cpu;
-	u64 timeout;
-
-	if (unlikely(smp_ops == NULL))
-		return ret;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	/* remove 'self' from the map */
-	if (cpu_isset(smp_processor_id(), map))
-		cpu_clear(smp_processor_id(), map);
-
-	/* sanity check the map, remove any non-online processors. */
-	cpus_and(map, map, cpu_online_map);
-
-	num_cpus = cpus_weight(map);
-	if (!num_cpus)
-		goto done;
-
-	call_data = &data;
-	smp_wmb();
-	/* Send a message to all CPUs in the map */
-	for_each_cpu_mask(cpu, map)
-		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
-
-	timeout = get_tb() + (u64) SMP_CALL_TIMEOUT * tb_ticks_per_sec;
-
-	/* Wait for indication that they have received the message */
-	while (atomic_read(&data.started) != num_cpus) {
-		HMT_low();
-		if (get_tb() >= timeout) {
-			printk("smp_call_function on cpu %d: other cpus not "
-				"responding (%d)\n", smp_processor_id(),
-				atomic_read(&data.started));
-			if (!ipi_fail_ok)
-				debugger(NULL);
-			goto out;
-		}
-	}
-
-	/* optionally wait for the CPUs to complete */
-	if (wait) {
-		while (atomic_read(&data.finished) != num_cpus) {
-			HMT_low();
-			if (get_tb() >= timeout) {
-				printk("smp_call_function on cpu %d: other "
-					"cpus not finishing (%d/%d)\n",
-					smp_processor_id(),
-					atomic_read(&data.finished),
-					atomic_read(&data.started));
-				debugger(NULL);
-				goto out;
-			}
-		}
-	}
-
- done:
-	ret = 0;
-
- out:
-	call_data = NULL;
-	HMT_medium();
-	return ret;
-}
-
-static int __smp_call_function(void (*func)(void *info), void *info,
-			       int nonatomic, int wait)
-{
-	int ret;
-	spin_lock(&call_lock);
-	ret =__smp_call_function_map(func, info, nonatomic, wait,
-				       cpu_online_map);
-	spin_unlock(&call_lock);
-	return ret;
-}
-
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-{
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	return __smp_call_function(func, info, nonatomic, wait);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	cpumask_t map = CPU_MASK_NONE;
-	int ret = 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	cpu_set(cpu, map);
-	if (cpu != get_cpu()) {
-		spin_lock(&call_lock);
-		ret = __smp_call_function_map(func, info, nonatomic, wait, map);
-		spin_unlock(&call_lock);
-	} else {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 void smp_send_stop(void)
 {
-	int nolock;
-
-	/* It's OK to fail sending the IPI, since the alternative is to
-	 * be stuck forever waiting on the other CPU to take the interrupt.
-	 *
-	 * It's better to at least continue and go through reboot, since this
-	 * function is usually called at panic or reboot time in the first
-	 * place.
-	 */
-	ipi_fail_ok = 1;
-
-	/* Don't deadlock in case we got called through panic */
-	nolock = !spin_trylock(&call_lock);
-	__smp_call_function_map(stop_this_cpu, NULL, 1, 0, cpu_online_map);
-	if (!nolock)
-		spin_unlock(&call_lock);
-}
-
-void smp_call_function_interrupt(void)
-{
-	void (*func) (void *info);
-	void *info;
-	int wait;
-
-	/* call_data will be NULL if the sender timed out while
-	 * waiting on us to receive the call.
-	 */
-	if (!call_data)
-		return;
-
-	func = call_data->func;
-	info = call_data->info;
-	wait = call_data->wait;
-
-	if (!wait)
-		smp_mb__before_atomic_inc();
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
-	(*func)(info);
-	if (wait) {
-		smp_mb__before_atomic_inc();
-		atomic_inc(&call_data->finished);
-	}
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 extern struct gettimeofday_struct do_gtod;
@@ -596,9 +402,9 @@ int __devinit start_secondary(void *unused)
 
 	secondary_cpu_time_init();
 
-	spin_lock(&call_lock);
+	ipi_call_lock();
 	cpu_set(cpu, cpu_online_map);
-	spin_unlock(&call_lock);
+	ipi_call_unlock();
 
 	local_irq_enable();
 
diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
index 368a493..c3a56d6 100644
--- a/arch/powerpc/kernel/tau_6xx.c
+++ b/arch/powerpc/kernel/tau_6xx.c
@@ -192,7 +192,7 @@ static void tau_timeout_smp(unsigned long unused)
 
 	/* schedule ourselves to be run again */
 	mod_timer(&tau_timer, jiffies + shrink_timer) ;
-	on_each_cpu(tau_timeout, NULL, 1, 0);
+	on_each_cpu(tau_timeout, NULL, 0);
 }
 
 /*
@@ -234,7 +234,7 @@ int __init TAU_init(void)
 	tau_timer.expires = jiffies + shrink_timer;
 	add_timer(&tau_timer);
 
-	on_each_cpu(TAU_init_smp, NULL, 1, 0);
+	on_each_cpu(TAU_init_smp, NULL, 0);
 
 	printk("Thermal assist unit ");
 #ifdef CONFIG_TAU_INT
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 73401e8..f1a38a6 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -322,7 +322,7 @@ void snapshot_timebases(void)
 {
 	if (!cpu_has_feature(CPU_FTR_PURR))
 		return;
-	on_each_cpu(snapshot_tb_and_purr, NULL, 0, 1);
+	on_each_cpu(snapshot_tb_and_purr, NULL, 1);
 }
 
 /*
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index ad928ed..2bd12d9 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -218,7 +218,7 @@ static void slice_convert(struct mm_struct *mm, struct slice_mask mask, int psiz
 	mb();
 
 	/* XXX this is sub-optimal but will do for now */
-	on_each_cpu(slice_flush_segments, mm, 0, 1);
+	on_each_cpu(slice_flush_segments, mm, 1);
 #ifdef CONFIG_SPU_BASE
 	spu_flush_all_slbs(mm);
 #endif
diff --git a/arch/powerpc/mm/tlb_64.c b/arch/powerpc/mm/tlb_64.c
index e2d867c..69ad829 100644
--- a/arch/powerpc/mm/tlb_64.c
+++ b/arch/powerpc/mm/tlb_64.c
@@ -66,7 +66,7 @@ static void pgtable_free_now(pgtable_free_t pgf)
 {
 	pte_freelist_forced_free++;
 
-	smp_call_function(pte_free_smp_sync, NULL, 0, 1);
+	smp_call_function(pte_free_smp_sync, NULL, 1);
 
 	pgtable_free(pgf);
 }
diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
index 4908dc9..17807ac 100644
--- a/arch/powerpc/oprofile/common.c
+++ b/arch/powerpc/oprofile/common.c
@@ -65,7 +65,7 @@ static int op_powerpc_setup(void)
 
 	/* Configure the registers on all cpus.	 If an error occurs on one
 	 * of the cpus, op_per_cpu_rc will be set to the error */
-	on_each_cpu(op_powerpc_cpu_setup, NULL, 0, 1);
+	on_each_cpu(op_powerpc_cpu_setup, NULL, 1);
 
 out:	if (op_per_cpu_rc) {
 		/* error on setup release the performance counter hardware */
@@ -100,7 +100,7 @@ static int op_powerpc_start(void)
 	if (model->global_start)
 		return model->global_start(ctr);
 	if (model->start) {
-		on_each_cpu(op_powerpc_cpu_start, NULL, 0, 1);
+		on_each_cpu(op_powerpc_cpu_start, NULL, 1);
 		return op_per_cpu_rc;
 	}
 	return -EIO; /* No start function is defined for this
@@ -115,7 +115,7 @@ static inline void op_powerpc_cpu_stop(void *dummy)
 static void op_powerpc_stop(void)
 {
 	if (model->stop)
-		on_each_cpu(op_powerpc_cpu_stop, NULL, 0, 1);
+		on_each_cpu(op_powerpc_cpu_stop, NULL, 1);
         if (model->global_stop)
                 model->global_stop();
 }
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 5bf7df1..2d5bb22 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -218,6 +218,7 @@ void iic_request_IPIs(void)
 {
 	iic_request_ipi(PPC_MSG_CALL_FUNCTION, "IPI-call");
 	iic_request_ipi(PPC_MSG_RESCHEDULE, "IPI-resched");
+	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE, "IPI-call-single");
 #ifdef CONFIG_DEBUGGER
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK, "IPI-debug");
 #endif /* CONFIG_DEBUGGER */
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index f0b12f2..a0927a3 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -105,9 +105,10 @@ static void __init ps3_smp_setup_cpu(int cpu)
 	 * to index needs to be setup.
 	 */
 
-	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION  != 0);
-	BUILD_BUG_ON(PPC_MSG_RESCHEDULE     != 1);
-	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK != 3);
+	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION    != 0);
+	BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
+	BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
+	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);
 
 	for (i = 0; i < MSG_COUNT; i++) {
 		result = ps3_event_receive_port_setup(cpu, &virqs[i]);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index ebebc28..0fc830f 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -383,13 +383,11 @@ static irqreturn_t xics_ipi_dispatch(int cpu)
 			mb();
 			smp_message_recv(PPC_MSG_RESCHEDULE);
 		}
-#if 0
-		if (test_and_clear_bit(PPC_MSG_MIGRATE_TASK,
+		if (test_and_clear_bit(PPC_MSG_CALL_FUNC_SINGLE,
 				       &xics_ipi_message[cpu].value)) {
 			mb();
-			smp_message_recv(PPC_MSG_MIGRATE_TASK);
+			smp_message_recv(PPC_MSG_CALL_FUNC_SINGLE);
 		}
-#endif
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 		if (test_and_clear_bit(PPC_MSG_DEBUGGER_BREAK,
 				       &xics_ipi_message[cpu].value)) {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 7680001..6c90c95 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1494,7 +1494,7 @@ void mpic_request_ipis(void)
 	static char *ipi_names[] = {
 		"IPI0 (call function)",
 		"IPI1 (reschedule)",
-		"IPI2 (unused)",
+		"IPI2 (call function single)",
 		"IPI3 (debugger break)",
 	};
 	BUG_ON(mpic == NULL);
diff --git a/arch/ppc/kernel/smp.c b/arch/ppc/kernel/smp.c
index 0559985..bcab0d2 100644
--- a/arch/ppc/kernel/smp.c
+++ b/arch/ppc/kernel/smp.c
@@ -152,7 +152,7 @@ static void stop_this_cpu(void *dummy)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 /*
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 9cb3d92..a7f8979 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -203,7 +203,7 @@ __appldata_vtimer_setup(int cmd)
 			per_cpu(appldata_timer, i).expires = per_cpu_interval;
 			smp_call_function_single(i, add_virt_timer_periodic,
 						 &per_cpu(appldata_timer, i),
-						 0, 1);
+						 1);
 		}
 		appldata_timer_active = 1;
 		break;
@@ -228,7 +228,7 @@ __appldata_vtimer_setup(int cmd)
 			args.timer = &per_cpu(appldata_timer, i);
 			args.expires = per_cpu_interval;
 			smp_call_function_single(i, __appldata_mod_vtimer_wrap,
-						 &args, 0, 1);
+						 &args, 1);
 		}
 	}
 }
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 5d4fa4b..b678103 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -109,7 +109,7 @@ static void do_call_function(void)
 }
 
 static void __smp_call_function_map(void (*func) (void *info), void *info,
-				    int nonatomic, int wait, cpumask_t map)
+				    int wait, cpumask_t map)
 {
 	struct call_data_struct data;
 	int cpu, local = 0;
@@ -162,7 +162,6 @@ out:
  * smp_call_function:
  * @func: the function to run; this must be fast and non-blocking
  * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
  * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
  * Run a function on all other CPUs.
@@ -170,15 +169,14 @@ out:
  * You must not call this function with disabled interrupts, from a
  * hardware interrupt handler or from a bottom half.
  */
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
+int smp_call_function(void (*func) (void *info), void *info, int wait)
 {
 	cpumask_t map;
 
 	spin_lock(&call_lock);
 	map = cpu_online_map;
 	cpu_clear(smp_processor_id(), map);
-	__smp_call_function_map(func, info, nonatomic, wait, map);
+	__smp_call_function_map(func, info, wait, map);
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -189,7 +187,6 @@ EXPORT_SYMBOL(smp_call_function);
  * @cpu: the CPU where func should run
  * @func: the function to run; this must be fast and non-blocking
  * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
  * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
  * Run a function on one processor.
@@ -198,11 +195,10 @@ EXPORT_SYMBOL(smp_call_function);
  * hardware interrupt handler or from a bottom half.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
+			     int wait)
 {
 	spin_lock(&call_lock);
-	__smp_call_function_map(func, info, nonatomic, wait,
-				cpumask_of_cpu(cpu));
+	__smp_call_function_map(func, info, wait, cpumask_of_cpu(cpu));
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -228,7 +224,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 {
 	spin_lock(&call_lock);
 	cpu_clear(smp_processor_id(), mask);
-	__smp_call_function_map(func, info, 0, wait, mask);
+	__smp_call_function_map(func, info, wait, mask);
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -303,7 +299,7 @@ static void smp_ptlb_callback(void *info)
 
 void smp_ptlb_all(void)
 {
-	on_each_cpu(smp_ptlb_callback, NULL, 0, 1);
+	on_each_cpu(smp_ptlb_callback, NULL, 1);
 }
 EXPORT_SYMBOL(smp_ptlb_all);
 #endif /* ! CONFIG_64BIT */
@@ -351,7 +347,7 @@ void smp_ctl_set_bit(int cr, int bit)
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
 	parms.orvals[cr] = 1 << bit;
-	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
+	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_set_bit);
 
@@ -365,7 +361,7 @@ void smp_ctl_clear_bit(int cr, int bit)
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
 	parms.andvals[cr] = ~(1L << bit);
-	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
+	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_clear_bit);
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 7418beb..f2cede3 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -707,7 +707,7 @@ static int etr_sync_clock(struct etr_aib *aib, int port)
 	 */
 	memset(&etr_sync, 0, sizeof(etr_sync));
 	preempt_disable();
-	smp_call_function(clock_sync_cpu_start, &etr_sync, 0, 0);
+	smp_call_function(clock_sync_cpu_start, &etr_sync, 0);
 	local_irq_disable();
 	enable_sync_clock();
 
@@ -746,7 +746,7 @@ static int etr_sync_clock(struct etr_aib *aib, int port)
 		rc = -EAGAIN;
 	}
 	local_irq_enable();
-	smp_call_function(clock_sync_cpu_end, NULL, 0, 0);
+	smp_call_function(clock_sync_cpu_end, NULL, 0);
 	preempt_enable();
 	return rc;
 }
@@ -926,7 +926,7 @@ static void etr_work_fn(struct work_struct *work)
 	if (!eacr.ea) {
 		/* Both ports offline. Reset everything. */
 		eacr.dp = eacr.es = eacr.sl = 0;
-		on_each_cpu(disable_sync_clock, NULL, 0, 1);
+		on_each_cpu(disable_sync_clock, NULL, 1);
 		del_timer_sync(&etr_timer);
 		etr_update_eacr(eacr);
 		clear_bit(CLOCK_SYNC_ETR, &clock_sync_flags);
@@ -1432,7 +1432,7 @@ static void stp_work_fn(struct work_struct *work)
 	 */
 	memset(&stp_sync, 0, sizeof(stp_sync));
 	preempt_disable();
-	smp_call_function(clock_sync_cpu_start, &stp_sync, 0, 0);
+	smp_call_function(clock_sync_cpu_start, &stp_sync, 0);
 	local_irq_disable();
 	enable_sync_clock();
 
@@ -1465,7 +1465,7 @@ static void stp_work_fn(struct work_struct *work)
 		stp_sync.in_sync = 1;
 
 	local_irq_enable();
-	smp_call_function(clock_sync_cpu_end, NULL, 0, 0);
+	smp_call_function(clock_sync_cpu_end, NULL, 0);
 	preempt_enable();
 }
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 9a854c8..3e7384f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -688,6 +688,7 @@ config CRASH_DUMP
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 5d039d1..60c5084 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -36,13 +36,6 @@ EXPORT_SYMBOL(cpu_possible_map);
 cpumask_t cpu_online_map;
 EXPORT_SYMBOL(cpu_online_map);
 
-static atomic_t cpus_booted = ATOMIC_INIT(0);
-
-/*
- * Run specified function on a particular processor.
- */
-void __smp_call_function(unsigned int cpu);
-
 static inline void __init smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
@@ -175,45 +168,20 @@ static void stop_this_cpu(void *unused)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, 0, 1, 0);
+	smp_call_function(stop_this_cpu, 0, 0);
 }
 
-struct smp_fn_call_struct smp_fn_call = {
-	.lock		= __SPIN_LOCK_UNLOCKED(smp_fn_call.lock),
-	.finished	= ATOMIC_INIT(0),
-};
-
-/*
- * The caller of this wants the passed function to run on every cpu.  If wait
- * is set, wait until all cpus have finished the function before returning.
- * The lock is here to protect the call structure.
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function(void (*func)(void *info), void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	unsigned int nr_cpus = atomic_read(&cpus_booted);
-	int i;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	spin_lock(&smp_fn_call.lock);
-
-	atomic_set(&smp_fn_call.finished, 0);
-	smp_fn_call.fn = func;
-	smp_fn_call.data = info;
-
-	for (i = 0; i < nr_cpus; i++)
-		if (i != smp_processor_id())
-			plat_send_ipi(i, SMP_MSG_FUNCTION);
-
-	if (wait)
-		while (atomic_read(&smp_fn_call.finished) != (nr_cpus - 1));
+	int cpu;
 
-	spin_unlock(&smp_fn_call.lock);
+	for_each_cpu_mask(cpu, mask)
+		plat_send_ipi(cpu, SMP_MSG_FUNCTION);
+}
 
-	return 0;
+void arch_send_call_function_single_ipi(int cpu)
+{
+	plat_send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
 }
 
 /* Not really SMP stuff ... */
@@ -229,7 +197,7 @@ static void flush_tlb_all_ipi(void *info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(flush_tlb_all_ipi, 0, 1, 1);
+	on_each_cpu(flush_tlb_all_ipi, 0, 1);
 }
 
 static void flush_tlb_mm_ipi(void *mm)
@@ -255,7 +223,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	preempt_disable();
 
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
-		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1, 1);
+		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -292,7 +260,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 		fd.vma = vma;
 		fd.addr1 = start;
 		fd.addr2 = end;
-		smp_call_function(flush_tlb_range_ipi, (void *)&fd, 1, 1);
+		smp_call_function(flush_tlb_range_ipi, (void *)&fd, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -316,7 +284,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 
 	fd.addr1 = start;
 	fd.addr2 = end;
-	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1, 1);
+	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1);
 }
 
 static void flush_tlb_page_ipi(void *info)
@@ -335,7 +303,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 
 		fd.vma = vma;
 		fd.addr1 = page;
-		smp_call_function(flush_tlb_page_ipi, (void *)&fd, 1, 1);
+		smp_call_function(flush_tlb_page_ipi, (void *)&fd, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -359,6 +327,6 @@ void flush_tlb_one(unsigned long asid, unsigned long vaddr)
 	fd.addr1 = asid;
 	fd.addr2 = vaddr;
 
-	smp_call_function(flush_tlb_one_ipi, (void *)&fd, 1, 1);
+	smp_call_function(flush_tlb_one_ipi, (void *)&fd, 1);
 	local_flush_tlb_one(asid, vaddr);
 }
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index fa63c68..c099d96 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -807,7 +807,6 @@ extern unsigned long xcall_call_function;
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code. Does not return until
@@ -816,8 +815,8 @@ extern unsigned long xcall_call_function;
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-static int smp_call_function_mask(void (*func)(void *info), void *info,
-				  int nonatomic, int wait, cpumask_t mask)
+static int sparc64_smp_call_function_mask(void (*func)(void *info), void *info,
+					  int wait, cpumask_t mask)
 {
 	struct call_data_struct data;
 	int cpus;
@@ -852,11 +851,9 @@ out_unlock:
 	return 0;
 }
 
-int smp_call_function(void (*func)(void *info), void *info,
-		      int nonatomic, int wait)
+int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
-	return smp_call_function_mask(func, info, nonatomic, wait,
-				      cpu_online_map);
+	return sparc64_smp_call_function_mask(func, info, wait, cpu_online_map);
 }
 
 void smp_call_function_client(int irq, struct pt_regs *regs)
@@ -893,7 +890,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	smp_call_function_mask(tsb_sync, mm, 0, 1, mm->cpu_vm_mask);
+	sparc64_smp_call_function_mask(tsb_sync, mm, 1, mm->cpu_vm_mask);
 }
 
 extern unsigned long xcall_flush_tlb_mm;
diff --git a/arch/sparc64/mm/hugetlbpage.c b/arch/sparc64/mm/hugetlbpage.c
index 6cfab2e..ebefd2a 100644
--- a/arch/sparc64/mm/hugetlbpage.c
+++ b/arch/sparc64/mm/hugetlbpage.c
@@ -344,7 +344,7 @@ void hugetlb_prefault_arch_hook(struct mm_struct *mm)
 			 * also executing in this address space.
 			 */
 			mm->context.sparc64_ctx_val = ctx;
-			on_each_cpu(context_reload, mm, 0, 0);
+			on_each_cpu(context_reload, mm, 0);
 		}
 		spin_unlock(&ctx_alloc_lock);
 	}
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index e1062ec..be2d50c 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -214,8 +214,7 @@ void smp_call_function_slave(int cpu)
 	atomic_inc(&scf_finished);
 }
 
-int smp_call_function(void (*_func)(void *info), void *_info, int nonatomic,
-		      int wait)
+int smp_call_function(void (*_func)(void *info), void *_info, int wait)
 {
 	int cpus = num_online_cpus() - 1;
 	int i;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2642b4b..96e0c2e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -170,6 +170,7 @@ config GENERIC_PENDING_IRQ
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
+	select USE_GENERIC_SMP_HELPERS
 	default y
 
 config X86_32_SMP
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3e58b67..a437d02 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1340,6 +1340,10 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				call_function_single_interrupt);
 }
 #endif
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 9874107..c4a7ec3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -364,7 +364,7 @@ static void mcheck_check_cpu(void *info)
 
 static void mcheck_timer(struct work_struct *work)
 {
-	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
+	on_each_cpu(mcheck_check_cpu, NULL, 1);
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -621,7 +621,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	 * Collect entries that were still getting written before the
 	 * synchronize.
 	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1, 1);
+	on_each_cpu(collect_tscs, cpu_tsc, 1);
 	for (i = next; i < MCE_LOG_LEN; i++) {
 		if (mcelog.entry[i].finished &&
 		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
@@ -746,7 +746,7 @@ static void mce_restart(void)
 	if (next_interval)
 		cancel_delayed_work(&mcheck_work);
 	/* Timer race is harmless here */
-	on_each_cpu(mce_init, NULL, 1, 1);
+	on_each_cpu(mce_init, NULL, 1);
 	next_interval = check_interval * HZ;
 	if (next_interval)
 		schedule_delayed_work(&mcheck_work,
diff --git a/arch/x86/kernel/cpu/mcheck/non-fatal.c b/arch/x86/kernel/cpu/mcheck/non-fatal.c
index 00ccb6c..cc1fccd 100644
--- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
@@ -59,7 +59,7 @@ static DECLARE_DELAYED_WORK(mce_work, mce_work_fn);
 
 static void mce_work_fn(struct work_struct *work)
 {
-	on_each_cpu(mce_checkregs, NULL, 1, 1);
+	on_each_cpu(mce_checkregs, NULL, 1);
 	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 105afe1..6f23969 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -223,7 +223,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	atomic_set(&data.gate,0);
 
 	/*  Start the ball rolling on other CPUs  */
-	if (smp_call_function(ipi_handler, &data, 1, 0) != 0)
+	if (smp_call_function(ipi_handler, &data, 0) != 0)
 		panic("mtrr: timed out waiting for other CPUs\n");
 
 	local_irq_save(flags);
@@ -1682,7 +1682,7 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
 }
 
 static int __init mtrr_init_finialize(void)
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 2e9bef6..6d4bdc0 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -189,7 +189,7 @@ void disable_lapic_nmi_watchdog(void)
 	if (atomic_read(&nmi_active) <= 0)
 		return;
 
-	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
 
 	if (wd_ops)
 		wd_ops->unreserve();
@@ -213,7 +213,7 @@ void enable_lapic_nmi_watchdog(void)
 		return;
 	}
 
-	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
+	on_each_cpu(setup_apic_nmi_watchdog, NULL, 1);
 	touch_nmi_watchdog();
 }
 
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 71f1c26..2de5fa2 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -96,7 +96,7 @@ static ssize_t cpuid_read(struct file *file, char __user *buf,
 	for (; count; count -= 16) {
 		cmd.eax = pos;
 		cmd.ecx = pos >> 32;
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
+		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1);
 		if (copy_to_user(tmp, &cmd, 16))
 			return -EFAULT;
 		tmp += 16;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ba41bf4..ae63e58 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -816,6 +816,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(call_function_single_interrupt)
+	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
+END(call_function_single_interrupt)
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 603261a..558abf4 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1569,7 +1569,7 @@ void /*__init*/ print_local_APIC(void *dummy)
 
 void print_all_local_APICs(void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1, 1);
+	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
 void /*__init*/ print_PIC(void)
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index b16ef02..6510cde 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1160,7 +1160,7 @@ void __apicdebuginit print_local_APIC(void * dummy)
 
 void print_all_local_APICs (void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1, 1);
+	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
 void __apicdebuginit print_PIC(void)
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 31f49e8..0373e88 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -199,6 +199,10 @@ void __init native_init_IRQ(void)
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
+	/* IPI for generic single function call */
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+			call_function_single_interrupt);
+
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 21f2bae..a844957 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -68,7 +68,7 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 		load_LDT(pc);
 		mask = cpumask_of_cpu(smp_processor_id());
 		if (!cpus_equal(current->mm->cpu_vm_mask, mask))
-			smp_call_function(flush_ldt, current->mm, 1, 1);
+			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else
 		load_LDT(pc);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 716b892..ec024b3 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -130,7 +130,7 @@ int __init check_nmi_watchdog(void)
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0);
 #endif
 
 	for_each_possible_cpu(cpu)
@@ -272,7 +272,7 @@ static void __acpi_nmi_enable(void *__unused)
 void acpi_nmi_enable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_enable, NULL, 1);
 }
 
 static void __acpi_nmi_disable(void *__unused)
@@ -286,7 +286,7 @@ static void __acpi_nmi_disable(void *__unused)
 void acpi_nmi_disable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 }
 
 void setup_apic_nmi_watchdog(void *unused)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4061d63..7dceea9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -132,7 +132,7 @@ void cpu_idle_wait(void)
 {
 	smp_mb();
 	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 0, 1);
+	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 0cb7aad..361b7a4 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -121,132 +121,23 @@ static void native_smp_send_reschedule(int cpu)
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-};
-
-void lock_ipi_call_lock(void)
+void native_send_call_func_single_ipi(int cpu)
 {
-	spin_lock_irq(&call_lock);
-}
-
-void unlock_ipi_call_lock(void)
-{
-	spin_unlock_irq(&call_lock);
-}
-
-static struct call_data_struct *call_data;
-
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
-{
-	struct call_data_struct data;
-	int cpus = num_online_cpus() - 1;
-
-	if (!cpus)
-		return;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();
-
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
+	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.  Must not include the current cpu.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
-  * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-static int
-native_smp_call_function_mask(cpumask_t mask,
-			      void (*func)(void *), void *info,
-			      int wait)
+void native_send_call_func_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
 	cpumask_t allbutself;
-	int cpus;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	wmb();
-
-	/* Send a message to other CPUs */
 	if (cpus_equal(mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	spin_unlock(&call_lock);
-
-	return 0;
 }
 
 static void stop_this_cpu(void *dummy)
@@ -268,18 +159,13 @@ static void stop_this_cpu(void *dummy)
 
 static void native_smp_send_stop(void)
 {
-	int nolock;
 	unsigned long flags;
 
 	if (reboot_force)
 		return;
 
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0);
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -301,33 +187,28 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
 	ack_APIC_irq();
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_interrupt();
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
 	add_pda(irq_call_count, 1);
 #endif
 	irq_exit();
+}
 
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
+void smp_call_function_single_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+#ifdef CONFIG_X86_32
+	__get_cpu_var(irq_stat).irq_call_count++;
+#else
+	add_pda(irq_call_count, 1);
+#endif
+	irq_exit();
 }
 
 struct smp_ops smp_ops = {
@@ -338,7 +219,8 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
-	.smp_call_function_mask = native_smp_call_function_mask,
+
+	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
-
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f35c2d8..687376a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -327,12 +327,12 @@ static void __cpuinit start_secondary(void *unused)
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
 	 */
-	lock_ipi_call_lock();
+	ipi_call_lock_irq();
 #ifdef CONFIG_X86_IO_APIC
 	setup_vector_irq(smp_processor_id());
 #endif
 	cpu_set(smp_processor_id(), cpu_online_map);
-	unlock_ipi_call_lock();
+	ipi_call_unlock_irq();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
 	setup_secondary_clock();
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 3449064..99941b3 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -25,59 +25,3 @@ __cpuinit void init_gdt(int cpu)
 	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
-
-/**
- * smp_call_function(): Run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
-{
-	return smp_call_function_mask(cpu_online_map, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-/**
- * smp_call_function_single - Run a function on a specific CPU
- * @cpu: The target CPU.  Cannot be the calling CPU.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int ret;
-	int me = get_cpu();
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index 9bb2363..fec1ece 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -238,6 +238,6 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 5039d0f..dcbf7a1 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -275,5 +275,5 @@ static void do_flush_tlb_all(void *info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e50740d..0b8b669 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -279,7 +279,7 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
-		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
+		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
 	return NOTIFY_DONE;
 }
 
@@ -302,7 +302,7 @@ static int __init vsyscall_init(void)
 #ifdef CONFIG_SYSCTL
 	register_sysctl_table(kernel_root_table2);
 #endif
-	on_each_cpu(cpu_vsyscall_init, NULL, 0, 1);
+	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	hotcpu_notifier(cpu_vsyscall_notifier, 0);
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 540e951..10ce6ee 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -335,7 +335,7 @@ static void vcpu_clear(struct vcpu_vmx *vmx)
 {
 	if (vmx->vcpu.cpu == -1)
 		return;
-	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 0, 1);
+	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 1);
 	vmx->launched = 0;
 }
 
@@ -2968,7 +2968,7 @@ static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->vmcs) {
-		on_each_cpu(__vcpu_clear, vmx, 0, 1);
+		on_each_cpu(__vcpu_clear, vmx, 1);
 		free_vmcs(vmx->vmcs);
 		vmx->vmcs = NULL;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63a77ca..0faa254 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4044,6 +4044,6 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * So need not to call smp_call_function_single() in that case.
 	 */
 	if (vcpu->guest_mode && vcpu->cpu != cpu)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
+		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
 	put_cpu();
 }
diff --git a/arch/x86/lib/msr-on-cpu.c b/arch/x86/lib/msr-on-cpu.c
index 57d043f..d5a2b39 100644
--- a/arch/x86/lib/msr-on-cpu.c
+++ b/arch/x86/lib/msr-on-cpu.c
@@ -30,10 +30,10 @@ static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
 
 	rv.msr_no = msr_no;
 	if (safe) {
-		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
 		err = rv.err;
 	} else {
-		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
 	}
 	*l = rv.l;
 	*h = rv.h;
@@ -64,10 +64,10 @@ static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
 	rv.l = l;
 	rv.h = h;
 	if (safe) {
-		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
 		err = rv.err;
 	} else {
-		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
 	}
 
 	return err;
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8dedd01..ee0fba0 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -950,94 +950,24 @@ static void smp_stop_cpu_function(void *dummy)
 		halt();
 }
 
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	volatile unsigned long started;
-	volatile unsigned long finished;
-	int wait;
-};
-
-static struct call_data_struct *call_data;
-
 /* execute a thread on a new CPU.  The function to be called must be
  * previously set up.  This is used to schedule a function for
  * execution on all CPUs - set up the function then broadcast a
  * function_interrupt CPI to come here on each CPU */
 static void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	/* must take copy of wait because call_data may be replaced
-	 * unless the function is waiting for us to finish */
-	int wait = call_data->wait;
-	__u8 cpu = smp_processor_id();
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	if (!test_and_clear_bit(cpu, &call_data->started)) {
-		/* If the bit wasn't set, this could be a replay */
-		printk(KERN_WARNING "VOYAGER SMP: CPU %d received call funtion"
-		       " with no call pending\n", cpu);
-		return;
-	}
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func) (info);
+	generic_smp_call_function_interrupt();
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
-	if (wait) {
-		mb();
-		clear_bit(cpu, &call_data->finished);
-	}
 }
 
-static int
-voyager_smp_call_function_mask(cpumask_t cpumask,
-			       void (*func) (void *info), void *info, int wait)
+static void smp_call_function_single_interrupt(void)
 {
-	struct call_data_struct data;
-	u32 mask = cpus_addr(cpumask)[0];
-
-	mask &= ~(1 << smp_processor_id());
-
-	if (!mask)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	data.started = mask;
-	data.wait = wait;
-	if (wait)
-		data.finished = mask;
-
-	spin_lock(&call_lock);
-	call_data = &data;
-	wmb();
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
-
-	/* Wait for response */
-	while (data.started)
-		barrier();
-
-	if (wait)
-		while (data.finished)
-			barrier();
-
-	spin_unlock(&call_lock);
-
-	return 0;
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 }
 
 /* Sorry about the name.  In an APIC based system, the APICs
@@ -1094,6 +1024,12 @@ void smp_qic_call_function_interrupt(struct pt_regs *regs)
 	smp_call_function_interrupt();
 }
 
+void smp_qic_call_function_single_interrupt(struct pt_regs *regs)
+{
+	ack_QIC_CPI(QIC_CALL_FUNCTION_SINGLE_CPI);
+	smp_call_function_single_interrupt();
+}
+
 void smp_vic_cpi_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
@@ -1114,6 +1050,8 @@ void smp_vic_cpi_interrupt(struct pt_regs *regs)
 		smp_enable_irq_interrupt();
 	if (test_and_clear_bit(VIC_CALL_FUNCTION_CPI, &vic_cpi_mailbox[cpu]))
 		smp_call_function_interrupt();
+	if (test_and_clear_bit(VIC_CALL_FUNCTION_SINGLE_CPI, &vic_cpi_mailbox[cpu]))
+		smp_call_function_single_interrupt();
 	set_irq_regs(old_regs);
 }
 
@@ -1129,7 +1067,7 @@ static void do_flush_tlb_all(void *info)
 /* flush the TLB of every active CPU in the system */
 void flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, 0, 1, 1);
+	on_each_cpu(do_flush_tlb_all, 0, 1);
 }
 
 /* send a reschedule CPI to one CPU by physical CPU number*/
@@ -1161,7 +1099,7 @@ int safe_smp_processor_id(void)
 /* broadcast a halt to all other CPUs */
 static void voyager_smp_send_stop(void)
 {
-	smp_call_function(smp_stop_cpu_function, NULL, 1, 1);
+	smp_call_function(smp_stop_cpu_function, NULL, 1);
 }
 
 /* this function is triggered in time.c when a clock tick fires
@@ -1848,5 +1786,7 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = voyager_smp_send_stop,
 	.smp_send_reschedule = voyager_smp_send_reschedule,
-	.smp_call_function_mask = voyager_smp_call_function_mask,
+
+	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 47f4e2e..65c6e46 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -141,7 +141,7 @@ static void cpa_flush_all(unsigned long cache)
 {
 	BUG_ON(irqs_disabled());
 
-	on_each_cpu(__cpa_flush_all, (void *) cache, 1, 1);
+	on_each_cpu(__cpa_flush_all, (void *) cache, 1);
 }
 
 static void __cpa_flush_range(void *arg)
@@ -162,7 +162,7 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	BUG_ON(irqs_disabled());
 	WARN_ON(PAGE_ALIGN(start) != start);
 
-	on_each_cpu(__cpa_flush_range, NULL, 1, 1);
+	on_each_cpu(__cpa_flush_range, NULL, 1);
 
 	if (!cache)
 		return;
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2b6ad5b..7f3329b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -218,8 +218,8 @@ static int nmi_setup(void)
 		}
 
 	}
-	on_each_cpu(nmi_save_registers, NULL, 0, 1);
-	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
+	on_each_cpu(nmi_save_registers, NULL, 1);
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
@@ -271,7 +271,7 @@ static void nmi_shutdown(void)
 {
 	struct op_msrs *msrs = &get_cpu_var(cpu_msrs);
 	nmi_enabled = 0;
-	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
 	model->shutdown(msrs);
 	free_msrs();
@@ -286,7 +286,7 @@ static void nmi_cpu_start(void *dummy)
 
 static int nmi_start(void)
 {
-	on_each_cpu(nmi_cpu_start, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_start, NULL, 1);
 	return 0;
 }
 
@@ -298,7 +298,7 @@ static void nmi_cpu_stop(void *dummy)
 
 static void nmi_stop(void)
 {
-	on_each_cpu(nmi_cpu_stop, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_stop, NULL, 1);
 }
 
 struct op_counter_config counter_config[OP_MAX_COUNTER];
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index a18141a..dbf5323 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -578,7 +578,7 @@ static int __init enable_pci_io_ecs(void)
 	/* assume all cpus from fam10h have IO ECS */
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
-	on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);
+	on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
 	pci_probe |= PCI_HAS_IO_ECS;
 	return 0;
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index dcd4e51..bb50845 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1214,7 +1214,9 @@ static const struct smp_ops xen_smp_ops __initdata = {
 
 	.smp_send_stop = xen_smp_send_stop,
 	.smp_send_reschedule = xen_smp_send_reschedule,
-	.smp_call_function_mask = xen_smp_call_function_mask,
+
+	.send_call_func_ipi = xen_smp_send_call_function_ipi,
+	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
 };
 #endif	/* CONFIG_SMP */
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 42b3b9e..ff0aa74 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -796,7 +796,7 @@ static void drop_mm_ref(struct mm_struct *mm)
 	}
 
 	if (!cpus_empty(mask))
-		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
+		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
 static void drop_mm_ref(struct mm_struct *mm)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index d2e3c20..233156f 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -36,27 +36,14 @@
 #include "mmu.h"
 
 cpumask_t xen_cpu_initialized_map;
-static DEFINE_PER_CPU(int, resched_irq) = -1;
-static DEFINE_PER_CPU(int, callfunc_irq) = -1;
-static DEFINE_PER_CPU(int, debug_irq) = -1;
-
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
 
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-};
+static DEFINE_PER_CPU(int, resched_irq);
+static DEFINE_PER_CPU(int, callfunc_irq);
+static DEFINE_PER_CPU(int, callfuncsingle_irq);
+static DEFINE_PER_CPU(int, debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
-
-static struct call_data_struct *call_data;
+static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 
 /*
  * Reschedule call back. Nothing to do,
@@ -128,6 +115,17 @@ static int xen_smp_intr_init(unsigned int cpu)
 		goto fail;
 	per_cpu(debug_irq, cpu) = rc;
 
+	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
+	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
+				    cpu,
+				    xen_call_function_single_interrupt,
+				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    callfunc_name,
+				    NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(callfuncsingle_irq, cpu) = rc;
+
 	return 0;
 
  fail:
@@ -137,6 +135,9 @@ static int xen_smp_intr_init(unsigned int cpu)
 		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
 	if (per_cpu(debug_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
+	if (per_cpu(callfuncsingle_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+
 	return rc;
 }
 
@@ -336,7 +337,7 @@ static void stop_self(void *v)
 
 void xen_smp_send_stop(void)
 {
-	smp_call_function(stop_self, NULL, 0, 0);
+	smp_call_function(stop_self, NULL, 0);
 }
 
 void xen_smp_send_reschedule(int cpu)
@@ -344,7 +345,6 @@ void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-
 static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 {
 	unsigned cpu;
@@ -355,83 +355,42 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 		xen_send_IPI_one(cpu, vector);
 }
 
+void xen_smp_send_call_function_ipi(cpumask_t mask)
+{
+	int cpu;
+
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+
+	/* Make sure other vcpus get a chance to run if they need to. */
+	for_each_cpu_mask(cpu, mask) {
+		if (xen_vcpu_stolen(cpu)) {
+			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			break;
+		}
+	}
+}
+
+void xen_smp_send_call_function_single_ipi(int cpu)
+{
+	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+}
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_interrupt();
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
 
-	if (wait) {
-		mb();		/* commit everything before setting finished */
-		atomic_inc(&call_data->finished);
-	}
-
 	return IRQ_HANDLED;
 }
 
-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-			       void *info, int wait)
+static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 {
-	struct call_data_struct data;
-	int cpus, cpu;
-	bool yield;
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-
-	cpu_clear(smp_processor_id(), mask);
-
-	cpus = cpus_weight(mask);
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();			/* write everything before IPI */
-
-	/* Send a message to other CPUs and wait for them to respond */
-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
-
-	/* Make sure other vcpus get a chance to run if they need to. */
-	yield = false;
-	for_each_cpu_mask(cpu, mask)
-		if (xen_vcpu_stolen(cpu))
-			yield = true;
-
-	if (yield)
-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus ||
-	       (wait && atomic_read(&data.finished) != cpus))
-		cpu_relax();
-
-	spin_unlock(&call_lock);
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 
-	return 0;
+	return IRQ_HANDLED;
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index d852ddb..6f4b104 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -55,13 +55,8 @@ void xen_smp_cpus_done(unsigned int max_cpus);
 
 void xen_smp_send_stop(void);
 void xen_smp_send_reschedule(int cpu);
-int xen_smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			   int wait);
-int xen_smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-				 int nonatomic, int wait);
-
-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-			       void *info, int wait);
+void xen_smp_send_call_function_ipi(cpumask_t mask);
+void xen_smp_send_call_function_single_ipi(int cpu);
 
 extern cpumask_t xen_cpu_initialized_map;
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 556ee15..4976e5d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1339,7 +1339,7 @@ static void smp_callback(void *v)
 static int acpi_processor_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 0, 1);
+	smp_call_function(smp_callback, NULL, 1);
 	return NOTIFY_OK;
 }
 
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 564daaa..eaa1a35 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1249,7 +1249,7 @@ static void ipi_handler(void *null)
 
 void global_cache_flush(void)
 {
-	if (on_each_cpu(ipi_handler, NULL, 1, 1) != 0)
+	if (on_each_cpu(ipi_handler, NULL, 1) != 0)
 		panic(PFX "timed out waiting for the other CPUs!\n");
 }
 EXPORT_SYMBOL(global_cache_flush);
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index dbce126..8fdfe9c 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -215,7 +215,7 @@ static void showacpu(void *dummy)
 
 static void sysrq_showregs_othercpus(struct work_struct *dummy)
 {
-	smp_call_function(showacpu, NULL, 0, 0);
+	smp_call_function(showacpu, NULL, 0);
 }
 
 static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 23554b6..5405769 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -340,7 +340,7 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 0, 1);
+	smp_call_function(smp_callback, NULL, 1);
 	return NOTIFY_OK;
 }
 
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 2e554a4..95dfda5 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -478,7 +478,7 @@ void __init lguest_arch_host_init(void)
 		cpu_had_pge = 1;
 		/* adjust_pge is a helper function which sets or unsets the PGE
 		 * bit on its CPU, depending on the argument (0 == unset). */
-		on_each_cpu(adjust_pge, (void *)0, 0, 1);
+		on_each_cpu(adjust_pge, (void *)0, 1);
 		/* Turn off the feature in the global feature set. */
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
@@ -493,7 +493,7 @@ void __exit lguest_arch_host_fini(void)
 	if (cpu_had_pge) {
 		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 		/* adjust_pge's argument "1" means set PGE. */
-		on_each_cpu(adjust_pge, (void *)1, 0, 1);
+		on_each_cpu(adjust_pge, (void *)1, 1);
 	}
 	put_online_cpus();
 }
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index c1ba0db..7708244 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -55,7 +55,7 @@ static void __booke_wdt_ping(void *data)
 
 static void booke_wdt_ping(void)
 {
-	on_each_cpu(__booke_wdt_ping, NULL, 0, 0);
+	on_each_cpu(__booke_wdt_ping, NULL, 0);
 }
 
 static void __booke_wdt_enable(void *data)
@@ -131,7 +131,7 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		on_each_cpu(__booke_wdt_enable, NULL, 0);
 		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
 				"(wdt_period=%d)\n", booke_wdt_period);
 	}
@@ -177,7 +177,7 @@ static int __init booke_wdt_init(void)
 	if (booke_wdt_enabled == 1) {
 		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
 				"(wdt_period=%d)\n", booke_wdt_period);
-		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 5fa1512..d48caee 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1464,7 +1464,7 @@ static void invalidate_bh_lru(void *arg)
 	
 void invalidate_bh_lrus(void)
 {
-	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
+	on_each_cpu(invalidate_bh_lru, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
diff --git a/include/asm-alpha/smp.h b/include/asm-alpha/smp.h
index 286e1d8..544c69a 100644
--- a/include/asm-alpha/smp.h
+++ b/include/asm-alpha/smp.h
@@ -47,12 +47,13 @@ extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 extern int smp_num_cpus;
 #define cpu_possible_map	cpu_present_map
 
-int smp_call_function_on_cpu(void (*func) (void *info), void *info,int retry, int wait, cpumask_t cpu);
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
 
 #else /* CONFIG_SMP */
 
 #define hard_smp_processor_id()		0
-#define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
+#define smp_call_function_on_cpu(func,info,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
 
diff --git a/include/asm-arm/smp.h b/include/asm-arm/smp.h
index af99636..7fffa24 100644
--- a/include/asm-arm/smp.h
+++ b/include/asm-arm/smp.h
@@ -101,6 +101,9 @@ extern void platform_cpu_die(unsigned int cpu);
 extern int platform_cpu_kill(unsigned int cpu);
 extern void platform_cpu_enable(unsigned int cpu);
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 /*
  * Local timer interrupt handling function (can be IPI'ed).
  */
diff --git a/include/asm-ia64/smp.h b/include/asm-ia64/smp.h
index ec5f355..27731e0 100644
--- a/include/asm-ia64/smp.h
+++ b/include/asm-ia64/smp.h
@@ -38,9 +38,6 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-				  void *info, int wait);
-
 #define hard_smp_processor_id()		ia64_get_lid()
 
 #ifdef CONFIG_SMP
@@ -124,11 +121,12 @@ extern void __init init_smp_config (void);
 extern void smp_do_timer (struct pt_regs *regs);
 
 extern void smp_send_reschedule (int cpu);
-extern void lock_ipi_calllock(void);
-extern void unlock_ipi_calllock(void);
 extern void identify_siblings (struct cpuinfo_ia64 *);
 extern int is_multithreading_enabled(void);
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 #else /* CONFIG_SMP */
 
 #define cpu_logical_id(i)		0
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index 078e1a5..c5dd669 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -89,6 +89,9 @@ static __inline__ unsigned int num_booting_cpus(void)
 extern void smp_send_timer(void);
 extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 #endif	/* not __ASSEMBLY__ */
 
 #define NO_PROC_ID (0xff)	/* No processor magic marker */
@@ -104,6 +107,7 @@ extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 #define LOCAL_TIMER_IPI		(M32R_IRQ_IPI3-M32R_IRQ_IPI0)
 #define INVALIDATE_CACHE_IPI	(M32R_IRQ_IPI4-M32R_IRQ_IPI0)
 #define CPU_BOOT_IPI		(M32R_IRQ_IPI5-M32R_IRQ_IPI0)
+#define CALL_FUNC_SINGLE_IPI	(M32R_IRQ_IPI6-M32R_IRQ_IPI0)
 
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
diff --git a/include/asm-mips/smp.h b/include/asm-mips/smp.h
index 84fef1a..0ff5b52 100644
--- a/include/asm-mips/smp.h
+++ b/include/asm-mips/smp.h
@@ -35,16 +35,6 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
-struct call_data_struct {
-	void		(*func)(void *);
-	void		*info;
-	atomic_t	started;
-	atomic_t	finished;
-	int		wait;
-};
-
-extern struct call_data_struct *call_data;
-
 #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
 #define SMP_CALL_FUNCTION	0x2
 
@@ -67,4 +57,7 @@ static inline void smp_send_reschedule(int cpu)
 
 extern asmlinkage void smp_call_function_interrupt(void);
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 #endif /* __ASM_SMP_H */
diff --git a/include/asm-parisc/smp.h b/include/asm-parisc/smp.h
index 306f495..398cdba 100644
--- a/include/asm-parisc/smp.h
+++ b/include/asm-parisc/smp.h
@@ -30,6 +30,9 @@ extern cpumask_t cpu_online_map;
 extern void smp_send_reschedule(int cpu);
 extern void smp_send_all_nop(void);
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 #endif /* !ASSEMBLY */
 
 /*
diff --git a/include/asm-powerpc/smp.h b/include/asm-powerpc/smp.h
index 505f35b..c663a1f 100644
--- a/include/asm-powerpc/smp.h
+++ b/include/asm-powerpc/smp.h
@@ -67,10 +67,7 @@ DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
  * in /proc/interrupts will be wrong!!! --Troy */
 #define PPC_MSG_CALL_FUNCTION   0
 #define PPC_MSG_RESCHEDULE      1
-/* This is unused now */
-#if 0
-#define PPC_MSG_MIGRATE_TASK    2
-#endif
+#define PPC_MSG_CALL_FUNC_SINGLE	2
 #define PPC_MSG_DEBUGGER_BREAK  3
 
 void smp_init_iSeries(void);
@@ -117,6 +114,9 @@ extern void smp_generic_take_timebase(void);
 
 extern struct smp_ops_t *smp_ops;
 
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sh/smp.h b/include/asm-sh/smp.h
index 9c8d34b..593343c 100644
--- a/include/asm-sh/smp.h
+++ b/include/asm-sh/smp.h
@@ -26,18 +26,10 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
-struct smp_fn_call_struct {
-	spinlock_t lock;
-	atomic_t   finished;
-	void (*fn)(void *);
-	void *data;
-};
-
-extern struct smp_fn_call_struct smp_fn_call;
-
 #define SMP_MSG_FUNCTION	0
 #define SMP_MSG_RESCHEDULE	1
-#define SMP_MSG_NR		2
+#define SMP_MSG_FUNCTION_SINGLE	2
+#define SMP_MSG_NR		3
 
 void plat_smp_setup(void);
 void plat_prepare_cpus(unsigned int max_cpus);
@@ -46,6 +38,8 @@ void plat_start_cpu(unsigned int cpu, unsigned long entry_point);
 void plat_send_ipi(unsigned int cpu, unsigned int message);
 int plat_register_ipi_handler(unsigned int message,
 			      void (*handler)(void *), void *arg);
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi(cpumask_t mask);
 
 #else
 
diff --git a/include/asm-sparc/smp.h b/include/asm-sparc/smp.h
index e6d5615..b61e74b 100644
--- a/include/asm-sparc/smp.h
+++ b/include/asm-sparc/smp.h
@@ -72,7 +72,7 @@ static inline void xc5(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4, unsigned long arg5)
 { smp_cross_call(func, arg1, arg2, arg3, arg4, arg5); }
 
-static inline int smp_call_function(void (*func)(void *info), void *info, int nonatomic, int wait)
+static inline int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
 	xc1((smpfunc_t)func, (unsigned long)info);
 	return 0;
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 18f067c..77ba51d 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -48,6 +48,7 @@ extern void irq_move_cleanup_interrupt(void);
 extern void threshold_interrupt(void);
 
 extern void call_function_interrupt(void);
+extern void call_function_single_interrupt(void);
 
 /* PIC specific functions */
 extern void disable_8259A_irq(unsigned int irq);
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 0ac864e..90b1d1f 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -64,6 +64,7 @@
 # define INVALIDATE_TLB_VECTOR		0xfd
 # define RESCHEDULE_VECTOR		0xfc
 # define CALL_FUNCTION_VECTOR		0xfb
+# define CALL_FUNCTION_SINGLE_VECTOR	0xfa
 # define THERMAL_APIC_VECTOR		0xf0
 
 #else
@@ -72,6 +73,7 @@
 #define ERROR_APIC_VECTOR		0xfe
 #define RESCHEDULE_VECTOR		0xfd
 #define CALL_FUNCTION_VECTOR		0xfc
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
 #define INVALIDATE_TLB_VECTOR_END	0xf7
@@ -143,6 +145,7 @@
 #define VIC_RESCHEDULE_CPI		4
 #define VIC_ENABLE_IRQ_CPI		5
 #define VIC_CALL_FUNCTION_CPI		6
+#define VIC_CALL_FUNCTION_SINGLE_CPI	7
 
 /* Now the QIC CPIs:  Since we don't need the two initial levels,
  * these are 2 less than the VIC CPIs */
@@ -152,9 +155,10 @@
 #define QIC_RESCHEDULE_CPI		(VIC_RESCHEDULE_CPI - QIC_CPI_OFFSET)
 #define QIC_ENABLE_IRQ_CPI		(VIC_ENABLE_IRQ_CPI - QIC_CPI_OFFSET)
 #define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_CPI - QIC_CPI_OFFSET)
+#define QIC_CALL_FUNCTION_SINGLE_CPI	(VIC_CALL_FUNCTION_SINGLE_CPI - QIC_CPI_OFFSET)
 
 #define VIC_START_FAKE_CPI		VIC_TIMER_CPI
-#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_CPI
+#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_SINGLE_CPI
 
 /* this is the SYS_INT CPI. */
 #define VIC_SYS_INT			8
diff --git a/include/asm-x86/mach-default/entry_arch.h b/include/asm-x86/mach-default/entry_arch.h
index bc86146..9283b60 100644
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -13,6 +13,7 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif
 
 /*
diff --git a/include/asm-x86/mach-visws/entry_arch.h b/include/asm-x86/mach-visws/entry_arch.h
index b183fa6..86be554 100644
--- a/include/asm-x86/mach-visws/entry_arch.h
+++ b/include/asm-x86/mach-visws/entry_arch.h
@@ -1,23 +1,5 @@
 /*
- * The following vectors are part of the Linux architecture, there
- * is no hardware IRQ pin equivalent for them, they are triggered
- * through the ICC by us (IPIs)
+ * VISWS uses the standard Linux entry points:
  */
-#ifdef CONFIG_X86_SMP
-BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
-BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
-#endif
 
-/*
- * every pentium local APIC has two 'local interrupts', with a
- * soft-definable vector attached to both interrupts, one of
- * which is a timer interrupt, the other one is error counter
- * overflow. Linux uses the local APIC timer interrupt to get
- * a much simpler SMP time architecture:
- */
-#ifdef CONFIG_X86_LOCAL_APIC
-BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
-BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
-BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
-#endif
+#include "../mach-default/entry_arch.h"
diff --git a/include/asm-x86/mach-voyager/entry_arch.h b/include/asm-x86/mach-voyager/entry_arch.h
index 4a1e1e8..ae52624 100644
--- a/include/asm-x86/mach-voyager/entry_arch.h
+++ b/include/asm-x86/mach-voyager/entry_arch.h
@@ -23,4 +23,4 @@ BUILD_INTERRUPT(qic_invalidate_interrupt, QIC_INVALIDATE_CPI);
 BUILD_INTERRUPT(qic_reschedule_interrupt, QIC_RESCHEDULE_CPI);
 BUILD_INTERRUPT(qic_enable_irq_interrupt, QIC_ENABLE_IRQ_CPI);
 BUILD_INTERRUPT(qic_call_function_interrupt, QIC_CALL_FUNCTION_CPI);
-
+BUILD_INTERRUPT(qic_call_function_single_interrupt, QIC_CALL_FUNCTION_SINGLE_CPI);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 2e221f1..c2784b3 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -50,9 +50,9 @@ struct smp_ops {
 
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
-	int (*smp_call_function_mask)(cpumask_t mask,
-				      void (*func)(void *info), void *info,
-				      int wait);
+
+	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_single_ipi)(int cpu);
 };
 
 /* Globals due to paravirt */
@@ -94,17 +94,22 @@ static inline void smp_send_reschedule(int cpu)
 	smp_ops.smp_send_reschedule(cpu);
 }
 
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
+static inline void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_ops.send_call_func_single_ipi(cpu);
+}
+
+static inline void arch_send_call_function_ipi(cpumask_t mask)
 {
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+	smp_ops.send_call_func_ipi(mask);
 }
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
+void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_single_ipi(int cpu);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
@@ -197,7 +202,5 @@ static inline int hard_smp_processor_id(void)
 extern void cpu_uninit(void);
 #endif
 
-extern void lock_ipi_call_lock(void);
-extern void unlock_ipi_call_lock(void);
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
index 596312a..f8d57ea 100644
--- a/include/asm-x86/xen/events.h
+++ b/include/asm-x86/xen/events.h
@@ -4,6 +4,7 @@
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
 	XEN_CALL_FUNCTION_VECTOR,
+	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 
 	XEN_NR_IPIS,
 };
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 55232cc..48262f8 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,9 +7,18 @@
  */
 
 #include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/cpumask.h>
 
 extern void cpu_idle(void);
 
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	unsigned int flags;
+};
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -52,15 +61,34 @@ extern void smp_cpus_done(unsigned int max_cpus);
 /*
  * Call a function on all other processors
  */
-int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
-
+int smp_call_function(void(*func)(void *info), void *info, int wait);
+int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
+				int wait);
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int retry, int wait);
+				int wait);
+void __smp_call_function_single(int cpuid, struct call_single_data *data);
+
+/*
+ * Generic and arch helpers
+ */
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
+void generic_smp_call_function_single_interrupt(void);
+void generic_smp_call_function_interrupt(void);
+void init_call_single_data(void);
+void ipi_call_lock(void);
+void ipi_call_unlock(void);
+void ipi_call_lock_irq(void);
+void ipi_call_unlock_irq(void);
+#else
+static inline void init_call_single_data(void)
+{
+}
+#endif
 
 /*
  * Call a function on all processors
  */
-int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
+int on_each_cpu(void (*func) (void *info), void *info, int wait);
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -90,9 +118,9 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 {
 	return 0;
 }
-#define smp_call_function(func, info, retry, wait) \
+#define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-#define on_each_cpu(func,info,retry,wait)	\
+#define on_each_cpu(func,info,wait)		\
 	({					\
 		local_irq_disable();		\
 		func(info);			\
@@ -102,7 +130,7 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_single(cpuid, func, info, retry, wait) \
+#define smp_call_function_single(cpuid, func, info, wait) \
 ({ \
 	WARN_ON(cpuid != 0);	\
 	local_irq_disable();	\
@@ -112,7 +140,9 @@ static inline void smp_send_reschedule(int cpu) { }
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-
+static inline void init_call_single_data(void)
+{
+}
 #endif /* !SMP */
 
 /*
diff --git a/init/main.c b/init/main.c
index f7fb200..1efcccf 100644
--- a/init/main.c
+++ b/init/main.c
@@ -31,6 +31,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/start_kernel.h>
 #include <linux/security.h>
+#include <linux/smp.h>
 #include <linux/workqueue.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
@@ -779,6 +780,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+	init_call_single_data();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/Makefile b/kernel/Makefile
index f6328e1..0a7ed83 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
+obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2913a8b..b8e4dce 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -622,7 +622,7 @@ static void retrigger_next_event(void *arg)
 void clock_was_set(void)
 {
 	/* Retrigger the CPU local events everywhere */
-	on_each_cpu(retrigger_next_event, NULL, 0, 1);
+	on_each_cpu(retrigger_next_event, NULL, 1);
 }
 
 /*
diff --git a/kernel/profile.c b/kernel/profile.c
index ae7ead8..5892641 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -252,7 +252,7 @@ static void profile_flip_buffers(void)
 	mutex_lock(&profile_flip_mutex);
 	j = per_cpu(cpu_profile_flip, get_cpu());
 	put_cpu();
-	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
+	on_each_cpu(__profile_flip_buffers, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[j];
 		for (i = 0; i < NR_PROFILE_HIT; ++i) {
@@ -275,7 +275,7 @@ static void profile_discard_flip_buffers(void)
 	mutex_lock(&profile_flip_mutex);
 	i = per_cpu(cpu_profile_flip, get_cpu());
 	put_cpu();
-	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
+	on_each_cpu(__profile_flip_buffers, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[i];
 		memset(hits, 0, NR_PROFILE_HIT*sizeof(struct profile_hit));
@@ -558,7 +558,7 @@ static int __init create_hash_tables(void)
 out_cleanup:
 	prof_on = 0;
 	smp_mb();
-	on_each_cpu(profile_nop, NULL, 0, 1);
+	on_each_cpu(profile_nop, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct page *page;
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index c09605f..6addab5 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -127,7 +127,7 @@ void rcu_barrier(void)
 	 * until all the callbacks are queued.
 	 */
 	rcu_read_lock();
-	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	on_each_cpu(rcu_barrier_func, NULL, 1);
 	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
diff --git a/kernel/smp.c b/kernel/smp.c
new file mode 100644
index 0000000..4f582b2
--- /dev/null
+++ b/kernel/smp.c
@@ -0,0 +1,381 @@
+/*
+ * Generic helpers for smp ipi calls
+ *
+ * (C) Jens Axboe <jens.axboe@oracle.com> 2008
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+#include <linux/smp.h>
+
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
+static LIST_HEAD(call_function_queue);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+
+enum {
+	CSD_FLAG_WAIT		= 0x01,
+	CSD_FLAG_ALLOC		= 0x02,
+};
+
+struct call_function_data {
+	struct call_single_data csd;
+	spinlock_t lock;
+	unsigned int refs;
+	cpumask_t cpumask;
+	struct rcu_head rcu_head;
+};
+
+struct call_single_queue {
+	struct list_head list;
+	spinlock_t lock;
+};
+
+void __cpuinit init_call_single_data(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct call_single_queue *q = &per_cpu(call_single_queue, i);
+
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->list);
+	}
+}
+
+static void csd_flag_wait(struct call_single_data *data)
+{
+	/* Wait for response */
+	do {
+		/*
+		 * We need to see the flags store in the IPI handler
+		 */
+		smp_mb();
+		if (!(data->flags & CSD_FLAG_WAIT))
+			break;
+		cpu_relax();
+	} while (1);
+}
+
+/*
+ * Insert a previously allocated call_single_data element for execution
+ * on the given CPU. data must already have ->func, ->info, and ->flags set.
+ */
+static void generic_exec_single(int cpu, struct call_single_data *data)
+{
+	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
+	int wait = data->flags & CSD_FLAG_WAIT, ipi;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dst->lock, flags);
+	ipi = list_empty(&dst->list);
+	list_add_tail(&data->list, &dst->list);
+	spin_unlock_irqrestore(&dst->lock, flags);
+
+	if (ipi)
+		arch_send_call_function_single_ipi(cpu);
+
+	if (wait)
+		csd_flag_wait(data);
+}
+
+static void rcu_free_call_data(struct rcu_head *head)
+{
+	struct call_function_data *data;
+
+	data = container_of(head, struct call_function_data, rcu_head);
+
+	kfree(data);
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function. Must be called with
+ * interrupts disabled.
+ */
+void generic_smp_call_function_interrupt(void)
+{
+	struct call_function_data *data;
+	int cpu = get_cpu();
+
+	/*
+	 * It's ok to use list_for_each_rcu() here even though we may delete
+	 * 'pos', since list_del_rcu() doesn't clear ->next
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
+		int refs;
+
+		if (!cpu_isset(cpu, data->cpumask))
+			continue;
+
+		data->csd.func(data->csd.info);
+
+		spin_lock(&data->lock);
+		cpu_clear(cpu, data->cpumask);
+		WARN_ON(data->refs == 0);
+		data->refs--;
+		refs = data->refs;
+		spin_unlock(&data->lock);
+
+		if (refs)
+			continue;
+
+		spin_lock(&call_function_lock);
+		list_del_rcu(&data->csd.list);
+		spin_unlock(&call_function_lock);
+
+		if (data->csd.flags & CSD_FLAG_WAIT) {
+			/*
+			 * serialize stores to data with the flag clear
+			 * and wakeup
+			 */
+			smp_wmb();
+			data->csd.flags &= ~CSD_FLAG_WAIT;
+		} else
+			call_rcu(&data->rcu_head, rcu_free_call_data);
+	}
+	rcu_read_unlock();
+
+	put_cpu();
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function single. Must be called
+ * from the arch with interrupts disabled.
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	LIST_HEAD(list);
+
+	/*
+	 * Need to see other stores to list head for checking whether
+	 * list is empty without holding q->lock
+	 */
+	smp_mb();
+	while (!list_empty(&q->list)) {
+		unsigned int data_flags;
+
+		spin_lock(&q->lock);
+		list_replace_init(&q->list, &list);
+		spin_unlock(&q->lock);
+
+		while (!list_empty(&list)) {
+			struct call_single_data *data;
+
+			data = list_entry(list.next, struct call_single_data,
+						list);
+			list_del(&data->list);
+
+			/*
+			 * 'data' can be invalid after this call if
+			 * flags == 0 (when called through
+			 * generic_exec_single(), so save them away before
+			 * making the call.
+			 */
+			data_flags = data->flags;
+
+			data->func(data->info);
+
+			if (data_flags & CSD_FLAG_WAIT) {
+				smp_wmb();
+				data->flags &= ~CSD_FLAG_WAIT;
+			} else if (data_flags & CSD_FLAG_ALLOC)
+				kfree(data);
+		}
+		/*
+		 * See comment on outer loop
+		 */
+		smp_mb();
+	}
+}
+
+/*
+ * smp_call_function_single - Run a function on a specific CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code. Note that @wait
+ * will be implicitly turned on in case of allocation failures, since
+ * we fall back to on-stack allocation.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int wait)
+{
+	struct call_single_data d;
+	unsigned long flags;
+	/* prevent preemption and reschedule on another processor */
+	int me = get_cpu();
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	if (cpu == me) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	} else {
+		struct call_single_data *data = NULL;
+
+		if (!wait) {
+			data = kmalloc(sizeof(*data), GFP_ATOMIC);
+			if (data)
+				data->flags = CSD_FLAG_ALLOC;
+		}
+		if (!data) {
+			data = &d;
+			data->flags = CSD_FLAG_WAIT;
+		}
+
+		data->func = func;
+		data->info = info;
+		generic_exec_single(cpu, data);
+	}
+
+	put_cpu();
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
+/**
+ * __smp_call_function_single(): Run a function on another CPU
+ * @cpu: The CPU to run on.
+ * @data: Pre-allocated and setup data structure
+ *
+ * Like smp_call_function_single(), but allow caller to pass in a pre-allocated
+ * data structure. Useful for embedding @data inside other structures, for
+ * instance.
+ *
+ */
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
+
+	generic_exec_single(cpu, data);
+}
+
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned. Note that @wait
+ * will be implicitly turned on in case of allocation failures, since
+ * we fall back to on-stack allocation.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler. Preemption
+ * must be disabled when calling this function.
+ */
+int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
+			   int wait)
+{
+	struct call_function_data d;
+	struct call_function_data *data = NULL;
+	cpumask_t allbutself;
+	unsigned long flags;
+	int cpu, num_cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	cpu = smp_processor_id();
+	allbutself = cpu_online_map;
+	cpu_clear(cpu, allbutself);
+	cpus_and(mask, mask, allbutself);
+	num_cpus = cpus_weight(mask);
+
+	/*
+	 * If zero CPUs, return. If just a single CPU, turn this request
+	 * into a targetted single call instead since it's faster.
+	 */
+	if (!num_cpus)
+		return 0;
+	else if (num_cpus == 1) {
+		cpu = first_cpu(mask);
+		return smp_call_function_single(cpu, func, info, wait);
+	}
+
+	if (!wait) {
+		data = kmalloc(sizeof(*data), GFP_ATOMIC);
+		if (data)
+			data->csd.flags = CSD_FLAG_ALLOC;
+	}
+	if (!data) {
+		data = &d;
+		data->csd.flags = CSD_FLAG_WAIT;
+	}
+
+	spin_lock_init(&data->lock);
+	data->csd.func = func;
+	data->csd.info = info;
+	data->refs = num_cpus;
+	data->cpumask = mask;
+
+	spin_lock_irqsave(&call_function_lock, flags);
+	list_add_tail_rcu(&data->csd.list, &call_function_queue);
+	spin_unlock_irqrestore(&call_function_lock, flags);
+
+	/* Send a message to all CPUs in the map */
+	arch_send_call_function_ipi(mask);
+
+	/* optionally wait for the CPUs to complete */
+	if (wait)
+		csd_flag_wait(&data->csd);
+
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_mask);
+
+/**
+ * smp_call_function(): Run a function on all other CPUs.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func. In case of allocation
+ * failure, @wait will be implicitly turned on.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function(void (*func)(void *), void *info, int wait)
+{
+	int ret;
+
+	preempt_disable();
+	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function);
+
+void ipi_call_lock(void)
+{
+	spin_lock(&call_function_lock);
+}
+
+void ipi_call_unlock(void)
+{
+	spin_unlock(&call_function_lock);
+}
+
+void ipi_call_lock_irq(void)
+{
+	spin_lock_irq(&call_function_lock);
+}
+
+void ipi_call_unlock_irq(void)
+{
+	spin_unlock_irq(&call_function_lock);
+}
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3e9e896..81e2fe0 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -645,12 +645,12 @@ __init int spawn_ksoftirqd(void)
 /*
  * Call a function on all processors
  */
-int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
+int on_each_cpu(void (*func) (void *info), void *info, int wait)
 {
 	int ret = 0;
 
 	preempt_disable();
-	ret = smp_call_function(func, info, retry, wait);
+	ret = smp_call_function(func, info, wait);
 	local_irq_disable();
 	func(info);
 	local_irq_enable();
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 67f80c2..f48d0f0 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -268,7 +268,7 @@ void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1, 1);
+					 &reason, 1);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f024b9b..79ac4af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -918,7 +918,7 @@ void drain_local_pages(void *arg)
  */
 void drain_all_pages(void)
 {
-	on_each_cpu(drain_local_pages, NULL, 0, 1);
+	on_each_cpu(drain_local_pages, NULL, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
diff --git a/mm/slab.c b/mm/slab.c
index b4aa4c8..052e7d6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2446,7 +2446,7 @@ static void drain_cpu_caches(struct kmem_cache *cachep)
 	struct kmem_list3 *l3;
 	int node;
 
-	on_each_cpu(do_drain, cachep, 1, 1);
+	on_each_cpu(do_drain, cachep, 1);
 	check_irq_on();
 	for_each_online_node(node) {
 		l3 = cachep->nodelists[node];
@@ -3931,7 +3931,7 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	}
 	new->cachep = cachep;
 
-	on_each_cpu(do_ccupdate_local, (void *)new, 1, 1);
+	on_each_cpu(do_ccupdate_local, (void *)new, 1);
 
 	check_irq_on();
 	cachep->batchcount = batchcount;
diff --git a/mm/slub.c b/mm/slub.c
index 488400d..35ab38a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1496,7 +1496,7 @@ static void flush_cpu_slab(void *d)
 static void flush_all(struct kmem_cache *s)
 {
 #ifdef CONFIG_SMP
-	on_each_cpu(flush_cpu_slab, s, 1, 1);
+	on_each_cpu(flush_cpu_slab, s, 1);
 #else
 	unsigned long flags;
 
diff --git a/net/core/flow.c b/net/core/flow.c
index 1999117..5cf8105 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -298,7 +298,7 @@ void flow_cache_flush(void)
 	init_completion(&info.completion);
 
 	local_bh_disable();
-	smp_call_function(flow_cache_flush_per_cpu, &info, 1, 0);
+	smp_call_function(flow_cache_flush_per_cpu, &info, 0);
 	flow_cache_flush_tasklet((unsigned long)&info);
 	local_bh_enable();
 
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 7f82b76..cc34ac7 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -480,7 +480,7 @@ static void iucv_setmask_mp(void)
 		if (cpu_isset(cpu, iucv_buffer_cpumask) &&
 		    !cpu_isset(cpu, iucv_irq_cpumask))
 			smp_call_function_single(cpu, iucv_allow_cpu,
-						 NULL, 0, 1);
+						 NULL, 1);
 	preempt_enable();
 }
 
@@ -498,7 +498,7 @@ static void iucv_setmask_up(void)
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
 	for_each_cpu_mask(cpu, cpumask)
-		smp_call_function_single(cpu, iucv_block_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 
 /**
@@ -523,7 +523,7 @@ static int iucv_enable(void)
 	rc = -EIO;
 	preempt_disable();
 	for_each_online_cpu(cpu)
-		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 1);
 	preempt_enable();
 	if (cpus_empty(iucv_buffer_cpumask))
 		/* No cpu could declare an iucv buffer. */
@@ -545,7 +545,7 @@ out:
  */
 static void iucv_disable(void)
 {
-	on_each_cpu(iucv_retrieve_cpu, NULL, 0, 1);
+	on_each_cpu(iucv_retrieve_cpu, NULL, 1);
 	kfree(iucv_path_table);
 }
 
@@ -580,7 +580,7 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 1);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -589,10 +589,10 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
 			return NOTIFY_BAD;
-		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
 		if (cpus_empty(iucv_irq_cpumask))
 			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
-						 iucv_allow_cpu, NULL, 0, 1);
+						 iucv_allow_cpu, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -652,7 +652,7 @@ static void iucv_cleanup_queue(void)
 	 * pending interrupts force them to the work queue by calling
 	 * an empty function on all cpus.
 	 */
-	smp_call_function(__iucv_cleanup_queue, NULL, 0, 1);
+	smp_call_function(__iucv_cleanup_queue, NULL, 1);
 	spin_lock_irq(&iucv_queue_lock);
 	list_for_each_entry_safe(p, n, &iucv_task_queue, list) {
 		/* Remove stale work items from the task queue. */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2d29e26..d4eae6a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1266,12 +1266,12 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_UP_CANCELED:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_disable, NULL, 1);
 		break;
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_enable, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -1286,7 +1286,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(hardware_disable, NULL, 0, 1);
+		on_each_cpu(hardware_disable, NULL, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -1474,12 +1474,12 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
 				kvm_arch_check_processor_compat,
-				&r, 0, 1);
+				&r, 1);
 		if (r < 0)
 			goto out_free_1;
 	}
 
-	on_each_cpu(hardware_enable, NULL, 0, 1);
+	on_each_cpu(hardware_enable, NULL, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_2;
@@ -1525,7 +1525,7 @@ out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_2:
-	on_each_cpu(hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 out_free_1:
 	kvm_arch_hardware_unsetup();
 out_free_0:
@@ -1547,7 +1547,7 @@ void kvm_exit(void)
 	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
-	on_each_cpu(hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	kvm_exit_debug();
