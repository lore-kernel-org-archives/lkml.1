Return-Path: <linux-kernel-owner+w=401wt.eu-S938765AbXGSOAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938765AbXGSOAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbXGSNs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbXGSNs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: tglx@linutronix.de, ak@suse.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [25/48] i386: remove volatile in apic.c
Message-Id: <20070719134855.295AE14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

Remove the volatile in apic.  We have a cpu_relax() in the wait loop.  Fix a
coding style issue while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -315,7 +315,7 @@ static void __devinit setup_APIC_timer(v
 
 #define LAPIC_CAL_LOOPS		(HZ/10)
 
-static __initdata volatile int lapic_cal_loops = -1;
+static __initdata int lapic_cal_loops = -1;
 static __initdata long lapic_cal_t1, lapic_cal_t2;
 static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
 static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
@@ -485,7 +485,7 @@ void __init setup_boot_APIC_clock(void)
 		/* Let the interrupts run */
 		local_irq_enable();
 
-		while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
 			cpu_relax();
 
 		local_irq_disable();
