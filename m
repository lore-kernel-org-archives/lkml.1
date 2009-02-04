Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZBDQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZBDQDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZBDQD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:03:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZBDQDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:03:25 -0500
Message-ID: <4989BC3B.2070508@suse.de>
Date: Wed, 04 Feb 2009 17:03:07 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       shaohuhua.li@intel.com, kristen.c.accardi@intel.com, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCHv2] ACPI: add missing KERN_* constants to printks
References: <4989A784.3030604@suse.de>
In-Reply-To: <4989A784.3030604@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls (beginning
a new line) should have an according KERN_* constant.
Those are the missing peaces here for the acpi subsystem.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/acpi/container.c |    5 +++--
 drivers/acpi/dock.c      |    8 ++++----
 drivers/acpi/osl.c       |    4 ++--
 drivers/acpi/pci_link.c  |    2 +-
 drivers/acpi/sleep.c     |    2 +-
 drivers/acpi/video.c     |    2 +-
 6 files changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1260,7 +1260,7 @@ static int acpi_video_bus_POST_info_seq_
 			printk(KERN_WARNING PREFIX
 			       "This indicates a BIOS bug. Please contact the manufacturer.\n");
 		}
-		printk("%llx\n", options);
+		printk(KERN_WARNING "%llx\n", options);
 		seq_printf(seq, "can POST: <integrated video>");
 		if (options & 2)
 			seq_printf(seq, " <PCI video>");
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -163,7 +163,7 @@ static void container_notify_cb(acpi_han
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk("Container driver received %s event\n",
+		printk(KERN_WARNING "Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 		status = acpi_bus_get_device(handle, &device);
@@ -174,7 +174,8 @@ static void container_notify_cb(acpi_han
 					kobject_uevent(&device->dev.kobj,
 						       KOBJ_ONLINE);
 				else
-					printk("Failed to add container\n");
+					printk(KERN_WARNING
+					       "Failed to add container\n");
 			}
 		} else {
 			if (ACPI_SUCCESS(status)) {
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -593,7 +593,7 @@ static int acpi_pci_link_allocate(struct
 		return -ENODEV;
 	} else {
 		acpi_irq_penalty[link->irq.active] += PIRQ_PENALTY_PCI_USING;
-		printk(PREFIX "%s [%s] enabled at IRQ %d\n",
+		printk(KERN_WARNING PREFIX "%s [%s] enabled at IRQ %d\n",
 		       acpi_device_name(link->device),
 		       acpi_device_bid(link->device), link->irq.active);
 	}
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -984,7 +984,7 @@ static int dock_add(acpi_handle handle)
 
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		platform_device_unregister(dock_device);
 		kfree(dock_station);
 		dock_station = NULL;
@@ -992,7 +992,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_undock);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		platform_device_unregister(dock_device);
 		kfree(dock_station);
@@ -1001,7 +1001,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_uid);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		device_remove_file(&dock_device->dev, &dev_attr_undock);
 		platform_device_unregister(dock_device);
@@ -1011,7 +1011,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_flags);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		device_remove_file(&dock_device->dev, &dev_attr_undock);
 		device_remove_file(&dock_device->dev, &dev_attr_uid);
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -228,10 +228,10 @@ void acpi_os_vprintf(const char *fmt, va
 	if (acpi_in_debugger) {
 		kdb_printf("%s", buffer);
 	} else {
-		printk("%s", buffer);
+		printk(KERN_WARNING "%s", buffer);
 	}
 #else
-	printk("%s", buffer);
+	printk(KERN_WARNING "%s", buffer);
 #endif
 }
 
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -679,7 +679,7 @@ static void acpi_power_off_prepare(void)
 static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __func__);
+	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
 	acpi_enable_wakeup_device(ACPI_STATE_S5);
 	acpi_enter_sleep_state(ACPI_STATE_S5);

