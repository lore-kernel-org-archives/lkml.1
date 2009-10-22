Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZJVWNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZJVWNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZJVWNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:13:02 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51861 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990AbZJVWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Uo8OovgsV2tRDMV67BwXM
Subject: [PATCH 09/10] omap4: Allow omap_serial_early_init() for OMAP4430 board
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:13:02 -0700
Message-ID: <20091022221302.27408.10116.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

This patch enables omap_serial_early_init() function for OMAP4430
SDP. Without this the bootup would throw oops in omap_serial_init().

Note that the ifndef CONFIG_ARCH_OMAP4 is split into two sections
to enable omap_serial_early_init(). This ifndef cannot be removed
until omap4 clock framework is implemented.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-By: Tony Lindgren <tony@atomide.com>
Reviewed-By: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |    4 ++--
 arch/arm/mach-omap2/io.c            |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index eb37c40..609a5a4 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -58,6 +58,8 @@ static void __init gic_init_irq(void)
 
 static void __init omap_4430sdp_init_irq(void)
 {
+	omap_board_config = sdp4430_config;
+	omap_board_config_size = ARRAY_SIZE(sdp4430_config);
 	omap2_init_common_hw(NULL, NULL);
 #ifdef CONFIG_OMAP_32K_TIMER
 	omap2_gp_clockevent_set_gptimer(1);
@@ -70,8 +72,6 @@ static void __init omap_4430sdp_init_irq(void)
 static void __init omap_4430sdp_init(void)
 {
 	platform_add_devices(sdp4430_devices, ARRAY_SIZE(sdp4430_devices));
-	omap_board_config = sdp4430_config;
-	omap_board_config_size = ARRAY_SIZE(sdp4430_config);
 	omap_serial_init();
 }
 
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index e3a3bad..56be87d 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -302,7 +302,9 @@ void __init omap2_init_common_hw(struct omap_sdrc_params *sdrc_cs0,
 	pwrdm_init(powerdomains_omap);
 	clkdm_init(clockdomains_omap, clkdm_pwrdm_autodeps);
 	omap2_clk_init();
+#endif
 	omap_serial_early_init();
+#ifndef CONFIG_ARCH_OMAP4
 	omap_hwmod_late_init();
 	omap_pm_if_init();
 	omap2_sdrc_init(sdrc_cs0, sdrc_cs1);

