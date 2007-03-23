Return-Path: <linux-kernel-owner+w=401wt.eu-S2992541AbXCWTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992541AbXCWTC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbXCWTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:01:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:45736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXCWTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:27 -0400
Message-Id: <20070323190112.389838000@strauss.suse.de>
References: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:50 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, discuss@x86-64.org,
       Andi Kleen <ak@suse.de>
Subject: [patch 3/7] Add IRQF_IRQPOLL_IRQ flag on x86_64
Content-Disposition: inline; filename=IRQF_IRQPOLL_IRQ-x86_64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL_IRQ for the timer interrupt on x86_64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/kernel/time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc4-mm1/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.21-rc4-mm1/arch/x86_64/kernel/time.c
@@ -317,7 +317,10 @@ void __init stop_timer_interrupt(void)
 }
 
 static struct irqaction irq0 = {
-	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL_IRQ,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
 };
 
 void __init time_init(void)

-- 
