Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYEDN7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYEDN7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYEDN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:59:30 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56173 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbYEDN73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:59:29 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 26/56] microblaze_v2: traps support
Date: Sun,  4 May 2008 13:41:15 +0200
Message-Id: <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
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
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |   88 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/traps.c

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
new file mode 100644
index 0000000..eb8202b
--- /dev/null
+++ b/arch/microblaze/kernel/traps.c
@@ -0,0 +1,88 @@
+/*
+ * arch/microblaze/kernel/traps.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/exceptions.h>
+#include <asm/system.h>
+
+void trap_init(void)
+{
+	initialize_exception_handlers();
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
+void show_trace(struct task_struct *task, unsigned long *stack)
+{
+	unsigned long addr;
+
+	if (!stack)
+		stack = (unsigned long *)&stack;
+
+	printk(KERN_INFO "Call Trace: ");
+#ifdef CONFIG_KALLSYMS
+	printk(KERN_INFO "\n");
+#endif
+	while (!kstack_end(stack)) {
+		addr = *stack++;
+		if (__kernel_text_address(addr)) {
+			printk(KERN_INFO "[<%08lx>] ", addr);
+			print_symbol("%s\n", addr);
+		}
+	}
+	printk(KERN_INFO "\n");
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
+						(task->stack))->cpu_context.sp;
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
1.5.4.GIT

