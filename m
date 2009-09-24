Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZIXL7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZIXL7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZIXL7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:59:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17875 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZIXL5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:57:10 -0400
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 03/19] OMAP: OMAPFB: add omapdss device
Date: Thu, 24 Sep 2009 14:56:08 +0300
Message-Id: <1253793384-31158-4-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1253793384-31158-3-git-send-email-tomi.valkeinen@nokia.com>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-2-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-3-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 24 Sep 2009 11:56:32.0765 (UTC) FILETIME=[0F3812D0:01CA3D0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upcoming new display subsystem driver is divided to two devices,
omapdss and omapfb, of which omapdss handles the actual hardware.

This patch adds a dummy omapdss platform device for the current omapfb
driver, which is then used to get the clocks. This will make it possible
for the current and the new display drivers to co-exist.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.c |    8 ++++----
 arch/arm/mach-omap2/clock34xx.c |   14 +++++++-------
 drivers/video/omap/dispc.c      |   19 ++++++++++++++++---
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index bc5d3ac..8cb8368 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -116,10 +116,10 @@ static struct omap_clk omap24xx_clks[] = {
 	CLK(NULL,	"mdm_ick",	&mdm_ick,	CK_243X),
 	CLK(NULL,	"mdm_osc_ck",	&mdm_osc_ck,	CK_243X),
 	/* DSS domain clocks */
-	CLK("omapfb",	"ick",		&dss_ick,	CK_243X | CK_242X),
-	CLK("omapfb",	"dss1_fck",	&dss1_fck,	CK_243X | CK_242X),
-	CLK("omapfb",	"dss2_fck",	&dss2_fck,	CK_243X | CK_242X),
-	CLK("omapfb",	"tv_fck",	&dss_54m_fck,	CK_243X | CK_242X),
+	CLK("omapdss",	"ick",		&dss_ick,	CK_243X | CK_242X),
+	CLK("omapdss",	"dss1_fck",	&dss1_fck,	CK_243X | CK_242X),
+	CLK("omapdss",	"dss2_fck",	&dss2_fck,	CK_243X | CK_242X),
+	CLK("omapdss",	"tv_fck",	&dss_54m_fck,	CK_243X | CK_242X),
 	/* L3 domain clocks */
 	CLK(NULL,	"core_l3_ck",	&core_l3_ck,	CK_243X | CK_242X),
 	CLK(NULL,	"ssi_fck",	&ssi_ssr_sst_fck, CK_243X | CK_242X),
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index fafcd32..1fa91e4 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -236,13 +236,13 @@ static struct omap_clk omap34xx_clks[] = {
 	CLK("omap_rng",	"ick",		&rng_ick,	CK_343X),
 	CLK(NULL,	"sha11_ick",	&sha11_ick,	CK_343X),
 	CLK(NULL,	"des1_ick",	&des1_ick,	CK_343X),
-	CLK("omapfb",	"dss1_fck",	&dss1_alwon_fck_3430es1, CK_3430ES1),
-	CLK("omapfb",	"dss1_fck",	&dss1_alwon_fck_3430es2, CK_3430ES2),
-	CLK("omapfb",	"tv_fck",	&dss_tv_fck,	CK_343X),
-	CLK("omapfb",	"video_fck",	&dss_96m_fck,	CK_343X),
-	CLK("omapfb",	"dss2_fck",	&dss2_alwon_fck, CK_343X),
-	CLK("omapfb",	"ick",		&dss_ick_3430es1,	CK_3430ES1),
-	CLK("omapfb",	"ick",		&dss_ick_3430es2,	CK_3430ES2),
+	CLK("omapdss",	"dss1_fck",	&dss1_alwon_fck_3430es1, CK_3430ES1),
+	CLK("omapdss",	"dss1_fck",	&dss1_alwon_fck_3430es2, CK_3430ES2),
+	CLK("omapdss",	"tv_fck",	&dss_tv_fck,	CK_343X),
+	CLK("omapdss",	"video_fck",	&dss_96m_fck,	CK_343X),
+	CLK("omapdss",	"dss2_fck",	&dss2_alwon_fck, CK_343X),
+	CLK("omapdss",	"ick",		&dss_ick_3430es1,	CK_3430ES1),
+	CLK("omapdss",	"ick",		&dss_ick_3430es2,	CK_3430ES2),
 	CLK(NULL,	"cam_mclk",	&cam_mclk,	CK_343X),
 	CLK(NULL,	"cam_ick",	&cam_ick,	CK_343X),
 	CLK(NULL,	"csi2_96m_fck",	&csi2_96m_fck,	CK_343X),
diff --git a/drivers/video/omap/dispc.c b/drivers/video/omap/dispc.c
index 66e57df..9edfb15 100644
--- a/drivers/video/omap/dispc.c
+++ b/drivers/video/omap/dispc.c
@@ -24,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 #include <mach/sram.h>
 #include <mach/board.h>
@@ -188,6 +189,11 @@ static struct {
 	struct omapfb_color_key	color_key;
 } dispc;
 
+static struct platform_device omapdss_device = {
+	.name		= "omapdss",
+	.id		= -1,
+};
+
 static void enable_lcd_clocks(int enable);
 
 static void inline dispc_write_reg(int idx, u32 val)
@@ -907,20 +913,20 @@ static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 
 static int get_dss_clocks(void)
 {
-	dispc.dss_ick = clk_get(dispc.fbdev->dev, "ick");
+	dispc.dss_ick = clk_get(&omapdss_device.dev, "ick");
 	if (IS_ERR(dispc.dss_ick)) {
 		dev_err(dispc.fbdev->dev, "can't get ick\n");
 		return PTR_ERR(dispc.dss_ick);
 	}
 
-	dispc.dss1_fck = clk_get(dispc.fbdev->dev, "dss1_fck");
+	dispc.dss1_fck = clk_get(&omapdss_device.dev, "dss1_fck");
 	if (IS_ERR(dispc.dss1_fck)) {
 		dev_err(dispc.fbdev->dev, "can't get dss1_fck\n");
 		clk_put(dispc.dss_ick);
 		return PTR_ERR(dispc.dss1_fck);
 	}
 
-	dispc.dss_54m_fck = clk_get(dispc.fbdev->dev, "tv_fck");
+	dispc.dss_54m_fck = clk_get(&omapdss_device.dev, "tv_fck");
 	if (IS_ERR(dispc.dss_54m_fck)) {
 		dev_err(dispc.fbdev->dev, "can't get tv_fck\n");
 		clk_put(dispc.dss_ick);
@@ -1371,6 +1377,12 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 	int skip_init = 0;
 	int i;
 
+	r = platform_device_register(&omapdss_device);
+	if (r) {
+		dev_err(fbdev->dev, "can't register omapdss device\n");
+		return r;
+	}
+
 	memset(&dispc, 0, sizeof(dispc));
 
 	dispc.base = ioremap(DISPC_BASE, SZ_1K);
@@ -1508,6 +1520,7 @@ static void omap_dispc_cleanup(void)
 	free_irq(INT_24XX_DSS_IRQ, dispc.fbdev);
 	put_dss_clocks();
 	iounmap(dispc.base);
+	platform_device_unregister(&omapdss_device);
 }
 
 const struct lcd_ctrl omap2_int_ctrl = {
-- 
1.6.4

