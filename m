Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbYBAHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbYBAHoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935145AbYBAHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:18 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48078 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934428AbYBAHjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:12 -0500
Date: Fri, 1 Feb 2008 17:38:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117cKwQ022727@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove dead code from m68knommu timer code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused LED heartbeat code from m68knommu timer code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/kernel/time.c linux-2.6.24-uc0/arch/m68knommu/kernel/time.c
--- linux-2.6.24/arch/m68knommu/kernel/time.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/kernel/time.c	2008-01-15 16:33:28.000000000 +1000
@@ -22,7 +22,6 @@
 #include <linux/timex.h>
 
 #include <asm/machdep.h>
-#include <asm/io.h>
 #include <asm/irq_regs.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
@@ -66,29 +65,6 @@ irqreturn_t arch_timer_interrupt(int irq
 	  else
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
-#ifdef CONFIG_HEARTBEAT
-	/* use power LED as a heartbeat instead -- much more useful
-	   for debugging -- based on the version for PReP by Cort */
-	/* acts like an actual heart beat -- ie thump-thump-pause... */
-	if (mach_heartbeat) {
-	    static unsigned cnt = 0, period = 0, dist = 0;
-
-	    if (cnt == 0 || cnt == dist)
-		mach_heartbeat( 1 );
-	    else if (cnt == 7 || cnt == dist+7)
-		mach_heartbeat( 0 );
-
-	    if (++cnt > period) {
-		cnt = 0;
-		/* The hyperbolic function below modifies the heartbeat period
-		 * length in dependency of the current (5min) load. It goes
-		 * through the points f(0)=126, f(1)=86, f(5)=51,
-		 * f(inf)->30. */
-		period = ((672<<FSHIFT)/(5*avenrun[0]+(7<<FSHIFT))) + 30;
-		dist = period / 4;
-	    }
-	}
-#endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
 	return(IRQ_HANDLED);
