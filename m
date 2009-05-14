Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbZENUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbZENUcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZENUbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:31:41 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45034 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbZENUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:31:39 -0400
Subject: [PATCH 2/2] ACPI: clean up whitespace in drivers/acpi/scan.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 May 2009 08:31:37 -0600
Message-ID: <20090514143137.18569.76534.stgit@bob.kio>
In-Reply-To: <20090514142941.18569.75813.stgit@bob.kio>
References: <20090514142941.18569.75813.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align labels in column 0, adjust spacing in 'if' statements, eliminate
trailing and superfluous whitespaces.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/scan.c |   44 ++++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index b8f5c00..c40515e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -198,12 +198,12 @@ acpi_device_path_show(struct device *dev, struct device_attribute *attr, char *b
 	int result;
 
 	result = acpi_get_name(acpi_dev->handle, ACPI_FULL_PATHNAME, &path);
-	if(result)
+	if (result)
 		goto end;
 
 	result = sprintf(buf, "%s\n", (char*)path.pointer);
 	kfree(path.pointer);
-  end:
+end:
 	return result;
 }
 static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
@@ -217,21 +217,21 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 	/*
 	 * Devices gotten from FADT don't have a "path" attribute
 	 */
-	if(dev->handle) {
+	if (dev->handle) {
 		result = device_create_file(&dev->dev, &dev_attr_path);
-		if(result)
+		if (result)
 			goto end;
 	}
 
-	if(dev->flags.hardware_id) {
+	if (dev->flags.hardware_id) {
 		result = device_create_file(&dev->dev, &dev_attr_hid);
-		if(result)
+		if (result)
 			goto end;
 	}
 
-	if (dev->flags.hardware_id || dev->flags.compatible_ids){
+	if (dev->flags.hardware_id || dev->flags.compatible_ids) {
 		result = device_create_file(&dev->dev, &dev_attr_modalias);
-		if(result)
+		if (result)
 			goto end;
 	}
 
@@ -242,7 +242,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
 	if (ACPI_SUCCESS(status))
 		result = device_create_file(&dev->dev, &dev_attr_eject);
-  end:
+end:
 	return result;
 }
 
@@ -262,9 +262,9 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 	if (dev->flags.hardware_id || dev->flags.compatible_ids)
 		device_remove_file(&dev->dev, &dev_attr_modalias);
 
-	if(dev->flags.hardware_id)
+	if (dev->flags.hardware_id)
 		device_remove_file(&dev->dev, &dev_attr_hid);
-	if(dev->handle)
+	if (dev->handle)
 		device_remove_file(&dev->dev, &dev_attr_path);
 }
 /* --------------------------------------------------------------------------
@@ -512,7 +512,7 @@ static int acpi_device_register(struct acpi_device *device,
 			break;
 		}
 	}
-	if(!found) {
+	if (!found) {
 		acpi_device_bus_id = new_bus_id;
 		strcpy(acpi_device_bus_id->bus_id, device->flags.hardware_id ? device->pnp.hardware_id : "device");
 		acpi_device_bus_id->instance_no = 0;
@@ -532,19 +532,19 @@ static int acpi_device_register(struct acpi_device *device,
 	device->dev.bus = &acpi_bus_type;
 	device->dev.release = &acpi_device_release;
 	result = device_register(&device->dev);
-	if(result) {
+	if (result) {
 		dev_err(&device->dev, "Error registering device\n");
 		goto end;
 	}
 
 	result = acpi_device_setup_files(device);
-	if(result)
+	if (result)
 		printk(KERN_ERR PREFIX "Error creating sysfs interface for device %s\n",
 		       dev_name(&device->dev));
 
 	device->removal_type = ACPI_BUS_REMOVAL_NORMAL;
 	return 0;
-  end:
+end:
 	mutex_lock(&acpi_device_lock);
 	if (device->parent)
 		list_del(&device->node);
@@ -576,7 +576,7 @@ static void acpi_device_unregister(struct acpi_device *device, int type)
  * @device: the device to add and initialize
  * @driver: driver for the device
  *
- * Used to initialize a device via its device driver.  Called whenever a 
+ * Used to initialize a device via its device driver.  Called whenever a
  * driver is bound to a device.  Invokes the driver's add() ops.
  */
 static int
@@ -584,7 +584,6 @@ acpi_bus_driver_init(struct acpi_device *device, struct acpi_driver *driver)
 {
 	int result = 0;
 
-
 	if (!device || !driver)
 		return -EINVAL;
 
@@ -801,7 +800,7 @@ static int acpi_bus_get_wakeup_device_flags(struct acpi_device *device)
 	if (!acpi_match_device_ids(device, button_device_ids))
 		device->wakeup.flags.run_wake = 1;
 
-      end:
+end:
 	if (ACPI_FAILURE(status))
 		device->flags.wake_capable = 0;
 	return 0;
@@ -1069,7 +1068,7 @@ static void acpi_device_set_id(struct acpi_device *device,
 		break;
 	}
 
-	/* 
+	/*
 	 * \_SB
 	 * ----
 	 * Fix for the system root bus device -- the only root-level device.
@@ -1319,7 +1318,7 @@ acpi_add_single_object(struct acpi_device **child,
 			device->parent->ops.bind(device);
 	}
 
-      end:
+end:
 	if (!result)
 		*child = device;
 	else {
@@ -1463,7 +1462,6 @@ acpi_bus_add(struct acpi_device **child,
 
 	return result;
 }
-
 EXPORT_SYMBOL(acpi_bus_add);
 
 int acpi_bus_start(struct acpi_device *device)
@@ -1483,7 +1481,6 @@ int acpi_bus_start(struct acpi_device *device)
 	}
 	return result;
 }
-
 EXPORT_SYMBOL(acpi_bus_start);
 
 int acpi_bus_trim(struct acpi_device *start, int rmdevice)
@@ -1541,7 +1538,6 @@ int acpi_bus_trim(struct acpi_device *start, int rmdevice)
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 
-
 static int acpi_bus_scan_fixed(struct acpi_device *root)
 {
 	int result = 0;
@@ -1609,6 +1605,6 @@ int __init acpi_scan_init(void)
 	if (result)
 		acpi_device_unregister(acpi_root, ACPI_BUS_REMOVAL_NORMAL);
 
-      Done:
+Done:
 	return result;
 }

