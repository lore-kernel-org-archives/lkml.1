Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXK0Xtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXK0Xtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbXK0XtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:49:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:3047 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649AbXK0XtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:49:17 -0500
Message-ID: <474CACFB.9060404@ct.jp.nec.com>
Date: Tue, 27 Nov 2007 15:49:15 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: clean up process_32/64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

White space and coding style clean up.
Make process_32/64.c similar.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/process_32.c |   20 ++--
 arch/x86/kernel/process_64.c |  307 +++++++++++++++++++++---------------------
 2 files changed, 163 insertions(+), 164 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a20de7f..bd707db 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(default_idle);
  * to poll the ->work.need_resched flag instead of waiting for the
  * cross-CPU IPI to arrive. Use this option with caution.
  */
-static void poll_idle (void)
+static void poll_idle(void)
 {
 	cpu_relax();
 }
@@ -330,8 +330,8 @@ void __show_registers(struct pt_regs *regs, int all)
 	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
 		regs->esi, regs->edi, regs->ebp, esp);
 	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
-	       regs->xds & 0xffff, regs->xes & 0xffff,
-	       regs->xfs & 0xffff, gs, ss);
+		regs->xds & 0xffff, regs->xes & 0xffff,
+		regs->xfs & 0xffff, gs, ss);
 
 	if (!all)
 		return;
@@ -426,7 +426,7 @@ void flush_thread(void)
 	struct task_struct *tsk = current;
 
 	memset(tsk->thread.debugreg, 0, sizeof(unsigned long)*8);
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 	/*
 	 * Forget coprocessor state..
@@ -451,8 +451,8 @@ void prepare_to_copy(struct task_struct *tsk)
 }
 
 int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
-	unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
+		unsigned long unused,
+		struct task_struct * p, struct pt_regs * regs)
 {
 	struct pt_regs * childregs;
 	struct task_struct *tsk;
@@ -468,7 +468,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
 
 	p->thread.eip = (unsigned long) ret_from_fork;
 
-	savesegment(gs,p->thread.gs);
+	savesegment(gs, p->thread.gs);
 
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
@@ -513,7 +513,7 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
 	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];  
+		dump->u_debugreg[i] = current->thread.debugreg[i];
 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
@@ -528,7 +528,7 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	dump->regs.ds = regs->xds;
 	dump->regs.es = regs->xes;
 	dump->regs.fs = regs->xfs;
-	savesegment(gs,dump->regs.gs);
+	savesegment(gs, dump->regs.gs);
 	dump->regs.orig_eax = regs->orig_eax;
 	dump->regs.eip = regs->eip;
 	dump->regs.cs = regs->xcs;
@@ -540,7 +540,7 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 }
 EXPORT_SYMBOL(dump_thread);
 
-/* 
+/*
  * Capture the user space registers if the task is not running (in user space)
  */
 int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 87c8e7f..57167dc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -3,7 +3,7 @@
  *
  *  Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
- * 
+ *
  *  X86-64 port
  *	Andi Kleen.
  *
@@ -19,19 +19,19 @@
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/fs.h>
 #include <linux/elfcore.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/module.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
+#include <linux/utsname.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/ptrace.h>
-#include <linux/utsname.h>
 #include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
@@ -122,43 +122,12 @@ static void default_idle(void)
  * to poll the ->need_resched flag instead of waiting for the
  * cross-CPU IPI to arrive. Use this option with caution.
  */
-static void poll_idle (void)
+static void poll_idle(void)
 {
 	local_irq_enable();
 	cpu_relax();
 }
 
-void cpu_idle_wait(void)
-{
-	unsigned int cpu, this_cpu = get_cpu();
-	cpumask_t map, tmp = current->cpus_allowed;
-
-	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
-	put_cpu();
-
-	cpus_clear(map);
-	for_each_online_cpu(cpu) {
-		per_cpu(cpu_idle_state, cpu) = 1;
-		cpu_set(cpu, map);
-	}
-
-	__get_cpu_var(cpu_idle_state) = 0;
-
-	wmb();
-	do {
-		ssleep(1);
-		for_each_online_cpu(cpu) {
-			if (cpu_isset(cpu, map) &&
-					!per_cpu(cpu_idle_state, cpu))
-				cpu_clear(cpu, map);
-		}
-		cpus_and(map, map, cpu_online_map);
-	} while (!cpus_empty(map));
-
-	set_cpus_allowed(current, tmp);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 
@@ -189,7 +158,7 @@ static inline void play_dead(void)
  * low exit latency (ie sit in a loop waiting for
  * somebody to say that they'd like to reschedule)
  */
-void cpu_idle (void)
+void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
@@ -229,6 +198,36 @@ void cpu_idle (void)
 	}
 }
 
+void cpu_idle_wait(void)
+{
+	unsigned int cpu, this_cpu = get_cpu();
+	cpumask_t map, tmp = current->cpus_allowed;
+
+	set_cpus_allowed(current, cpumask_of_cpu(this_cpu));
+	put_cpu();
+
+	cpus_clear(map);
+	for_each_online_cpu(cpu) {
+		per_cpu(cpu_idle_state, cpu) = 1;
+		cpu_set(cpu, map);
+	}
+
+	__get_cpu_var(cpu_idle_state) = 0;
+
+	wmb();
+	do {
+		ssleep(1);
+		for_each_online_cpu(cpu) {
+			if (cpu_isset(cpu, map) && !per_cpu(cpu_idle_state, cpu))
+				cpu_clear(cpu, map);
+		}
+		cpus_and(map, map, cpu_online_map);
+	} while (!cpus_empty(map));
+
+	set_cpus_allowed(current, tmp);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
 /*
  * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
  * which can obviate IPI to trigger checking of need_resched.
@@ -282,7 +281,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 	}
 }
 
-static int __init idle_setup (char *str)
+static int __init idle_setup(char *str)
 {
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
@@ -297,13 +296,13 @@ static int __init idle_setup (char *str)
 }
 early_param("idle", idle_setup);
 
-/* Prints also some state that isn't saved in the pt_regs */ 
+/* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
-	unsigned int fsindex,gsindex;
-	unsigned int ds,cs,es; 
+	unsigned int fsindex, gsindex;
+	unsigned int ds, cs, es;
 
 	printk("\n");
 	print_modules();
@@ -313,38 +312,38 @@ void __show_regs(struct pt_regs * regs)
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
 	printk("RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->rip);
-	printk_address(regs->rip); 
+	printk_address(regs->rip);
 	printk("RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss, regs->rsp,
 		regs->eflags);
 	printk("RAX: %016lx RBX: %016lx RCX: %016lx\n",
-	       regs->rax, regs->rbx, regs->rcx);
+		regs->rax, regs->rbx, regs->rcx);
 	printk("RDX: %016lx RSI: %016lx RDI: %016lx\n",
-	       regs->rdx, regs->rsi, regs->rdi); 
+		regs->rdx, regs->rsi, regs->rdi);
 	printk("RBP: %016lx R08: %016lx R09: %016lx\n",
-	       regs->rbp, regs->r8, regs->r9); 
+		regs->rbp, regs->r8, regs->r9);
 	printk("R10: %016lx R11: %016lx R12: %016lx\n",
-	       regs->r10, regs->r11, regs->r12); 
+		regs->r10, regs->r11, regs->r12);
 	printk("R13: %016lx R14: %016lx R15: %016lx\n",
-	       regs->r13, regs->r14, regs->r15); 
+		regs->r13, regs->r14, regs->r15);
 
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
+		fs, fsindex, gs, gsindex, shadowgs);
+	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0);
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
@@ -372,7 +371,7 @@ void exit_thread(void)
 	struct task_struct *me = current;
 	struct thread_struct *t = &me->thread;
 
-	if (me->thread.io_bitmap_ptr) { 
+	if (me->thread.io_bitmap_ptr) {
 		struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
 
 		kfree(t->io_bitmap_ptr);
@@ -408,7 +407,7 @@ void flush_thread(void)
 	tsk->thread.debugreg3 = 0;
 	tsk->thread.debugreg6 = 0;
 	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	/*
 	 * Forget coprocessor state..
 	 */
@@ -431,7 +430,7 @@ void release_thread(struct task_struct *dead_task)
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 {
-	struct user_desc ud = { 
+	struct user_desc ud = {
 		.base_addr = addr,
 		.limit = 0xfffff,
 		.seg_32bit = 1,
@@ -440,8 +439,8 @@ static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 	};
 	struct n_desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
-	desc->a = LDT_entry_a(&ud); 
-	desc->b = LDT_entry_b(&ud); 
+	desc->a = LDT_entry_a(&ud);
+	desc->b = LDT_entry_b(&ud);
 }
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
@@ -458,9 +457,9 @@ void prepare_to_copy(struct task_struct *tsk)
 	unlazy_fpu(tsk);
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp, 
+int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp,
 		unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
+		struct task_struct * p, struct pt_regs * regs)
 {
 	int err;
 	struct pt_regs * childregs;
@@ -477,7 +476,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp,
 
 	p->thread.rsp = (unsigned long) childregs;
 	p->thread.rsp0 = (unsigned long) (childregs+1);
-	p->thread.userrsp = me->thread.userrsp; 
+	p->thread.userrsp = me->thread.userrsp;
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
@@ -498,7 +497,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp,
 		memcpy(p->thread.io_bitmap_ptr, me->thread.io_bitmap_ptr,
 				IO_BITMAP_BYTES);
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
-	} 
+	}
 
 	/*
 	 * Set a new TLS for the child thread?
@@ -508,10 +507,10 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp,
 		if (test_thread_flag(TIF_IA32))
 			err = do_set_thread_area(p, -1,
 				(struct user_desc __user *)childregs->rsi, 0);
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
@@ -526,11 +525,29 @@ out:
 /*
  * This special macro can be used to load a debugging register
  */
-#define loaddebug(thread,r) set_debugreg(thread->debugreg ## r, r)
+#define loaddebug(thread, r) set_debugreg(thread->debugreg ## r, r)
+
+/*
+ * Capture the user space registers if the task is not running (in user space)
+ */
+int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
+{
+	struct pt_regs *pp, ptregs;
+
+	pp = task_pt_regs(tsk);
+
+	ptregs = *pp;
+	ptregs.cs &= 0xffff;
+	ptregs.ss &= 0xffff;
+
+	elf_core_copy_regs(regs, &ptregs);
+
+	return 1;
+}
 
 static inline void __switch_to_xtra(struct task_struct *prev_p,
-			     	    struct task_struct *next_p,
-			     	    struct tss_struct *tss)
+				    struct task_struct *next_p,
+				    struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
 
@@ -565,7 +582,7 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
 /*
  *	switch_to(x,y) should switch tasks from x to y.
  *
- * This could still be optimized: 
+ * This could still be optimized:
  * - fold all the options into a flag word and test it with a single test.
  * - could test fs/gs bitsliced
  *
@@ -576,7 +593,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
 				 *next = &next_p->thread;
-	int cpu = smp_processor_id();  
+	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 
 	/* we're going to use this soon, after a few expensive things */
@@ -588,66 +605,66 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	tss->rsp0 = next->rsp0;
 
-	/* 
+	/*
 	 * Switch DS and ES.
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	asm volatile("mov %%es,%0" : "=m" (prev->es));
 	if (unlikely(next->es | prev->es))
-		loadsegment(es, next->es); 
-	
+		loadsegment(es, next->es);
+
 	asm volatile ("mov %%ds,%0" : "=m" (prev->ds));
 	if (unlikely(next->ds | prev->ds))
 		loadsegment(ds, next->ds);
 
 	load_TLS(next, cpu);
 
-	/* 
+	/*
 	 * Switch FS and GS.
 	 */
-	{ 
+	{
 		unsigned fsindex;
-		asm volatile("movl %%fs,%0" : "=r" (fsindex)); 
-		/* segment register != 0 always requires a reload. 
-		   also reload when it has changed. 
+		asm volatile("movl %%fs,%0" : "=r" (fsindex));
+		/* segment register != 0 always requires a reload.
+		   also reload when it has changed.
 		   when prev process used 64bit base always reload
 		   to avoid an information leak. */
 		if (unlikely(fsindex | next->fsindex | prev->fs)) {
 			loadsegment(fs, next->fsindex);
 			/* check if the user used a selector != 0
-	                 * if yes clear 64bit base, since overloaded base
-                         * is always mapped to the Null selector
-                         */
+			 * if yes clear 64bit base, since overloaded base
+			 * is always mapped to the Null selector
+			 */
 			if (fsindex)
-			prev->fs = 0;				
+			prev->fs = 0;
 		}
 		/* when next process has a 64bit base use it */
-		if (next->fs) 
-			wrmsrl(MSR_FS_BASE, next->fs); 
+		if (next->fs)
+			wrmsrl(MSR_FS_BASE, next->fs);
 		prev->fsindex = fsindex;
 	}
-	{ 
+	{
 		unsigned gsindex;
-		asm volatile("movl %%gs,%0" : "=r" (gsindex)); 
+		asm volatile("movl %%gs,%0" : "=r" (gsindex));
 		if (unlikely(gsindex | next->gsindex | prev->gs)) {
 			load_gs_index(next->gsindex);
 			if (gsindex)
-			prev->gs = 0;				
+			prev->gs = 0;
 		}
 		if (next->gs)
-			wrmsrl(MSR_KERNEL_GS_BASE, next->gs); 
+			wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 		prev->gsindex = gsindex;
 	}
 
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
 
-	/* 
+	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->userrsp = read_pda(oldrsp); 
-	write_pda(oldrsp, next->userrsp); 
-	write_pda(pcurrent, next_p); 
+	prev->userrsp = read_pda(oldrsp);
+	write_pda(oldrsp, next->userrsp);
+	write_pda(pcurrent, next_p);
 
 	write_pda(kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
@@ -679,7 +696,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage 
+asmlinkage
 long sys_execve(char __user *name, char __user * __user *argv,
 		char __user * __user *envp, struct pt_regs regs)
 {
@@ -688,9 +705,9 @@ long sys_execve(char __user *name, char __user * __user *argv,
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (IS_ERR(filename)) 
+	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, &regs); 
+	error = do_execve(filename, argv, envp, &regs);
 	if (error == 0) {
 		task_lock(current);
 		current->ptrace &= ~PT_DTRACE;
@@ -705,12 +722,12 @@ void set_personality_64bit(void)
 	/* inherit personality from parent */
 
 	/* Make sure to be in 64bit mode */
-	clear_thread_flag(TIF_IA32); 
+	clear_thread_flag(TIF_IA32);
 
 	/* TBD: overwrites user setup. Should have two bits.
 	   But 64bit processes have always behaved this way,
 	   so it's not too bad. The main problem is just that
-   	   32bit childs are affected again. */
+	   32bit childs are affected again. */
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
@@ -747,55 +764,55 @@ asmlinkage long sys_vfork(struct pt_regs *regs)
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
-	u64 fp,rip;
+	u64 fp, rip;
 	int count = 0;
 
 	if (!p || p == current || p->state==TASK_RUNNING)
-		return 0; 
+		return 0;
 	stack = (unsigned long)task_stack_page(p);
 	if (p->thread.rsp < stack || p->thread.rsp > stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.rsp);
-	do { 
+	do {
 		if (fp < (unsigned long)stack ||
 		    fp > (unsigned long)stack+THREAD_SIZE)
-			return 0; 
-		rip = *(u64 *)(fp+8); 
+			return 0;
+		rip = *(u64 *)(fp+8);
 		if (!in_sched_functions(rip))
-			return rip; 
-		fp = *(u64 *)fp; 
-	} while (count++ < 16); 
+			return rip;
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
@@ -803,19 +820,19 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		/* Not strictly needed for fs, but do it for symmetry
 		   with gs */
 		if (addr >= TASK_SIZE_OF(task))
-			return -EPERM; 
+			return -EPERM;
 		cpu = get_cpu();
-		/* handle small bases via the GDT because that's faster to 
+		/* handle small bases via the GDT because that's faster to
 		   switch. */
-		if (addr <= 0xffffffff) { 
+		if (addr <= 0xffffffff) {
 			set_32bit_tls(task, FS_TLS, addr);
-			if (doit) { 
-				load_TLS(&task->thread, cpu); 
+			if (doit) {
+				load_TLS(&task->thread, cpu);
 				asm volatile("movl %0,%%fs" :: "r"(FS_TLS_SEL));
 			}
 			task->thread.fsindex = FS_TLS_SEL;
 			task->thread.fs = 0;
-		} else { 
+		} else {
 			task->thread.fsindex = 0;
 			task->thread.fs = addr;
 			if (doit) {
@@ -827,24 +844,24 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		}
 		put_cpu();
 		break;
-	case ARCH_GET_FS: { 
-		unsigned long base; 
+	case ARCH_GET_FS: {
+		unsigned long base;
 		if (task->thread.fsindex == FS_TLS_SEL)
 			base = read_32bit_tls(task, FS_TLS);
 		else if (doit)
 			rdmsrl(MSR_FS_BASE, base);
 		else
 			base = task->thread.fs;
-		ret = put_user(base, (unsigned long __user *)addr); 
-		break; 
+		ret = put_user(base, (unsigned long __user *)addr);
+		break;
 	}
-	case ARCH_GET_GS: { 
+	case ARCH_GET_GS: {
 		unsigned long base;
 		unsigned gsindex;
 		if (task->thread.gsindex == GS_TLS_SEL)
 			base = read_32bit_tls(task, GS_TLS);
 		else if (doit) {
- 			asm("movl %%gs,%0" : "=r" (gsindex));
+			asm("movl %%gs,%0" : "=r" (gsindex));
 			if (gsindex)
 				rdmsrl(MSR_KERNEL_GS_BASE, base);
 			else
@@ -852,39 +869,21 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		}
 		else
 			base = task->thread.gs;
-		ret = put_user(base, (unsigned long __user *)addr); 
+		ret = put_user(base, (unsigned long __user *)addr);
 		break;
 	}
 
 	default:
 		ret = -EINVAL;
 		break;
-	} 
+	}
 
-	return ret;	
-} 
+	return ret;
+}
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
 	return do_arch_prctl(current, code, addr);
-} 
-
-/* 
- * Capture the user space registers if the task is not running (in user space)
- */
-int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
-{
-	struct pt_regs *pp, ptregs;
-
-	pp = task_pt_regs(tsk);
-
-	ptregs = *pp; 
-	ptregs.cs &= 0xffff;
-	ptregs.ss &= 0xffff;
-
-	elf_core_copy_regs(regs, &ptregs);
- 
-	return 1;
 }
 
 unsigned long arch_align_stack(unsigned long sp)
-- 
1.5.3.4

