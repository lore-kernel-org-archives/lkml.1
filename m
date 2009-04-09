Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbZDISND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbZDISND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbZDISMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:12:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760920AbZDISMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:12:32 -0400
Date: Thu, 9 Apr 2009 20:10:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC GIT PULL (late)] Xen updates for v2.6.30
Message-ID: <20090409181039.GA605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Would you still be willing to pull pending Xen updates? They can be 
pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git xen-for-linus

These are late, delayed past the merge window due to the discussions 
around the DOM0 bits and due to an exceptionally busy merge window.

These are the uncontroversial bits separated out. 95% of the impact is 
in Xen guest support related files.

There's cross-arch API rename impact due to the change of context-switch 
notification callbacks, but x86 is the only user of that facility so it 
does not affect other architectures.

Beyond the usual x86 tests, i also ran a few cross-build tests as well 
and all arches that build on current upstream build fine on this tree 
too:

                                  warnings             warnings
 testing        arm:  -git:  pass (  30),  -tip:  pass (  30)
 testing       i386:  -git:  pass (   7),  -tip:  pass (   7)
 testing       m32r:  -git:  pass (  26),  -tip:  pass (  26)
 testing       m68k:  -git:  pass (  30),  -tip:  pass (  30)
 testing       mips:  -git:  pass (   2),  -tip:  pass (   2)
 testing    powerpc:  -git:  pass (  46),  -tip:  pass (  46)
 testing         sh:  -git:  pass (  30),  -tip:  pass (  30)
 testing      sparc:  -git:  pass (   0),  -tip:  pass (   2)

Thanks,

	Ingo

------------------>
Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Ian Campbell (8):
      xen: resume interrupts before system devices.
      xen: add irq_from_evtchn
      xen: add /dev/xen/evtchn driver
      xen: export ioctl headers to userspace
      xen: remove suspend_cancel hook
      xen: use device model for suspending xenbus devices
      xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet
      xen: honour VCPU availability on boot

Jeremy Fitzhardinge (27):
      mm: disable preemption in apply_to_pte_range
      x86/paravirt: remove lazy mode in interrupts
      x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
      x86/paravirt: flush pending mmu updates on context switch
      x86/paravirt: finish change from lazy cpu to context switch start/end
      x86/paravirt: allow preemption with lazy mmu mode
      mm: allow preemption in apply_to_pte_range
      x86/paravirt: use percpu_ rather than __get_cpu_var
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: mask XSAVE from cpuid
      x86-64: remove PGE from must-have feature list
      x86-64: non-paravirt systems always has PSE and PGE
      xen/mmu: some early pagetable cleanups
      xen/mmu: weaken flush_tlb_other test
      xen: set _PAGE_NX in __supported_pte_mask before pagetable construction
      xen: clean up gate trap/interrupt constants
      xen/dev-evtchn: clean up locking in evtchn
      xen/xenbus: export xenbus_dev_changed
      xen: add /sys/hypervisor support
      xen/sys/hypervisor: change writable_pt to features
      xen: add "capabilities" file
      lguest: update lazy mmu changes to match lguest's use of kvm hypercalls


 arch/x86/include/asm/paravirt.h          |   22 +-
 arch/x86/include/asm/pgtable.h           |    2 +
 arch/x86/include/asm/required-features.h |    8 +-
 arch/x86/include/asm/thread_info.h       |    4 +-
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/kernel/kvm.c                    |    2 +-
 arch/x86/kernel/paravirt.c               |   56 ++--
 arch/x86/kernel/process_32.c             |    2 +-
 arch/x86/kernel/process_64.c             |    2 +-
 arch/x86/kernel/vmi_32.c                 |   20 +-
 arch/x86/lguest/boot.c                   |   16 +-
 arch/x86/mm/fault.c                      |    6 +-
 arch/x86/mm/highmem_32.c                 |    2 -
 arch/x86/mm/iomap_32.c                   |    1 -
 arch/x86/mm/pageattr.c                   |   14 -
 arch/x86/xen/enlighten.c                 |   99 +++++--
 arch/x86/xen/mmu.c                       |  134 ++++++---
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 arch/x86/xen/xen-ops.h                   |    3 -
 drivers/xen/Kconfig                      |   20 ++
 drivers/xen/Makefile                     |    4 +-
 drivers/xen/cpu_hotplug.c                |   40 ++-
 drivers/xen/events.c                     |    6 +
 drivers/xen/evtchn.c                     |  507 ++++++++++++++++++++++++++++++
 drivers/xen/manage.c                     |   14 +-
 drivers/xen/sys-hypervisor.c             |  445 ++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c        |   61 +---
 drivers/xen/xenbus/xenbus_xs.c           |    2 +
 drivers/xen/xenfs/super.c                |   19 +-
 include/Kbuild                           |    1 +
 include/asm-frv/pgtable.h                |    4 +-
 include/asm-generic/pgtable.h            |   21 +-
 include/xen/Kbuild                       |    1 +
 include/xen/events.h                     |    3 +
 include/xen/evtchn.h                     |   88 +++++
 include/xen/interface/version.h          |    3 +
 include/xen/xenbus.h                     |    3 +-
 kernel/sched.c                           |    2 +-
 39 files changed, 1407 insertions(+), 240 deletions(-)
 create mode 100644 drivers/xen/evtchn.c
 create mode 100644 drivers/xen/sys-hypervisor.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/evtchn.h

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..bc384be 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -56,6 +56,7 @@ struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
+struct task_struct;
 
 /*
  * Wrapper type for pointers to code which uses the non-standard
@@ -203,7 +204,8 @@ struct pv_cpu_ops {
 
 	void (*swapgs)(void);
 
-	struct pv_lazy_ops lazy_mode;
+	void (*start_context_switch)(struct task_struct *prev);
+	void (*end_context_switch)(struct task_struct *next);
 };
 
 struct pv_irq_ops {
@@ -1399,25 +1401,23 @@ enum paravirt_lazy_mode {
 };
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
-void paravirt_enter_lazy_cpu(void);
-void paravirt_leave_lazy_cpu(void);
+void paravirt_start_context_switch(struct task_struct *prev);
+void paravirt_end_context_switch(struct task_struct *next);
+
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
 
-#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-static inline void arch_enter_lazy_cpu_mode(void)
+#define  __HAVE_ARCH_START_CONTEXT_SWITCH
+static inline void arch_start_context_switch(struct task_struct *prev)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.enter);
+	PVOP_VCALL1(pv_cpu_ops.start_context_switch, prev);
 }
 
-static inline void arch_leave_lazy_cpu_mode(void)
+static inline void arch_end_context_switch(struct task_struct *next)
 {
-	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
+	PVOP_VCALL1(pv_cpu_ops.end_context_switch, next);
 }
 
-void arch_flush_lazy_cpu_mode(void);
-
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 29d96d1..b27c4f2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -81,6 +81,8 @@ static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
+#define arch_end_context_switch(prev)	do {} while(0)
+
 #endif	/* CONFIG_PARAVIRT */
 
 /*
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index d5cd6c5..64cf2d2 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -48,9 +48,15 @@
 #endif
 
 #ifdef CONFIG_X86_64
+#ifdef CONFIG_PARAVIRT
+/* Paravirtualized systems may not have PSE or PGE available */
 #define NEED_PSE	0
+#define NEED_PGE	0
+#else
+#define NEED_PSE	(1<<(X86_FEATURE_PSE) & 31)
+#define NEED_PGE	(1<<(X86_FEATURE_PGE) & 31)
+#endif
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
-#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8820a73..602c769 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -94,7 +94,8 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
-#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
+#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
+#define TIF_SYSCALL_FTRACE	28	/* for ftrace syscall instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -116,6 +117,7 @@ struct thread_info {
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
 
 /* work to do in syscall_trace_enter() */
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 1a918dd..018a0a4 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -124,7 +124,8 @@ static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 
 /* VIRT <-> MACHINE conversion */
 #define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
+#define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
 #define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
 static inline unsigned long pte_mfn(pte_t pte)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33019dd..6551ded 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -195,7 +195,7 @@ static void kvm_leave_lazy_mmu(void)
 	struct kvm_para_state *state = kvm_para_state();
 
 	mmu_queue_flush(state);
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	paravirt_leave_lazy_mmu();
 	state->mode = paravirt_get_lazy_mode();
 }
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8e45f44..aa34423 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -246,18 +246,16 @@ static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LA
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
-	BUG_ON(preemptible());
+	BUG_ON(percpu_read(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 
-	__get_cpu_var(paravirt_lazy_mode) = mode;
+	percpu_write(paravirt_lazy_mode, mode);
 }
 
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+static void leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
-	BUG_ON(preemptible());
+	BUG_ON(percpu_read(paravirt_lazy_mode) != mode);
 
-	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+	percpu_write(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -267,22 +265,36 @@ void paravirt_enter_lazy_mmu(void)
 
 void paravirt_leave_lazy_mmu(void)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
+	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
-void paravirt_enter_lazy_cpu(void)
+void paravirt_start_context_switch(struct task_struct *prev)
 {
+	BUG_ON(preemptible());
+
+	if (percpu_read(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
+	}
 	enter_lazy(PARAVIRT_LAZY_CPU);
 }
 
-void paravirt_leave_lazy_cpu(void)
+void paravirt_end_context_switch(struct task_struct *next)
 {
-	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
+	BUG_ON(preemptible());
+
+	leave_lazy(PARAVIRT_LAZY_CPU);
+
+	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
+		arch_enter_lazy_mmu_mode();
 }
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 {
-	return __get_cpu_var(paravirt_lazy_mode);
+	if (in_interrupt())
+		return PARAVIRT_LAZY_NONE;
+
+	return percpu_read(paravirt_lazy_mode);
 }
 
 void arch_flush_lazy_mmu_mode(void)
@@ -290,7 +302,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_disable();
 
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		WARN_ON(preempt_count() == 1);
 		arch_leave_lazy_mmu_mode();
 		arch_enter_lazy_mmu_mode();
 	}
@@ -298,19 +309,6 @@ void arch_flush_lazy_mmu_mode(void)
 	preempt_enable();
 }
 
-void arch_flush_lazy_cpu_mode(void)
-{
-	preempt_disable();
-
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
-		WARN_ON(preempt_count() == 1);
-		arch_leave_lazy_cpu_mode();
-		arch_enter_lazy_cpu_mode();
-	}
-
-	preempt_enable();
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -402,10 +400,8 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
 
-	.lazy_mode = {
-		.enter = paravirt_nop,
-		.leave = paravirt_nop,
-	},
+	.start_context_switch = paravirt_nop,
+	.end_context_switch = paravirt_nop,
 };
 
 struct pv_apic_ops pv_apic_ops = {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..5de30f0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -407,7 +407,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch(next_p);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..66ad067 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -428,7 +428,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * done before math_state_restore, so the TS bit is up
 	 * to date.
 	 */
-	arch_leave_lazy_cpu_mode();
+	arch_end_context_switch(next_p);
 
 	/*
 	 * Switch FS and GS.
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 95deb9f..b263423 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -462,22 +462,28 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 }
 #endif
 
-static void vmi_enter_lazy_cpu(void)
+static void vmi_start_context_switch(struct task_struct *prev)
 {
-	paravirt_enter_lazy_cpu();
+	paravirt_start_context_switch(prev);
 	vmi_ops.set_lazy_mode(2);
 }
 
+static void vmi_end_context_switch(struct task_struct *next)
+{
+	vmi_ops.set_lazy_mode(0);
+	paravirt_end_context_switch(next);
+}
+
 static void vmi_enter_lazy_mmu(void)
 {
 	paravirt_enter_lazy_mmu();
 	vmi_ops.set_lazy_mode(1);
 }
 
-static void vmi_leave_lazy(void)
+static void vmi_leave_lazy_mmu(void)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	vmi_ops.set_lazy_mode(0);
+	paravirt_leave_lazy_mmu();
 }
 
 static inline int __init check_vmi_rom(struct vrom_header *rom)
@@ -711,14 +717,14 @@ static inline int __init activate_vmi(void)
 	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
 	para_fill(pv_cpu_ops.io_delay, IODelay);
 
-	para_wrap(pv_cpu_ops.lazy_mode.enter, vmi_enter_lazy_cpu,
+	para_wrap(pv_cpu_ops.start_context_switch, vmi_start_context_switch,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_cpu_ops.end_context_switch, vmi_end_context_switch,
 		  set_lazy_mode, SetLazyMode);
 
 	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy,
+	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy_mmu,
 		  set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index e94a11e..cfb2d68 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -166,10 +166,16 @@ static void lazy_hcall3(unsigned long call,
 
 /* When lazy mode is turned off reset the per-cpu lazy mode variable and then
  * issue the do-nothing hypercall to flush any stored calls. */
-static void lguest_leave_lazy_mode(void)
+static void lguest_leave_lazy_mmu_mode(void)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	kvm_hypercall0(LHCALL_FLUSH_ASYNC);
+	paravirt_leave_lazy_mmu();
+}
+
+static void lguest_end_context_switch(struct task_struct *next)
+{
+	kvm_hypercall0(LHCALL_FLUSH_ASYNC);
+	paravirt_end_context_switch(next);
 }
 
 /*G:033
@@ -1051,8 +1057,8 @@ __init void lguest_init(void)
 	pv_cpu_ops.write_gdt_entry = lguest_write_gdt_entry;
 	pv_cpu_ops.write_idt_entry = lguest_write_idt_entry;
 	pv_cpu_ops.wbinvd = lguest_wbinvd;
-	pv_cpu_ops.lazy_mode.enter = paravirt_enter_lazy_cpu;
-	pv_cpu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_cpu_ops.start_context_switch = paravirt_start_context_switch;
+	pv_cpu_ops.end_context_switch = lguest_end_context_switch;
 
 	/* pagetable management */
 	pv_mmu_ops.write_cr3 = lguest_write_cr3;
@@ -1065,7 +1071,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr2 = lguest_read_cr2;
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
-	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
 	pv_mmu_ops.pte_update = lguest_pte_update;
 	pv_mmu_ops.pte_update_defer = lguest_pte_update;
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..cfbb4a7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -225,12 +225,10 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	if (!pmd_present(*pmd_k))
 		return NULL;
 
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
-		arch_flush_lazy_mmu_mode();
-	} else {
+	else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
-	}
 
 	return pmd_k;
 }
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 8126e8d..58f621e 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -44,7 +44,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -74,7 +73,6 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 #endif
 	}
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 8056545..fe6f84c 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -82,7 +82,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..660cac7 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -844,13 +844,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	vm_unmap_aliases();
 
-	/*
-	 * If we're called with lazy mmu updates enabled, the
-	 * in-memory pte state may be stale.  Flush pending updates to
-	 * bring them up to date.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 	cpa.vaddr = addr;
 	cpa.pages = pages;
 	cpa.numpages = numpages;
@@ -895,13 +888,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	} else
 		cpa_flush_all(cache);
 
-	/*
-	 * If we've been called with lazy mmu updates enabled, then
-	 * make sure that everything gets flushed out before we
-	 * return.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 out:
 	return ret;
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 82cd39a..12a3159 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -42,6 +42,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/fixmap.h>
 #include <asm/processor.h>
+#include <asm/proto.h>
 #include <asm/msr-index.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
@@ -168,21 +169,23 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
+static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
+static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
+
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		      unsigned int *cx, unsigned int *dx)
 {
+	unsigned maskecx = ~0;
 	unsigned maskedx = ~0;
 
 	/*
 	 * Mask out inconvenient features, to try and disable as many
 	 * unsupported kernel subsystems as possible.
 	 */
-	if (*ax == 1)
-		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
-			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
-			    (1 << X86_FEATURE_MCE)  |  /* disable MCE */
-			    (1 << X86_FEATURE_MCA)  |  /* disable MCA */
-			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+	if (*ax == 1) {
+		maskecx = cpuid_leaf1_ecx_mask;
+		maskedx = cpuid_leaf1_edx_mask;
+	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
 		: "=a" (*ax),
@@ -190,9 +193,43 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		  "=c" (*cx),
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
+
+	*cx &= maskecx;
 	*dx &= maskedx;
 }
 
+static __init void xen_init_cpuid_mask(void)
+{
+	unsigned int ax, bx, cx, dx;
+
+	cpuid_leaf1_edx_mask =
+		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
+		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
+		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+
+	if (!xen_initial_domain())
+		cpuid_leaf1_edx_mask &=
+			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
+			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
+
+	ax = 1;
+	xen_cpuid(&ax, &bx, &cx, &dx);
+
+	/* cpuid claims we support xsave; try enabling it to see what happens */
+	if (cx & (1 << (X86_FEATURE_XSAVE % 32))) {
+		unsigned long cr4;
+
+		set_in_cr4(X86_CR4_OSXSAVE);
+		
+		cr4 = read_cr4();
+
+		if ((cr4 & X86_CR4_OSXSAVE) == 0)
+			cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_XSAVE % 32));
+
+		clear_in_cr4(X86_CR4_OSXSAVE);
+	}
+}
+
 static void xen_set_debugreg(int reg, unsigned long val)
 {
 	HYPERVISOR_set_debugreg(reg, val);
@@ -203,10 +240,10 @@ static unsigned long xen_get_debugreg(int reg)
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-void xen_leave_lazy(void)
+static void xen_end_context_switch(struct task_struct *next)
 {
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	xen_mc_flush();
+	paravirt_end_context_switch(next);
 }
 
 static unsigned long xen_store_tr(void)
@@ -284,12 +321,11 @@ static void xen_set_ldt(const void *addr, unsigned entries)
 
 static void xen_load_gdt(const struct desc_ptr *dtr)
 {
-	unsigned long *frames;
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
 	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned long frames[pages];
 	int f;
-	struct multicall_space mcs;
 
 	/* A GDT can be up to 64k in size, which corresponds to 8192
 	   8-byte entries, or 16 4k pages.. */
@@ -297,19 +333,26 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	BUG_ON(size > 65536);
 	BUG_ON(va & ~PAGE_MASK);
 
-	mcs = xen_mc_entry(sizeof(*frames) * pages);
-	frames = mcs.args;
-
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
-		frames[f] = arbitrary_virt_to_mfn((void *)va);
+		int level;
+		pte_t *ptep = lookup_address(va, &level);
+		unsigned long pfn, mfn;
+		void *virt;
+
+		BUG_ON(ptep == NULL);
+
+		pfn = pte_pfn(*ptep);
+		mfn = pfn_to_mfn(pfn);
+		virt = __va(PFN_PHYS(pfn));
+
+		frames[f] = mfn;
 
 		make_lowmem_page_readonly((void *)va);
-		make_lowmem_page_readonly(mfn_to_virt(frames[f]));
+		make_lowmem_page_readonly(virt);
 	}
 
-	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
-
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
+	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
+		BUG();
 }
 
 static void load_TLS_descriptor(struct thread_struct *t,
@@ -385,7 +428,7 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 static int cvt_gate_to_trap(int vector, const gate_desc *val,
 			    struct trap_info *info)
 {
-	if (val->type != 0xf && val->type != 0xe)
+	if (val->type != GATE_TRAP && val->type != GATE_INTERRUPT)
 		return 0;
 
 	info->vector = vector;
@@ -393,8 +436,8 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 	info->cs = gate_segment(*val);
 	info->flags = val->dpl;
 	/* interrupt gates clear IF */
-	if (val->type == 0xe)
-		info->flags |= 4;
+	if (val->type == GATE_INTERRUPT)
+		info->flags |= 1 << 2;
 
 	return 1;
 }
@@ -817,10 +860,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	/* Xen takes care of %gs when switching to usermode for us */
 	.swapgs = paravirt_nop,
 
-	.lazy_mode = {
-		.enter = paravirt_enter_lazy_cpu,
-		.leave = xen_leave_lazy,
-	},
+	.start_context_switch = paravirt_start_context_switch,
+	.end_context_switch = xen_end_context_switch,
 };
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
@@ -872,7 +913,6 @@ static const struct machine_ops __initdata xen_machine_ops = {
 	.emergency_restart = xen_emergency_restart,
 };
 
-
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -897,6 +937,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_init_irq_ops();
 
+	xen_init_cpuid_mask();
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * set up the basic apic ops.
@@ -938,6 +980,11 @@ asmlinkage void __init xen_start_kernel(void)
 	if (!xen_initial_domain())
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
+#ifdef CONFIG_X86_64
+	/* Work out if we support NX */
+	check_efer();
+#endif
+
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..77b242c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -184,7 +184,7 @@ static inline unsigned p2m_index(unsigned long pfn)
 }
 
 /* Build the parallel p2m_top_mfn structures */
-void xen_setup_mfn_list_list(void)
+static void __init xen_build_mfn_list_list(void)
 {
 	unsigned pfn, idx;
 
@@ -198,7 +198,10 @@ void xen_setup_mfn_list_list(void)
 		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
 		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
 	}
+}
 
+void xen_setup_mfn_list_list(void)
+{
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
@@ -218,6 +221,8 @@ void __init xen_build_dynamic_phys_to_machine(void)
 
 		p2m_top[topidx] = &mfn_list[pfn];
 	}
+
+	xen_build_mfn_list_list();
 }
 
 unsigned long get_phys_to_machine(unsigned long pfn)
@@ -233,47 +238,74 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
-static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
+/* install a  new p2m_top page */
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p)
 {
-	unsigned long *p;
+	unsigned topidx = p2m_top_index(pfn);
+	unsigned long **pfnp, *mfnp;
 	unsigned i;
 
-	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
-	BUG_ON(p == NULL);
+	pfnp = &p2m_top[topidx];
+	mfnp = &p2m_top_mfn[topidx];
 
 	for (i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
 		p[i] = INVALID_P2M_ENTRY;
 
-	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
-		free_page((unsigned long)p);
-	else
+	if (cmpxchg(pfnp, p2m_missing, p) == p2m_missing) {
 		*mfnp = virt_to_mfn(p);
+		return true;
+	}
+
+	return false;
 }
 
-void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+static void alloc_p2m(unsigned long pfn)
 {
-	unsigned topidx, idx;
+	unsigned long *p;
 
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
+	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
+	BUG_ON(p == NULL);
+
+	if (!install_p2mtop_page(pfn, p))
+		free_page((unsigned long)p);
+}
+
+/* Try to install p2m mapping; fail if intermediate bits missing */
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	unsigned topidx, idx;
 
 	if (unlikely(pfn >= MAX_DOMAIN_PAGES)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
-		return;
+		return true;
 	}
 
 	topidx = p2m_top_index(pfn);
 	if (p2m_top[topidx] == p2m_missing) {
-		/* no need to allocate a page to store an invalid entry */
 		if (mfn == INVALID_P2M_ENTRY)
-			return;
-		alloc_p2m(&p2m_top[topidx], &p2m_top_mfn[topidx]);
+			return true;
+		return false;
 	}
 
 	idx = p2m_index(pfn);
 	p2m_top[topidx][idx] = mfn;
+
+	return true;
+}
+
+void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		alloc_p2m(pfn);
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			BUG();
+	}
 }
 
 unsigned long arbitrary_virt_to_mfn(void *vaddr)
@@ -419,10 +451,6 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	/* updates to init_mm may be done without lock */
-	if (mm == &init_mm)
-		preempt_disable();
-
 	ADD_STATS(set_pte_at, 1);
 //	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
 	ADD_STATS(set_pte_at_current, mm == current->mm);
@@ -443,9 +471,7 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 	}
 	xen_set_pte(ptep, pteval);
 
-out:
-	if (mm == &init_mm)
-		preempt_enable();
+out:	return;
 }
 
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
@@ -987,7 +1013,7 @@ static __init int xen_mark_pinned(struct mm_struct *mm, struct page *page,
 	return 0;
 }
 
-void __init xen_mark_init_mm_pinned(void)
+static void __init xen_mark_init_mm_pinned(void)
 {
 	xen_pgd_walk(&init_mm, xen_mark_pinned, FIXADDR_TOP);
 }
@@ -1119,10 +1145,8 @@ static void drop_other_mm_ref(void *info)
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (percpu_read(xen_current_cr3) == __pa(mm->pgd)) {
+	if (percpu_read(xen_current_cr3) == __pa(mm->pgd))
 		load_cr3(swapper_pg_dir);
-		arch_flush_lazy_cpu_mode();
-	}
 }
 
 static void xen_drop_mm_ref(struct mm_struct *mm)
@@ -1135,7 +1159,6 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 			load_cr3(swapper_pg_dir);
 		else
 			leave_mm(smp_processor_id());
-		arch_flush_lazy_cpu_mode();
 	}
 
 	/* Get the "official" set of cpus referring to our pagetable. */
@@ -1270,8 +1293,8 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	} *args;
 	struct multicall_space mcs;
 
-	BUG_ON(cpumask_empty(cpus));
-	BUG_ON(!mm);
+	if (cpumask_empty(cpus))
+		return;		/* nothing to do */
 
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;
@@ -1438,6 +1461,15 @@ static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
 }
 #endif
 
+static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+{
+	struct mmuext_op op;
+	op.cmd = cmd;
+	op.arg1.mfn = pfn_to_mfn(pfn);
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
 static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
@@ -1446,22 +1478,29 @@ static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
 	BUG_ON(mem_map);	/* should only be used early */
 #endif
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+	pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+}
+
+/* Used for pmd and pud */
+static __init void xen_alloc_pmd_init(struct mm_struct *mm, unsigned long pfn)
+{
+#ifdef CONFIG_FLATMEM
+	BUG_ON(mem_map);	/* should only be used early */
+#endif
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
 /* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static void xen_release_pte_init(unsigned long pfn)
+static __init void xen_release_pte_init(unsigned long pfn)
 {
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
-static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+static __init void xen_release_pmd_init(unsigned long pfn)
 {
-	struct mmuext_op op;
-	op.cmd = cmd;
-	op.arg1.mfn = pfn_to_mfn(pfn);
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
 /* This needs to make sure the new pte page is pinned iff its being
@@ -1819,6 +1858,13 @@ __init void xen_post_allocator_init(void)
 	xen_mark_init_mm_pinned();
 }
 
+static void xen_leave_lazy_mmu(void)
+{
+	preempt_disable();
+	xen_mc_flush();
+	paravirt_leave_lazy_mmu();
+	preempt_enable();
+}
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pagetable_setup_start = xen_pagetable_setup_start,
@@ -1843,9 +1889,9 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
-	.alloc_pmd = xen_alloc_pte_init,
+	.alloc_pmd = xen_alloc_pmd_init,
 	.alloc_pmd_clone = paravirt_nop,
-	.release_pmd = xen_release_pte_init,
+	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
@@ -1883,8 +1929,8 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.make_pud = PV_CALLEE_SAVE(xen_make_pud),
 	.set_pgd = xen_set_pgd_hyper,
 
-	.alloc_pud = xen_alloc_pte_init,
-	.release_pud = xen_release_pte_init,
+	.alloc_pud = xen_alloc_pmd_init,
+	.release_pud = xen_release_pmd_init,
 #endif	/* PAGETABLE_LEVELS == 4 */
 
 	.activate_mm = xen_activate_mm,
@@ -1893,7 +1939,7 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
-		.leave = xen_leave_lazy,
+		.leave = xen_leave_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 24d1b44..da73026 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -11,6 +11,9 @@ enum pt_level {
 };
 
 
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p);
+
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 585a6e3..429834e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -317,7 +317,7 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	BUG_ON(rc);
 
 	while(per_cpu(cpu_state, cpu) != CPU_ONLINE) {
-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+		HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 		barrier();
 	}
 
@@ -422,7 +422,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
-			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 			break;
 		}
 	}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 2f5ef26..5c50a10 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -30,7 +30,6 @@ pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
 
-void xen_leave_lazy(void);
 void xen_post_allocator_init(void);
 
 char * __init xen_memory_setup(void);
@@ -57,8 +56,6 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
 bool xen_vcpu_stolen(int vcpu);
 
-void xen_mark_init_mm_pinned(void);
-
 void xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 8ac9cdd..cab100a 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -18,6 +18,16 @@ config XEN_SCRUB_PAGES
 	  secure, but slightly less efficient.
 	  If in doubt, say yes.
 
+config XEN_DEV_EVTCHN
+	tristate "Xen /dev/xen/evtchn device"
+	depends on XEN
+	default y
+	help
+	  The evtchn driver allows a userspace process to triger event
+	  channels and to receive notification of an event channel
+	  firing.
+	  If in doubt, say yes.
+
 config XENFS
 	tristate "Xen filesystem"
 	depends on XEN
@@ -41,3 +51,13 @@ config XEN_COMPAT_XENFS
          a xen platform.
          If in doubt, say yes.
 
+config XEN_SYS_HYPERVISOR
+       bool "Create xen entries under /sys/hypervisor"
+       depends on XEN && SYSFS
+       select SYS_HYPERVISOR
+       default y
+       help
+         Create entries under /sys/hypervisor describing the Xen
+	 hypervisor environment.  When running native or in another
+	 virtual environment, /sys/hypervisor will still be present,
+	 but will have no xen contents.
\ No newline at end of file
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index ff8accc..ec2a39b 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -4,4 +4,6 @@ obj-y	+= xenbus/
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
-obj-$(CONFIG_XENFS)		+= xenfs/
\ No newline at end of file
+obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
+obj-$(CONFIG_XENFS)		+= xenfs/
+obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
\ No newline at end of file
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 5f54c01..bdfd584 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -21,29 +21,41 @@ static void disable_hotplug_cpu(int cpu)
 	set_cpu_present(cpu, false);
 }
 
-static void vcpu_hotplug(unsigned int cpu)
+static int vcpu_online(unsigned int cpu)
 {
 	int err;
 	char dir[32], state[32];
 
-	if (!cpu_possible(cpu))
-		return;
-
 	sprintf(dir, "cpu/%u", cpu);
 	err = xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
 	if (err != 1) {
 		printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
-		return;
+		return err;
 	}
 
-	if (strcmp(state, "online") == 0) {
+	if (strcmp(state, "online") == 0)
+		return 1;
+	else if (strcmp(state, "offline") == 0)
+		return 0;
+
+	printk(KERN_ERR "XENBUS: unknown state(%s) on CPU%d\n", state, cpu);
+	return -EINVAL;
+}
+static void vcpu_hotplug(unsigned int cpu)
+{
+	if (!cpu_possible(cpu))
+		return;
+
+	switch (vcpu_online(cpu)) {
+	case 1:
 		enable_hotplug_cpu(cpu);
-	} else if (strcmp(state, "offline") == 0) {
+		break;
+	case 0:
 		(void)cpu_down(cpu);
 		disable_hotplug_cpu(cpu);
-	} else {
-		printk(KERN_ERR "XENBUS: unknown state(%s) on CPU%d\n",
-		       state, cpu);
+		break;
+	default:
+		break;
 	}
 }
 
@@ -64,12 +76,20 @@ static void handle_vcpu_hotplug_event(struct xenbus_watch *watch,
 static int setup_cpu_watcher(struct notifier_block *notifier,
 			      unsigned long event, void *data)
 {
+	int cpu;
 	static struct xenbus_watch cpu_watch = {
 		.node = "cpu",
 		.callback = handle_vcpu_hotplug_event};
 
 	(void)register_xenbus_watch(&cpu_watch);
 
+	for_each_possible_cpu(cpu) {
+		if (vcpu_online(cpu) == 0) {
+			(void)cpu_down(cpu);
+			cpu_clear(cpu, cpu_present_map);
+		}
+	}
+
 	return NOTIFY_DONE;
 }
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..1cd2a0e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -151,6 +151,12 @@ static unsigned int evtchn_from_irq(unsigned irq)
 	return info_for_irq(irq)->evtchn;
 }
 
+unsigned irq_from_evtchn(unsigned int evtchn)
+{
+	return evtchn_to_irq[evtchn];
+}
+EXPORT_SYMBOL_GPL(irq_from_evtchn);
+
 static enum ipi_vector ipi_from_irq(unsigned irq)
 {
 	struct irq_info *info = info_for_irq(irq);
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
new file mode 100644
index 0000000..af03195
--- /dev/null
+++ b/drivers/xen/evtchn.c
@@ -0,0 +1,507 @@
+/******************************************************************************
+ * evtchn.c
+ *
+ * Driver for receiving and demuxing event-channel signals.
+ *
+ * Copyright (c) 2004-2005, K A Fraser
+ * Multi-process extensions Copyright (c) 2004, Steven Smith
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/major.h>
+#include <linux/proc_fs.h>
+#include <linux/stat.h>
+#include <linux/poll.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/gfp.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <xen/events.h>
+#include <xen/evtchn.h>
+#include <asm/xen/hypervisor.h>
+
+struct per_user_data {
+	struct mutex bind_mutex; /* serialize bind/unbind operations */
+
+	/* Notification ring, accessed via /dev/xen/evtchn. */
+#define EVTCHN_RING_SIZE     (PAGE_SIZE / sizeof(evtchn_port_t))
+#define EVTCHN_RING_MASK(_i) ((_i)&(EVTCHN_RING_SIZE-1))
+	evtchn_port_t *ring;
+	unsigned int ring_cons, ring_prod, ring_overflow;
+	struct mutex ring_cons_mutex; /* protect against concurrent readers */
+
+	/* Processes wait on this queue when ring is empty. */
+	wait_queue_head_t evtchn_wait;
+	struct fasync_struct *evtchn_async_queue;
+	const char *name;
+};
+
+/* Who's bound to each port? */
+static struct per_user_data *port_user[NR_EVENT_CHANNELS];
+static DEFINE_SPINLOCK(port_user_lock); /* protects port_user[] and ring_prod */
+
+irqreturn_t evtchn_interrupt(int irq, void *data)
+{
+	unsigned int port = (unsigned long)data;
+	struct per_user_data *u;
+
+	spin_lock(&port_user_lock);
+
+	u = port_user[port];
+
+	disable_irq_nosync(irq);
+
+	if ((u->ring_prod - u->ring_cons) < EVTCHN_RING_SIZE) {
+		u->ring[EVTCHN_RING_MASK(u->ring_prod)] = port;
+		wmb(); /* Ensure ring contents visible */
+		if (u->ring_cons == u->ring_prod++) {
+			wake_up_interruptible(&u->evtchn_wait);
+			kill_fasync(&u->evtchn_async_queue,
+				    SIGIO, POLL_IN);
+		}
+	} else {
+		u->ring_overflow = 1;
+	}
+
+	spin_unlock(&port_user_lock);
+
+	return IRQ_HANDLED;
+}
+
+static ssize_t evtchn_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	int rc;
+	unsigned int c, p, bytes1 = 0, bytes2 = 0;
+	struct per_user_data *u = file->private_data;
+
+	/* Whole number of ports. */
+	count &= ~(sizeof(evtchn_port_t)-1);
+
+	if (count == 0)
+		return 0;
+
+	if (count > PAGE_SIZE)
+		count = PAGE_SIZE;
+
+	for (;;) {
+		mutex_lock(&u->ring_cons_mutex);
+
+		rc = -EFBIG;
+		if (u->ring_overflow)
+			goto unlock_out;
+
+		c = u->ring_cons;
+		p = u->ring_prod;
+		if (c != p)
+			break;
+
+		mutex_unlock(&u->ring_cons_mutex);
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		rc = wait_event_interruptible(u->evtchn_wait,
+					      u->ring_cons != u->ring_prod);
+		if (rc)
+			return rc;
+	}
+
+	/* Byte lengths of two chunks. Chunk split (if any) is at ring wrap. */
+	if (((c ^ p) & EVTCHN_RING_SIZE) != 0) {
+		bytes1 = (EVTCHN_RING_SIZE - EVTCHN_RING_MASK(c)) *
+			sizeof(evtchn_port_t);
+		bytes2 = EVTCHN_RING_MASK(p) * sizeof(evtchn_port_t);
+	} else {
+		bytes1 = (p - c) * sizeof(evtchn_port_t);
+		bytes2 = 0;
+	}
+
+	/* Truncate chunks according to caller's maximum byte count. */
+	if (bytes1 > count) {
+		bytes1 = count;
+		bytes2 = 0;
+	} else if ((bytes1 + bytes2) > count) {
+		bytes2 = count - bytes1;
+	}
+
+	rc = -EFAULT;
+	rmb(); /* Ensure that we see the port before we copy it. */
+	if (copy_to_user(buf, &u->ring[EVTCHN_RING_MASK(c)], bytes1) ||
+	    ((bytes2 != 0) &&
+	     copy_to_user(&buf[bytes1], &u->ring[0], bytes2)))
+		goto unlock_out;
+
+	u->ring_cons += (bytes1 + bytes2) / sizeof(evtchn_port_t);
+	rc = bytes1 + bytes2;
+
+ unlock_out:
+	mutex_unlock(&u->ring_cons_mutex);
+	return rc;
+}
+
+static ssize_t evtchn_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	int rc, i;
+	evtchn_port_t *kbuf = (evtchn_port_t *)__get_free_page(GFP_KERNEL);
+	struct per_user_data *u = file->private_data;
+
+	if (kbuf == NULL)
+		return -ENOMEM;
+
+	/* Whole number of ports. */
+	count &= ~(sizeof(evtchn_port_t)-1);
+
+	rc = 0;
+	if (count == 0)
+		goto out;
+
+	if (count > PAGE_SIZE)
+		count = PAGE_SIZE;
+
+	rc = -EFAULT;
+	if (copy_from_user(kbuf, buf, count) != 0)
+		goto out;
+
+	spin_lock_irq(&port_user_lock);
+	for (i = 0; i < (count/sizeof(evtchn_port_t)); i++)
+		if ((kbuf[i] < NR_EVENT_CHANNELS) && (port_user[kbuf[i]] == u))
+			enable_irq(irq_from_evtchn(kbuf[i]));
+	spin_unlock_irq(&port_user_lock);
+
+	rc = count;
+
+ out:
+	free_page((unsigned long)kbuf);
+	return rc;
+}
+
+static int evtchn_bind_to_user(struct per_user_data *u, int port)
+{
+	int rc = 0;
+
+	/*
+	 * Ports are never reused, so every caller should pass in a
+	 * unique port.
+	 *
+	 * (Locking not necessary because we haven't registered the
+	 * interrupt handler yet, and our caller has already
+	 * serialized bind operations.)
+	 */
+	BUG_ON(port_user[port] != NULL);
+	port_user[port] = u;
+
+	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, IRQF_DISABLED,
+				       u->name, (void *)(unsigned long)port);
+	if (rc >= 0)
+		rc = 0;
+
+	return rc;
+}
+
+static void evtchn_unbind_from_user(struct per_user_data *u, int port)
+{
+	int irq = irq_from_evtchn(port);
+
+	unbind_from_irqhandler(irq, (void *)(unsigned long)port);
+
+	/* make sure we unbind the irq handler before clearing the port */
+	barrier();
+
+	port_user[port] = NULL;
+}
+
+static long evtchn_ioctl(struct file *file,
+			 unsigned int cmd, unsigned long arg)
+{
+	int rc;
+	struct per_user_data *u = file->private_data;
+	void __user *uarg = (void __user *) arg;
+
+	/* Prevent bind from racing with unbind */
+	mutex_lock(&u->bind_mutex);
+
+	switch (cmd) {
+	case IOCTL_EVTCHN_BIND_VIRQ: {
+		struct ioctl_evtchn_bind_virq bind;
+		struct evtchn_bind_virq bind_virq;
+
+		rc = -EFAULT;
+		if (copy_from_user(&bind, uarg, sizeof(bind)))
+			break;
+
+		bind_virq.virq = bind.virq;
+		bind_virq.vcpu = 0;
+		rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
+						 &bind_virq);
+		if (rc != 0)
+			break;
+
+		rc = evtchn_bind_to_user(u, bind_virq.port);
+		if (rc == 0)
+			rc = bind_virq.port;
+		break;
+	}
+
+	case IOCTL_EVTCHN_BIND_INTERDOMAIN: {
+		struct ioctl_evtchn_bind_interdomain bind;
+		struct evtchn_bind_interdomain bind_interdomain;
+
+		rc = -EFAULT;
+		if (copy_from_user(&bind, uarg, sizeof(bind)))
+			break;
+
+		bind_interdomain.remote_dom  = bind.remote_domain;
+		bind_interdomain.remote_port = bind.remote_port;
+		rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
+						 &bind_interdomain);
+		if (rc != 0)
+			break;
+
+		rc = evtchn_bind_to_user(u, bind_interdomain.local_port);
+		if (rc == 0)
+			rc = bind_interdomain.local_port;
+		break;
+	}
+
+	case IOCTL_EVTCHN_BIND_UNBOUND_PORT: {
+		struct ioctl_evtchn_bind_unbound_port bind;
+		struct evtchn_alloc_unbound alloc_unbound;
+
+		rc = -EFAULT;
+		if (copy_from_user(&bind, uarg, sizeof(bind)))
+			break;
+
+		alloc_unbound.dom        = DOMID_SELF;
+		alloc_unbound.remote_dom = bind.remote_domain;
+		rc = HYPERVISOR_event_channel_op(EVTCHNOP_alloc_unbound,
+						 &alloc_unbound);
+		if (rc != 0)
+			break;
+
+		rc = evtchn_bind_to_user(u, alloc_unbound.port);
+		if (rc == 0)
+			rc = alloc_unbound.port;
+		break;
+	}
+
+	case IOCTL_EVTCHN_UNBIND: {
+		struct ioctl_evtchn_unbind unbind;
+
+		rc = -EFAULT;
+		if (copy_from_user(&unbind, uarg, sizeof(unbind)))
+			break;
+
+		rc = -EINVAL;
+		if (unbind.port >= NR_EVENT_CHANNELS)
+			break;
+
+		spin_lock_irq(&port_user_lock);
+
+		rc = -ENOTCONN;
+		if (port_user[unbind.port] != u) {
+			spin_unlock_irq(&port_user_lock);
+			break;
+		}
+
+		evtchn_unbind_from_user(u, unbind.port);
+
+		spin_unlock_irq(&port_user_lock);
+
+		rc = 0;
+		break;
+	}
+
+	case IOCTL_EVTCHN_NOTIFY: {
+		struct ioctl_evtchn_notify notify;
+
+		rc = -EFAULT;
+		if (copy_from_user(&notify, uarg, sizeof(notify)))
+			break;
+
+		if (notify.port >= NR_EVENT_CHANNELS) {
+			rc = -EINVAL;
+		} else if (port_user[notify.port] != u) {
+			rc = -ENOTCONN;
+		} else {
+			notify_remote_via_evtchn(notify.port);
+			rc = 0;
+		}
+		break;
+	}
+
+	case IOCTL_EVTCHN_RESET: {
+		/* Initialise the ring to empty. Clear errors. */
+		mutex_lock(&u->ring_cons_mutex);
+		spin_lock_irq(&port_user_lock);
+		u->ring_cons = u->ring_prod = u->ring_overflow = 0;
+		spin_unlock_irq(&port_user_lock);
+		mutex_unlock(&u->ring_cons_mutex);
+		rc = 0;
+		break;
+	}
+
+	default:
+		rc = -ENOSYS;
+		break;
+	}
+	mutex_unlock(&u->bind_mutex);
+
+	return rc;
+}
+
+static unsigned int evtchn_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask = POLLOUT | POLLWRNORM;
+	struct per_user_data *u = file->private_data;
+
+	poll_wait(file, &u->evtchn_wait, wait);
+	if (u->ring_cons != u->ring_prod)
+		mask |= POLLIN | POLLRDNORM;
+	if (u->ring_overflow)
+		mask = POLLERR;
+	return mask;
+}
+
+static int evtchn_fasync(int fd, struct file *filp, int on)
+{
+	struct per_user_data *u = filp->private_data;
+	return fasync_helper(fd, filp, on, &u->evtchn_async_queue);
+}
+
+static int evtchn_open(struct inode *inode, struct file *filp)
+{
+	struct per_user_data *u;
+
+	u = kzalloc(sizeof(*u), GFP_KERNEL);
+	if (u == NULL)
+		return -ENOMEM;
+
+	u->name = kasprintf(GFP_KERNEL, "evtchn:%s", current->comm);
+	if (u->name == NULL) {
+		kfree(u);
+		return -ENOMEM;
+	}
+
+	init_waitqueue_head(&u->evtchn_wait);
+
+	u->ring = (evtchn_port_t *)__get_free_page(GFP_KERNEL);
+	if (u->ring == NULL) {
+		kfree(u->name);
+		kfree(u);
+		return -ENOMEM;
+	}
+
+	mutex_init(&u->bind_mutex);
+	mutex_init(&u->ring_cons_mutex);
+
+	filp->private_data = u;
+
+	return 0;
+}
+
+static int evtchn_release(struct inode *inode, struct file *filp)
+{
+	int i;
+	struct per_user_data *u = filp->private_data;
+
+	spin_lock_irq(&port_user_lock);
+
+	free_page((unsigned long)u->ring);
+
+	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
+		if (port_user[i] != u)
+			continue;
+
+		evtchn_unbind_from_user(port_user[i], i);
+	}
+
+	spin_unlock_irq(&port_user_lock);
+
+	kfree(u->name);
+	kfree(u);
+
+	return 0;
+}
+
+static const struct file_operations evtchn_fops = {
+	.owner   = THIS_MODULE,
+	.read    = evtchn_read,
+	.write   = evtchn_write,
+	.unlocked_ioctl = evtchn_ioctl,
+	.poll    = evtchn_poll,
+	.fasync  = evtchn_fasync,
+	.open    = evtchn_open,
+	.release = evtchn_release,
+};
+
+static struct miscdevice evtchn_miscdev = {
+	.minor        = MISC_DYNAMIC_MINOR,
+	.name         = "evtchn",
+	.fops         = &evtchn_fops,
+};
+static int __init evtchn_init(void)
+{
+	int err;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	spin_lock_init(&port_user_lock);
+	memset(port_user, 0, sizeof(port_user));
+
+	/* Create '/dev/misc/evtchn'. */
+	err = misc_register(&evtchn_miscdev);
+	if (err != 0) {
+		printk(KERN_ALERT "Could not register /dev/misc/evtchn\n");
+		return err;
+	}
+
+	printk(KERN_INFO "Event-channel device installed.\n");
+
+	return 0;
+}
+
+static void __exit evtchn_cleanup(void)
+{
+	misc_deregister(&evtchn_miscdev);
+}
+
+module_init(evtchn_init);
+module_exit(evtchn_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 0d61db1..fddc202 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -62,14 +62,15 @@ static int xen_suspend(void *data)
 	gnttab_resume();
 	xen_mm_unpin_all();
 
-	sysdev_resume();
-
 	if (!*cancelled) {
 		xen_irq_resume();
 		xen_console_resume();
 		xen_timer_resume();
 	}
 
+	sysdev_resume();
+	device_power_up(PMSG_RESUME);
+
 	return 0;
 }
 
@@ -97,9 +98,8 @@ static void do_suspend(void)
 		goto out;
 	}
 
-	printk("suspending xenbus...\n");
-	/* XXX use normal device tree? */
-	xenbus_suspend();
+	printk(KERN_DEBUG "suspending xenstore...\n");
+	xs_suspend();
 
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {
@@ -115,9 +115,9 @@ static void do_suspend(void)
 
 	if (!cancelled) {
 		xen_arch_resume();
-		xenbus_resume();
+		xs_resume();
 	} else
-		xenbus_suspend_cancel();
+		xs_suspend_cancel();
 
 	device_power_up(PMSG_RESUME);
 
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
new file mode 100644
index 0000000..88a60e0
--- /dev/null
+++ b/drivers/xen/sys-hypervisor.c
@@ -0,0 +1,445 @@
+/*
+ *  copyright (c) 2006 IBM Corporation
+ *  Authored by: Mike D. Day <ncmike@us.ibm.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kobject.h>
+
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/xenbus.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/version.h>
+
+#define HYPERVISOR_ATTR_RO(_name) \
+static struct hyp_sysfs_attr  _name##_attr = __ATTR_RO(_name)
+
+#define HYPERVISOR_ATTR_RW(_name) \
+static struct hyp_sysfs_attr _name##_attr = \
+	__ATTR(_name, 0644, _name##_show, _name##_store)
+
+struct hyp_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct hyp_sysfs_attr *, char *);
+	ssize_t (*store)(struct hyp_sysfs_attr *, const char *, size_t);
+	void *hyp_attr_data;
+};
+
+static ssize_t type_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	return sprintf(buffer, "xen\n");
+}
+
+HYPERVISOR_ATTR_RO(type);
+
+static int __init xen_sysfs_type_init(void)
+{
+	return sysfs_create_file(hypervisor_kobj, &type_attr.attr);
+}
+
+static void xen_sysfs_type_destroy(void)
+{
+	sysfs_remove_file(hypervisor_kobj, &type_attr.attr);
+}
+
+/* xen version attributes */
+static ssize_t major_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int version = HYPERVISOR_xen_version(XENVER_version, NULL);
+	if (version)
+		return sprintf(buffer, "%d\n", version >> 16);
+	return -ENODEV;
+}
+
+HYPERVISOR_ATTR_RO(major);
+
+static ssize_t minor_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int version = HYPERVISOR_xen_version(XENVER_version, NULL);
+	if (version)
+		return sprintf(buffer, "%d\n", version & 0xff);
+	return -ENODEV;
+}
+
+HYPERVISOR_ATTR_RO(minor);
+
+static ssize_t extra_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	char *extra;
+
+	extra = kmalloc(XEN_EXTRAVERSION_LEN, GFP_KERNEL);
+	if (extra) {
+		ret = HYPERVISOR_xen_version(XENVER_extraversion, extra);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", extra);
+		kfree(extra);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(extra);
+
+static struct attribute *version_attrs[] = {
+	&major_attr.attr,
+	&minor_attr.attr,
+	&extra_attr.attr,
+	NULL
+};
+
+static struct attribute_group version_group = {
+	.name = "version",
+	.attrs = version_attrs,
+};
+
+static int __init xen_sysfs_version_init(void)
+{
+	return sysfs_create_group(hypervisor_kobj, &version_group);
+}
+
+static void xen_sysfs_version_destroy(void)
+{
+	sysfs_remove_group(hypervisor_kobj, &version_group);
+}
+
+/* UUID */
+
+static ssize_t uuid_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	char *vm, *val;
+	int ret;
+	extern int xenstored_ready;
+
+	if (!xenstored_ready)
+		return -EBUSY;
+
+	vm = xenbus_read(XBT_NIL, "vm", "", NULL);
+	if (IS_ERR(vm))
+		return PTR_ERR(vm);
+	val = xenbus_read(XBT_NIL, vm, "uuid", NULL);
+	kfree(vm);
+	if (IS_ERR(val))
+		return PTR_ERR(val);
+	ret = sprintf(buffer, "%s\n", val);
+	kfree(val);
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(uuid);
+
+static int __init xen_sysfs_uuid_init(void)
+{
+	return sysfs_create_file(hypervisor_kobj, &uuid_attr.attr);
+}
+
+static void xen_sysfs_uuid_destroy(void)
+{
+	sysfs_remove_file(hypervisor_kobj, &uuid_attr.attr);
+}
+
+/* xen compilation attributes */
+
+static ssize_t compiler_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	struct xen_compile_info *info;
+
+	info = kmalloc(sizeof(struct xen_compile_info), GFP_KERNEL);
+	if (info) {
+		ret = HYPERVISOR_xen_version(XENVER_compile_info, info);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", info->compiler);
+		kfree(info);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(compiler);
+
+static ssize_t compiled_by_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	struct xen_compile_info *info;
+
+	info = kmalloc(sizeof(struct xen_compile_info), GFP_KERNEL);
+	if (info) {
+		ret = HYPERVISOR_xen_version(XENVER_compile_info, info);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", info->compile_by);
+		kfree(info);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(compiled_by);
+
+static ssize_t compile_date_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	struct xen_compile_info *info;
+
+	info = kmalloc(sizeof(struct xen_compile_info), GFP_KERNEL);
+	if (info) {
+		ret = HYPERVISOR_xen_version(XENVER_compile_info, info);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", info->compile_date);
+		kfree(info);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(compile_date);
+
+static struct attribute *xen_compile_attrs[] = {
+	&compiler_attr.attr,
+	&compiled_by_attr.attr,
+	&compile_date_attr.attr,
+	NULL
+};
+
+static struct attribute_group xen_compilation_group = {
+	.name = "compilation",
+	.attrs = xen_compile_attrs,
+};
+
+int __init static xen_compilation_init(void)
+{
+	return sysfs_create_group(hypervisor_kobj, &xen_compilation_group);
+}
+
+static void xen_compilation_destroy(void)
+{
+	sysfs_remove_group(hypervisor_kobj, &xen_compilation_group);
+}
+
+/* xen properties info */
+
+static ssize_t capabilities_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	char *caps;
+
+	caps = kmalloc(XEN_CAPABILITIES_INFO_LEN, GFP_KERNEL);
+	if (caps) {
+		ret = HYPERVISOR_xen_version(XENVER_capabilities, caps);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", caps);
+		kfree(caps);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(capabilities);
+
+static ssize_t changeset_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	char *cset;
+
+	cset = kmalloc(XEN_CHANGESET_INFO_LEN, GFP_KERNEL);
+	if (cset) {
+		ret = HYPERVISOR_xen_version(XENVER_changeset, cset);
+		if (!ret)
+			ret = sprintf(buffer, "%s\n", cset);
+		kfree(cset);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(changeset);
+
+static ssize_t virtual_start_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret = -ENOMEM;
+	struct xen_platform_parameters *parms;
+
+	parms = kmalloc(sizeof(struct xen_platform_parameters), GFP_KERNEL);
+	if (parms) {
+		ret = HYPERVISOR_xen_version(XENVER_platform_parameters,
+					     parms);
+		if (!ret)
+			ret = sprintf(buffer, "%lx\n", parms->virt_start);
+		kfree(parms);
+	}
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(virtual_start);
+
+static ssize_t pagesize_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret;
+
+	ret = HYPERVISOR_xen_version(XENVER_pagesize, NULL);
+	if (ret > 0)
+		ret = sprintf(buffer, "%x\n", ret);
+
+	return ret;
+}
+
+HYPERVISOR_ATTR_RO(pagesize);
+
+static ssize_t xen_feature_show(int index, char *buffer)
+{
+	ssize_t ret;
+	struct xen_feature_info info;
+
+	info.submap_idx = index;
+	ret = HYPERVISOR_xen_version(XENVER_get_features, &info);
+	if (!ret)
+		ret = sprintf(buffer, "%08x", info.submap);
+
+	return ret;
+}
+
+static ssize_t features_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	ssize_t len;
+	int i;
+
+	len = 0;
+	for (i = XENFEAT_NR_SUBMAPS-1; i >= 0; i--) {
+		int ret = xen_feature_show(i, buffer + len);
+		if (ret < 0) {
+			if (len == 0)
+				len = ret;
+			break;
+		}
+		len += ret;
+	}
+	if (len > 0)
+		buffer[len++] = '\n';
+
+	return len;
+}
+
+HYPERVISOR_ATTR_RO(features);
+
+static struct attribute *xen_properties_attrs[] = {
+	&capabilities_attr.attr,
+	&changeset_attr.attr,
+	&virtual_start_attr.attr,
+	&pagesize_attr.attr,
+	&features_attr.attr,
+	NULL
+};
+
+static struct attribute_group xen_properties_group = {
+	.name = "properties",
+	.attrs = xen_properties_attrs,
+};
+
+static int __init xen_properties_init(void)
+{
+	return sysfs_create_group(hypervisor_kobj, &xen_properties_group);
+}
+
+static void xen_properties_destroy(void)
+{
+	sysfs_remove_group(hypervisor_kobj, &xen_properties_group);
+}
+
+static int __init hyper_sysfs_init(void)
+{
+	int ret;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	ret = xen_sysfs_type_init();
+	if (ret)
+		goto out;
+	ret = xen_sysfs_version_init();
+	if (ret)
+		goto version_out;
+	ret = xen_compilation_init();
+	if (ret)
+		goto comp_out;
+	ret = xen_sysfs_uuid_init();
+	if (ret)
+		goto uuid_out;
+	ret = xen_properties_init();
+	if (ret)
+		goto prop_out;
+
+	goto out;
+
+prop_out:
+	xen_sysfs_uuid_destroy();
+uuid_out:
+	xen_compilation_destroy();
+comp_out:
+	xen_sysfs_version_destroy();
+version_out:
+	xen_sysfs_type_destroy();
+out:
+	return ret;
+}
+
+static void __exit hyper_sysfs_exit(void)
+{
+	xen_properties_destroy();
+	xen_compilation_destroy();
+	xen_sysfs_uuid_destroy();
+	xen_sysfs_version_destroy();
+	xen_sysfs_type_destroy();
+
+}
+module_init(hyper_sysfs_init);
+module_exit(hyper_sysfs_exit);
+
+static ssize_t hyp_sysfs_show(struct kobject *kobj,
+			      struct attribute *attr,
+			      char *buffer)
+{
+	struct hyp_sysfs_attr *hyp_attr;
+	hyp_attr = container_of(attr, struct hyp_sysfs_attr, attr);
+	if (hyp_attr->show)
+		return hyp_attr->show(hyp_attr, buffer);
+	return 0;
+}
+
+static ssize_t hyp_sysfs_store(struct kobject *kobj,
+			       struct attribute *attr,
+			       const char *buffer,
+			       size_t len)
+{
+	struct hyp_sysfs_attr *hyp_attr;
+	hyp_attr = container_of(attr, struct hyp_sysfs_attr, attr);
+	if (hyp_attr->store)
+		return hyp_attr->store(hyp_attr, buffer, len);
+	return 0;
+}
+
+static struct sysfs_ops hyp_sysfs_ops = {
+	.show = hyp_sysfs_show,
+	.store = hyp_sysfs_store,
+};
+
+static struct kobj_type hyp_sysfs_kobj_type = {
+	.sysfs_ops = &hyp_sysfs_ops,
+};
+
+static int __init hypervisor_subsys_init(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	hypervisor_kobj->ktype = &hyp_sysfs_kobj_type;
+	return 0;
+}
+device_initcall(hypervisor_subsys_init);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 773d1cf..d42e25d 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -71,6 +71,9 @@ static int xenbus_probe_frontend(const char *type, const char *name);
 
 static void xenbus_dev_shutdown(struct device *_dev);
 
+static int xenbus_dev_suspend(struct device *dev, pm_message_t state);
+static int xenbus_dev_resume(struct device *dev);
+
 /* If something in array of ids matches this device, return it. */
 static const struct xenbus_device_id *
 match_device(const struct xenbus_device_id *arr, struct xenbus_device *dev)
@@ -188,6 +191,9 @@ static struct xen_bus_type xenbus_frontend = {
 		.remove    = xenbus_dev_remove,
 		.shutdown  = xenbus_dev_shutdown,
 		.dev_attrs = xenbus_dev_attrs,
+
+		.suspend   = xenbus_dev_suspend,
+		.resume    = xenbus_dev_resume,
 	},
 };
 
@@ -654,6 +660,7 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 
 	kfree(root);
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_changed);
 
 static void frontend_changed(struct xenbus_watch *watch,
 			     const char **vec, unsigned int len)
@@ -669,7 +676,7 @@ static struct xenbus_watch fe_watch = {
 	.callback = frontend_changed,
 };
 
-static int suspend_dev(struct device *dev, void *data)
+static int xenbus_dev_suspend(struct device *dev, pm_message_t state)
 {
 	int err = 0;
 	struct xenbus_driver *drv;
@@ -682,35 +689,14 @@ static int suspend_dev(struct device *dev, void *data)
 	drv = to_xenbus_driver(dev->driver);
 	xdev = container_of(dev, struct xenbus_device, dev);
 	if (drv->suspend)
-		err = drv->suspend(xdev);
+		err = drv->suspend(xdev, state);
 	if (err)
 		printk(KERN_WARNING
 		       "xenbus: suspend %s failed: %i\n", dev_name(dev), err);
 	return 0;
 }
 
-static int suspend_cancel_dev(struct device *dev, void *data)
-{
-	int err = 0;
-	struct xenbus_driver *drv;
-	struct xenbus_device *xdev;
-
-	DPRINTK("");
-
-	if (dev->driver == NULL)
-		return 0;
-	drv = to_xenbus_driver(dev->driver);
-	xdev = container_of(dev, struct xenbus_device, dev);
-	if (drv->suspend_cancel)
-		err = drv->suspend_cancel(xdev);
-	if (err)
-		printk(KERN_WARNING
-		       "xenbus: suspend_cancel %s failed: %i\n",
-		       dev_name(dev), err);
-	return 0;
-}
-
-static int resume_dev(struct device *dev, void *data)
+static int xenbus_dev_resume(struct device *dev)
 {
 	int err;
 	struct xenbus_driver *drv;
@@ -755,33 +741,6 @@ static int resume_dev(struct device *dev, void *data)
 	return 0;
 }
 
-void xenbus_suspend(void)
-{
-	DPRINTK("");
-
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, suspend_dev);
-	xenbus_backend_suspend(suspend_dev);
-	xs_suspend();
-}
-EXPORT_SYMBOL_GPL(xenbus_suspend);
-
-void xenbus_resume(void)
-{
-	xb_init_comms();
-	xs_resume();
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, resume_dev);
-	xenbus_backend_resume(resume_dev);
-}
-EXPORT_SYMBOL_GPL(xenbus_resume);
-
-void xenbus_suspend_cancel(void)
-{
-	xs_suspend_cancel();
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, suspend_cancel_dev);
-	xenbus_backend_resume(suspend_cancel_dev);
-}
-EXPORT_SYMBOL_GPL(xenbus_suspend_cancel);
-
 /* A flag to determine if xenstored is 'ready' (i.e. has started) */
 int xenstored_ready = 0;
 
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index e325eab..eab33f1 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -673,6 +673,8 @@ void xs_resume(void)
 	struct xenbus_watch *watch;
 	char token[sizeof(watch) * 2 + 1];
 
+	xb_init_comms();
+
 	mutex_unlock(&xs_state.response_mutex);
 	mutex_unlock(&xs_state.request_mutex);
 	up_write(&xs_state.transaction_mutex);
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 515741a..6559e0c 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -20,10 +20,27 @@
 MODULE_DESCRIPTION("Xen filesystem");
 MODULE_LICENSE("GPL");
 
+static ssize_t capabilities_read(struct file *file, char __user *buf,
+				 size_t size, loff_t *off)
+{
+	char *tmp = "";
+
+	if (xen_initial_domain())
+		tmp = "control_d\n";
+
+	return simple_read_from_buffer(buf, size, off, tmp, strlen(tmp));
+}
+
+static const struct file_operations capabilities_file_ops = {
+	.read = capabilities_read,
+};
+
 static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr xenfs_files[] = {
-		[2] = {"xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR},
+		[1] = {},
+		{ "xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR },
+		{ "capabilities", &capabilities_file_ops, S_IRUGO },
 		{""},
 	};
 
diff --git a/include/Kbuild b/include/Kbuild
index d8c3e3c..fe36acc 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -8,3 +8,4 @@ header-y += mtd/
 header-y += rdma/
 header-y += video/
 header-y += drm/
+header-y += xen/
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index e16fdb1..0988704 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -73,8 +73,8 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define pgtable_cache_init()		do {} while (0)
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#define arch_start_context_switch(prev)	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 8e6d0ca..e410f60 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -280,17 +280,18 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 #endif
 
 /*
- * A facility to provide batching of the reload of page tables with the
- * actual context switch code for paravirtualized guests.  By convention,
- * only one of the lazy modes (CPU, MMU) should be active at any given
- * time, entry should never be nested, and entry and exits should always
- * be paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.
+ * A facility to provide batching of the reload of page tables and
+ * other process state with the actual context switch code for
+ * paravirtualized guests.  By convention, only one of the batched
+ * update (lazy) modes (CPU, MMU) should be active at any given time,
+ * entry should never be nested, and entry and exits should always be
+ * paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.  In this case, the exit (end of the context switch) is
+ * in architecture-specific code, and so doesn't need a generic
+ * definition.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
+#ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
+#define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff --git a/include/xen/Kbuild b/include/xen/Kbuild
new file mode 100644
index 0000000..4e65c16
--- /dev/null
+++ b/include/xen/Kbuild
@@ -0,0 +1 @@
+header-y += evtchn.h
diff --git a/include/xen/events.h b/include/xen/events.h
index 0d5f1ad..e68d59a 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -53,4 +53,7 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
+/* Determine the IRQ which is bound to an event channel */
+unsigned irq_from_evtchn(unsigned int evtchn);
+
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/evtchn.h b/include/xen/evtchn.h
new file mode 100644
index 0000000..14e833e
--- /dev/null
+++ b/include/xen/evtchn.h
@@ -0,0 +1,88 @@
+/******************************************************************************
+ * evtchn.h
+ *
+ * Interface to /dev/xen/evtchn.
+ *
+ * Copyright (c) 2003-2005, K A Fraser
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __LINUX_PUBLIC_EVTCHN_H__
+#define __LINUX_PUBLIC_EVTCHN_H__
+
+/*
+ * Bind a fresh port to VIRQ @virq.
+ * Return allocated port.
+ */
+#define IOCTL_EVTCHN_BIND_VIRQ				\
+	_IOC(_IOC_NONE, 'E', 0, sizeof(struct ioctl_evtchn_bind_virq))
+struct ioctl_evtchn_bind_virq {
+	unsigned int virq;
+};
+
+/*
+ * Bind a fresh port to remote <@remote_domain, @remote_port>.
+ * Return allocated port.
+ */
+#define IOCTL_EVTCHN_BIND_INTERDOMAIN			\
+	_IOC(_IOC_NONE, 'E', 1, sizeof(struct ioctl_evtchn_bind_interdomain))
+struct ioctl_evtchn_bind_interdomain {
+	unsigned int remote_domain, remote_port;
+};
+
+/*
+ * Allocate a fresh port for binding to @remote_domain.
+ * Return allocated port.
+ */
+#define IOCTL_EVTCHN_BIND_UNBOUND_PORT			\
+	_IOC(_IOC_NONE, 'E', 2, sizeof(struct ioctl_evtchn_bind_unbound_port))
+struct ioctl_evtchn_bind_unbound_port {
+	unsigned int remote_domain;
+};
+
+/*
+ * Unbind previously allocated @port.
+ */
+#define IOCTL_EVTCHN_UNBIND				\
+	_IOC(_IOC_NONE, 'E', 3, sizeof(struct ioctl_evtchn_unbind))
+struct ioctl_evtchn_unbind {
+	unsigned int port;
+};
+
+/*
+ * Unbind previously allocated @port.
+ */
+#define IOCTL_EVTCHN_NOTIFY				\
+	_IOC(_IOC_NONE, 'E', 4, sizeof(struct ioctl_evtchn_notify))
+struct ioctl_evtchn_notify {
+	unsigned int port;
+};
+
+/* Clear and reinitialise the event buffer. Clear error condition. */
+#define IOCTL_EVTCHN_RESET				\
+	_IOC(_IOC_NONE, 'E', 5, 0)
+
+#endif /* __LINUX_PUBLIC_EVTCHN_H__ */
diff --git a/include/xen/interface/version.h b/include/xen/interface/version.h
index 453235e..e8b6519 100644
--- a/include/xen/interface/version.h
+++ b/include/xen/interface/version.h
@@ -57,4 +57,7 @@ struct xen_feature_info {
 /* Declares the features reported by XENVER_get_features. */
 #include "features.h"
 
+/* arg == NULL; returns host memory page size. */
+#define XENVER_pagesize 7
+
 #endif /* __XEN_PUBLIC_VERSION_H__ */
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index f87f961..b9763ba 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -91,8 +91,7 @@ struct xenbus_driver {
 	void (*otherend_changed)(struct xenbus_device *dev,
 				 enum xenbus_state backend_state);
 	int (*remove)(struct xenbus_device *dev);
-	int (*suspend)(struct xenbus_device *dev);
-	int (*suspend_cancel)(struct xenbus_device *dev);
+	int (*suspend)(struct xenbus_device *dev, pm_message_t state);
 	int (*resume)(struct xenbus_device *dev);
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc1fd5..b38bd96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2754,7 +2754,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * combine the page table reload and the switch backend into
 	 * one hypercall.
 	 */
-	arch_enter_lazy_cpu_mode();
+	arch_start_context_switch(prev);
 
 	if (unlikely(!mm)) {
 		next->active_mm = oldmm;
