Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbYCFCcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbYCFCcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbYCFCZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:15 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:26847 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbYCFCZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IYwKK5ND+o9W4zlzPrCoY9bq+vf/ymWdEcj2x5Eyqx2/aO4yKRuGnmDp5NGobo74XRi84zENxPfATcH6hdBSMPfghJ1qVFnmf04Hc5pJ1oDDMixy7hW/AVRXrQk2IzX2XtX54hUYWkF9jpzeLJKpxbcvkCZnEgkQjojmfifOQF8=
Subject: [PATCH 15/16] power: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:59 -0800
Message-Id: <1204770299.14154.51.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/power/ds2760_battery.c    |    4 ++--
 drivers/power/power_supply_core.c |    6 +++---
 drivers/power/power_supply_leds.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index bdb9b72..71be36f 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -262,7 +262,7 @@ static void ds2760_battery_work(struct work_struct *work)
 		struct ds2760_device_info, monitor_work.work);
 	const int interval = HZ * 60;
 
-	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+	dev_dbg(di->dev, "%s\n", __func__);
 
 	ds2760_battery_update_status(di);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, interval);
@@ -275,7 +275,7 @@ static void ds2760_battery_external_power_changed(struct power_supply *psy)
 {
 	struct ds2760_device_info *di = to_ds2760_device_info(psy);
 
-	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+	dev_dbg(di->dev, "%s\n", __func__);
 
 	cancel_delayed_work(&di->monitor_work);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 03d6a38..138dd76 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -39,7 +39,7 @@ static void power_supply_changed_work(struct work_struct *work)
 	struct power_supply *psy = container_of(work, struct power_supply,
 						changed_work);
 
-	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
+	dev_dbg(psy->dev, "%s\n", __func__);
 
 	class_for_each_device(power_supply_class, psy,
 			      __power_supply_changed_work);
@@ -51,7 +51,7 @@ static void power_supply_changed_work(struct work_struct *work)
 
 void power_supply_changed(struct power_supply *psy)
 {
-	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
+	dev_dbg(psy->dev, "%s\n", __func__);
 
 	schedule_work(&psy->changed_work);
 }
@@ -82,7 +82,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 	error = class_for_each_device(power_supply_class, psy,
 				      __power_supply_am_i_supplied);
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, error);
+	dev_dbg(psy->dev, "%s %d\n", __func__, error);
 
 	return error;
 }
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index fa3034f..2dece40 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -24,7 +24,7 @@ static void power_supply_update_bat_leds(struct power_supply *psy)
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, status.intval);
+	dev_dbg(psy->dev, "%s %d\n", __func__, status.intval);
 
 	switch (status.intval) {
 	case POWER_SUPPLY_STATUS_FULL:
@@ -101,7 +101,7 @@ static void power_supply_update_gen_leds(struct power_supply *psy)
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, online.intval);
+	dev_dbg(psy->dev, "%s %d\n", __func__, online.intval);
 
 	if (online.intval)
 		led_trigger_event(psy->online_trig, LED_FULL);
-- 
1.5.4.GIT


