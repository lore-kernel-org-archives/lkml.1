Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXDDRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXDDRzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXDDRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:55:10 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:36057 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXDDRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:55:07 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/90] ARM: OMAP: Force APLLs always active
Date: Wed,  4 Apr 2007 13:46:29 -0400
Message-Id: <11757088822930-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757088791107-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com> <11757088791107-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

The APLLs are most efficiently idled by hardware.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 5170481..0306507 100644
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

