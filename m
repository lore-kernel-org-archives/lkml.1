Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXJXCFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXJXCFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXJXCEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:10 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34298 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753635AbXJXCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:08 -0400
Date: Wed, 24 Oct 2007 12:03:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23WmQ016659@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup 68VZ328 init code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removed header includes not needed.
Remove use of old m68knommu timer function pointers.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/68VZ328/config.c linux-2.6.23-uc0/arch/m68knommu/platform/68VZ328/config.c
--- linux-2.6.23/arch/m68knommu/platform/68VZ328/config.c	2007-10-19 10:30:57.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/68VZ328/config.c	2007-10-19 10:35:41.000000000 +1000
@@ -16,17 +16,13 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/console.h>
 #include <linux/kd.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
-#include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
 #include <asm/bootstd.h>
@@ -37,9 +33,6 @@
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine);
-void m68328_timer_tick(void);
-unsigned long m68328_timer_gettimeoffset(void);
 void m68328_timer_gettod(int *year, int *mon, int *day, int *hour, int *min, int *sec);
 
 /***************************************************************************/
@@ -193,9 +186,6 @@ void config_BSP(char *command, int size)
 
 	init_hardware(command, size);
 
-	mach_sched_init = (void *) m68328_timer_init;
-	mach_tick = m68328_timer_tick;
-	mach_gettimeoffset = m68328_timer_gettimeoffset;
 	mach_gettod = m68328_timer_gettod;
 	mach_reset = m68vz328_reset;
 }
