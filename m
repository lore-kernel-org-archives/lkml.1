Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXGOBtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXGOBtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763574AbXGOBtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:49:46 -0400
Received: from mx34.mail.ru ([194.67.23.200]:28509 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762140AbXGOBtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:49:45 -0400
Date: Sun, 15 Jul 2007 05:45:07 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Power supply class and drivers: remove non obligatory
	return statements
Message-ID: <20070715014507.GB7474@zarina>
References: <46996A53.6000807@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <46996A53.6000807@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Per Jeff Garzik request.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/apm_power.c          |    4 ----
 drivers/power/ds2760_battery.c     |    7 -------
 drivers/power/olpc_battery.c       |    1 -
 drivers/power/pda_power.c          |    5 -----
 drivers/power/pmu_battery.c        |    2 --
 drivers/power/power_supply_core.c  |    6 ------
 drivers/power/power_supply_leds.c  |    8 --------
 drivers/power/power_supply_sysfs.c |    2 --
 drivers/w1/slaves/w1_ds2760.c      |    4 ----
 9 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 042bd95..39a90a6 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -48,8 +48,6 @@ static void find_main_battery(void)
 	}
 	if (!main_battery)
 		main_battery = batm;
-
-	return;
 }
 
 static int calculate_time(int status)
@@ -218,7 +216,6 @@ static void apm_battery_apm_get_power_status(struct apm_power_info *info)
 	}
 
 	up(&power_supply_class->sem);
-	return;
 }
 
 static int __init apm_battery_init(void)
@@ -232,7 +229,6 @@ static int __init apm_battery_init(void)
 static void __exit apm_battery_exit(void)
 {
 	apm_get_power_status = NULL;
-	return;
 }
 
 module_init(apm_battery_init);
diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 00e1ea6..be7021e 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -254,8 +254,6 @@ static void ds2760_battery_update_status(struct ds2760_device_info *di)
 
 	if (di->charge_status != old_charge_status)
 		power_supply_changed(&di->bat);
-
-	return;
 }
 
 static void ds2760_battery_work(struct work_struct *work)
@@ -268,8 +266,6 @@ static void ds2760_battery_work(struct work_struct *work)
 
 	ds2760_battery_update_status(di);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, interval);
-
-	return;
 }
 
 #define to_ds2760_device_info(x) container_of((x), struct ds2760_device_info, \
@@ -283,8 +279,6 @@ static void ds2760_battery_external_power_changed(struct power_supply *psy)
 
 	cancel_delayed_work(&di->monitor_work);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
-
-	return;
 }
 
 static int ds2760_battery_get_property(struct power_supply *psy,
@@ -457,7 +451,6 @@ static int __init ds2760_battery_init(void)
 static void __exit ds2760_battery_exit(void)
 {
 	platform_driver_unregister(&ds2760_battery_driver);
-	return;
 }
 
 module_init(ds2760_battery_init);
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 878684d..c998e68 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -341,7 +341,6 @@ static void __exit olpc_bat_exit(void)
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
 	platform_device_unregister(bat_pdev);
-	return;
 }
 
 module_init(olpc_bat_init);
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 8304506..dacbe50 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -97,8 +97,6 @@ static void update_charger(void)
 		dev_dbg(dev, "charger off\n");
 		pdata->set_charge(0);
 	}
-
-	return;
 }
 
 static void supply_timer_func(unsigned long power_supply_ptr)
@@ -106,7 +104,6 @@ static void supply_timer_func(unsigned long power_supply_ptr)
 	void *power_supply = (void *) power_supply_ptr;
 
 	power_supply_changed(power_supply);
-	return;
 }
 
 static void charger_timer_func(unsigned long power_supply_ptr)
@@ -118,7 +115,6 @@ static void charger_timer_func(unsigned long power_supply_ptr)
 	supply_timer.data = power_supply_ptr;
 	mod_timer(&supply_timer,
 		  jiffies + msecs_to_jiffies(pdata->wait_for_charger));
-	return;
 }
 
 static irqreturn_t power_changed_isr(int irq, void *power_supply)
@@ -251,7 +247,6 @@ static int __init pda_power_init(void)
 static void __exit pda_power_exit(void)
 {
 	platform_driver_unregister(&pda_power_pdrv);
-	return;
 }
 
 module_init(pda_power_init);
diff --git a/drivers/power/pmu_battery.c b/drivers/power/pmu_battery.c
index 2fea4af..60a8cf3 100644
--- a/drivers/power/pmu_battery.c
+++ b/drivers/power/pmu_battery.c
@@ -203,8 +203,6 @@ static void __exit pmu_bat_exit(void)
 	}
 	power_supply_unregister(&pmu_ac);
 	platform_device_unregister(bat_pdev);
-
-	return;
 }
 
 module_init(pmu_bat_init);
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index e87ea51..a63b75c 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -46,8 +46,6 @@ static void power_supply_changed_work(struct work_struct *work)
 	power_supply_update_leds(psy);
 
 	kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
-
-	return;
 }
 
 void power_supply_changed(struct power_supply *psy)
@@ -55,8 +53,6 @@ void power_supply_changed(struct power_supply *psy)
 	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
 
 	schedule_work(&psy->changed_work);
-
-	return;
 }
 
 int power_supply_am_i_supplied(struct power_supply *psy)
@@ -129,7 +125,6 @@ void power_supply_unregister(struct power_supply *psy)
 	power_supply_remove_triggers(psy);
 	power_supply_remove_attrs(psy);
 	device_unregister(psy->dev);
-	return;
 }
 
 static int __init power_supply_class_init(void)
@@ -147,7 +142,6 @@ static int __init power_supply_class_init(void)
 static void __exit power_supply_class_exit(void)
 {
 	class_destroy(power_supply_class);
-	return;
 }
 
 EXPORT_SYMBOL_GPL(power_supply_changed);
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 7232490..7f8f359 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -40,8 +40,6 @@ static void power_supply_update_bat_leds(struct power_supply *psy)
 		led_trigger_event(psy->full_trig, LED_OFF);
 		break;
 	}
-
-	return;
 }
 
 static int power_supply_create_bat_triggers(struct power_supply *psy)
@@ -97,7 +95,6 @@ static void power_supply_remove_bat_triggers(struct power_supply *psy)
 	kfree(psy->full_trig_name);
 	kfree(psy->charging_trig_name);
 	kfree(psy->charging_full_trig_name);
-	return;
 }
 
 /* Generated power specific LEDs triggers. */
@@ -115,8 +112,6 @@ static void power_supply_update_gen_leds(struct power_supply *psy)
 		led_trigger_event(psy->online_trig, LED_FULL);
 	else
 		led_trigger_event(psy->online_trig, LED_OFF);
-
-	return;
 }
 
 static int power_supply_create_gen_triggers(struct power_supply *psy)
@@ -145,7 +140,6 @@ static void power_supply_remove_gen_triggers(struct power_supply *psy)
 {
 	led_trigger_unregister_simple(psy->online_trig);
 	kfree(psy->online_trig_name);
-	return;
 }
 
 /* Choice what triggers to create&update. */
@@ -156,7 +150,6 @@ void power_supply_update_leds(struct power_supply *psy)
 		power_supply_update_bat_leds(psy);
 	else
 		power_supply_update_gen_leds(psy);
-	return;
 }
 
 int power_supply_create_triggers(struct power_supply *psy)
@@ -172,5 +165,4 @@ void power_supply_remove_triggers(struct power_supply *psy)
 		power_supply_remove_bat_triggers(psy);
 	else
 		power_supply_remove_gen_triggers(psy);
-	return;
 }
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index c07d425..c7c4574 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -176,8 +176,6 @@ void power_supply_remove_attrs(struct power_supply *psy)
 	for (i = 0; i < psy->num_properties; i++)
 		device_remove_file(psy->dev,
 			    &power_supply_attrs[psy->properties[i]]);
-
-	return;
 }
 
 static char *kstruprdup(const char *str, gfp_t gfp)
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 88a37fb..15e7f9a 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -121,8 +121,6 @@ static void release_bat_id(int id)
 	mutex_lock(&bat_idr_lock);
 	idr_remove(&bat_idr, id);
 	mutex_unlock(&bat_idr_lock);
-
-	return;
 }
 
 static int w1_ds2760_add_slave(struct w1_slave *sl)
@@ -174,8 +172,6 @@ static void w1_ds2760_remove_slave(struct w1_slave *sl)
 	platform_device_unregister(pdev);
 	release_bat_id(id);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
-
-	return;
 }
 
 static struct w1_family_ops w1_ds2760_fops = {
-- 
1.5.1.1-dirty
