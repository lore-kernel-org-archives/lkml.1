Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbXHHFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbXHHFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932474AbXHHFcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:32:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:48591 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762298AbXHHFcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:32:08 -0400
Message-Id: <20070808053036.985965000@suse.de>
References: <20070808052842.451400000@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 07 Aug 2007 22:28:48 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 6/6] Misc cleanup
Content-Disposition: inline; filename=adm1025-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Misc cleanup post removal of class_device.   adm1025_group_opt is unused.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

---
 drivers/hwmon/adm1025.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -347,17 +347,6 @@ static const struct attribute_group adm1
 	.attrs = adm1025_attributes,
 };
 
-static struct attribute *adm1025_attributes_opt[] = {
-	&dev_attr_in4_input.attr,
-	&dev_attr_in4_min.attr,
-	&dev_attr_in4_max.attr,
-	NULL
-};
-
-static const struct attribute_group adm1025_group_opt = {
-	.attrs = adm1025_attributes_opt,
-};
-
 /*
  * The following function does more than just detection. If detection
  * succeeds, it also registers the new chip.
@@ -482,7 +471,6 @@ static int adm1025_detect(struct i2c_ada
 
 exit_remove:
 	sysfs_remove_group(&new_client->dev.kobj, &adm1025_group);
-	sysfs_remove_group(&new_client->dev.kobj, &adm1025_group_opt);
 exit_detach:
 	i2c_detach_client(new_client);
 exit_free:
@@ -540,7 +528,6 @@ static int adm1025_detach_client(struct 
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group);
-	sysfs_remove_group(&client->dev.kobj, &adm1025_group_opt);
 
 	if ((err = i2c_detach_client(client)))
 		return err;

-- 
