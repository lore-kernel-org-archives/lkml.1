Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZGLSbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZGLSbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZGLS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:52 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47023 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZGLS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:51 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 05/15] power: bq27200: remove unnecessary function
Date: Sun, 12 Jul 2009 21:09:27 +0300
Message-Id: <1247422177-7329-5-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-4-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that init function was completely unnecessary.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index eddb731..deef1b5 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -164,15 +164,6 @@ static int bq27200_get_property(struct power_supply *psy,
 	return 0;
 }
 
-static void bq27200_powersupply_init(struct bq27200_device_info *di)
-{
-	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
-	di->bat.properties = bq27200_props;
-	di->bat.num_properties = ARRAY_SIZE(bq27200_props);
-	di->bat.get_property = bq27200_get_property;
-	di->bat.external_power_changed = NULL;
-}
-
 static int bq27200_battery_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
@@ -191,7 +182,11 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	di->bat.name = client->name;
 	di->client = client;
 
-	bq27200_powersupply_init(di);
+	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
+	di->bat.properties = bq27200_props;
+	di->bat.num_properties = ARRAY_SIZE(bq27200_props);
+	di->bat.get_property = bq27200_get_property;
+	di->bat.external_power_changed = NULL;
 
 	retval = power_supply_register(&client->dev, &di->bat);
 	if (retval) {
-- 
1.6.1.3

