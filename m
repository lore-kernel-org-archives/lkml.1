Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbXIUU6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbXIUU6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763514AbXIUUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762807AbXIUUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:24 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: venkatesh.pallipadi@intel.com, ak@suse.de, mingo@elte.hu,
       johnstul@us.ibm.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [39/45] x86_64: block irq balancing for timer
Message-Id: <20070921204522.5E4AB14F22@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Disable irq balancing on IRQ0.  Several SIS chipsets lock up when you try to
change affinity of IRQ #0.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -360,7 +360,7 @@ void stop_timer_interrupt(void)
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
