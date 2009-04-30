Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbZD3Waj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbZD3Waj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761933AbZD3W3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:29:43 -0400
Received: from kroah.org ([198.145.64.141]:55460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbZD3W3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:29:41 -0400
Date: Thu, 30 Apr 2009 15:22:52 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: [PATCH] thermal: remove driver_data direct access of struct device
Message-ID: <20090430222252.GA18646@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/thermal/thermal_sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
@@ -488,7 +488,7 @@ thermal_add_hwmon_sysfs(struct thermal_z
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
 	}
-	hwmon->device->driver_data = hwmon;
+	dev_set_drvdata(hwmon->device, hwmon);
 	result = device_create_file(hwmon->device, &dev_attr_name);
 	if (result)
 		goto unregister_hwmon_device;
