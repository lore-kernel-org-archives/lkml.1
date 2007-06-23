Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXFWN1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXFWN1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXFWNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:18 -0400
Received: from www.osadl.org ([213.239.205.134]:59251 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758104AbXFWNWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:08 -0400
Message-Id: <20070623124030.803753497@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 15/28] i386: remove volatile in apic.c
Content-Disposition: inline; filename=i386-apic-remove-bogus-volatile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the volatile in apic. We have a cpu_relax() in the wait loop.
Fix a coding style issue while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/i386/kernel/apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/apic.c	2007-06-23 14:38:58.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c	2007-06-23 14:38:59.000000000 +0200
@@ -318,7 +318,7 @@ static void __devinit setup_APIC_timer(v
 
 #define LAPIC_CAL_LOOPS		(HZ/10)
 
-static __initdata volatile int lapic_cal_loops = -1;
+static __initdata int lapic_cal_loops = -1;
 static __initdata long lapic_cal_t1, lapic_cal_t2;
 static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
 static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
@@ -488,7 +488,7 @@ void __init setup_boot_APIC_clock(void)
 		/* Let the interrupts run */
 		local_irq_enable();
 
-		while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
 			cpu_relax();
 
 		local_irq_disable();

-- 

