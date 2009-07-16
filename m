Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZGPPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZGPPoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZGPPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:44:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:46039 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbZGPPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:44:21 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 2/3] pda-power: EXPORT_SYMBOL cleanups
Date: Thu, 16 Jul 2009 17:44:03 +0200
Message-Id: <1247759044-4747-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I'm at it, cleanup the power supply code so that EXPORT_SYMBOL_GPL
appears directly after the symbole declaration. checkpatch.pl wants it
that way.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ian Molton <spyro@f2s.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Matt Reimer <mreimer@vpop.net>
---
 drivers/power/power_supply_core.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 7303c45..0a10799 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -20,6 +20,9 @@
 
 struct class *power_supply_class;
 
+/* exported for the APM Power driver, APM emulation */
+EXPORT_SYMBOL_GPL(power_supply_class);
+
 static int __power_supply_changed_work(struct device *dev, void *data)
 {
 	struct power_supply *psy = (struct power_supply *)data;
@@ -55,6 +58,7 @@ void power_supply_changed(struct power_supply *psy)
 
 	schedule_work(&psy->changed_work);
 }
+EXPORT_SYMBOL_GPL(power_supply_changed);
 
 static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
@@ -86,6 +90,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(power_supply_am_i_supplied);
 
 static int __power_supply_is_system_supplied(struct device *dev, void *data)
 {
@@ -110,6 +115,7 @@ int power_supply_is_system_supplied(void)
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 
 static int __power_supply_set_battery_charged(struct device *dev, void *data)
 {
@@ -160,6 +166,7 @@ dev_create_failed:
 success:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(power_supply_register);
 
 void power_supply_unregister(struct power_supply *psy)
 {
@@ -168,6 +175,7 @@ void power_supply_unregister(struct power_supply *psy)
 	power_supply_remove_attrs(psy);
 	device_unregister(psy->dev);
 }
+EXPORT_SYMBOL_GPL(power_supply_unregister);
 
 static int __init power_supply_class_init(void)
 {
@@ -186,15 +194,6 @@ static void __exit power_supply_class_exit(void)
 	class_destroy(power_supply_class);
 }
 
-EXPORT_SYMBOL_GPL(power_supply_changed);
-EXPORT_SYMBOL_GPL(power_supply_am_i_supplied);
-EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
-EXPORT_SYMBOL_GPL(power_supply_register);
-EXPORT_SYMBOL_GPL(power_supply_unregister);
-
-/* exported for the APM Power driver, APM emulation */
-EXPORT_SYMBOL_GPL(power_supply_class);
-
 subsys_initcall(power_supply_class_init);
 module_exit(power_supply_class_exit);
 
-- 
1.6.3.1

