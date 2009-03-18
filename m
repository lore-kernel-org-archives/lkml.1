Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZCRVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZCRVnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZCRVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:42:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755635AbZCRVmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:07 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/57] microblaze_v7: traps support
Date: Wed, 18 Mar 2009 21:30:55 +0100
Message-Id: <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
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
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |  105 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/traps.c

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
new file mode 100644
index 0000000..4863a57
--- /dev/null
+++ b/arch/microblaze/kernel/traps.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/debug_locks.h>
+
+#include <asm/exceptions.h>
+#include <asm/system.h>
+
+void trap_init(void)
+{
+	__enable_hw_exceptions();
+}
+
+void __bad_xchg(volatile void *ptr, int size)
+{
+	printk(KERN_INFO "xchg: bad data size: pc 0x%p, ptr 0x%p, size %d\n",
+		__builtin_return_address(0), ptr, size);
+	BUG();
+}
+EXPORT_SYMBOL(__bad_xchg);
+
+static int kstack_depth_to_print = 24;
+
+static int __init kstack_setup(char *s)
+{
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+
+	return 1;
+}
+__setup("kstack=", kstack_setup);
+
+void show_trace(struct task_struct *task, unsigned long *stack)
+{
+	unsigned long addr;
+
+	if (!stack)
+		stack = (unsigned long *)&stack;
+
+	printk(KERN_NOTICE "Call Trace: ");
+#ifdef CONFIG_KALLSYMS
+	printk(KERN_NOTICE "\n");
+#endif
+	while (!kstack_end(stack)) {
+		addr = *stack++;
+		/*
+		 * If the address is either in the text segment of the
+		 * kernel, or in the region which contains vmalloc'ed
+		 * memory, it *may* be the address of a calling
+		 * routine; if so, print it so that someone tracing
+		 * down the cause of the crash will be able to figure
+		 * out the call path that was taken.
+		 */
+		if (kernel_text_address(addr))
+			print_ip_sym(addr);
+	}
+	printk(KERN_NOTICE "\n");
+
+	if (!task)
+		task = current;
+
+	debug_show_held_locks(task);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	unsigned long *stack;
+	int i;
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *) ((struct thread_info *)
+						(task->stack))->cpu_context.r1;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+
+	printk(KERN_INFO "\nStack:\n  ");
+
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (kstack_end(sp))
+			break;
+		if (i && ((i % 8) == 0))
+			printk("\n  ");
+		printk("%08lx ", *sp++);
+	}
+	printk("\n");
+	show_trace(task, stack);
+}
+
+void dump_stack(void)
+{
+	show_stack(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
-- 
1.5.5.1

