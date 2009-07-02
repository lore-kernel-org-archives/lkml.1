Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZGBPfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZGBPfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZGBPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:35:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55769 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098AbZGBPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:35:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: Implement charge type property for WM835x battery
Date: Thu,  2 Jul 2009 16:35:21 +0100
Message-Id: <1246548921-28624-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm8350_power.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 1b16bf3..28b0299 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -321,6 +321,24 @@ static int wm8350_bat_check_health(struct wm8350 *wm8350)
 	return POWER_SUPPLY_HEALTH_GOOD;
 }
 
+static int wm8350_bat_get_charge_type(struct wm8350 *wm8350)
+{
+	int state;
+
+	state = wm8350_reg_read(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2) &
+	    WM8350_CHG_STS_MASK;
+	switch (state) {
+	case WM8350_CHG_STS_OFF:
+		return POWER_SUPPLY_CHARGE_TYPE_NONE;
+	case WM8350_CHG_STS_TRICKLE:
+		return POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+	case WM8350_CHG_STS_FAST:
+		return POWER_SUPPLY_CHARGE_TYPE_FAST;
+	default:
+		return POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+	}
+}
+
 static int wm8350_bat_get_property(struct power_supply *psy,
 				   enum power_supply_property psp,
 				   union power_supply_propval *val)
@@ -342,6 +360,9 @@ static int wm8350_bat_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_HEALTH:
 		val->intval = wm8350_bat_check_health(wm8350);
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = wm8350_bat_get_charge_type(wm8350);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -355,6 +376,7 @@ static enum power_supply_property wm8350_bat_props[] = {
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
 };
 
 /*********************************************************************
-- 
1.6.3.3

