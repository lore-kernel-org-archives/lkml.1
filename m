Return-Path: <linux-kernel-owner+w=401wt.eu-S966041AbXDIVcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966041AbXDIVcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXDIVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:31:51 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33163 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966019AbXDIVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:19 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/18] ARM: OMAP2: Force APLLs always active
Date: Mon,  9 Apr 2007 17:30:45 -0400
Message-Id: <11761542683139-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761542642563-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

The APLLs are most efficiently idled by hardware.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -1160,8 +1160,8 @@ int __init omap2_clk_init(void)
 	clk_enable(&sync_32k_ick);
 	clk_enable(&omapctrl_ick);
 
-	/* Force the APLLs active during bootup to avoid disabling and
-	 * enabling them unnecessarily. */
+	/* Force the APLLs always active. The clocks are idled
+	 * automatically by hardware. */
 	clk_enable(&apll96_ck);
 	clk_enable(&apll54_ck);
 
@@ -1174,12 +1174,3 @@ int __init omap2_clk_init(void)
 
 	return 0;
 }
-
-static int __init omap2_disable_aplls(void)
-{
-	clk_disable(&apll96_ck);
-	clk_disable(&apll54_ck);
-
-	return 0;
-}
-late_initcall(omap2_disable_aplls);
-- 
1.4.4.2

