Return-Path: <linux-kernel-owner+w=401wt.eu-S965756AbXDIVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756AbXDIVCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXDIVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:02:44 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:12043 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778AbXDIVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:02:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/10] ARM: OMAP: gpio init section cleanups
Date: Mon,  9 Apr 2007 17:01:06 -0400
Message-Id: <11761525022200-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176152494436-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor GPIO cleanups:  remove needless #include, and omap_gpio_init()
should be __init, as well as all the board init code calling it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-fsample.c   |    2 +-
 arch/arm/mach-omap1/board-h3.c        |    2 +-
 arch/arm/mach-omap1/board-innovator.c |    2 +-
 arch/arm/mach-omap1/board-perseus2.c  |    2 +-
 arch/arm/plat-omap/gpio.c             |    3 +--
 5 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-omap1/board-fsample.c
+++ b/arch/arm/mach-omap1/board-fsample.c
@@ -246,7 +246,7 @@ static void __init fsample_init_smc91x(void)
 	mdelay(50);
 }
 
-void omap_fsample_init_irq(void)
+static void __init omap_fsample_init_irq(void)
 {
 	omap1_init_common_hw();
 	omap_init_irq();
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -455,7 +455,7 @@ static void __init h3_init_smc91x(void)
 	}
 }
 
-void h3_init_irq(void)
+static void __init h3_init_irq(void)
 {
 	omap1_init_common_hw();
 	omap_init_irq();
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -308,7 +308,7 @@ static void __init innovator_init_smc91x(void)
 	}
 }
 
-void innovator_init_irq(void)
+static void __init innovator_init_irq(void)
 {
 	omap1_init_common_hw();
 	omap_init_irq();
--- a/arch/arm/mach-omap1/board-perseus2.c
+++ b/arch/arm/mach-omap1/board-perseus2.c
@@ -246,7 +246,7 @@ static void __init perseus2_init_smc91x(void)
 	mdelay(50);
 }
 
-void omap_perseus2_init_irq(void)
+static void __init omap_perseus2_init_irq(void)
 {
 	omap1_init_common_hw();
 	omap_init_irq();
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -13,7 +13,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/ptrace.h>
 #include <linux/sysdev.h>
@@ -1329,7 +1328,7 @@ void omap2_gpio_resume_after_retention(void)
  * This may get called early from board specific init
  * for boards that have interrupts routed via FPGA.
  */
-int omap_gpio_init(void)
+int __init omap_gpio_init(void)
 {
 	if (!initialized)
 		return _omap_gpio_init();
-- 
1.4.4.2

