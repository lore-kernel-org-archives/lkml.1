Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZKIWMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZKIWMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZKIWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:12:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1273 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZKIWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:12:44 -0500
Subject: [PATCH] drivers/thermal/thermal_sys.c: fix strncmp tests
From: Joe Perches <joe@perches.com>
To: Zhang Rui <rui.zhang@intel.com>, Sujith Thomas <sujith.thomas@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 14:12:49 -0800
Message-ID: <1257804769.12852.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strncmp(var, "foo", sizeof("foo") - 1)
not strncmp(var, "foo", sizeof("foo"))

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 4e83c29..c35d538 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -147,9 +147,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	if (!tz->ops->set_mode)
 		return -EPERM;
 
-	if (!strncmp(buf, "enabled", sizeof("enabled")))
+	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
-	else if (!strncmp(buf, "disabled", sizeof("disabled")))
+	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
 		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
 	else
 		result = -EINVAL;
@@ -228,8 +228,8 @@ passive_store(struct device *dev, struct device_attribute *attr,
 	if (state && !tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
-			if (!strncmp("Processor", cdev->type,
-				     sizeof("Processor")))
+			if (!strncmp(cdev->type, "Processor",
+				     sizeof("Processor") - 1))
 				thermal_zone_bind_cooling_device(tz,
 								 THERMAL_TRIPS_NONE,
 								 cdev);
@@ -238,8 +238,8 @@ passive_store(struct device *dev, struct device_attribute *attr,
 	} else if (!state && tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
-			if (!strncmp("Processor", cdev->type,
-				     sizeof("Processor")))
+			if (!strncmp(cdev->type, "Processor",
+				     sizeof("Processor") - 1))
 				thermal_zone_unbind_cooling_device(tz,
 								   THERMAL_TRIPS_NONE,
 								   cdev);
@@ -796,7 +796,7 @@ static void thermal_release(struct device *dev)
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 
-	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
+	if (!strncmp(dev_name(dev), "thermal_zone", sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
 	} else {


