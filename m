Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZGLSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZGLSb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZGLSal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:30:41 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47137 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbZGLSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:30:40 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 03/15] power: bq27200: misc cleanup
Date: Sun, 12 Jul 2009 21:09:25 +0300
Message-Id: <1247422177-7329-3-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-2-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

whitespaces, tabs, unnecessary prints... the usual.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   40 ++++++++++++--------------------------
 1 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 1978cd9..3eb0f5a 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -39,7 +39,7 @@ struct bq27200_access_methods {
 };
 
 struct bq27200_device_info {
-	struct device 		*dev;
+	struct device		*dev;
 	int			voltage_uV;
 	int			current_uA;
 	int			temp_C;
@@ -50,6 +50,9 @@ struct bq27200_device_info {
 	struct i2c_client	*client;
 };
 
+#define to_bq27200_device_info(x) container_of((x), \
+				struct bq27200_device_info, bat);
+
 static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
@@ -134,6 +137,7 @@ static int bq27200_current(struct bq27200_device_info *di)
 		dev_dbg(di->dev, "negative current!\n");
 		return -curr;
 	}
+
 	return curr;
 }
 
@@ -155,9 +159,6 @@ static int bq27200_rsoc(struct bq27200_device_info *di)
 	return rsoc >> 8;
 }
 
-#define to_bq27200_device_info(x) container_of((x), \
-				struct bq27200_device_info, bat);
-
 static int bq27200_get_property(struct power_supply *psy,
 					enum power_supply_property psp,
 					union power_supply_propval *val)
@@ -196,10 +197,6 @@ static void bq27200_powersupply_init(struct bq27200_device_info *di)
 	di->bat.external_power_changed = NULL;
 }
 
-/*
- * BQ27200 specific code
- */
-
 static int _bq27200_read(u8 reg, int *rt_value, int b_single,
 			struct bq27200_device_info *di)
 {
@@ -236,6 +233,7 @@ static int _bq27200_read(u8 reg, int *rt_value, int b_single,
 			return 0;
 		}
 	}
+
 	return err;
 }
 
@@ -264,7 +262,7 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, di);
 	di->dev = &client->dev;
 	di->bat.name = client->name;
-	bus->read = &_bq27200_read;
+	bus->read = _bq27200_read;
 	di->bus = bus;
 	di->client = client;
 
@@ -276,8 +274,6 @@ static int bq27200_battery_probe(struct i2c_client *client,
 		goto batt_failed_3;
 	}
 
-	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
-
 	return 0;
 
 batt_failed_3:
@@ -301,33 +297,23 @@ static int bq27200_battery_remove(struct i2c_client *client)
 	return 0;
 }
 
-/*
- * Module stuff
- */
-
 static const struct i2c_device_id bq27200_id[] = {
 	{ "bq27200", 0 },
 	{},
 };
 
 static struct i2c_driver bq27200_battery_driver = {
-	.driver = {
-		.name = "bq27200",
+	.driver		= {
+		.name	= "bq27200",
 	},
-	.probe = bq27200_battery_probe,
-	.remove = bq27200_battery_remove,
-	.id_table = bq27200_id,
+	.probe		= bq27200_battery_probe,
+	.remove		= bq27200_battery_remove,
+	.id_table	= bq27200_id,
 };
 
 static int __init bq27200_init(void)
 {
-	int ret;
-
-	ret = i2c_add_driver(&bq27200_battery_driver);
-	if (ret)
-		printk(KERN_ERR "Unable to register BQ27200 driver\n");
-
-	return ret;
+	return i2c_add_driver(&bq27200_battery_driver);
 }
 module_init(bq27200_init);
 
-- 
1.6.1.3

