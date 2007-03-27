Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXC0Ure@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXC0Ure (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXC0Ure
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:34 -0400
Received: from ns.suse.de ([195.135.220.2]:51942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXC0Urd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:33 -0400
Message-Id: <20070327204728.611979000@strauss.suse.de>
References: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
Subject: [patch 3/7] Add IRQF_IRQPOLL flag on i386
Content-Disposition: inline; filename=add-irqf_irqpoll-flag-on-i386.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL to timer interrupts on i386.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
---
 arch/i386/mach-default/setup.c |    2 +-
 arch/i386/mach-visws/setup.c   |    2 +-
 arch/i386/mach-voyager/setup.c |    7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc5-mm2/arch/i386/mach-default/setup.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/i386/mach-default/setup.c
+++ linux-2.6.21-rc5-mm2/arch/i386/mach-default/setup.c
@@ -81,7 +81,7 @@ void __init trap_init_hook(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
Index: linux-2.6.21-rc5-mm2/arch/i386/mach-visws/setup.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/i386/mach-visws/setup.c
+++ linux-2.6.21-rc5-mm2/arch/i386/mach-visws/setup.c
@@ -116,7 +116,7 @@ void __init pre_setup_arch_hook()
 
 static struct irqaction irq0 = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
 	.name =		"timer",
 };
 
Index: linux-2.6.21-rc5-mm2/arch/i386/mach-voyager/setup.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/i386/mach-voyager/setup.c
+++ linux-2.6.21-rc5-mm2/arch/i386/mach-voyager/setup.c
@@ -40,7 +40,12 @@ void __init trap_init_hook(void)
 {
 }
 
-static struct irqaction irq0  = { timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL};
+static struct irqaction irq0  = {
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
+};
 
 void __init time_init_hook(void)
 {

-- 
