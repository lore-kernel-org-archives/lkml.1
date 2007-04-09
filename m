Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXDIVbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXDIVbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966032AbXDIVbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:31:43 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33325 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966031AbXDIVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:40 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/18] ARM: OMAP: omap2/memory.c compile fixes
Date: Mon,  9 Apr 2007 17:30:49 -0400
Message-Id: <11761542841909-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154277435-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Remove some conflicting declarations in omap2/memory.c so that the
file builds again.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/memory.c |   40 +++++-----------------------------------
 1 files changed, 5 insertions(+), 35 deletions(-)

--- a/arch/arm/mach-omap2/memory.c
+++ b/arch/arm/mach-omap2/memory.c
@@ -30,37 +30,6 @@
 #include "prcm-regs.h"
 #include "memory.h"
 
-#define SMS_BASE		0x68008000
-#define SMS_SYSCONFIG		0x010
-
-#define SDRC_BASE		0x68009000
-#define SDRC_SYSCONFIG		0x010
-#define SDRC_SYSSTATUS		0x014
-
-static const u32 sms_base = IO_ADDRESS(SMS_BASE);
-static const u32 sdrc_base = IO_ADDRESS(SDRC_BASE);
-
-
-static inline void sms_write_reg(int idx, u32 val)
-{
-	__raw_writel(val, sms_base + idx);
-}
-
-static inline u32 sms_read_reg(int idx)
-{
-	return __raw_readl(sms_base + idx);
-}
-
-static inline void sdrc_write_reg(int idx, u32 val)
-{
-	__raw_writel(val, sdrc_base + idx);
-}
-
-static inline u32 sdrc_read_reg(int idx)
-{
-	return __raw_readl(sdrc_base + idx);
-}
-
 
 static struct memory_timings mem_timings;
 
@@ -132,18 +101,19 @@ void omap2_init_memory_params(u32 force_lock_to_unlock_mode)
 	mem_timings.slow_dll_ctrl |= ((1 << 1) | (3 << 8));
 }
 
+/* turn on smart idle modes for SDRAM scheduler and controller */
 void __init omap2_init_memory(void)
 {
 	u32 l;
 
-	l = sms_read_reg(SMS_SYSCONFIG);
+	l = SMS_SYSCONFIG;
 	l &= ~(0x3 << 3);
 	l |= (0x2 << 3);
-	sms_write_reg(SMS_SYSCONFIG, l);
+	SMS_SYSCONFIG = l;
 
-	l = sdrc_read_reg(SDRC_SYSCONFIG);
+	l = SDRC_SYSCONFIG;
 	l &= ~(0x3 << 3);
 	l |= (0x2 << 3);
-	sdrc_write_reg(SDRC_SYSCONFIG, l);
+	SDRC_SYSCONFIG = l;
 
 }
-- 
1.4.4.2

