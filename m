Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0BKPOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:14:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0BKPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:14:48 -0500
From: Thomas Weber <weber@corscience.de>
Cc: Thomas Weber <weber@corscience.de>, jhnikula@gmail.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       perex@perex.cz, tiwai@suse.de, jkrzyszt@tis.icnet.pl,
       anuj.aggarwal@ti.com, x0052729@ti.com, peter.ujfalusi@nokia.com,
       tony@atomide.com, jy0922.shim@samsung.com, linux-omap@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCHv2 3/4] Add ASoC support for Devkit8000
Date: Thu, 11 Feb 2010 16:13:59 +0100
Message-Id: <1265901239-31285-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.6.6.1
X-Provags-ID: V01U2FsdGVkX18HX7b1d8byOGgeFhpD1uwXLBsrBkDy8d6Ecti
 TFPdI0x72Y306uu4r7KQOpZ7cakxFi4W8811zGQGTIshXYY2cr
 7ZbI5pcSq4GAYnwauD/1Q==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch expands the omap3beagle sound soc for the
beagle board clone DevKit8000.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 sound/soc/omap/Kconfig       |    8 +++++---
 sound/soc/omap/omap3beagle.c |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index 61952aa..18ebdc7 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -94,12 +94,14 @@ config SND_OMAP_SOC_OMAP3_PANDORA
 	  Say Y if you want to add support for SoC audio on the OMAP3 Pandora.
 
 config SND_OMAP_SOC_OMAP3_BEAGLE
-	tristate "SoC Audio support for OMAP3 Beagle"
-	depends on TWL4030_CORE && SND_OMAP_SOC && MACH_OMAP3_BEAGLE
+	tristate "SoC Audio support for OMAP3 Beagle and Devkit8000"
+	depends on TWL4030_CORE && SND_OMAP_SOC
+	depends on (MACH_OMAP3_BEAGLE || MACH_DEVKIT8000)
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_TWL4030
 	help
-	  Say Y if you want to add support for SoC audio on the Beagleboard.
+	  Say Y if you want to add support for SoC audio on the Beagleboard or
+	  the clone Devkit8000.
 
 config SND_OMAP_SOC_ZOOM2
 	tristate "SoC Audio support for Zoom2"
diff --git a/sound/soc/omap/omap3beagle.c b/sound/soc/omap/omap3beagle.c
index d88ad5c..240e097 100644
--- a/sound/soc/omap/omap3beagle.c
+++ b/sound/soc/omap/omap3beagle.c
@@ -117,11 +117,11 @@ static int __init omap3beagle_soc_init(void)
 {
 	int ret;
 
-	if (!machine_is_omap3_beagle()) {
-		pr_debug("Not OMAP3 Beagle!\n");
+	if (!(machine_is_omap3_beagle() || machine_is_devkit8000())) {
+		pr_debug("Not OMAP3 Beagle or Devkit8000!\n");
 		return -ENODEV;
 	}
-	pr_info("OMAP3 Beagle SoC init\n");
+	pr_info("OMAP3 Beagle/Devkit8000 SoC init\n");
 
 	omap3beagle_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!omap3beagle_snd_device) {
-- 
1.6.6.1

