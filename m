Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbXDIVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbXDIVd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966052AbXDIVdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:33:25 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:34081 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966045AbXDIVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:46 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@mvista.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 18/18] ARM: OMAP: Fix PRCM base register usage for 243x
Date: Mon,  9 Apr 2007 17:31:01 -0400
Message-Id: <1176154335964-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154331925-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com> <1176154308509-git-send-email-tony@atomide.com> <1176154311389-git-send-email-tony@atomide.com> <11761543144181-git-send-email-tony@atomide.com> <11761543231102-git-send-email-tony@atomide.com> <1176154331925-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@mvista.com>

The PRCM base register is different on 242x and 243x.  Use
the #ifdef'd #define from omap24xx.h instead of the locally
defined one.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/pm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -45,7 +45,6 @@
 #include <asm/arch/dma.h>
 #include <asm/arch/board.h>
 
-#define PRCM_BASE		0x48008000
 #define PRCM_REVISION		0x000
 #define PRCM_SYSCONFIG		0x010
 #define PRCM_IRQSTATUS_MPU	0x018
@@ -144,7 +143,7 @@ static void (*omap2_sram_idle)(void);
 static void (*omap2_sram_suspend)(int dllctrl);
 static void (*saved_idle)(void);
 
-static u32 prcm_base = IO_ADDRESS(PRCM_BASE);
+static u32 prcm_base = IO_ADDRESS(OMAP24XX_PRCM_BASE);
 
 static inline void prcm_write_reg(int idx, u32 val)
 {

