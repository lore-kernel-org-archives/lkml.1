Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZJGWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZJGWIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZJGWIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:08:37 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:10277 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZJGWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:34 -0400
Subject: [PATCH 6/6] ACPI: dock: minor whitespace and style cleanups
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:57 -0600
Message-ID: <20091007220757.15597.63755.stgit@bob.kio>
In-Reply-To: <20091007220509.15597.65501.stgit@bob.kio>
References: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some stray whitespaces
Added whitespace when needed for legibility
Removed unneeded curly braces
Removed useless void casts
Removed unnecessary local variable initialization
Renamed variables to help out with 80-column fixes

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   79 ++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index ce36b6c..1598fb4 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -239,6 +239,7 @@ static int is_battery(acpi_handle handle)
 static int is_ejectable_bay(acpi_handle handle)
 {
 	acpi_handle phandle;
+
 	if (!is_ejectable(handle))
 		return 0;
 	if (is_battery(handle) || is_ata(handle))
@@ -265,14 +266,13 @@ int is_dock_device(acpi_handle handle)
 
 	if (is_dock(handle))
 		return 1;
-	list_for_each_entry(dock_station, &dock_stations, sibling) {
+
+	list_for_each_entry(dock_station, &dock_stations, sibling)
 		if (find_dock_dependent_device(dock_station, handle))
 			return 1;
-	}
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(is_dock_device);
 
 /**
@@ -295,8 +295,6 @@ static int dock_present(struct dock_station *ds)
 	return 0;
 }
 
-
-
 /**
  * dock_create_acpi_device - add new devices to acpi
  * @handle - handle of the device to add
@@ -310,7 +308,7 @@ static int dock_present(struct dock_station *ds)
  */
 static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device;
 	struct acpi_device *parent_device;
 	acpi_handle parent;
 	int ret;
@@ -327,8 +325,7 @@ static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
 		ret = acpi_bus_add(&device, parent_device, handle,
 			ACPI_BUS_TYPE_DEVICE);
 		if (ret) {
-			pr_debug("error adding bus, %x\n",
-				-ret);
+			pr_debug("error adding bus, %x\n", -ret);
 			return NULL;
 		}
 	}
@@ -354,7 +351,6 @@ static void dock_remove_acpi_device(acpi_handle handle)
 	}
 }
 
-
 /**
  * hotplug_dock_devices - insert or remove devices on the dock station
  * @ds: the dock station
@@ -374,10 +370,9 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
 	/*
 	 * First call driver specific hotplug functions
 	 */
-	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list) {
+	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
 		if (dd->ops && dd->ops->handler)
 			dd->ops->handler(dd->handle, event, dd->context);
-	}
 
 	/*
 	 * Now make sure that an acpi_device is created for each
@@ -416,6 +411,7 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
 	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
 		if (dd->ops && dd->ops->uevent)
 			dd->ops->uevent(dd->handle, event, dd->context);
+
 	if (num != DOCK_EVENT)
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
@@ -446,8 +442,8 @@ static void eject_dock(struct dock_station *ds)
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = 1;
 
-	if (ACPI_FAILURE(acpi_evaluate_object(ds->handle, "_EJ0",
-					      &arg_list, NULL)))
+	status = acpi_evaluate_object(ds->handle, "_EJ0", &arg_list, NULL);
+	if (ACPI_FAILURE(status))
 		pr_debug("Failed to evaluate _EJ0!\n");
 }
 
@@ -567,7 +563,6 @@ int register_dock_notifier(struct notifier_block *nb)
 
 	return atomic_notifier_chain_register(&dock_notifier_list, nb);
 }
-
 EXPORT_SYMBOL_GPL(register_dock_notifier);
 
 /**
@@ -581,7 +576,6 @@ void unregister_dock_notifier(struct notifier_block *nb)
 
 	atomic_notifier_chain_unregister(&dock_notifier_list, nb);
 }
-
 EXPORT_SYMBOL_GPL(unregister_dock_notifier);
 
 /**
@@ -626,7 +620,6 @@ register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
 
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
 
 /**
@@ -647,7 +640,6 @@ void unregister_hotplug_dock_device(acpi_handle handle)
 			dock_del_hotplug_device(dock_station, dd);
 	}
 }
-
 EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
 
 /**
@@ -762,7 +754,7 @@ struct dock_data {
 
 static void acpi_dock_deferred_cb(void *context)
 {
-	struct dock_data *data = (struct dock_data *)context;
+	struct dock_data *data = context;
 
 	dock_notify(data->handle, data->event, data->ds);
 	kfree(data);
@@ -772,23 +764,22 @@ static int acpi_dock_notifier_call(struct notifier_block *this,
 	unsigned long event, void *data)
 {
 	struct dock_station *dock_station;
-	acpi_handle handle = (acpi_handle)data;
+	acpi_handle handle = data;
 
 	if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
 	   && event != ACPI_NOTIFY_EJECT_REQUEST)
 		return 0;
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		if (dock_station->handle == handle) {
-			struct dock_data *dock_data;
+			struct dock_data *dd;
 
-			dock_data = kmalloc(sizeof(*dock_data), GFP_KERNEL);
-			if (!dock_data)
+			dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+			if (!dd)
 				return 0;
-			dock_data->handle = handle;
-			dock_data->event = event;
-			dock_data->ds = dock_station;
-			acpi_os_hotplug_execute(acpi_dock_deferred_cb,
-				dock_data);
+			dd->handle = handle;
+			dd->event = event;
+			dd->ds = dock_station;
+			acpi_os_hotplug_execute(acpi_dock_deferred_cb, dd);
 			return 0 ;
 		}
 	}
@@ -935,8 +926,10 @@ static int dock_add(acpi_handle handle)
 	ds = kzalloc(sizeof(struct dock_station), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
+
 	ds->handle = handle;
 	ds->last_dock_time = jiffies - HZ;
+
 	INIT_LIST_HEAD(&ds->dependent_devices);
 	INIT_LIST_HEAD(&ds->hotplug_devices);
 	INIT_LIST_HEAD(&ds->sibling);
@@ -945,16 +938,15 @@ static int dock_add(acpi_handle handle)
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
 	/* initialize platform device stuff */
-	ds->dock_device =
-		platform_device_register_simple(dock_device_name,
-			dock_station_count, NULL, 0);
+	ds->dock_device = platform_device_register_simple(dock_device_name,
+				dock_station_count, NULL, 0);
 	dock_device = ds->dock_device;
+
 	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
 	if (ret)
 		goto err_free;
 
-	platform_device_add_data(dock_device, ds,
-		sizeof(struct dock_station));
+	platform_device_add_data(dock_device, ds, sizeof(struct dock_station));
 
 	/* we want the dock device to send uevents */
 	dev_set_uevent_suppress(&dock_device->dev, 0);
@@ -988,8 +980,7 @@ static int dock_add(acpi_handle handle)
 
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX, find_dock_devices, ds,
-			    NULL);
+			    ACPI_UINT32_MAX, find_dock_devices, ds, NULL);
 
 	/* add the dock station as a device dependent on itself */
 	ret = add_dock_dependent_device(ds, handle);
@@ -1022,18 +1013,17 @@ err_free:
 /**
  * dock_remove - free up resources related to the dock station
  */
-static int dock_remove(struct dock_station *dock_station)
+static int dock_remove(struct dock_station *ds)
 {
 	struct dock_dependent_device *dd, *tmp;
-	struct platform_device *dock_device = dock_station->dock_device;
+	struct platform_device *dock_device = ds->dock_device;
 
 	if (!dock_station_count)
 		return 0;
 
 	/* remove dependent devices */
-	list_for_each_entry_safe(dd, tmp, &dock_station->dependent_devices,
-				 list)
-	    kfree(dd);
+	list_for_each_entry_safe(dd, tmp, &ds->dependent_devices, list)
+		kfree(dd);
 
 	/* cleanup sysfs */
 	device_remove_file(&dock_device->dev, &dev_attr_type);
@@ -1044,8 +1034,8 @@ static int dock_remove(struct dock_station *dock_station)
 	platform_device_unregister(dock_device);
 
 	/* free dock station memory */
-	kfree(dock_station);
-	dock_station = NULL;
+	kfree(ds);
+	ds = NULL;
 	return 0;
 }
 
@@ -1063,11 +1053,10 @@ find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	acpi_status status = AE_OK;
 
-	if (is_dock(handle)) {
-		if (dock_add(handle) >= 0) {
+	if (is_dock(handle))
+		if (dock_add(handle) >= 0)
 			status = AE_CTRL_TERMINATE;
-		}
-	}
+
 	return status;
 }
 

