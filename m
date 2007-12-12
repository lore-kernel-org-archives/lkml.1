Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbXLLU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbXLLU3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbXLLU32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:29:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:57933 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734AbXLLU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=odNdnxSginF3Lp0KH0SRZqzd3jc17y7bA1wfi33xgjRdJEjCHgNs8vAHCTHmH7ks87y1KFqJZObQQ6xu5TrWkA6eX6xW2RVnKkSoyZB9JJeSxEoqm3qT9jrqg6VC+WuX0SaOaN3XX+WFUPw5/bRwOJet0wNcGe399EPsEm/S6iE=
Subject: [PATCH] x86: Remove all definitions with fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:29:24 -0800
Message-Id: <1197491364.21291.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall is always defined to be empty, remove it from arch/x86

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/apic_32.c            |    2 +-
 arch/x86/kernel/cpu/mcheck/k7.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.h     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c  |    4 ++--
 arch/x86/kernel/cpu/mcheck/p4.c      |    4 ++--
 arch/x86/kernel/cpu/mcheck/p5.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/p6.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c |    2 +-
 arch/x86/kernel/io_apic_32.c         |    2 +-
 arch/x86/kernel/irq_32.c             |    2 +-
 arch/x86/kernel/kprobes_32.c         |    2 +-
 arch/x86/kernel/process_32.c         |    2 +-
 arch/x86/kernel/signal_32.c          |    2 +-
 arch/x86/kernel/smp_32.c             |    8 ++++----
 arch/x86/kernel/traps_32.c           |   24 ++++++++++++------------
 arch/x86/kernel/vm86_32.c            |    3 +--
 arch/x86/mach-voyager/voyager_smp.c  |   20 ++++++++++----------
 arch/x86/mm/fault_32.c               |    5 ++---
 arch/x86/xen/events.c                |    2 +-
 19 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 1872f88..ba21079 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -578,7 +578,7 @@ static void local_apic_timer_interrupt(void)
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
 
-void fastcall smp_apic_timer_interrupt(struct pt_regs *regs)
+void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/x86/kernel/cpu/mcheck/k7.c b/arch/x86/kernel/cpu/mcheck/k7.c
index eef63e3..39fa76f 100644
--- a/arch/x86/kernel/cpu/mcheck/k7.c
+++ b/arch/x86/kernel/cpu/mcheck/k7.c
@@ -16,7 +16,7 @@
 #include "mce.h"
 
 /* Machine Check Handler For AMD Athlon/Duron */
-static fastcall void k7_machine_check(struct pt_regs * regs, long error_code)
+static void k7_machine_check(struct pt_regs * regs, long error_code)
 {
 	int recover=1;
 	u32 alow, ahigh, high, low;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
index 81fb6e2..ae9f628 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ b/arch/x86/kernel/cpu/mcheck/mce.h
@@ -8,7 +8,7 @@ void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
 void winchip_mcheck_init(struct cpuinfo_x86 *c);
 
 /* Call the installed machine check handler for this CPU setup. */
-extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
 
 extern int nr_mce_banks;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_32.c b/arch/x86/kernel/cpu/mcheck/mce_32.c
index 34c781e..a5182dc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -22,13 +22,13 @@ int nr_mce_banks;
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
 /* Handle unconfigured int18 (should never happen) */
-static fastcall void unexpected_machine_check(struct pt_regs * regs, long error_code)
+static void unexpected_machine_check(struct pt_regs * regs, long error_code)
 {	
 	printk(KERN_ERR "CPU#%d: Unexpected int18 (Machine Check).\n", smp_processor_id());
 }
 
 /* Call the installed machine check handler for this CPU setup. */
-void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexpected_machine_check;
+void (*machine_check_vector)(struct pt_regs *, long error_code) = unexpected_machine_check;
 
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index be4dabf..16a6238 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -57,7 +57,7 @@ static void intel_thermal_interrupt(struct pt_regs *regs)
 /* Thermal interrupt handler for this CPU setup */
 static void (*vendor_thermal_interrupt)(struct pt_regs *regs) = unexpected_thermal_interrupt;
 
-fastcall void smp_thermal_interrupt(struct pt_regs *regs)
+void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	vendor_thermal_interrupt(regs);
@@ -141,7 +141,7 @@ static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 	rdmsr (MSR_IA32_MCG_EIP, r->eip, h);
 }
 
-static fastcall void intel_machine_check(struct pt_regs * regs, long error_code)
+static void intel_machine_check(struct pt_regs * regs, long error_code)
 {
 	int recover=1;
 	u32 alow, ahigh, high, low;
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 94bc43d..a18310a 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -16,7 +16,7 @@
 #include "mce.h"
 
 /* Machine check handler for Pentium class Intel */
-static fastcall void pentium_machine_check(struct pt_regs * regs, long error_code)
+static void pentium_machine_check(struct pt_regs * regs, long error_code)
 {
 	u32 loaddr, hi, lotype;
 	rdmsr(MSR_IA32_P5_MC_ADDR, loaddr, hi);
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index deeae42..cb3829e 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -16,7 +16,7 @@
 #include "mce.h"
 
 /* Machine Check Handler For PII/PIII */
-static fastcall void intel_machine_check(struct pt_regs * regs, long error_code)
+static void intel_machine_check(struct pt_regs * regs, long error_code)
 {
 	int recover=1;
 	u32 alow, ahigh, high, low;
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 9e424b6..3d428d5 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -15,7 +15,7 @@
 #include "mce.h"
 
 /* Machine check handler for WinChip C6 */
-static fastcall void winchip_machine_check(struct pt_regs * regs, long error_code)
+static void winchip_machine_check(struct pt_regs * regs, long error_code)
 {
 	printk(KERN_EMERG "CPU0: Machine Check Exception.\n");
 	add_taint(TAINT_MACHINE_CHECK);
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a9ee8ce..7bd0460 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -725,7 +725,7 @@ late_initcall(balanced_irq_init);
 #endif /* CONFIG_SMP */
 
 #ifndef CONFIG_SMP
-void fastcall send_IPI_self(int vector)
+void send_IPI_self(int vector)
 {
 	unsigned int cfg;
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index b49616b..cef054b 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -66,7 +66,7 @@ static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-fastcall unsigned int do_IRQ(struct pt_regs *regs)
+unsigned int do_IRQ(struct pt_regs *regs)
 {	
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 44bc600..b47381e 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -403,7 +403,7 @@ no_kprobe:
 /*
  * Called from kretprobe_trampoline
  */
-fastcall void *__kprobes trampoline_handler(struct pt_regs *regs)
+void *__kprobes trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e855994..2cfa528 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -705,7 +705,7 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-struct task_struct fastcall * __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
+struct task_struct * __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
 				 *next = &next_p->thread;
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 985c197..6e65d0c 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -575,7 +575,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-static void fastcall do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index d4c01a4..070816a 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -159,7 +159,7 @@ void __send_IPI_shortcut(unsigned int shortcut, int vector)
 	apic_write_around(APIC_ICR, cfg);
 }
 
-void fastcall send_IPI_self(int vector)
+void send_IPI_self(int vector)
 {
 	__send_IPI_shortcut(APIC_DEST_SELF, vector);
 }
@@ -310,7 +310,7 @@ void leave_mm(unsigned long cpu)
  * 2) Leave the mm if we are in the lazy tlb mode.
  */
 
-fastcall void smp_invalidate_interrupt(struct pt_regs *regs)
+void smp_invalidate_interrupt(struct pt_regs *regs)
 {
 	unsigned long cpu;
 
@@ -638,13 +638,13 @@ static void native_smp_send_stop(void)
  * all the work is done automatically when
  * we return from the interrupt.
  */
-fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
+void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	__get_cpu_var(irq_stat).irq_resched_count++;
 }
 
-fastcall void smp_call_function_interrupt(struct pt_regs *regs)
+void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	void (*func) (void *info) = call_data->func;
 	void *info = call_data->info;
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index e15014e..0506b56 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -501,7 +501,7 @@ static void __kprobes do_trap(int trapnr, int signr, char *str, int vm86,
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
-fastcall void do_##name(struct pt_regs * regs, long error_code) \
+void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
 						== NOTIFY_STOP) \
@@ -510,7 +510,7 @@ fastcall void do_##name(struct pt_regs * regs, long error_code) \
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq) \
-fastcall void do_##name(struct pt_regs * regs, long error_code) \
+void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	siginfo_t info; \
 	if (irq) \
@@ -526,7 +526,7 @@ fastcall void do_##name(struct pt_regs * regs, long error_code) \
 }
 
 #define DO_VM86_ERROR(trapnr, signr, str, name) \
-fastcall void do_##name(struct pt_regs * regs, long error_code) \
+void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
 						== NOTIFY_STOP) \
@@ -535,7 +535,7 @@ fastcall void do_##name(struct pt_regs * regs, long error_code) \
 }
 
 #define DO_VM86_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr) \
-fastcall void do_##name(struct pt_regs * regs, long error_code) \
+void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	siginfo_t info; \
 	info.si_signo = signr; \
@@ -562,7 +562,7 @@ DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
 DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
-fastcall void __kprobes do_general_protection(struct pt_regs * regs,
+void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)
 {
 	int cpu = get_cpu();
@@ -763,7 +763,7 @@ static __kprobes void default_do_nmi(struct pt_regs * regs)
 
 static int ignore_nmis;
 
-fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+__kprobes void do_nmi(struct pt_regs * regs, long error_code)
 {
 	int cpu;
 
@@ -792,7 +792,7 @@ void restart_nmi(void)
 }
 
 #ifdef CONFIG_KPROBES
-fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
+void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	trace_hardirqs_fixup();
 
@@ -828,7 +828,7 @@ fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
  */
-fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
+void __kprobes do_debug(struct pt_regs * regs, long error_code)
 {
 	unsigned int condition;
 	struct task_struct *tsk = current;
@@ -960,7 +960,7 @@ void math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-fastcall void do_coprocessor_error(struct pt_regs * regs, long error_code)
+void do_coprocessor_error(struct pt_regs * regs, long error_code)
 {
 	ignore_fpu_irq = 1;
 	math_error((void __user *)regs->ip);
@@ -1014,7 +1014,7 @@ static void simd_math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-fastcall void do_simd_coprocessor_error(struct pt_regs * regs,
+void do_simd_coprocessor_error(struct pt_regs * regs,
 					  long error_code)
 {
 	if (cpu_has_xmm) {
@@ -1038,7 +1038,7 @@ fastcall void do_simd_coprocessor_error(struct pt_regs * regs,
 	}
 }
 
-fastcall void do_spurious_interrupt_bug(struct pt_regs * regs,
+void do_spurious_interrupt_bug(struct pt_regs * regs,
 					  long error_code)
 {
 #if 0
@@ -1047,7 +1047,7 @@ fastcall void do_spurious_interrupt_bug(struct pt_regs * regs,
 #endif
 }
 
-fastcall unsigned long patch_espfix_desc(unsigned long uesp,
+unsigned long patch_espfix_desc(unsigned long uesp,
 					  unsigned long kesp)
 {
 	struct desc_struct *gdt = __get_cpu_var(gdt_page).gdt;
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 5aa5e2f..c9f67ef 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -120,8 +120,7 @@ static int copy_vm86_regs_from_user(struct kernel_vm86_regs *regs,
 	return ret;
 }
 
-struct pt_regs * save_v86_state(struct kernel_vm86_regs * regs);
-struct pt_regs * fastcall save_v86_state(struct kernel_vm86_regs * regs)
+struct pt_regs * save_v86_state(struct kernel_vm86_regs * regs)
 {
 	struct tss_struct *tss;
 	struct pt_regs *ret;
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index f2c1348..7517772 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -755,7 +755,7 @@ void __init initialize_secondary(void)
  * System interrupts occur because some problem was detected on the
  * various busses.  To find out what you have to probe all the
  * hardware via the CAT bus.  FIXME: At the moment we do nothing. */
-fastcall void smp_vic_sys_interrupt(struct pt_regs *regs)
+void smp_vic_sys_interrupt(struct pt_regs *regs)
 {
 	ack_CPI(VIC_SYS_INT);
 	printk("Voyager SYSTEM INTERRUPT\n");
@@ -764,7 +764,7 @@ fastcall void smp_vic_sys_interrupt(struct pt_regs *regs)
 /* Handle a voyager CMN_INT; These interrupts occur either because of
  * a system status change or because a single bit memory error
  * occurred.  FIXME: At the moment, ignore all this. */
-fastcall void smp_vic_cmn_interrupt(struct pt_regs *regs)
+void smp_vic_cmn_interrupt(struct pt_regs *regs)
 {
 	static __u8 in_cmn_int = 0;
 	static DEFINE_SPINLOCK(cmn_int_lock);
@@ -1086,7 +1086,7 @@ voyager_smp_call_function_mask(cpumask_t cpumask,
  * no local APIC, so I can't do this
  *
  * This function is currently a placeholder and is unused in the code */
-fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
+void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	wrapper_smp_local_timer_interrupt();
@@ -1094,7 +1094,7 @@ fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
 }
 
 /* All of the QUAD interrupt GATES */
-fastcall void smp_qic_timer_interrupt(struct pt_regs *regs)
+void smp_qic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	ack_QIC_CPI(QIC_TIMER_CPI);
@@ -1102,31 +1102,31 @@ fastcall void smp_qic_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-fastcall void smp_qic_invalidate_interrupt(struct pt_regs *regs)
+void smp_qic_invalidate_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_INVALIDATE_CPI);
 	smp_invalidate_interrupt();
 }
 
-fastcall void smp_qic_reschedule_interrupt(struct pt_regs *regs)
+void smp_qic_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_RESCHEDULE_CPI);
 	smp_reschedule_interrupt();
 }
 
-fastcall void smp_qic_enable_irq_interrupt(struct pt_regs *regs)
+void smp_qic_enable_irq_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_ENABLE_IRQ_CPI);
 	smp_enable_irq_interrupt();
 }
 
-fastcall void smp_qic_call_function_interrupt(struct pt_regs *regs)
+void smp_qic_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_CALL_FUNCTION_CPI);
 	smp_call_function_interrupt();
 }
 
-fastcall void smp_vic_cpi_interrupt(struct pt_regs *regs)
+void smp_vic_cpi_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	__u8 cpu = smp_processor_id();
@@ -1333,7 +1333,7 @@ int setup_profiling_timer(unsigned int multiplier)
 /* This is a bit of a mess, but forced on us by the genirq changes
  * there's no genirq handler that really does what voyager wants
  * so hack it up with the simple IRQ handler */
-static void fastcall handle_vic_irq(unsigned int irq, struct irq_desc *desc)
+static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	before_handle_vic_irq(irq);
 	handle_simple_irq(irq, desc);
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 6056c6d..656c24e 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -214,7 +214,7 @@ static noinline void force_sig_info_fault(int si_signo, int si_code,
 	force_sig_info(si_signo, &info, tsk);
 }
 
-fastcall void do_invalid_op(struct pt_regs *, unsigned long);
+void do_invalid_op(struct pt_regs *, unsigned long);
 
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
@@ -293,8 +293,7 @@ int show_unhandled_signals = 1;
  *	bit 3 == 1 means use of reserved bit detected
  *	bit 4 == 1 means fault was an instruction fetch
  */
-fastcall void __kprobes do_page_fault(struct pt_regs *regs,
-				      unsigned long error_code)
+void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
diff --git a/arch/x86/xen/events.c b/arch/x86/xen/events.c
index aebab97..dcf613e 100644
--- a/arch/x86/xen/events.c
+++ b/arch/x86/xen/events.c
@@ -465,7 +465,7 @@ void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
  * a bitset of words which contain pending event bits.  The second
  * level is a bitset of pending events themselves.
  */
-fastcall void xen_evtchn_do_upcall(struct pt_regs *regs)
+void xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
-- 
1.5.3.7.2212.gd092



