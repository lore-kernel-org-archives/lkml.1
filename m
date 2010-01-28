Return-Path: <linux-kernel-owner+w=401wt.eu-S932190Ab0A1KVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0A1KVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479Ab0A1KVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:21:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46180 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753402Ab0A1KVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:21:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Convert fixed voltage regulator to use enable_time()
Date: Thu, 28 Jan 2010 10:21:05 +0000
Message-Id: <1264674065-21852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It had an open coded version in enable().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index ee3e7eb..a3d3bfc 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -50,8 +50,6 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 	if (gpio_is_valid(data->gpio)) {
 		gpio_set_value_cansleep(data->gpio, data->enable_high);
 		data->is_enabled = 1;
-		if (data->startup_delay)
-			udelay(data->startup_delay);
 	}
 
 	return 0;
@@ -69,6 +67,13 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 	return 0;
 }
 
+static int fixed_voltage_enable_time(struct regulator_dev *dev)
+{
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->startup_delay;
+}
+
 static int fixed_voltage_get_voltage(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
@@ -91,6 +96,7 @@ static struct regulator_ops fixed_voltage_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
 	.disable = fixed_voltage_disable,
+	.enable_time = fixed_voltage_enable_time,
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
 };
-- 
1.6.6

