Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477Ab0AEN7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0AEN7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436Ab0AEN7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:59:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60539 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754421Ab0AEN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:59:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] mfd: Add a data argument to the WM8350 IRQ free function
Date: Tue,  5 Jan 2010 13:59:07 +0000
Message-Id: <1262699949-3079-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262699949-3079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20100105135756.GA2993@rakim.wolfsonmicro.main>
 <1262699949-3079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To better match genirq.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c             |    2 +-
 drivers/power/wm8350_power.c         |   24 ++++++++++++------------
 drivers/regulator/wm8350-regulator.c |    2 +-
 drivers/rtc/rtc-wm8350.c             |    4 ++--
 include/linux/mfd/wm8350/core.h      |    3 ++-
 sound/soc/codecs/wm8350.c            |    4 ++--
 6 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 9025f29..655836b 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -451,7 +451,7 @@ int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 }
 EXPORT_SYMBOL_GPL(wm8350_register_irq);
 
-int wm8350_free_irq(struct wm8350 *wm8350, int irq)
+int wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data)
 {
 	if (irq < 0 || irq >= WM8350_NUM_IRQ)
 		return -EINVAL;
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index ad4f071..3839a5e 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -428,18 +428,18 @@ static void wm8350_init_charger(struct wm8350 *wm8350)
 
 static void free_charger_irq(struct wm8350 *wm8350)
 {
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
-	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
-	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
-	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_BAT_FB, wm8350);
 }
 
 static __devinit int wm8350_power_probe(struct platform_device *pdev)
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1bbff09..0764a0b 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1407,7 +1407,7 @@ static int wm8350_regulator_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
 
-	wm8350_free_irq(wm8350, wm8350_reg[pdev->id].irq);
+	wm8350_free_irq(wm8350, wm8350_reg[pdev->id].irq, rdev);
 
 	regulator_unregister(rdev);
 
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index f164866..a427491 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -476,8 +476,8 @@ static int __devexit wm8350_rtc_remove(struct platform_device *pdev)
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
 
-	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC);
-	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_ALM);
+	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_ALM, wm8350);
 
 	rtc_device_unregister(wm_rtc->rtc);
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index e115560..cfccb4a 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -682,7 +682,8 @@ int wm8350_block_write(struct wm8350 *wm8350, int reg, int size, u16 *src);
 int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 			irq_handler_t handler, unsigned long flags,
 			const char *name, void *data);
-int wm8350_free_irq(struct wm8350 *wm8350, int irq);
+int wm8350_free_irq(struct wm8350 *wm8350, int irq, void *data);
+
 int wm8350_mask_irq(struct wm8350 *wm8350, int irq);
 int wm8350_unmask_irq(struct wm8350 *wm8350, int irq);
 int wm8350_irq_init(struct wm8350 *wm8350, int irq,
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index ebbf11b..f45845a 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1521,8 +1521,8 @@ static int wm8350_remove(struct platform_device *pdev)
 			  WM8350_JDL_ENA | WM8350_JDR_ENA);
 	wm8350_clear_bits(wm8350, WM8350_POWER_MGMT_4, WM8350_TOCLK_ENA);
 
-	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L);
-	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L, priv);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R, priv);
 
 	priv->hpl.jack = NULL;
 	priv->hpr.jack = NULL;
-- 
1.6.5.7

