Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZD1Izf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZD1Izf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZD1IzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:55:21 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41681 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZD1IzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:55:19 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 1/3] w1: ds2760_battery: cleanups in ds2760_battery_probe()
Date: Tue, 28 Apr 2009 10:55:00 +0200
Message-Id: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed struct ds2760_platform_data which wasn't defined anywhere.
Indentation cleanups.

Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/power/ds2760_battery.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index a52d4a1..9331009 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -344,7 +344,6 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 {
 	int retval = 0;
 	struct ds2760_device_info *di;
-	struct ds2760_platform_data *pdata;
 
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di) {
@@ -354,14 +353,13 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, di);
 
-	pdata = pdev->dev.platform_data;
-	di->dev		= &pdev->dev;
-	di->w1_dev	     = pdev->dev.parent;
-	di->bat.name	   = dev_name(&pdev->dev);
-	di->bat.type	   = POWER_SUPPLY_TYPE_BATTERY;
-	di->bat.properties     = ds2760_battery_props;
-	di->bat.num_properties = ARRAY_SIZE(ds2760_battery_props);
-	di->bat.get_property   = ds2760_battery_get_property;
+	di->dev			= &pdev->dev;
+	di->w1_dev		= pdev->dev.parent;
+	di->bat.name		= dev_name(&pdev->dev);
+	di->bat.type		= POWER_SUPPLY_TYPE_BATTERY;
+	di->bat.properties	= ds2760_battery_props;
+	di->bat.num_properties	= ARRAY_SIZE(ds2760_battery_props);
+	di->bat.get_property	= ds2760_battery_get_property;
 	di->bat.external_power_changed =
 				  ds2760_battery_external_power_changed;
 
-- 
1.6.2.1

