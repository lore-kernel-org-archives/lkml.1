Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXC0Usx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXC0Usx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXC0Urg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:36 -0400
Received: from ns.suse.de ([195.135.220.2]:51945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbXC0Urd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:33 -0400
Message-Id: <20070327204728.363693000@strauss.suse.de>
References: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:36 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
Subject: [patch 2/7] Add IRQF_IRQPOLL flag on x86_64
Content-Disposition: inline; filename=add-irqf_irqpoll-flag-on-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQF_IRQPOLL for the timer interrupt on x86_64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/kernel/time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc5-mm2/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.21-rc5-mm2/arch/x86_64/kernel/time.c
@@ -317,7 +317,10 @@ void __init stop_timer_interrupt(void)
 }
 
 static struct irqaction irq0 = {
-	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
 };
 
 void __init time_init(void)

-- 
