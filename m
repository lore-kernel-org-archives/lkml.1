Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbZASNiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbZASNiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbZASNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:37:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34176 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756138AbZASNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:37:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] regulator: Allow init data to be supplied for bq24022
Date: Mon, 19 Jan 2009 13:37:03 +0000
Message-Id: <1232372226-23319-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously it was not possible to do so, making it impossible for
machines to configure the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/bq24022.c       |    3 ++-
 include/linux/regulator/bq24022.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index 50129b4..141f8b6 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -105,7 +105,8 @@ static int __init bq24022_probe(struct platform_device *pdev)
 	ret = gpio_direction_output(pdata->gpio_iset2, 0);
 	ret = gpio_direction_output(pdata->gpio_nce, 1);
 
-	bq24022 = regulator_register(&bq24022_desc, &pdev->dev, NULL, pdata);
+	bq24022 = regulator_register(&bq24022_desc, &pdev->dev,
+				     pdata->init_data, pdata);
 	if (IS_ERR(bq24022)) {
 		dev_dbg(&pdev->dev, "couldn't register regulator\n");
 		ret = PTR_ERR(bq24022);
diff --git a/include/linux/regulator/bq24022.h b/include/linux/regulator/bq24022.h
index e84b0a9..a6d0140 100644
--- a/include/linux/regulator/bq24022.h
+++ b/include/linux/regulator/bq24022.h
@@ -10,6 +10,8 @@
  *
  */
 
+struct regulator_init_data;
+
 /**
  * bq24022_mach_info - platform data for bq24022
  * @gpio_nce: GPIO line connected to the nCE pin, used to enable / disable charging
@@ -18,4 +20,5 @@
 struct bq24022_mach_info {
 	int gpio_nce;
 	int gpio_iset2;
+	struct regulator_init_data *init_data;
 };
-- 
1.5.6.5

