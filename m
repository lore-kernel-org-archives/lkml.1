Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXFPKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXFPKbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXFPKYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:37 -0400
Received: from www.osadl.org ([213.239.205.134]:37265 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755269AbXFPKY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:27 -0400
Message-Id: <20070616101637.429539521@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 23/25] x86-64 block irq balancing for timer
Content-Disposition: inline; filename=x86-64-clockevents-irq-balancing.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Disable irq balancing on IRQ0.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	2007-06-16 12:10:24.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	2007-06-16 12:10:25.000000000 +0200
@@ -255,7 +255,7 @@ static unsigned int __init tsc_calibrate
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };

-- 

