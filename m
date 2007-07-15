Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXGOQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXGOQM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762679AbXGOQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:18 -0400
Received: from www.osadl.org ([213.239.205.134]:42567 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762440AbXGOQFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:06 -0400
Message-Id: <20070715155541.423564813@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 17/33] i386: prepare sharing the PIT code
Content-Disposition: inline; filename=i386-prepare-sharing-pit-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PIT clock events work already and the PIT handling is the same for
i386 and x86_64. x86_64 does not support PIT as a clock source, so
disable the PIT clocksource for x86_64.

Prepare i8253.h to be shared with x8664

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/i8253.c |    3 +++
 include/asm-i386/i8253.h |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/i386/kernel/i8253.c	2007-07-15 17:26:45.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/i386/kernel/i8253.c	2007-07-15 17:39:21.000000000 +0200
@@ -120,6 +120,7 @@ void __init setup_pit_timer(void)
 	global_clock_event = &pit_clockevent;
 }
 
+#ifndef CONFIG_X86_64
 /*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
@@ -204,3 +205,5 @@ static int __init init_pit_clocksource(v
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
+
+#endif
Index: linux-2.6.22-rc6-mm/include/asm-i386/i8253.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/i8253.h	2007-07-15 17:26:45.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/i8253.h	2007-07-15 17:48:50.000000000 +0200
@@ -1,8 +1,6 @@
 #ifndef __ASM_I8253_H__
 #define __ASM_I8253_H__
 
-#include <linux/clockchips.h>
-
 /* i8253A PIT registers */
 #define PIT_MODE		0x43
 #define PIT_CH0			0x40
@@ -10,8 +8,12 @@
 
 extern spinlock_t i8253_lock;
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
 extern struct clock_event_device *global_clock_event;
 
 extern void setup_pit_timer(void);
 
+#endif
+
 #endif	/* __ASM_I8253_H__ */

-- 

