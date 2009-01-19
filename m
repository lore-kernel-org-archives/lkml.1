Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbZASNjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbZASNjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZASNhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:37:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34175 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756283AbZASNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:37:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] regulator: Allow init_data to be passed to fixed voltage regulators
Date: Mon, 19 Jan 2009 13:37:04 +0000
Message-Id: <1232372226-23319-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232372226-23319-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c       |    3 ++-
 include/linux/regulator/fixed.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index d31db3e..23d5546 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -73,7 +73,8 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->microvolts = config->microvolts;
 
-	drvdata->dev = regulator_register(&drvdata->desc, drvdata);
+	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
+					  config->init_data, drvdata);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		goto err_name;
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 1387a5d..91b4da3 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -14,9 +14,12 @@
 #ifndef __REGULATOR_FIXED_H
 #define __REGULATOR_FIXED_H
 
+struct regulator_init_data;
+
 struct fixed_voltage_config {
 	const char *supply_name;
 	int microvolts;
+	struct regulator_init_data *init_data;
 };
 
 #endif
-- 
1.5.6.5

