Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbXFWNbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbXFWNbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbXFWNWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:35 -0400
Received: from www.osadl.org ([213.239.205.134]:59335 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758239AbXFWNWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:19 -0400
Message-Id: <20070623124031.301753868@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 26/28] x86-64 block irq balancing for timer
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
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	2007-06-23 14:39:00.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	2007-06-23 14:39:00.000000000 +0200
@@ -255,7 +255,7 @@ static unsigned int __init tsc_calibrate
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };

-- 

