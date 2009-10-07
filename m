Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZJGWJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZJGWJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZJGWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:09:00 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2179 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZJGWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:14 -0400
Subject: [PATCH 2/6] ACPI: dock: rename local variable 'dock_station' in
	dock_add()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:37 -0600
Message-ID: <20091007220737.15597.75265.stgit@bob.kio>
In-Reply-To: <20091007220509.15597.65501.stgit@bob.kio>
References: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten the name of 'dock_station' to 'ds'.

No functional change.

It will help later on with some whitespace and legibility issues.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index a8f81c0..390adee 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -947,44 +947,44 @@ static int dock_add(acpi_handle handle)
 {
 	int ret;
 	struct dock_dependent_device *dd;
-	struct dock_station *dock_station;
+	struct dock_station *ds;
 	struct platform_device *dock_device;
 
 	/* allocate & initialize the dock_station private data */
-	dock_station = kzalloc(sizeof(*dock_station), GFP_KERNEL);
-	if (!dock_station)
+	ds = kzalloc(sizeof(struct dock_station), GFP_KERNEL);
+	if (!ds)
 		return -ENOMEM;
-	dock_station->handle = handle;
-	dock_station->last_dock_time = jiffies - HZ;
-	INIT_LIST_HEAD(&dock_station->dependent_devices);
-	INIT_LIST_HEAD(&dock_station->hotplug_devices);
-	INIT_LIST_HEAD(&dock_station->sibling);
-	spin_lock_init(&dock_station->dd_lock);
-	mutex_init(&dock_station->hp_lock);
+	ds->handle = handle;
+	ds->last_dock_time = jiffies - HZ;
+	INIT_LIST_HEAD(&ds->dependent_devices);
+	INIT_LIST_HEAD(&ds->hotplug_devices);
+	INIT_LIST_HEAD(&ds->sibling);
+	spin_lock_init(&ds->dd_lock);
+	mutex_init(&ds->hp_lock);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
 	/* initialize platform device stuff */
-	dock_station->dock_device =
+	ds->dock_device =
 		platform_device_register_simple(dock_device_name,
 			dock_station_count, NULL, 0);
-	dock_device = dock_station->dock_device;
+	dock_device = ds->dock_device;
 	if (IS_ERR(dock_device)) {
-		kfree(dock_station);
-		dock_station = NULL;
+		kfree(ds);
+		ds = NULL;
 		return PTR_ERR(dock_device);
 	}
-	platform_device_add_data(dock_device, &dock_station,
+	platform_device_add_data(dock_device, &ds,
 		sizeof(struct dock_station *));
 
 	/* we want the dock device to send uevents */
 	dev_set_uevent_suppress(&dock_device->dev, 0);
 
 	if (is_dock(handle))
-		dock_station->flags |= DOCK_IS_DOCK;
+		ds->flags |= DOCK_IS_DOCK;
 	if (is_ata(handle))
-		dock_station->flags |= DOCK_IS_ATA;
+		ds->flags |= DOCK_IS_ATA;
 	if (is_battery(handle))
-		dock_station->flags |= DOCK_IS_BAT;
+		ds->flags |= DOCK_IS_BAT;
 
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret)
@@ -1008,7 +1008,7 @@ static int dock_add(acpi_handle handle)
 
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX, find_dock_devices, dock_station,
+			    ACPI_UINT32_MAX, find_dock_devices, ds,
 			    NULL);
 
 	/* add the dock station as a device dependent on itself */
@@ -1017,10 +1017,10 @@ static int dock_add(acpi_handle handle)
 		ret = -ENOMEM;
 		goto err_unregister5;
 	}
-	add_dock_dependent_device(dock_station, dd);
+	add_dock_dependent_device(ds, dd);
 
 	dock_station_count++;
-	list_add(&dock_station->sibling, &dock_stations);
+	list_add(&ds->sibling, &dock_stations);
 	return 0;
 
 err_unregister5:
@@ -1036,8 +1036,8 @@ err_unregister1:
 err_unregister:
 	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
 	platform_device_unregister(dock_device);
-	kfree(dock_station);
-	dock_station = NULL;
+	kfree(ds);
+	ds = NULL;
 	return ret;
 }
 

