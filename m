Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZHCRuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZHCRuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZHCRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:50:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37459 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752872AbZHCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:49:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] regulator: More explict error reporting for fixed regulator
Date: Mon,  3 Aug 2009 18:49:53 +0100
Message-Id: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index cdc674f..9c7f956 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -70,12 +70,14 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
 	if (drvdata == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate device data\n");
 		ret = -ENOMEM;
 		goto err;
 	}
 
 	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate supply name\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -90,6 +92,7 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 					  config->init_data, drvdata);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
+		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
 		goto err_name;
 	}
 
-- 
1.6.3.3

