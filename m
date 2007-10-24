Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXJXQfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXJXQfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbXJXQYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33403 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759536AbXJXQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:13 -0400
Date: Wed, 24 Oct 2007 18:24:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ACPI: possible cleanups
Message-ID: <20071024162442.GO30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global code static:
  - drivers/acpi/battery.c:acpi_battery_present()
  - drivers/acpi/battery.c:acpi_battery_units()
  - drivers/acpi/bay.c:dev_attr_eject
  - drivers/acpi/bay.c:dev_attr_present
  - drivers/acpi/dock.c:dev_attr_docked
  - drivers/acpi/dock.c:dev_attr_flags
  - drivers/acpi/dock.c:dev_attr_uid
  - drivers/acpi/dock.c:dev_attr_undock
  - drivers/acpi/pci_bind.c:acpi_pci_unbind()
  - drivers/acpi/pci_link.c:acpi_link_lock
  - drivers/acpi/sbs.c:acpi_sbs_callback()
  - drivers/acpi/sbshc.c:acpi_smbus_transaction()
  - drivers/acpi/sleep/main.c:acpi_sleep_prepare()
- #if 0 the following unused global functions:
  - drivers/acpi/ec.c:acpi_ec_burst_disable()
  - drivers/acpi/ec.c:acpi_ec_burst_enable()
  - drivers/acpi/ec.c:ec_burst_disable()
  - drivers/acpi/ec.c:ec_burst_enable()
  - drivers/acpi/numa.c:acpi_unmap_pxm_to_node()
- remove the following unused EXPORT_SYMBOL's:
  - acpi_register_gsi
  - acpi_unregister_gsi
  - acpi_strict
  - acpi_bus_receive_event
  - register_acpi_bus_type
  - unregister_acpi_bus_type
  - acpi_os_printf
  - acpi_os_sleep
  - acpi_os_stall
  - acpi_os_read_pci_configuration
  - acpi_os_create_semaphore
  - acpi_os_delete_semaphore
  - acpi_os_wait_semaphore
  - acpi_os_signal_semaphore
  - acpi_os_signal
  - acpi_pci_irq_enable
  - acpi_get_pxm

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/ia64/kernel/acpi.c     |    4 -
 arch/x86/kernel/acpi/boot.c |    3 -
 drivers/acpi/battery.c      |    4 -
 drivers/acpi/bay.c          |    4 -
 drivers/acpi/bus.c          |    1 
 drivers/acpi/dock.c         |    8 +-
 drivers/acpi/ec.c           |    8 ++
 drivers/acpi/glue.c         |    4 -
 drivers/acpi/numa.c         |    3 -
 drivers/acpi/osl.c          |   18 ------
 drivers/acpi/pci_bind.c     |  102 ++++++++++++++++++------------------
 drivers/acpi/pci_irq.c      |    2 
 drivers/acpi/pci_link.c     |    2 
 drivers/acpi/sbs.c          |    2 
 drivers/acpi/sbshc.c        |    4 -
 drivers/acpi/sleep/main.c   |    2 
 drivers/acpi/sleep/sleep.h  |    1 
 include/acpi/acpi_drivers.h |    1 
 include/acpi/acpi_numa.h    |    1 
 19 files changed, 74 insertions(+), 100 deletions(-)

commit 71d9a7f955d637b86480aba4ce153ed623c143e3
Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Oct 21 14:50:52 2007 +0200

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 3d45d24..e71a5c2 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -601,8 +601,6 @@ int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 				     IOSAPIC_LEVEL);
 }
 
-EXPORT_SYMBOL(acpi_register_gsi);
-
 void acpi_unregister_gsi(u32 gsi)
 {
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
@@ -611,8 +609,6 @@ void acpi_unregister_gsi(u32 gsi)
 	iosapic_unregister_intr(gsi);
 }
 
-EXPORT_SYMBOL(acpi_unregister_gsi);
-
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
 	struct acpi_table_header *fadt_header;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 289247d..c845d75 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -78,7 +78,6 @@ int acpi_ht __initdata = 1;	/* enable HT */
 int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
-EXPORT_SYMBOL(acpi_strict);
 
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
@@ -490,8 +489,6 @@ int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 	return irq;
 }
 
-EXPORT_SYMBOL(acpi_register_gsi);
-
 /*
  *  ACPI based hotplug support for CPU
  */
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 681e26b..8bdcfdb 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -112,7 +112,7 @@ struct acpi_battery {
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
 
-inline int acpi_battery_present(struct acpi_battery *battery)
+static int acpi_battery_present(struct acpi_battery *battery)
 {
 	return battery->device->status.battery_present;
 }
@@ -216,7 +216,7 @@ static enum power_supply_property energy_battery_props[] = {
 };
 
 #ifdef CONFIG_ACPI_PROCFS
-inline char *acpi_battery_units(struct acpi_battery *battery)
+static char *acpi_battery_units(struct acpi_battery *battery)
 {
 	return (battery->power_unit)?"mA":"mW";
 }
diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index 6daf608..0c81294 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -128,7 +128,7 @@ static ssize_t show_present(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", bay_present(bay));
 
 }
-DEVICE_ATTR(present, S_IRUGO, show_present, NULL);
+static DEVICE_ATTR(present, S_IRUGO, show_present, NULL);
 
 /*
  * write_eject - write method for "eject" file in sysfs
@@ -144,7 +144,7 @@ static ssize_t write_eject(struct device *dev, struct device_attribute *attr,
 	eject_device(bay->handle);
 	return count;
 }
-DEVICE_ATTR(eject, S_IWUSR, NULL, write_eject);
+static DEVICE_ATTR(eject, S_IWUSR, NULL, write_eject);
 
 /**
  * is_ata - see if a device is an ata device
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index fb2cff9..4f58cde 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -369,7 +369,6 @@ int acpi_bus_receive_event(struct acpi_bus_event *event)
 	return 0;
 }
 
-EXPORT_SYMBOL(acpi_bus_receive_event);
 #endif	/* CONFIG_ACPI_PROC_EVENT */
 
 /* --------------------------------------------------------------------------
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 1dabdf4..7e47a98 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -680,7 +680,7 @@ static ssize_t show_docked(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
 
 }
-DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
+static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
 /*
  * show_flags - read method for flags file in sysfs
@@ -691,7 +691,7 @@ static ssize_t show_flags(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
 
 }
-DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
+static DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
 
 /*
  * write_undock - write method for "undock" file in sysfs
@@ -707,7 +707,7 @@ static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
 	ret = handle_eject_request(dock_station, ACPI_NOTIFY_EJECT_REQUEST);
 	return ret ? ret: count;
 }
-DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
+static DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
 
 /*
  * show_dock_uid - read method for "uid" file in sysfs
@@ -723,7 +723,7 @@ static ssize_t show_dock_uid(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%lx\n", lbuf);
 }
-DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
+static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 
 /**
  * dock_add - add a new dock station
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7b41783..ea16f6f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -282,6 +282,8 @@ static int acpi_ec_transaction(struct acpi_ec *ec, u8 command,
 	return status;
 }
 
+#if 0
+
 /*
  * Note: samsung nv5000 doesn't work with ec burst mode.
  * http://bugzilla.kernel.org/show_bug.cgi?id=4980
@@ -297,6 +299,8 @@ int acpi_ec_burst_disable(struct acpi_ec *ec)
 	return acpi_ec_transaction(ec, ACPI_EC_BURST_DISABLE, NULL, 0, NULL, 0, 0);
 }
 
+#endif  /*  0  */
+
 static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 * data)
 {
 	int result;
@@ -315,6 +319,8 @@ static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 				   wdata, 2, NULL, 0, 0);
 }
 
+#if 0
+
 /*
  * Externally callable EC access functions. For now, assume 1 EC only
  */
@@ -336,6 +342,8 @@ int ec_burst_disable(void)
 
 EXPORT_SYMBOL(ec_burst_disable);
 
+#endif  /*  0  */
+
 int ec_read(u8 addr, u8 * val)
 {
 	int err;
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 4893e25..eda0978 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -36,8 +36,6 @@ int register_acpi_bus_type(struct acpi_bus_type *type)
 	return -ENODEV;
 }
 
-EXPORT_SYMBOL(register_acpi_bus_type);
-
 int unregister_acpi_bus_type(struct acpi_bus_type *type)
 {
 	if (acpi_disabled)
@@ -53,8 +51,6 @@ int unregister_acpi_bus_type(struct acpi_bus_type *type)
 	return -ENODEV;
 }
 
-EXPORT_SYMBOL(unregister_acpi_bus_type);
-
 static struct acpi_bus_type *acpi_get_bus_type(struct bus_type *type)
 {
 	struct acpi_bus_type *tmp, *ret = NULL;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index aabc6ca..d24e977 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -176,8 +176,6 @@ void acpi_os_printf(const char *fmt, ...)
 	va_end(args);
 }
 
-EXPORT_SYMBOL(acpi_os_printf);
-
 void acpi_os_vprintf(const char *fmt, va_list args)
 {
 	static char buffer[512];
@@ -341,8 +339,6 @@ void acpi_os_sleep(acpi_integer ms)
 	schedule_timeout_interruptible(msecs_to_jiffies(ms));
 }
 
-EXPORT_SYMBOL(acpi_os_sleep);
-
 void acpi_os_stall(u32 us)
 {
 	while (us) {
@@ -356,8 +352,6 @@ void acpi_os_stall(u32 us)
 	}
 }
 
-EXPORT_SYMBOL(acpi_os_stall);
-
 /*
  * Support ACPI 3.0 AML Timer operand
  * Returns 64-bit free-running, monotonically increasing timer
@@ -514,8 +508,6 @@ acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 	return (result ? AE_ERROR : AE_OK);
 }
 
-EXPORT_SYMBOL(acpi_os_read_pci_configuration);
-
 acpi_status
 acpi_os_write_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 				acpi_integer value, u32 width)
@@ -757,8 +749,6 @@ acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
 	return AE_OK;
 }
 
-EXPORT_SYMBOL(acpi_os_create_semaphore);
-
 /*
  * TODO: A better way to delete semaphores?  Linux doesn't have a
  * 'delete_semaphore()' function -- may result in an invalid
@@ -782,8 +772,6 @@ acpi_status acpi_os_delete_semaphore(acpi_handle handle)
 	return AE_OK;
 }
 
-EXPORT_SYMBOL(acpi_os_delete_semaphore);
-
 /*
  * TODO: The kernel doesn't have a 'down_timeout' function -- had to
  * improvise.  The process is to sleep for one scheduler quantum
@@ -876,8 +864,6 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 	return status;
 }
 
-EXPORT_SYMBOL(acpi_os_wait_semaphore);
-
 /*
  * TODO: Support for units > 1?
  */
@@ -900,8 +886,6 @@ acpi_status acpi_os_signal_semaphore(acpi_handle handle, u32 units)
 	return AE_OK;
 }
 
-EXPORT_SYMBOL(acpi_os_signal_semaphore);
-
 #ifdef ACPI_FUTURE_USAGE
 u32 acpi_os_get_line(char *buffer)
 {
@@ -945,8 +929,6 @@ acpi_status acpi_os_signal(u32 function, void *info)
 	return AE_OK;
 }
 
-EXPORT_SYMBOL(acpi_os_signal);
-
 static int __init acpi_os_name_setup(char *str)
 {
 	char *p = acpi_os_name;
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 0289693..2a5782f 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -106,6 +106,57 @@ acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id)
 
 EXPORT_SYMBOL(acpi_get_pci_id);
 
+static int acpi_pci_unbind(struct acpi_device *device)
+{
+	int result = 0;
+	acpi_status status = AE_OK;
+	struct acpi_pci_data *data = NULL;
+	char *pathname = NULL;
+	struct acpi_buffer buffer = { 0, NULL };
+
+
+	if (!device || !device->parent)
+		return -EINVAL;
+
+	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
+	if (!pathname)
+		return -ENOMEM;
+
+	buffer.length = ACPI_PATHNAME_MAX;
+	buffer.pointer = pathname;
+	acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
+			  pathname));
+	kfree(pathname);
+
+	status =
+	    acpi_get_data(device->handle, acpi_pci_data_handler,
+			  (void **)&data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Unable to get data from device %s",
+				acpi_device_bid(device)));
+		result = -ENODEV;
+		goto end;
+	}
+
+	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Unable to detach data from device %s",
+				acpi_device_bid(device)));
+		result = -ENODEV;
+		goto end;
+	}
+	if (data->dev->subordinate) {
+		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
+	}
+	kfree(data);
+
+      end:
+	return result;
+}
+
 int acpi_pci_bind(struct acpi_device *device)
 {
 	int result = 0;
@@ -267,57 +318,6 @@ int acpi_pci_bind(struct acpi_device *device)
 	return result;
 }
 
-int acpi_pci_unbind(struct acpi_device *device)
-{
-	int result = 0;
-	acpi_status status = AE_OK;
-	struct acpi_pci_data *data = NULL;
-	char *pathname = NULL;
-	struct acpi_buffer buffer = { 0, NULL };
-
-
-	if (!device || !device->parent)
-		return -EINVAL;
-
-	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
-	if (!pathname)
-		return -ENOMEM;
-
-	buffer.length = ACPI_PATHNAME_MAX;
-	buffer.pointer = pathname;
-	acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
-			  pathname));
-	kfree(pathname);
-
-	status =
-	    acpi_get_data(device->handle, acpi_pci_data_handler,
-			  (void **)&data);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to get data from device %s",
-				acpi_device_bid(device)));
-		result = -ENODEV;
-		goto end;
-	}
-
-	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to detach data from device %s",
-				acpi_device_bid(device)));
-		result = -ENODEV;
-		goto end;
-	}
-	if (data->dev->subordinate) {
-		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
-	}
-	kfree(data);
-
-      end:
-	return result;
-}
-
 int
 acpi_pci_bind_root(struct acpi_device *device,
 		   struct acpi_pci_id *id, struct pci_bus *bus)
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index dd3186a..b10a3e6 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -469,8 +469,6 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	return 0;
 }
 
-EXPORT_SYMBOL(acpi_pci_irq_enable);
-
 /* FIXME: implement x86/x86_64 version */
 void __attribute__ ((weak)) acpi_unregister_gsi(u32 i)
 {
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index c9f526e..73c20a5 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -95,7 +95,7 @@ static struct {
 	int count;
 	struct list_head entries;
 } acpi_link;
-DEFINE_MUTEX(acpi_link_lock);
+static DEFINE_MUTEX(acpi_link_lock);
 
 /* --------------------------------------------------------------------------
                             PCI Link Device Management
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 90fd09c..6482502 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -865,7 +865,7 @@ static void acpi_charger_remove(struct acpi_sbs *sbs)
 #endif
 }
 
-void acpi_sbs_callback(void *context)
+static void acpi_sbs_callback(void *context)
 {
 	int id;
 	struct acpi_sbs *sbs = context;
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index 046d7c3..152334d 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -111,8 +111,8 @@ static int wait_transaction_complete(struct acpi_smb_hc *hc, int timeout)
 		return -ETIME;
 }
 
-int acpi_smbus_transaction(struct acpi_smb_hc *hc, u8 protocol, u8 address,
-		    u8 command, u8 *data, u8 length)
+static int acpi_smbus_transaction(struct acpi_smb_hc *hc, u8 protocol,
+				  u8 address, u8 command, u8 *data, u8 length)
 {
 	int ret = -EFAULT, i;
 	u8 temp, sz = 0;
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index f3d3867..ccfcaa7 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -28,7 +28,7 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 #endif
 
-int acpi_sleep_prepare(u32 acpi_state)
+static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
 	/* do we have a wakeup address for S2 and S3? */
diff --git a/drivers/acpi/sleep/sleep.h b/drivers/acpi/sleep/sleep.h
index a2ea125..bf49d62 100644
--- a/drivers/acpi/sleep/sleep.h
+++ b/drivers/acpi/sleep/sleep.h
@@ -6,4 +6,3 @@ extern void acpi_enable_wakeup_device_prep(u8 sleep_state);
 extern void acpi_enable_wakeup_device(u8 sleep_state);
 extern void acpi_disable_wakeup_device(u8 sleep_state);
 
-extern int acpi_sleep_prepare(u32 acpi_state);
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f85f77a..a77196b 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -73,7 +73,6 @@ struct pci_bus;
 
 acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
 int acpi_pci_bind(struct acpi_device *device);
-int acpi_pci_unbind(struct acpi_device *device);
 int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
 		       struct pci_bus *bus);
 
cfbab8d33a3cf9a9f4a310cde37448d2db15cf8e 
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index ab04d84..44a2d85 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -78,6 +78,7 @@ int acpi_map_pxm_to_node(int pxm)
 	return node;
 }
 
+#if 0
 void __cpuinit acpi_unmap_pxm_to_node(int node)
 {
 	int pxm = node_to_pxm_map[node];
@@ -85,6 +86,7 @@ void __cpuinit acpi_unmap_pxm_to_node(int node)
 	node_to_pxm_map[node] = PXM_INVAL;
 	node_clear(node, nodes_found_map);
 }
+#endif  /*  0  */
 
 static void __init
 acpi_table_print_srat_entry(struct acpi_subtable_header *header)
@@ -247,7 +249,6 @@ int acpi_get_pxm(acpi_handle h)
 	} while (ACPI_SUCCESS(status));
 	return -1;
 }
-EXPORT_SYMBOL(acpi_get_pxm);
 
 int acpi_get_node(acpi_handle *handle)
 {
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
index 62c5ee4..1739726 100644
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -15,7 +15,6 @@ extern int pxm_to_node(int);
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
-extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */

