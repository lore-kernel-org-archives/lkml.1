Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXDDSjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXDDSjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXDDSHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:07:30 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36349 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbXDDSHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:21 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 14/90] ARM: OMAP: omap2/memory.c compile fixes
Date: Wed,  4 Apr 2007 14:04:53 -0400
Message-Id: <11757100011056-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757099942493-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com>
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

diff --git a/arch/arm/mach-omap2/memory.c b/arch/arm/mach-omap2/memory.c
index f173aa8..3e5d8cd 100644
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

