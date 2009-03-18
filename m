Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZCRVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZCRVuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbZCRVnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:12 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757819AbZCRVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:09 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 24/57] microblaze_v7: process and init task function
Date: Wed, 18 Mar 2009 21:30:51 +0100
Message-Id: <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/init_task.c |   27 +++++
 arch/microblaze/kernel/process.c   |  185 ++++++++++++++++++++++++++++++++++++
 2 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/init_task.c
 create mode 100644 arch/microblaze/kernel/process.c

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
new file mode 100644
index 0000000..1abdfdb
--- /dev/null
+++ b/arch/microblaze/kernel/init_task.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/init_task.h>
+#include <linux/fs.h>
+#include <linux/mqueue.h>
+
+#include <asm/pgtable.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+EXPORT_SYMBOL(init_mm);
+
+union thread_union init_thread_union
+	__attribute__((__section__(".data.init_task"))) =
+{ INIT_THREAD_INFO(init_task) };
+
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
new file mode 100644
index 0000000..157893e
--- /dev/null
+++ b/arch/microblaze/kernel/process.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/pm.h>
+#include <linux/tick.h>
+#include <linux/bitops.h>
+#include <asm/system.h>
+#include <asm/pgalloc.h>
+
+void show_regs(struct pt_regs *regs)
+{
+	printk(KERN_INFO " Registers dump: mode=%X\r\n", regs->kernel_mode);
+	printk(KERN_INFO " r1=%08lX, r2=%08lX, r3=%08lX, r4=%08lX\n",
+				regs->r1, regs->r2, regs->r3, regs->r4);
+	printk(KERN_INFO " r5=%08lX, r6=%08lX, r7=%08lX, r8=%08lX\n",
+				regs->r5, regs->r6, regs->r7, regs->r8);
+	printk(KERN_INFO " r9=%08lX, r10=%08lX, r11=%08lX, r12=%08lX\n",
+				regs->r9, regs->r10, regs->r11, regs->r12);
+	printk(KERN_INFO " r13=%08lX, r14=%08lX, r15=%08lX, r16=%08lX\n",
+				regs->r13, regs->r14, regs->r15, regs->r16);
+	printk(KERN_INFO " r17=%08lX, r18=%08lX, r19=%08lX, r20=%08lX\n",
+				regs->r17, regs->r18, regs->r19, regs->r20);
+	printk(KERN_INFO " r21=%08lX, r22=%08lX, r23=%08lX, r24=%08lX\n",
+				regs->r21, regs->r22, regs->r23, regs->r24);
+	printk(KERN_INFO " r25=%08lX, r26=%08lX, r27=%08lX, r28=%08lX\n",
+				regs->r25, regs->r26, regs->r27, regs->r28);
+	printk(KERN_INFO " r29=%08lX, r30=%08lX, r31=%08lX, rPC=%08lX\n",
+				regs->r29, regs->r30, regs->r31, regs->pc);
+	printk(KERN_INFO " msr=%08lX, ear=%08lX, esr=%08lX, fsr=%08lX\n",
+				regs->msr, regs->ear, regs->esr, regs->fsr);
+	while(1);
+}
+
+void (*pm_idle)(void);
+void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
+
+static int hlt_counter = 1;
+
+void disable_hlt(void)
+{
+	hlt_counter++;
+}
+EXPORT_SYMBOL(disable_hlt);
+
+void enable_hlt(void)
+{
+	hlt_counter--;
+}
+EXPORT_SYMBOL(enable_hlt);
+
+static int __init nohlt_setup(char *__unused)
+{
+	hlt_counter = 1;
+	return 1;
+}
+__setup("nohlt", nohlt_setup);
+
+static int __init hlt_setup(char *__unused)
+{
+	hlt_counter = 0;
+	return 1;
+}
+__setup("hlt", hlt_setup);
+
+void default_idle(void)
+{
+	if (!hlt_counter) {
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+		smp_mb__after_clear_bit();
+		local_irq_disable();
+		while (!need_resched())
+			cpu_sleep();
+		local_irq_enable();
+		set_thread_flag(TIF_POLLING_NRFLAG);
+	} else
+		while (!need_resched())
+			cpu_relax();
+}
+
+void cpu_idle(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	/* endless idle loop with no priority at all */
+	while (1) {
+		void (*idle)(void) = pm_idle;
+
+		if (!idle)
+			idle = default_idle;
+
+		tick_nohz_stop_sched_tick(1);
+		while (!need_resched())
+			idle();
+		tick_nohz_restart_sched_tick();
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+		check_pgt_cache();
+	}
+}
+
+void flush_thread(void)
+{
+}
+
+int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+		unsigned long unused,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs = task_pt_regs(p);
+	struct thread_info *ti = task_thread_info(p);
+
+	*childregs = *regs;
+	if (user_mode(regs))
+		childregs->r1 = usp;
+	else
+		childregs->r1 = ((unsigned long) ti) + THREAD_SIZE;
+
+	memset(&ti->cpu_context, 0, sizeof(struct cpu_context));
+	ti->cpu_context.r1 = (unsigned long)childregs;
+	ti->cpu_context.msr = (unsigned long)childregs->msr;
+	ti->cpu_context.r15 = (unsigned long)ret_from_fork - 8;
+
+	if (clone_flags & CLONE_SETTLS)
+		;
+
+	return 0;
+}
+
+/*
+ * Return saved PC of a blocked thread.
+ */
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+	struct cpu_context *ctx =
+		&(((struct thread_info *)(tsk->stack))->cpu_context);
+
+	/* Check whether the thread is blocked in resume() */
+	if (in_sched_functions(ctx->r15))
+		return (unsigned long)ctx->r15;
+	else
+		return ctx->r14;
+}
+
+static void kernel_thread_helper(int (*fn)(void *), void *arg)
+{
+	fn(arg);
+	do_exit(-1);
+}
+
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+	int ret;
+
+	memset(&regs, 0, sizeof(regs));
+	/* store them in non-volatile registers */
+	regs.r5 = (unsigned long)fn;
+	regs.r6 = (unsigned long)arg;
+	local_save_flags(regs.msr);
+	regs.pc = (unsigned long)kernel_thread_helper;
+	regs.kernel_mode = 1;
+
+	ret = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+			&regs, 0, NULL, NULL);
+
+	return ret;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+/* TBD (used by procfs) */
+	return 0;
+}
-- 
1.5.5.1

