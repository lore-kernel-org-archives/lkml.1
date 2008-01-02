Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYABULm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYABULm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYABUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:09:40 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55713 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYABUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:09:37 -0500
Date: Wed, 2 Jan 2008 15:08:52 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/7] UML - Style fixes in arch/um/kernel
Message-ID: <20080102200852.GA7959@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches noticed some printks in smp.c that needed fixing.

While I was in there, I did the usual tidying in arch/um/kernel, which
should be fairly style-clean at this point:
	copyright updates
	emacs formatting comments removal
	include tidying
	style fixes

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/exitcode.c   |   31 ++++++++++++++++--------------
 arch/um/kernel/gmon_syms.c  |   11 +++++-----
 arch/um/kernel/gprof_syms.c |   13 ------------
 arch/um/kernel/process.c    |   41 +++++++++++++++++++++-------------------
 arch/um/kernel/reboot.c     |    6 ++---
 arch/um/kernel/sigio.c      |   18 +++++------------
 arch/um/kernel/signal.c     |   16 +++++++--------
 arch/um/kernel/smp.c        |    7 ++----
 arch/um/kernel/sysrq.c      |   45 ++++++++++++++++++++------------------------
 arch/um/kernel/time.c       |   14 ++++++-------
 arch/um/kernel/tlb.c        |    2 -
 arch/um/kernel/uaccess.c    |   11 ++++++----
 arch/um/kernel/um_arch.c    |   26 ++++++++++++-------------
 arch/um/kernel/umid.c       |   15 ++++++--------
 14 files changed, 122 insertions(+), 134 deletions(-)

Index: linux-2.6-git/arch/um/kernel/gprof_syms.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/gprof_syms.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/gprof_syms.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -7,14 +7,3 @@
 
 extern void mcount(void);
 EXPORT_SYMBOL(mcount);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6-git/arch/um/kernel/smp.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/smp.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/smp.c	2008-01-02 11:38:16.000000000 -0500
@@ -60,7 +60,7 @@ void smp_send_stop(void)
 			continue;
 		os_write_file(cpu_data[i].ipi_pipe[1], "S", 1);
 	}
-	printk(KERN_INFO "done\n");
+	printk(KERN_CONT "done\n");
 }
 
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
@@ -140,9 +140,8 @@ void smp_prepare_cpus(unsigned int maxcp
 		while (waittime-- && !cpu_isset(cpu, cpu_callin_map))
 			cpu_relax();
 
-		if (cpu_isset(cpu, cpu_callin_map))
-			printk(KERN_INFO "done\n");
-		else printk(KERN_INFO "failed\n");
+		printk(KERN_INFO "%s\n",
+		       cpu_isset(cpu, cpu_calling_map) ? "done" : "failed");
 	}
 }
 
Index: linux-2.6-git/arch/um/kernel/sigio.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/sigio.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/sigio.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,18 +1,12 @@
 /*
- * Copyright (C) 2002 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/list.h"
-#include "linux/slab.h"
-#include "linux/signal.h"
-#include "linux/interrupt.h"
-#include "init.h"
-#include "sigio.h"
-#include "irq_user.h"
+#include <linux/interrupt.h>
 #include "irq_kern.h"
 #include "os.h"
+#include "sigio.h"
 
 /* Protected by sigio_lock() called from write_sigio_workaround */
 static int sigio_irq_fd = -1;
@@ -33,9 +27,9 @@ int write_sigio_irq(int fd)
 	err = um_request_irq(SIGIO_WRITE_IRQ, fd, IRQ_READ, sigio_interrupt,
 			     IRQF_DISABLED|IRQF_SAMPLE_RANDOM, "write sigio",
 			     NULL);
-	if(err){
-		printk("write_sigio_irq : um_request_irq failed, err = %d\n",
-		       err);
+	if (err) {
+		printk(KERN_ERR "write_sigio_irq : um_request_irq failed, "
+		       "err = %d\n", err);
 		return -1;
 	}
 	sigio_irq_fd = fd;
Index: linux-2.6-git/arch/um/kernel/exitcode.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/exitcode.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/exitcode.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,15 +1,17 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/init.h"
-#include "linux/ctype.h"
-#include "linux/proc_fs.h"
-#include "asm/uaccess.h"
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/types.h>
+#include <asm/uaccess.h>
 
-/* If read and write race, the read will still atomically read a valid
+/*
+ * If read and write race, the read will still atomically read a valid
  * value.
  */
 int uml_exitcode = 0;
@@ -19,18 +21,19 @@ static int read_proc_exitcode(char *page
 {
 	int len, val;
 
-	/* Save uml_exitcode in a local so that we don't need to guarantee
+	/*
+	 * Save uml_exitcode in a local so that we don't need to guarantee
 	 * that sprintf accesses it atomically.
 	 */
 	val = uml_exitcode;
 	len = sprintf(page, "%d\n", val);
 	len -= off;
-	if(len <= off+count)
+	if (len <= off+count)
 		*eof = 1;
 	*start = page + off;
-	if(len > count)
+	if (len > count)
 		len = count;
-	if(len < 0)
+	if (len < 0)
 		len = 0;
 	return len;
 }
@@ -41,11 +44,11 @@ static int write_proc_exitcode(struct fi
 	char *end, buf[sizeof("nnnnn\0")];
 	int tmp;
 
-	if(copy_from_user(buf, buffer, count))
+	if (copy_from_user(buf, buffer, count))
 		return -EFAULT;
 
 	tmp = simple_strtol(buf, &end, 0);
-	if((*end != '\0') && !isspace(*end))
+	if ((*end != '\0') && !isspace(*end))
 		return -EINVAL;
 
 	uml_exitcode = tmp;
@@ -57,7 +60,7 @@ static int make_proc_exitcode(void)
 	struct proc_dir_entry *ent;
 
 	ent = create_proc_entry("exitcode", 0600, &proc_root);
-	if(ent == NULL){
+	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
 		return 0;
Index: linux-2.6-git/arch/um/kernel/gmon_syms.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/gmon_syms.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/gmon_syms.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,5 +1,5 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -8,12 +8,13 @@
 extern void __bb_init_func(void *)  __attribute__((weak));
 EXPORT_SYMBOL(__bb_init_func);
 
-/* This is defined (and referred to in profiling stub code) only by some GCC
+/*
+ * This is defined (and referred to in profiling stub code) only by some GCC
  * versions in libgcov.
  *
  * Since SuSE backported the fix, we cannot handle it depending on GCC version.
- * So, unconditionally export it. But also give it a weak declaration, which will
- * be overridden by any other one.
+ * So, unconditionally export it. But also give it a weak declaration, which
+ * will be overridden by any other one.
  */
 
 extern void __gcov_init(void *) __attribute__((weak));
Index: linux-2.6-git/arch/um/kernel/sysrq.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/sysrq.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/sysrq.c	2008-01-02 11:42:39.000000000 -0500
@@ -1,38 +1,37 @@
-/* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/kernel.h"
-#include "linux/module.h"
-#include "linux/kallsyms.h"
-#include "asm/page.h"
-#include "asm/processor.h"
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
 #include "sysrq.h"
 
 /* Catch non-i386 SUBARCH's. */
 #if !defined(CONFIG_UML_X86) || defined(CONFIG_64BIT)
 void show_trace(struct task_struct *task, unsigned long * stack)
 {
-        unsigned long addr;
+	unsigned long addr;
 
-        if (!stack) {
+	if (!stack) {
 		stack = (unsigned long*) &stack;
 		WARN_ON(1);
 	}
 
-        printk("Call Trace: \n");
-        while (((long) stack & (THREAD_SIZE-1)) != 0) {
-                addr = *stack;
+	printk(KERN_INFO "Call Trace: \n");
+	while (((long) stack & (THREAD_SIZE-1)) != 0) {
+		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			printk("%08lx:  [<%08lx>]", (unsigned long) stack, addr);
-			print_symbol(" %s", addr);
-			printk("\n");
-                }
-                stack++;
-        }
-        printk("\n");
+			printk(KERN_INFO "%08lx:  [<%08lx>]",
+			       (unsigned long) stack, addr);
+			print_symbol(KERN_CONT " %s", addr);
+			printk(KERN_CONT "\n");
+		}
+		stack++;
+	}
+	printk(KERN_INFO "\n");
 }
 #endif
 
@@ -67,14 +66,13 @@ void show_stack(struct task_struct *task
 	}
 
 	stack = esp;
-	for(i = 0; i < kstack_depth_to_print; i++) {
+	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % 8) == 0))
-			printk("\n       ");
+			printk("\n" KERN_INFO "       ");
 		printk("%08lx ", *stack++);
 	}
 
-	printk("Call Trace: \n");
 	show_trace(task, esp);
 }
Index: linux-2.6-git/arch/um/kernel/umid.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/umid.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/umid.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,13 +1,12 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "asm/errno.h"
+#include <asm/errno.h>
 #include "init.h"
-#include "os.h"
 #include "kern.h"
-#include "linux/kernel.h"
+#include "os.h"
 
 /* Changed by set_umid_arg */
 static int umid_inited = 0;
@@ -16,16 +15,16 @@ static int __init set_umid_arg(char *nam
 {
 	int err;
 
-	if(umid_inited){
+	if (umid_inited) {
 		printf("umid already set\n");
 		return 0;
 	}
 
 	*add = 0;
 	err = set_umid(name);
-	if(err == -EEXIST)
+	if (err == -EEXIST)
 		printf("umid '%s' already in use\n", name);
-	else if(!err)
+	else if (!err)
 		umid_inited = 1;
 
 	return 0;
Index: linux-2.6-git/arch/um/kernel/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/process.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/process.c	2008-01-02 11:38:16.000000000 -0500
@@ -4,19 +4,21 @@
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/err.h"
-#include "linux/hardirq.h"
-#include "linux/mm.h"
-#include "linux/personality.h"
-#include "linux/proc_fs.h"
-#include "linux/ptrace.h"
-#include "linux/random.h"
-#include "linux/sched.h"
-#include "linux/tick.h"
-#include "linux/threads.h"
-#include "asm/pgtable.h"
-#include "asm/uaccess.h"
+#include <linux/stddef.h>
+#include <linux/err.h>
+#include <linux/hardirq.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/personality.h>
+#include <linux/proc_fs.h>
+#include <linux/ptrace.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+#include <linux/threads.h>
+#include <asm/current.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
@@ -40,7 +42,7 @@ int pid_to_processor_id(int pid)
 {
 	int i;
 
-	for(i = 0; i < ncpus; i++) {
+	for (i = 0; i < ncpus; i++) {
 		if (cpu_tasks[i].pid == pid)
 			return i;
 	}
@@ -94,14 +96,15 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		switch_threads(&from->thread.switch_buf, &to->thread.switch_buf);
+		switch_threads(&from->thread.switch_buf,
+			       &to->thread.switch_buf);
 
 		arch_switch_to(current);
 
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
-		next = current->thread.saved_task;
-		prev = current;
+		to = current->thread.saved_task;
+		from = current;
 	} while (current->thread.saved_task);
 
 	return current->thread.prev_sched;
@@ -232,7 +235,7 @@ void default_idle(void)
 {
 	unsigned long long nsecs;
 
-	while(1) {
+	while (1) {
 		/* endless idle loop with no priority at all */
 
 		/*
@@ -387,7 +390,7 @@ int singlestepping(void * t)
 {
 	struct task_struct *task = t ? t : current;
 
-	if ( ! (task->ptrace & PT_DTRACE) )
+	if (!(task->ptrace & PT_DTRACE))
 		return 0;
 
 	if (task->thread.singlestep_syscall)
Index: linux-2.6-git/arch/um/kernel/reboot.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/reboot.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/reboot.c	2008-01-02 11:38:16.000000000 -0500
@@ -12,7 +12,7 @@ void (*pm_power_off)(void);
 
 static void kill_off_processes(void)
 {
-	if(proc_mm)
+	if (proc_mm)
 		/*
 		 * FIXME: need to loop over userspace_pids
 		 */
@@ -22,8 +22,8 @@ static void kill_off_processes(void)
 		int pid, me;
 
 		me = os_getpid();
-		for_each_process(p){
-			if(p->mm == NULL)
+		for_each_process(p) {
+			if (p->mm == NULL)
 				continue;
 
 			pid = p->mm->context.id.u.pid;
Index: linux-2.6-git/arch/um/kernel/uaccess.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/uaccess.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/uaccess.c	2008-01-02 11:38:16.000000000 -0500
@@ -1,10 +1,11 @@
 /*
  * Copyright (C) 2001 Chris Emerson (cemerson@chiark.greenend.org.uk)
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-/* These are here rather than tt/uaccess.c because skas mode needs them in
+/*
+ * These are here rather than tt/uaccess.c because skas mode needs them in
  * order to do SIGBUS recovery when a tmpfs mount runs out of room.
  */
 
@@ -25,6 +26,8 @@ int __do_copy_to_user(void *to, const vo
 
 	fault = __do_user_copy(to, from, n, fault_addr, fault_catcher,
 			       __do_copy, &faulted);
-	if(!faulted) return(0);
-	else return(n - (fault - (unsigned long) to));
+	if (!faulted)
+		return 0;
+	else
+		return n - (fault - (unsigned long) to);
 }
Index: linux-2.6-git/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/um_arch.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/um_arch.c	2008-01-02 11:38:16.000000000 -0500
@@ -3,23 +3,23 @@
  * Licensed under the GPL
  */
 
-#include "linux/delay.h"
-#include "linux/mm.h"
-#include "linux/module.h"
-#include "linux/seq_file.h"
-#include "linux/string.h"
-#include "linux/utsname.h"
-#include "asm/pgtable.h"
-#include "asm/processor.h"
-#include "asm/setup.h"
-#include "arch.h"
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/utsname.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
 #include "as-layout.h"
+#include "arch.h"
 #include "init.h"
 #include "kern.h"
 #include "kern_util.h"
 #include "mem_user.h"
 #include "os.h"
-#include "skas.h"
 
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
@@ -201,7 +201,7 @@ static void __init uml_checksetup(char *
 	struct uml_param *p;
 
 	p = &__uml_setup_start;
-	while(p < &__uml_setup_end) {
+	while (p < &__uml_setup_end) {
 		int n;
 
 		n = strlen(p->str);
@@ -216,7 +216,7 @@ static void __init uml_postsetup(void)
 	initcall_t *p;
 
 	p = &__uml_postsetup_start;
-	while(p < &__uml_postsetup_end) {
+	while (p < &__uml_postsetup_end) {
 		(*p)();
 		p++;
 	}
Index: linux-2.6-git/arch/um/kernel/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/signal.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/signal.c	2008-01-02 11:38:16.000000000 -0500
@@ -3,12 +3,12 @@
  * Licensed under the GPL
  */
 
-#include "linux/module.h"
-#include "linux/ptrace.h"
-#include "linux/sched.h"
-#include "asm/siginfo.h"
-#include "asm/signal.h"
-#include "asm/unistd.h"
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <asm/siginfo.h>
+#include <asm/signal.h>
+#include <asm/unistd.h>
 #include "frame_kern.h"
 #include "kern_util.h"
 #include "sigcontext.h"
@@ -36,7 +36,7 @@ static int handle_signal(struct pt_regs 
 	/* Did we come from a system call? */
 	if (PT_REGS_SYSCALL_NR(regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch(PT_REGS_SYSCALL_RET(regs)) {
+		switch (PT_REGS_SYSCALL_RET(regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			PT_REGS_SYSCALL_RET(regs) = -EINTR;
@@ -116,7 +116,7 @@ static int kern_do_signal(struct pt_regs
 	/* Did we come from a system call? */
 	if (!handled_sig && (PT_REGS_SYSCALL_NR(regs) >= 0)) {
 		/* Restart the system call - no handlers present */
-		switch(PT_REGS_SYSCALL_RET(regs)) {
+		switch (PT_REGS_SYSCALL_RET(regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
Index: linux-2.6-git/arch/um/kernel/time.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/time.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/time.c	2008-01-02 11:38:16.000000000 -0500
@@ -3,12 +3,12 @@
  * Licensed under the GPL
  */
 
-#include "linux/clockchips.h"
-#include "linux/interrupt.h"
-#include "linux/jiffies.h"
-#include "linux/threads.h"
-#include "asm/irq.h"
-#include "asm/param.h"
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/threads.h>
+#include <asm/irq.h>
+#include <asm/param.h>
 #include "kern_util.h"
 #include "os.h"
 
@@ -32,7 +32,7 @@ void timer_handler(int sig, struct uml_p
 static void itimer_set_mode(enum clock_event_mode mode,
 			    struct clock_event_device *evt)
 {
-	switch(mode) {
+	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		set_interval();
 		break;
Index: linux-2.6-git/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/tlb.c	2008-01-02 11:37:43.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/tlb.c	2008-01-02 11:38:16.000000000 -0500
@@ -57,7 +57,7 @@ static int do_ops(struct host_vm_change 
 
 	for (i = 0; i < end && !ret; i++) {
 		op = &hvc->ops[i];
-		switch(op->type) {
+		switch (op->type) {
 		case MMAP:
 			ret = map(hvc->id, op->u.mmap.addr, op->u.mmap.len,
 				  op->u.mmap.prot, op->u.mmap.fd,
