Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXLDNLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXLDNLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXLDNK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:10:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbXLDNK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:10:56 -0500
Date: Tue, 4 Dec 2007 14:10:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean up process_32/64.c
Message-ID: <20071204131037.GF31590@elte.hu>
References: <474CACFB.9060404@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CACFB.9060404@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> White space and coding style clean up.
> Make process_32/64.c similar.

there were renames and other cleanups in x86.git meanwhile that 
conflicted with your patch, so parts of your patch did not apply. Would 
you be interested in resending the remaining cleanups? I've attached the 
current mergup of your patch below.

	Ingo

------------------>
Subject: x86: clean up process_32/64.c
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

White space and coding style clean up.
Make process_32/64.c similar.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/process_32.c |    6 -
 arch/x86/kernel/process_64.c |  175 +++++++++++++++++++++----------------------
 2 files changed, 90 insertions(+), 91 deletions(-)

Index: linux-x86.q/arch/x86/kernel/process_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_32.c
+++ linux-x86.q/arch/x86/kernel/process_32.c
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(default_idle);
  * to poll the ->work.need_resched flag instead of waiting for the
  * cross-CPU IPI to arrive. Use this option with caution.
  */
-static void poll_idle (void)
+static void poll_idle(void)
 {
 	cpu_relax();
 }
@@ -473,7 +473,7 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread.ip = (unsigned long) ret_from_fork;
 
-	savesegment(gs,p->thread.gs);
+	savesegment(gs, p->thread.gs);
 
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
@@ -551,7 +551,7 @@ void dump_thread(struct pt_regs * regs, 
 }
 EXPORT_SYMBOL(dump_thread);
 
-/* 
+/*
  * Capture the user space registers if the task is not running (in user space)
  */
 int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
Index: linux-x86.q/arch/x86/kernel/process_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/process_64.c
+++ linux-x86.q/arch/x86/kernel/process_64.c
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
 
@@ -229,6 +198,36 @@ void cpu_idle(void)
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
@@ -282,7 +281,7 @@ void __cpuinit select_idle_routine(const
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
@@ -431,7 +430,7 @@ void release_thread(struct task_struct *
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 {
-	struct user_desc ud = { 
+	struct user_desc ud = {
 		.base_addr = addr,
 		.limit = 0xfffff,
 		.seg_32bit = 1,
@@ -440,8 +439,8 @@ static inline void set_32bit_tls(struct 
 	};
 	struct n_desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
-	desc->a = LDT_entry_a(&ud); 
-	desc->b = LDT_entry_b(&ud); 
+	desc->a = LDT_entry_a(&ud);
+	desc->b = LDT_entry_b(&ud);
 }
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
@@ -498,7 +497,7 @@ int copy_thread(int nr, unsigned long cl
 		memcpy(p->thread.io_bitmap_ptr, me->thread.io_bitmap_ptr,
 				IO_BITMAP_BYTES);
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
-	} 
+	}
 
 	/*
 	 * Set a new TLS for the child thread?
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
 
@@ -568,7 +585,7 @@ static inline void __switch_to_xtra(stru
 /*
  *	switch_to(x,y) should switch tasks from x to y.
  *
- * This could still be optimized: 
+ * This could still be optimized:
  * - fold all the options into a flag word and test it with a single test.
  * - could test fs/gs bitsliced
  *
@@ -579,7 +596,7 @@ __switch_to(struct task_struct *prev_p, 
 {
 	struct thread_struct *prev = &prev_p->thread,
 				 *next = &next_p->thread;
-	int cpu = smp_processor_id();  
+	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 
 	/* we're going to use this soon, after a few expensive things */
@@ -682,7 +699,7 @@ __switch_to(struct task_struct *prev_p, 
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage 
+asmlinkage
 long sys_execve(char __user *name, char __user * __user *argv,
 		char __user * __user *envp, struct pt_regs regs)
 {
@@ -703,12 +720,12 @@ void set_personality_64bit(void)
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
 
@@ -801,19 +818,19 @@ long do_arch_prctl(struct task_struct *t
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
@@ -825,24 +842,24 @@ long do_arch_prctl(struct task_struct *t
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
@@ -850,39 +867,21 @@ long do_arch_prctl(struct task_struct *t
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
