Return-Path: <linux-kernel-owner+w=401wt.eu-S936653AbZFPGCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936653AbZFPGCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935657AbZFPFvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:37 -0400
Received: from kroah.org ([198.145.64.141]:48436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935595AbZFPFve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/64] thermal: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:37 -0700
Message-Id: <1245131213-24168-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/thermal/thermal_sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5e38ba1..0a69672 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -417,7 +417,7 @@ static LIST_HEAD(thermal_hwmon_list);
 static ssize_t
 name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct thermal_hwmon_device *hwmon = dev->driver_data;
+	struct thermal_hwmon_device *hwmon = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", hwmon->type);
 }
 static DEVICE_ATTR(name, 0444, name_show, NULL);
@@ -488,7 +488,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
 	}
-	hwmon->device->driver_data = hwmon;
+	dev_set_drvdata(hwmon->device, hwmon);
 	result = device_create_file(hwmon->device, &dev_attr_name);
 	if (result)
 		goto unregister_hwmon_device;
-- 
1.6.3.2

