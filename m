Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXCWTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXCWTC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992544AbXCWTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:02:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:32793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXCWTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:27 -0400
Message-Id: <20070323190113.772015000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:54 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: [patch 7/7] Add IRQF_IRQPOLL_IRQ flag on i386
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ-i386
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL_IRQ to timer interrupts on i386.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
---
 arch/i386/mach-default/setup.c |    2 +-
 arch/i386/mach-visws/setup.c   |    2 +-
 arch/i386/mach-voyager/setup.c |    7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc4-mm1/arch/i386/mach-default/setup.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/i386/mach-default/setup.c
+++ linux-2.6.21-rc4-mm1/arch/i386/mach-default/setup.c
@@ -81,7 +81,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL_IRQ,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
Index: linux-2.6.21-rc4-mm1/arch/i386/mach-visws/setup.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/i386/mach-visws/setup.c
+++ linux-2.6.21-rc4-mm1/arch/i386/mach-visws/setup.c
@@ -116,7 +116,7 @@ void __init pre_setup_arch_hook()
 
 static struct irqaction irq0 = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL_IRQ,
 	.name =		"timer",
 };
 
Index: linux-2.6.21-rc4-mm1/arch/i386/mach-voyager/setup.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/i386/mach-voyager/setup.c
+++ linux-2.6.21-rc4-mm1/arch/i386/mach-voyager/setup.c
@@ -40,7 +40,12 @@ void __init trap_init_hook(void)
 {
 }
 
-static struct irqaction irq0  = { timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL};
+static struct irqaction irq0  = {
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL_IRQ,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
+};
 
 void __init time_init_hook(void)
 {

-- 
