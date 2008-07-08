Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYGHMm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYGHMm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYGHMmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:42:10 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27518 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbYGHMmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:42:08 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/58] microblaze_v5: traps support
Date: Tue,  8 Jul 2008 13:59:28 +0200
Message-Id: <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/traps.c |  107 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/traps.c

diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
new file mode 100644
index 0000000..876c8e1
--- /dev/null
+++ b/arch/microblaze/kernel/traps.c
@@ -0,0 +1,107 @@
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
+/* x86 has syscall for setting the value */
+int kstack_depth_to_print = 24;
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
1.5.4.GIT

