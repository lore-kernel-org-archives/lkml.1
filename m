Return-Path: <linux-kernel-owner+w=401wt.eu-S935715AbXGMSOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935715AbXGMSOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXGMSNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:12 -0400
Received: from deeprooted.net ([216.254.16.51]:38941 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760089AbXGMSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:07 -0400
Message-Id: <20070713175228.623525155@mvista.com>
References: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:18 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 4/6] Add trace_preempt_*_idle() support for ARM.
Content-Disposition: inline; filename=arm-trace-preempt-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace functions to ARM idle loop and also move the
tick_nohz_restart_sched_tick() after the local_irq_disable() as is
done on x86.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 arch/arm/kernel/process.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/process.c
+++ linux-2.6/arch/arm/kernel/process.c
@@ -165,11 +165,13 @@ void cpu_idle(void)
 		while (!need_resched() && !need_resched_delayed())
 			idle();
 		leds_event(led_idle_end);
-		tick_nohz_restart_sched_tick();
 		local_irq_disable();
+		trace_preempt_exit_idle();
+		tick_nohz_restart_sched_tick();
 		__preempt_enable_no_resched();
 		__schedule();
 		preempt_disable();
+		trace_preempt_enter_idle();
 		local_irq_enable();
 	}
 }

--
