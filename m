Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZADLEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZADLEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZADLEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:04:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:52095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZADLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:04:40 -0500
Subject: [PATCH -tip] x86: irq_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:32:36 +0530
Message-Id: <1231066956.27852.31.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: "(foo*)" should be "(foo *)"
ERROR: space required after that ',' (ctx:VxV)

total: 5 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irq_32.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 9dc5588..74b9ff7 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -15,9 +15,9 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <asm/apic.h>
-#include <asm/uaccess.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
@@ -93,7 +93,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 		return 0;
 
 	/* build the stack frame on the IRQ stack */
-	isp = (u32 *) ((char*)irqctx + sizeof(*irqctx));
+	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
@@ -137,7 +137,7 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	hardirq_ctx[cpu] = irqctx;
 
-	irqctx = (union irq_ctx*) &softirq_stack[cpu*THREAD_SIZE];
+	irqctx = (union irq_ctx *) &softirq_stack[cpu*THREAD_SIZE];
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -147,7 +147,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	softirq_ctx[cpu] = irqctx;
 
 	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",
-	       cpu,hardirq_ctx[cpu],softirq_ctx[cpu]);
+	       cpu, hardirq_ctx[cpu], softirq_ctx[cpu]);
 }
 
 void irq_ctx_exit(int cpu)
@@ -174,7 +174,7 @@ asmlinkage void do_softirq(void)
 		irqctx->tinfo.previous_esp = current_stack_pointer;
 
 		/* build the stack frame on the softirq stack */
-		isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
+		isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 
 		call_on_stack(__do_softirq, isp);
 		/*
-- 
1.5.5.1



