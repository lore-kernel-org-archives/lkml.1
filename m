Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbXJXCF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbXJXCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXJXCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:09 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34297 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753617AbXJXCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:08 -0400
Date: Wed, 24 Oct 2007 12:03:28 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23SGn016653@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup 68EZ328 init code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up 68EZ328 timer support code. Removed header includes not needed.
Remove use of old m68knommu timer function pointers.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/platform/68EZ328/config.c linux-2.6.23-uc0/arch/m68knommu/platform/68EZ328/config.c
--- linux-2.6.23/arch/m68knommu/platform/68EZ328/config.c	2007-10-19 10:30:56.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/platform/68EZ328/config.c	2007-10-19 10:35:41.000000000 +1000
@@ -13,15 +13,8 @@
 
 /***************************************************************************/
 
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/console.h>
-#include <linux/interrupt.h>
-
-#include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
@@ -32,9 +25,6 @@
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine);
-void m68328_timer_tick(void);
-unsigned long m68328_timer_gettimeoffset(void);
 void m68328_timer_gettod(int *year, int *mon, int *day, int *hour, int *min, int *sec);
 
 /***************************************************************************/
@@ -79,13 +69,8 @@ void config_BSP(char *command, int len)
   else command[0] = 0;
 #endif
  
-  mach_sched_init      = m68328_timer_init;
-  mach_tick            = m68328_timer_tick;
-  mach_gettimeoffset   = m68328_timer_gettimeoffset;
-  mach_gettod          = m68328_timer_gettod;
-  mach_hwclk           = NULL;
-  mach_set_clock_mmss  = NULL;
-  mach_reset           = m68ez328_reset;
+  mach_gettod = m68328_timer_gettod;
+  mach_reset = m68ez328_reset;
 }
 
 /***************************************************************************/
