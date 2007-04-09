Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXDIV2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXDIV2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXDIV0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:45 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29408 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbXDIV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:26:28 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5/6] ARM: OMAP: fix OMAP1 dmtimer build warning
Date: Mon,  9 Apr 2007 17:25:43 -0400
Message-Id: <11761539621074-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761539581152-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com> <1176153948771-git-send-email-tony@atomide.com> <11761539511877-git-send-email-tony@atomide.com> <11761539553166-git-send-email-tony@atomide.com> <11761539581152-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Remove the OMAP1 version of omap_dm_timer_get_fclk(), and its associated
compile-time warning.  It would only BUG() if called, while it's only
called on OMAP2.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/dmtimer.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -271,11 +271,6 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
 
 #if defined(CONFIG_ARCH_OMAP1)
 
-struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
-{
-	BUG();
-}
-
 /**
  * omap_dm_timer_modify_idlect_mask - Check if any running timers use ARMXOR
  * @inputmask: current value of idlect mask
-- 
1.4.4.2

