Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646Ab0A0Upl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0A0Upl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995Ab0A0Upk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:45:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59393 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753406Ab0A0Upj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:45:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: Clean up wm97xx_battery warnings
Date: Wed, 27 Jan 2010 20:45:35 +0000
Message-Id: <1264625135-4075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staticise work_lock (nothing outside the driver has any reason to
see it) and specify dev when requesting the charger IRQ (since that's
what we pass in when we free it).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm97xx_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 6ea3cb5..23eed35 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -26,7 +26,7 @@
 
 static DEFINE_MUTEX(bat_lock);
 static struct work_struct bat_work;
-struct mutex work_lock;
+static struct mutex work_lock;
 static int bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
 static struct wm97xx_batt_info *gpdata;
 static enum power_supply_property *prop;
@@ -203,7 +203,7 @@ static int __devinit wm97xx_bat_probe(struct platform_device *dev)
 			goto err2;
 		ret = request_irq(gpio_to_irq(pdata->charge_gpio),
 				wm97xx_chrg_irq, IRQF_DISABLED,
-				"AC Detect", 0);
+				"AC Detect", dev);
 		if (ret)
 			goto err2;
 		props++;	/* POWER_SUPPLY_PROP_STATUS */
-- 
1.6.6

