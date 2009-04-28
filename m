Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZD1KOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZD1KOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZD1KN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:13:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54735 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754822AbZD1KN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:13:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Support list_voltage for fixed voltage regulator
Date: Tue, 28 Apr 2009 11:13:54 +0100
Message-Id: <1240913635-22404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 6e0bede..4c525af 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -44,10 +44,22 @@ static int fixed_voltage_get_voltage(struct regulator_dev *dev)
 	return data->microvolts;
 }
 
+static int fixed_voltage_list_voltage(struct regulator_dev *dev,
+				      unsigned selector)
+{
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (selector != 0)
+		return -EINVAL;
+
+	return data->microvolts;
+}
+
 static struct regulator_ops fixed_voltage_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
 	.get_voltage = fixed_voltage_get_voltage,
+	.list_voltage = fixed_voltage_list_voltage,
 };
 
 static int regulator_fixed_voltage_probe(struct platform_device *pdev)
@@ -69,7 +81,8 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 	}
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
-	drvdata->desc.ops = &fixed_voltage_ops,
+	drvdata->desc.ops = &fixed_voltage_ops;
+	drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
 
-- 
1.6.2.4

