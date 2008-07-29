Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYG2Ft1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYG2Ft1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYG2Fs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:48:57 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55501 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbYG2Fsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:55 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 1/6] x86: coding styles fixes to arch/x86/kernel/process_64.c
Date: Tue, 29 Jul 2008 02:48:51 -0300
Message-Id: <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix about 50 errors and many warnings without change process_64.o

arch/x86/kernel/process_64.o:
text    data     bss     dec     hex filename
5236       8      24    5268    1494 process_64.o.after
5236       8      24    5268    1494 process_64.o.before
md5:
9c35e9debdea4e471288c6e8ca267a75  process_64.o.after
9c35e9debdea4e471288c6e8ca267a75  process_64.o.before

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/process_64.c |  101 +++++++++++++++++++++---------------------
 1 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3fb62a7..4da8514 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,11 +37,11 @@
 #include <linux/kdebug.h>
 #include <linux/tick.h>
 #include <linux/prctl.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/mmu_context.h>
@@ -88,7 +88,7 @@ void exit_idle(void)
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 
-#include <asm/nmi.h>
+#include <linux/nmi.h>
 /* We halt the CPU with physical CPU hotplug */
 static inline void play_dead(void)
 {
@@ -152,7 +152,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs * regs)
+void __show_regs(struct pt_regs *regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -177,28 +177,28 @@ void __show_regs(struct pt_regs * regs)
 	printk("RBP: %016lx R08: %016lx R09: %016lx\n",
 	       regs->bp, regs->r8, regs->r9);
 	printk("R10: %016lx R11: %016lx R12: %016lx\n",
-	       regs->r10, regs->r11, regs->r12); 
+	       regs->r10, regs->r11, regs->r12);
 	printk("R13: %016lx R14: %016lx R15: %016lx\n",
-	       regs->r13, regs->r14, regs->r15); 
+	       regs->r13, regs->r14, regs->r15);
 
-	asm("movl %%ds,%0" : "=r" (ds)); 
-	asm("movl %%cs,%0" : "=r" (cs)); 
-	asm("movl %%es,%0" : "=r" (es)); 
+	asm("movl %%ds,%0" : "=r" (ds));
+	asm("movl %%cs,%0" : "=r" (cs));
+	asm("movl %%es,%0" : "=r" (es));
 	asm("movl %%fs,%0" : "=r" (fsindex));
 	asm("movl %%gs,%0" : "=r" (gsindex));
 
 	rdmsrl(MSR_FS_BASE, fs);
-	rdmsrl(MSR_GS_BASE, gs); 
-	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
+	rdmsrl(MSR_GS_BASE, gs);
+	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs);
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
-	       fs,fsindex,gs,gsindex,shadowgs); 
-	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
+	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs, fsindex, gs, gsindex, shadowgs);
+	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0);
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
@@ -314,10 +314,10 @@ void prepare_to_copy(struct task_struct *tsk)
 
 int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 		unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
+	struct task_struct *p, struct pt_regs *regs)
 {
 	int err;
-	struct pt_regs * childregs;
+	struct pt_regs *childregs;
 	struct task_struct *me = current;
 
 	childregs = ((struct pt_regs *)
@@ -362,10 +362,10 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 		if (test_thread_flag(TIF_IA32))
 			err = do_set_thread_area(p, -1,
 				(struct user_desc __user *)childregs->si, 0);
-		else 			
-#endif	 
-			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8); 
-		if (err) 
+		else
+#endif
+			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
+		if (err)
 			goto out;
 	}
 	err = 0;
@@ -544,7 +544,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	unsigned fsindex, gsindex;
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter>5)
+	if (next_p->fpu_counter > 5)
 		prefetch(next->xstate);
 
 	/*
@@ -552,13 +552,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	load_sp0(tss, next);
 
-	/* 
+	/*
 	 * Switch DS and ES.
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
 	if (unlikely(next->es | prev->es))
-		loadsegment(es, next->es); 
+		loadsegment(es, next->es);
 
 	savesegment(ds, prev->ds);
 	if (unlikely(next->ds | prev->ds))
@@ -584,7 +584,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_leave_lazy_cpu_mode();
 
-	/* 
+	/*
 	 * Switch FS and GS.
 	 *
 	 * Segment register != 0 always requires a reload.  Also
@@ -593,13 +593,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	if (unlikely(fsindex | next->fsindex | prev->fs)) {
 		loadsegment(fs, next->fsindex);
-		/* 
+		/*
 		 * Check if the user used a selector != 0; if yes
 		 *  clear 64bit base, since overloaded base is always
 		 *  mapped to the Null selector
 		 */
 		if (fsindex)
-			prev->fs = 0;				
+			prev->fs = 0;
 	}
 	/* when next process has a 64bit base use it */
 	if (next->fs)
@@ -609,7 +609,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (unlikely(gsindex | next->gsindex | prev->gs)) {
 		load_gs_index(next->gsindex);
 		if (gsindex)
-			prev->gs = 0;				
+			prev->gs = 0;
 	}
 	if (next->gs)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
@@ -618,12 +618,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
 
-	/* 
+	/*
 	 * Switch the PDA and FPU contexts.
 	 */
 	prev->usersp = read_pda(oldrsp);
 	write_pda(oldrsp, next->usersp);
-	write_pda(pcurrent, next_p); 
+	write_pda(pcurrent, next_p);
 
 	write_pda(kernelstack,
 		  (unsigned long)task_stack_page(next_p) +
@@ -664,7 +664,7 @@ long sys_execve(char __user *name, char __user * __user *argv,
 		char __user * __user *envp, struct pt_regs *regs)
 {
 	long error;
-	char * filename;
+	char *filename;
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
@@ -722,55 +722,55 @@ asmlinkage long sys_vfork(struct pt_regs *regs)
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
-	u64 fp,ip;
+	u64 fp, ip;
 	int count = 0;
 
-	if (!p || p == current || p->state==TASK_RUNNING)
-		return 0; 
+	if (!p || p == current || p->state == TASK_RUNNING)
+		return 0;
 	stack = (unsigned long)task_stack_page(p);
 	if (p->thread.sp < stack || p->thread.sp > stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
-	do { 
+	do {
 		if (fp < (unsigned long)stack ||
 		    fp > (unsigned long)stack+THREAD_SIZE)
-			return 0; 
+			return 0;
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))
 			return ip;
-		fp = *(u64 *)fp; 
-	} while (count++ < 16); 
+		fp = *(u64 *)fp;
+	} while (count++ < 16);
 	return 0;
 }
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
-{ 
-	int ret = 0; 
+{
+	int ret = 0;
 	int doit = task == current;
 	int cpu;
 
-	switch (code) { 
+	switch (code) {
 	case ARCH_SET_GS:
 		if (addr >= TASK_SIZE_OF(task))
-			return -EPERM; 
+			return -EPERM;
 		cpu = get_cpu();
-		/* handle small bases via the GDT because that's faster to 
+		/* handle small bases via the GDT because that's faster to
 		   switch. */
-		if (addr <= 0xffffffff) {  
-			set_32bit_tls(task, GS_TLS, addr); 
-			if (doit) { 
+		if (addr <= 0xffffffff) {
+			set_32bit_tls(task, GS_TLS, addr);
+			if (doit) {
 				load_TLS(&task->thread, cpu);
-				load_gs_index(GS_TLS_SEL); 
+				load_gs_index(GS_TLS_SEL);
 			}
-			task->thread.gsindex = GS_TLS_SEL; 
+			task->thread.gsindex = GS_TLS_SEL;
 			task->thread.gs = 0;
-		} else { 
+		} else {
 			task->thread.gsindex = 0;
 			task->thread.gs = addr;
 			if (doit) {
 				load_gs_index(0);
 				ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
-			} 
+			}
 		}
 		put_cpu();
 		break;
@@ -824,8 +824,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 				rdmsrl(MSR_KERNEL_GS_BASE, base);
 			else
 				base = task->thread.gs;
-		}
-		else
+		} else
 			base = task->thread.gs;
 		ret = put_user(base, (unsigned long __user *)addr);
 		break;
-- 
1.5.4.5

