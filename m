Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXGYOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXGYOJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbXGYOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:07:14 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59458 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754537AbXGYOHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:07:09 -0400
Date: Thu, 26 Jul 2007 00:06:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251406.l6PE6PDr005827@goober>
To: linux-kernel@vger.kernel.org
Subject: [M68KNOMMU 05/06]: remove external timer references
Cc: gerg@uclinux.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the external references to timer functions from all
the m68knommu board/cpu setup files. Now that common function
names are used for the few different types of m68knommu
timer these can all go away.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

 5206/config.c    |   13 +------------
 5206e/config.c   |   15 ++-------------
 520x/config.c    |   10 +---------
 523x/config.c    |   12 +-----------
 5249/config.c    |   13 +------------
 5272/config.c    |   13 +------------
 527x/config.c    |   12 +-----------
 528x/config.c    |   12 +-----------
 5307/config.c    |   13 +------------
 532x/config.c    |   13 +------------
 5407/config.c    |   13 +------------
 68328/config.c   |   19 -------------------
 68360/config.c   |    4 ----
 68EZ328/config.c |    8 --------
 68VZ328/config.c |    6 ------
 15 files changed, 12 insertions(+), 164 deletions(-)


diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5206/config.c linux/arch/m68knommu/platform/5206/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5206/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5206/config.c	2007-07-25 23:09:47.000000000 +1000
@@ -3,20 +3,17 @@
 /*
  *	linux/arch/m68knommu/platform/5206/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  * 	Copyright (C) 2000-2001, Lineo Inc. (www.lineo.com) 
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcftimer.h>
@@ -25,10 +22,6 @@
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -98,10 +91,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5206e/config.c linux/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5206e/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5206e/config.c	2007-07-25 23:11:35.000000000 +1000
@@ -3,31 +3,24 @@
 /*
  *	linux/arch/m68knommu/platform/5206e/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/irq.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -104,10 +97,6 @@
 	commandp[size-1] = 0;
 #endif /* CONFIG_NETtel */
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/520x/config.c linux/arch/m68knommu/platform/520x/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/520x/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/520x/config.c	2007-07-25 23:14:29.000000000 +1000
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 2005,      Freescale (www.freescale.com)
  *  Copyright (C) 2005,      Intec Automation (mike@steroidmicros.com)
- *  Copyright (C) 1999-2003, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *  Copyright (C) 2001-2003, SnapGear Inc. (www.snapgear.com)
  */
 
@@ -27,10 +27,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -48,10 +44,6 @@
 
 void config_BSP(char *commandp, int size)
 {
-    mach_sched_init = coldfire_pit_init;
-    mach_tick = coldfire_pit_tick;
-    mach_gettimeoffset = coldfire_pit_offset;
-    mach_trap_init = coldfire_trap_init;
     mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/523x/config.c linux/arch/m68knommu/platform/523x/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/523x/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/523x/config.c	2007-07-25 23:14:55.000000000 +1000
@@ -6,19 +6,17 @@
  *	Sub-architcture dependant initialization code for the Freescale
  *	523x CPUs.
  *
- *	Copyright (C) 1999-2005, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2003, SnapGear Inc. (www.snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,10 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -63,10 +57,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5249/config.c linux/arch/m68knommu/platform/5249/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5249/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5249/config.c	2007-07-25 23:17:56.000000000 +1000
@@ -3,31 +3,24 @@
 /*
  *	linux/arch/m68knommu/platform/5249/config.c
  *
- *	Copyright (C) 2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 2007, Greg Ungerer (gerg@snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -96,10 +89,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5272/config.c linux/arch/m68knommu/platform/5272/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5272/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5272/config.c	2007-07-25 23:12:10.000000000 +1000
@@ -3,32 +3,25 @@
 /*
  *	linux/arch/m68knommu/platform/5272/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2002, SnapGear Inc. (www.snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -129,10 +122,6 @@
 
 	mcf_timervector = 69;
 	mcf_profilevector = 70;
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/527x/config.c linux/arch/m68knommu/platform/527x/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/527x/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/527x/config.c	2007-07-25 23:18:22.000000000 +1000
@@ -6,19 +6,17 @@
  *	Sub-architcture dependant initialization code for the Freescale
  *	5270/5271 CPUs.
  *
- *	Copyright (C) 1999-2004, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2004, SnapGear Inc. (www.snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,10 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -63,10 +57,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/528x/config.c linux/arch/m68knommu/platform/528x/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/528x/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/528x/config.c	2007-07-25 23:12:37.000000000 +1000
@@ -6,19 +6,17 @@
  *	Sub-architcture dependant initialization code for the Motorola
  *	5280 and 5282 CPUs.
  *
- *	Copyright (C) 1999-2003, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2001-2003, SnapGear Inc. (www.snapgear.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
@@ -26,10 +24,6 @@
 
 /***************************************************************************/
 
-void coldfire_pit_tick(void);
-void coldfire_pit_init(irq_handler_t handler);
-unsigned long coldfire_pit_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 /***************************************************************************/
@@ -63,10 +57,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_sched_init = coldfire_pit_init;
-	mach_tick = coldfire_pit_tick;
-	mach_gettimeoffset = coldfire_pit_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5307/config.c linux/arch/m68knommu/platform/5307/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5307/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5307/config.c	2007-07-25 23:13:10.000000000 +1000
@@ -3,33 +3,26 @@
 /*
  *	linux/arch/m68knommu/platform/5307/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2000, Lineo (www.lineo.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -123,10 +116,6 @@
 	mcf_timerlevel = 6;
 #endif
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/532x/config.c linux/arch/m68knommu/platform/532x/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/532x/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/532x/config.c	2007-07-25 23:17:24.000000000 +1000
@@ -3,7 +3,7 @@
 /*
  *	linux/arch/m68knommu/platform/532x/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2000, Lineo (www.lineo.com)
  *	Yaroslav Vinogradov yaroslav.vinogradov@freescale.com
  *	Copyright Freescale Semiconductor, Inc 2006
@@ -18,26 +18,19 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 #include <asm/mcfwdebug.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -105,10 +98,6 @@
 
 	mcf_timervector = 64+32;
 	mcf_profilevector = 64+33;
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 
 #ifdef MCF_BDM_DISABLE
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5407/config.c linux/arch/m68knommu/platform/5407/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/5407/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/5407/config.c	2007-07-25 23:16:53.000000000 +1000
@@ -3,32 +3,25 @@
 /*
  *	linux/arch/m68knommu/platform/5407/config.c
  *
- *	Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
+ *	Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *	Copyright (C) 2000, Lineo (www.lineo.com)
  */
 
 /***************************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/coldfire.h>
-#include <asm/mcftimer.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
 
 /***************************************************************************/
 
-void coldfire_tick(void);
-void coldfire_timer_init(irq_handler_t handler);
-unsigned long coldfire_timer_offset(void);
-void coldfire_trap_init(void);
 void coldfire_reset(void);
 
 extern unsigned int mcf_timervector;
@@ -109,10 +102,6 @@
 	mcf_timerlevel = 6;
 #endif
 
-	mach_sched_init = coldfire_timer_init;
-	mach_tick = coldfire_tick;
-	mach_gettimeoffset = coldfire_timer_offset;
-	mach_trap_init = coldfire_trap_init;
 	mach_reset = coldfire_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68328/config.c linux/arch/m68knommu/platform/68328/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68328/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/68328/config.c	2007-07-25 23:06:56.000000000 +1000
@@ -15,28 +15,14 @@
 
 /***************************************************************************/
 
-#include <asm/dbg.h>
-#include <stdarg.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/console.h>
-#include <linux/interrupt.h>
-#include <asm/current.h>
-
-#include <asm/setup.h>
 #include <asm/system.h>
-#include <asm/pgtable.h>
-#include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/MC68328.h>
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine);
-void m68328_timer_tick(void);
-unsigned long m68328_timer_gettimeoffset(void);
 void m68328_timer_gettod(int *year, int *mon, int *day, int *hour, int *min, int *sec);
 
 /***************************************************************************/
@@ -59,12 +45,7 @@
   printk(KERN_INFO "68328 support Kenneth Albanowski <kjahds@kjshds.com>\n");
   printk(KERN_INFO "68328/Pilot support Bernhard Kuhn <kuhn@lpr.e-technik.tu-muenchen.de>\n");
 
-  mach_sched_init      = m68328_timer_init;
-  mach_tick            = m68328_timer_tick;
-  mach_gettimeoffset   = m68328_timer_gettimeoffset;
   mach_gettod          = m68328_timer_gettod;
-  mach_hwclk           = NULL;
-  mach_set_clock_mmss  = NULL;
   mach_reset           = m68328_reset;
   *command = '\0';
 }
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68360/config.c linux/arch/m68knommu/platform/68360/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68360/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/68360/config.c	2007-07-25 23:16:17.000000000 +1000
@@ -198,11 +198,7 @@
   scc1_hwaddr = "\00\01\02\03\04\05";
 #endif
  
-  mach_sched_init      = BSP_sched_init;
-  mach_tick            = BSP_tick;
-  mach_gettimeoffset   = BSP_gettimeoffset;
   mach_gettod          = BSP_gettod;
   mach_hwclk           = NULL;
-  mach_set_clock_mmss  = NULL;
   mach_reset           = BSP_reset;
 }
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68EZ328/config.c linux/arch/m68knommu/platform/68EZ328/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68EZ328/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/68EZ328/config.c	2007-07-25 23:19:20.000000000 +1000
@@ -32,9 +32,6 @@
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine);
-void m68328_timer_tick(void);
-unsigned long m68328_timer_gettimeoffset(void);
 void m68328_timer_gettod(int *year, int *mon, int *day, int *hour, int *min, int *sec);
 
 /***************************************************************************/
@@ -79,12 +76,7 @@
   else command[0] = 0;
 #endif
  
-  mach_sched_init      = m68328_timer_init;
-  mach_tick            = m68328_timer_tick;
-  mach_gettimeoffset   = m68328_timer_gettimeoffset;
   mach_gettod          = m68328_timer_gettod;
-  mach_hwclk           = NULL;
-  mach_set_clock_mmss  = NULL;
   mach_reset           = m68ez328_reset;
 }
 
diff -Naur linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68VZ328/config.c linux/arch/m68knommu/platform/68VZ328/config.c
--- linux-2.6.23-rc1-gerg1/arch/m68knommu/platform/68VZ328/config.c	2007-07-25 23:00:35.000000000 +1000
+++ linux/arch/m68knommu/platform/68VZ328/config.c	2007-07-25 23:20:08.000000000 +1000
@@ -37,9 +37,6 @@
 
 /***************************************************************************/
 
-void m68328_timer_init(irq_handler_t timer_routine);
-void m68328_timer_tick(void);
-unsigned long m68328_timer_gettimeoffset(void);
 void m68328_timer_gettod(int *year, int *mon, int *day, int *hour, int *min, int *sec);
 
 /***************************************************************************/
@@ -193,9 +190,6 @@
 
 	init_hardware(command, size);
 
-	mach_sched_init = (void *) m68328_timer_init;
-	mach_tick = m68328_timer_tick;
-	mach_gettimeoffset = m68328_timer_gettimeoffset;
 	mach_gettod = m68328_timer_gettod;
 	mach_reset = m68vz328_reset;
 }
