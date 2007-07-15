Return-Path: <linux-kernel-owner+w=401wt.eu-S1763047AbXGOQQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047AbXGOQQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXGOQFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:37 -0400
Received: from www.osadl.org ([213.239.205.134]:42630 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762437AbXGOQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:20 -0400
Message-Id: <20070715155542.069320112@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
Subject: [patch-mm 31/33] ACPI: remove the now unused ifdef code
Content-Disposition: inline; filename=acpi-remove-the-useless-ifdef-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of x86-64 to clock events makes the
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 n the timer broadcast functions useless. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux-2.6.22-rc6-mm/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/drivers/acpi/processor_idle.c	2007-07-15 17:48:12.000000000 +0200
+++ linux-2.6.22-rc6-mm/drivers/acpi/processor_idle.c	2007-07-15 17:48:22.000000000 +0200
@@ -203,21 +203,12 @@ static void acpi_timer_check_state(int s
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
 	clockevents_notify(reason, &pr->id);
-#else
-	cpumask_t mask = cpumask_of_cpu(pr->id);
-
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
-		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
-#endif
 }
 
 /* Power(C) State timer broadcast control */
@@ -225,8 +216,6 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
@@ -236,7 +225,6 @@ static void acpi_state_timer_broadcast(s
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
 	}
-#endif
 }
 
 #else

-- 

