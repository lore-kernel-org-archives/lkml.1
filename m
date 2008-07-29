Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYG2Fus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYG2Fus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYG2FtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:49:00 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55506 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYG2Fs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:58 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 5/6] x86: coding style fixes to arch/x86/kernel/traps_64.c
Date: Tue, 29 Jul 2008 02:48:55 -0300
Message-Id: <1217310536-7181-6-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217310536-7181-5-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-5-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all errors and many warnings reported by checkpath.pl.
Except the change of include <asm/io.h> to <linux/io.h>
the traps.o before and after changes are the same.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/traps_64.c |   59 +++++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3f18d73..fe36d96 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -32,6 +32,8 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/io.h>
 
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
@@ -45,9 +47,6 @@
 #include <asm/unwind.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
-#include <asm/nmi.h>
-#include <asm/smp.h>
-#include <asm/io.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pda.h>
@@ -85,7 +84,8 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%016lx>] %s%pS\n", address, reliable ? "": "? ", (void *) address);
+	printk(" [<%016lx>] %s%pS\n", address, reliable ?
+			"" : "? ", (void *) address);
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
@@ -98,7 +98,8 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 		[STACKFAULT_STACK - 1] = "#SS",
 		[MCE_STACK - 1] = "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ... N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
+		[N_EXCEPTION_STACKS ... N_EXCEPTION_STACKS + DEBUG_STKSZ /
+			EXCEPTION_STKSZ - 2] = "#DB[?]"
 #endif
 	};
 	unsigned k;
@@ -163,7 +164,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 }
 
 /*
- * x86-64 can have up to three kernel stacks: 
+ * x86-64 can have up to three kernel stacks:
  * process stack
  * interrupt stack
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
@@ -219,7 +220,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
@@ -237,7 +238,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!bp) {
 		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp) :);
+			asm("movq %%rbp, %0" : "=r" (bp) : );
 		} else {
 			/* bp is the last reg pushed by switch_to */
 			bp = *(unsigned long *) task->thread.sp;
@@ -357,11 +358,13 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end = (unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack = (unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irqstack_end =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
+	unsigned long *irqstack =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
 
-	// debugging aid: "show_stack(NULL, NULL);" prints the
-	// back trace for this cpu.
+	/* debugging aid: "show_stack(NULL, NULL);" prints the
+	  back trace for this cpu. */
 
 	if (sp == NULL) {
 		if (task)
@@ -404,7 +407,7 @@ void dump_stack(void)
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
-		asm("movq %%rbp, %0" : "=r" (bp):);
+		asm("movq %%rbp, %0" : "=r" (bp) : );
 #endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
@@ -414,7 +417,6 @@ void dump_stack(void)
 		init_utsname()->version);
 	show_trace(NULL, NULL, &stack, bp);
 }
-
 EXPORT_SYMBOL(dump_stack);
 
 void show_registers(struct pt_regs *regs)
@@ -493,7 +495,7 @@ unsigned __kprobes long oops_begin(void)
 	raw_local_irq_save(flags);
 	cpu = smp_processor_id();
 	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner) 
+		if (cpu == die_owner)
 			/* nested oops. should stop eventually */;
 		else
 			__raw_spin_lock(&die_lock);
@@ -638,7 +640,7 @@ kernel_trap:
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
-asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
@@ -648,7 +650,7 @@ asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 	info.si_signo = signr;						\
@@ -683,7 +685,7 @@ asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 }
 
-asmlinkage void do_double_fault(struct pt_regs * regs, long error_code)
+asmlinkage void do_double_fault(struct pt_regs *regs, long error_code)
 {
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
@@ -778,9 +780,10 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 }
 
 static notrace __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
+unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
+			NOTIFY_STOP)
 		return;
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
 		reason);
@@ -882,7 +885,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 	else if (user_mode(eregs))
 		regs = task_pt_regs(current);
 	/* Exception from kernel and interrupts are enabled. Move to
- 	   kernel process stack. */
+	   kernel process stack. */
 	else if (eregs->flags & X86_EFLAGS_IF)
 		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
 	if (eregs != regs)
@@ -891,7 +894,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 }
 
 /* runs on IST stack. */
-asmlinkage void __kprobes do_debug(struct pt_regs * regs,
+asmlinkage void __kprobes do_debug(struct pt_regs *regs,
 				   unsigned long error_code)
 {
 	struct task_struct *tsk = current;
@@ -1035,7 +1038,7 @@ asmlinkage void do_coprocessor_error(struct pt_regs *regs)
 
 asmlinkage void bad_intr(void)
 {
-	printk("bad interrupt"); 
+	printk("bad interrupt");
 }
 
 asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
@@ -1047,7 +1050,7 @@ asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
 
 	conditional_sti(regs);
 	if (!user_mode(regs) &&
-        	kernel_math_error(regs, "kernel simd math error", 19))
+			kernel_math_error(regs, "kernel simd math error", 19))
 		return;
 
 	/*
@@ -1092,7 +1095,7 @@ asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs * regs)
+asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs)
 {
 }
 
@@ -1142,8 +1145,10 @@ void __init trap_init(void)
 	set_intr_gate(0, &divide_error);
 	set_intr_gate_ist(1, &debug, DEBUG_STACK);
 	set_intr_gate_ist(2, &nmi, NMI_STACK);
- 	set_system_gate_ist(3, &int3, DEBUG_STACK); /* int3 can be called from all */
-	set_system_gate(4, &overflow); /* int4 can be called from all */
+	/* int3 can be called from all */
+	set_system_gate_ist(3, &int3, DEBUG_STACK);
+	/* int4 can be called from all */
+	set_system_gate(4, &overflow);
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
 	set_intr_gate(7, &device_not_available);
-- 
1.5.4.5

