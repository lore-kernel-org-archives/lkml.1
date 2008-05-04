Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYEDPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYEDPh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYEDPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:37:20 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:51379 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbYEDPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:37:18 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 23/56] microblaze_v2: process and init task function
Date: Sun,  4 May 2008 13:41:12 +0200
Message-Id: <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/init_task.c |   31 +++++++++
 arch/microblaze/kernel/process.c   |  129 ++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/init_task.c
 create mode 100644 arch/microblaze/kernel/process.c

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
new file mode 100644
index 0000000..7c6bce3
--- /dev/null
+++ b/arch/microblaze/kernel/init_task.c
@@ -0,0 +1,31 @@
+/*
+ * arch/microblaze/kernel/init_task.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+static struct fs_struct init_fs = INIT_FS;
+static struct files_struct init_files = INIT_FILES;
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
index 0000000..679fe19
--- /dev/null
+++ b/arch/microblaze/kernel/process.c
@@ -0,0 +1,129 @@
+/*
+ * arch/microblaze/kernel/process.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/pm.h>
+
+#include <asm/system.h>
+
+/* FIXME */
+void show_regs(struct pt_regs *regs)
+{
+	unsigned long *p;
+	int i;
+	printk(KERN_INFO "pc:\t0x%08lx\tsp:\t0x%08lx\n", regs->pc, regs->r1);
+	printk(KERN_INFO
+		"flags:\t0x%08lx\tear:\t0x%08lx\tesr:\t"
+		"0x%08lx\tfsr:\t0x%08lx\n",
+		regs->msr, regs->ear, regs->esr, regs->fsr);
+	printk(KERN_INFO
+		"r0:\t0x%08lx\tr1:\t0x%08lx\tr2:\t0x%08lx\tr3\t0x%08lx\n",
+		0L, regs->r1, regs->r2, regs->r3);
+	for (i = 4, p = &(regs->r4); i < 32; i += 4, p += 4) {
+		printk(KERN_INFO "r%i:\t0x%08lx\tr%i:\t0x%08lx\tr%i:\t"
+			"0x%08lx\tr%i:\t0x%08lx\n",
+			i, *p, i+1, *(p+1), i+2, *(p+2), i+3, *(p+3));
+	}
+	printk(KERN_INFO "\n");
+}
+
+void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
+
+void cpu_idle(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while (1) {
+		while (!need_resched())
+			cpu_relax();
+
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
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
+
+	if (user_mode(regs))
+		childregs->r1 = usp;
+	else
+		childregs->r1 = ((unsigned long) ti) + THREAD_SIZE;
+
+	memset(&ti->cpu_context, 0, sizeof(struct cpu_context));
+	ti->cpu_context.sp = (unsigned long)childregs;
+	ti->cpu_context.msr = (unsigned long)childregs->msr;
+	ti->cpu_context.r15 = (unsigned long)ret_from_fork - 8;
+
+	if (clone_flags & CLONE_SETTLS)
+		;/* FIXME: not sure what to do */
+
+	return 0;
+}
+
+/*
+ * Return saved PC of a blocked thread.
+ * FIXME this needs to be checked
+ */
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+	struct cpu_context *ctx =
+		&(((struct thread_info *)(tsk->stack))->cpu_context);
+
+	/* Check whether the thread is blocked in resume() */
+	if (in_sched_functions(ctx->r15))
+		return ((unsigned long)ctx->r15);
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
1.5.4.GIT

