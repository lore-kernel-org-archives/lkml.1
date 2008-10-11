Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYJKHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYJKHl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbYJKHhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:39 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32846 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYJKHhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:35 -0400
Date: Sat, 11 Oct 2008 02:36:19 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 59/85] ACPI: catch calls of acpi_driver_data on pointer of
 wrong type
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Message-id: <db89b4f0dbab837d0f3de2c3e9427a8d5393afa3.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@suse.cz>

Catch attempts to use of acpi_driver_data on pointers of wrong type.

akpm: rewritten to use proper C typechecking and remove the
"function"-used-as-lvalue thing.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/ac.c              |    2 +-
 drivers/acpi/acpi_memhotplug.c |    2 +-
 drivers/acpi/asus_acpi.c       |    2 +-
 drivers/acpi/battery.c         |    2 +-
 drivers/acpi/button.c          |    2 +-
 drivers/acpi/container.c       |    2 +-
 drivers/acpi/ec.c              |    4 ++--
 drivers/acpi/fan.c             |    2 +-
 drivers/acpi/pci_link.c        |    2 +-
 drivers/acpi/pci_root.c        |    2 +-
 drivers/acpi/power.c           |    4 ++--
 drivers/acpi/processor_core.c  |    2 +-
 drivers/acpi/sbs.c             |    2 +-
 drivers/acpi/sbshc.c           |    4 ++--
 drivers/acpi/scan.c            |    4 ++--
 drivers/acpi/thermal.c         |    2 +-
 drivers/acpi/video.c           |    6 +++---
 drivers/misc/asus-laptop.c     |    2 +-
 drivers/misc/eeepc-laptop.c    |    2 +-
 drivers/misc/fujitsu-laptop.c  |    4 ++--
 drivers/misc/intel_menlow.c    |    2 +-
 drivers/misc/thinkpad_acpi.c   |    2 +-
 include/acpi/acpi_bus.h        |    6 +++++-
 23 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 831883b..8b6a84a 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -269,7 +269,7 @@ static int acpi_ac_add(struct acpi_device *device)
 	ac->device = device;
 	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
-	acpi_driver_data(device) = ac;
+	device->driver_data = ac;
 
 	result = acpi_ac_get_state(ac);
 	if (result)
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 5f1127a..afd955f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -403,7 +403,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	mem_device->device = device;
 	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
-	acpi_driver_data(device) = mem_device;
+	device->driver_data = mem_device;
 
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index d3d0886..91571fc 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -1321,7 +1321,7 @@ static int asus_hotk_add(struct acpi_device *device)
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b1c723f..de80469 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -804,7 +804,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	battery->device = device;
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
-	acpi_driver_data(device) = battery;
+	device->driver_data = battery;
 	mutex_init(&battery->lock);
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS_POWER
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 1dfec41..e22033e 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -384,7 +384,7 @@ static int acpi_button_add(struct acpi_device *device)
 		return -ENOMEM;
 
 	button->device = device;
-	acpi_driver_data(device) = button;
+	device->driver_data = button;
 
 	button->input = input = input_allocate_device();
 	if (!input) {
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 3c25ec7..03ea847 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -108,7 +108,7 @@ static int acpi_container_add(struct acpi_device *device)
 	container->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
-	acpi_driver_data(device) = container;
+	device->driver_data = container;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
 			  acpi_device_name(device), acpi_device_bid(device)));
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 13593f9..5741d99 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -788,7 +788,7 @@ static int acpi_ec_add(struct acpi_device *device)
 
 	if (!first_ec)
 		first_ec = ec;
-	acpi_driver_data(device) = ec;
+	device->driver_data = ec;
 	acpi_ec_add_fs(device);
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
@@ -813,7 +813,7 @@ static int acpi_ec_remove(struct acpi_device *device, int type)
 	}
 	mutex_unlock(&ec->lock);
 	acpi_ec_remove_fs(device);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
 	kfree(ec);
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 2655bc1..e603e40 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -265,7 +265,7 @@ static int acpi_fan_add(struct acpi_device *device)
 
 	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index cf47805..54cd77a 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -737,7 +737,7 @@ static int acpi_pci_link_add(struct acpi_device *device)
 	link->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_LINK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_LINK_CLASS);
-	acpi_driver_data(device) = link;
+	device->driver_data = link;
 
 	mutex_lock(&acpi_link_lock);
 	result = acpi_pci_link_get_possible(link);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index c3fed31..add1a19 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -206,7 +206,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	root->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
-	acpi_driver_data(device) = root;
+	device->driver_data = root;
 
 	device->ops.bind = acpi_pci_bind;
 
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 4ab21cb..1bef942 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -657,7 +657,7 @@ static int acpi_power_add(struct acpi_device *device)
 	strcpy(resource->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
-	acpi_driver_data(device) = resource;
+	device->driver_data = resource;
 
 	/* Evalute the object to get the system level and resource order. */
 	status = acpi_evaluate_object(device->handle, NULL, NULL, &buffer);
@@ -733,7 +733,7 @@ static int acpi_power_resume(struct acpi_device *device)
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
-	resource = (struct acpi_power_resource *)acpi_driver_data(device);
+	resource = acpi_driver_data(device);
 
 	result = acpi_power_get_state(resource, &state);
 	if (result)
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ee68ac5..2894616 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -818,7 +818,7 @@ static int acpi_processor_add(struct acpi_device *device)
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
-	acpi_driver_data(device) = pr;
+	device->driver_data = pr;
 
 	return 0;
 }
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 10a3651..d003325 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -931,7 +931,7 @@ static int acpi_sbs_add(struct acpi_device *device)
 	sbs->device = device;
 	strcpy(acpi_device_name(device), ACPI_SBS_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_SBS_CLASS);
-	acpi_driver_data(device) = sbs;
+	device->driver_data = sbs;
 
 	result = acpi_charger_add(sbs);
 	if (result)
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index a4e3767..001d914 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -282,7 +282,7 @@ static int acpi_smbus_hc_add(struct acpi_device *device)
 	hc->ec = acpi_driver_data(device->parent);
 	hc->offset = (val >> 8) & 0xff;
 	hc->query_bit = val & 0xff;
-	acpi_driver_data(device) = hc;
+	device->driver_data = hc;
 
 	acpi_ec_add_query_handler(hc->ec, hc->query_bit, NULL, smbus_alarm, hc);
 	printk(KERN_INFO PREFIX "SBS HC: EC = 0x%p, offset = 0x%0x, query_bit = 0x%0x\n",
@@ -303,7 +303,7 @@ static int acpi_smbus_hc_remove(struct acpi_device *device, int type)
 	hc = acpi_driver_data(device);
 	acpi_ec_remove_query_handler(hc->ec, hc->query_bit);
 	kfree(hc);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	return 0;
 }
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e7b8853..b88536a 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -384,7 +384,7 @@ static int acpi_device_remove(struct device * dev)
 			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
 	}
 	acpi_dev->driver = NULL;
-	acpi_driver_data(acpi_dev) = NULL;
+	acpi_dev->driver_data = NULL;
 
 	put_device(dev);
 	return 0;
@@ -537,7 +537,7 @@ acpi_bus_driver_init(struct acpi_device *device, struct acpi_driver *driver)
 	result = driver->ops.add(device);
 	if (result) {
 		device->driver = NULL;
-		acpi_driver_data(device) = NULL;
+		device->driver_data = NULL;
 		return result;
 	}
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9127036..e052a75 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1647,7 +1647,7 @@ static int acpi_thermal_add(struct acpi_device *device)
 	strcpy(tz->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_THERMAL_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_THERMAL_CLASS);
-	acpi_driver_data(device) = tz;
+	device->driver_data = tz;
 	mutex_init(&tz->lock);
 
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index e8a51a1..85c6554 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1491,7 +1491,7 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 
 		strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 		strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-		acpi_driver_data(device) = data;
+		device->driver_data = data;
 
 		data->device_id = device_id;
 		data->video = video;
@@ -1982,7 +1982,7 @@ static int acpi_video_bus_add(struct acpi_device *device)
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-	acpi_driver_data(device) = video;
+	device->driver_data = video;
 
 	acpi_video_bus_find_cap(video);
 	error = acpi_video_bus_check(video);
@@ -2058,7 +2058,7 @@ static int acpi_video_bus_add(struct acpi_device *device)
 	acpi_video_bus_remove_fs(device);
  err_free_video:
 	kfree(video);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 
 	return error;
 }
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 7c6dfd0..de82f2f 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -996,7 +996,7 @@ static int asus_hotk_add(struct acpi_device *device)
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ASUS_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ASUS_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 1ee8501..c124705 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -411,7 +411,7 @@ static int eeepc_hotk_add(struct acpi_device *device)
 	ehotk->handle = device->handle;
 	strcpy(acpi_device_name(device), EEEPC_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), EEEPC_HOTK_CLASS);
-	acpi_driver_data(device) = ehotk;
+	device->driver_data = ehotk;
 	ehotk->device = device;
 	result = eeepc_hotk_check();
 	if (result)
diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index 3e56203..7b69cfb 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -490,7 +490,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 	fujitsu->acpi_handle = device->handle;
 	sprintf(acpi_device_name(device), "%s", ACPI_FUJITSU_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_FUJITSU_CLASS);
-	acpi_driver_data(device) = fujitsu;
+	device->driver_data = fujitsu;
 
 	status = acpi_install_notify_handler(device->handle,
 					     ACPI_DEVICE_NOTIFY,
@@ -703,7 +703,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	sprintf(acpi_device_name(device), "%s",
 		ACPI_FUJITSU_HOTKEY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_FUJITSU_CLASS);
-	acpi_driver_data(device) = fujitsu_hotkey;
+	device->driver_data = fujitsu_hotkey;
 
 	status = acpi_install_notify_handler(device->handle,
 					     ACPI_DEVICE_NOTIFY,
diff --git a/drivers/misc/intel_menlow.c b/drivers/misc/intel_menlow.c
index 80a1363..cd3ea7f 100644
--- a/drivers/misc/intel_menlow.c
+++ b/drivers/misc/intel_menlow.c
@@ -175,7 +175,7 @@ static int intel_menlow_memory_add(struct acpi_device *device)
 		goto end;
 	}
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				&cdev->device.kobj, "thermal_cooling");
 	if (result)
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 6b93007..62aebaa 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -543,7 +543,7 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 		return -ENODEV;
 	}
 
-	acpi_driver_data(ibm->acpi->device) = ibm;
+	ibm->acpi->device->driver_data = ibm;
 	sprintf(acpi_device_class(ibm->acpi->device), "%s/%s",
 		TPACPI_ACPI_EVENT_PREFIX,
 		ibm->name);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a5ac0bc..4768246 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -300,7 +300,11 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((d)->driver_data)
+static inline void *acpi_driver_data(struct acpi_device *d)
+{
+	return d->driver_data;
+}
+
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
-- 
1.5.5.1

