Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0BBHxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:53:49 -0500
Received: from iksaif.net ([88.191.73.63]:50271 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab0BBHwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:13 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 08/28] asus-laptop: revise names
Date: Tue,  2 Feb 2010 08:38:51 +0100
Message-Id: <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asus-laptop now does a lot more than just hotkeys.  Replace the "hotk"
names used throughout the driver with some slightly more appropriate
names.  The actual strings used in kernel messages and sysfs are left
unchanged.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  221 ++++++++++++++++++------------------
 1 files changed, 111 insertions(+), 110 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 8834405..2505f15 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -52,11 +52,11 @@
 
 #define ASUS_LAPTOP_VERSION	"0.42"
 
-#define ASUS_HOTK_NAME		"Asus Laptop Support"
-#define ASUS_HOTK_CLASS		"hotkey"
-#define ASUS_HOTK_DEVICE_NAME	"Hotkey"
-#define ASUS_HOTK_FILE		KBUILD_MODNAME
-#define ASUS_HOTK_PREFIX	"\\_SB.ATKD."
+#define ASUS_LAPTOP_NAME	"Asus Laptop Support"
+#define ASUS_LAPTOP_CLASS	"hotkey"
+#define ASUS_LAPTOP_DEVICE_NAME	"Hotkey"
+#define ASUS_LAPTOP_FILE	KBUILD_MODNAME
+#define ASUS_LAPTOP_PREFIX	"\\_SB.ATKD."
 
 
 /*
@@ -89,7 +89,7 @@
 #define KEY_ON		0x200	/* Keyboard backlight */
 
 MODULE_AUTHOR("Julien Lerouge, Karol Kozimor, Corentin Chary");
-MODULE_DESCRIPTION(ASUS_HOTK_NAME);
+MODULE_DESCRIPTION(ASUS_LAPTOP_NAME);
 MODULE_LICENSE("GPL");
 
 /*
@@ -124,27 +124,27 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 	static char *object##_paths[] = { paths }
 
 /* LED */
-ASUS_HANDLE(mled_set, ASUS_HOTK_PREFIX "MLED");
-ASUS_HANDLE(tled_set, ASUS_HOTK_PREFIX "TLED");
-ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");	/* W1JC */
-ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");	/* A7J */
-ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");	/* G1, G2 (probably) */
+ASUS_HANDLE(mled_set, ASUS_LAPTOP_PREFIX "MLED");
+ASUS_HANDLE(tled_set, ASUS_LAPTOP_PREFIX "TLED");
+ASUS_HANDLE(rled_set, ASUS_LAPTOP_PREFIX "RLED");	/* W1JC */
+ASUS_HANDLE(pled_set, ASUS_LAPTOP_PREFIX "PLED");	/* A7J */
+ASUS_HANDLE(gled_set, ASUS_LAPTOP_PREFIX "GLED");	/* G1, G2 (probably) */
 
 /* LEDD */
-ASUS_HANDLE(ledd_set, ASUS_HOTK_PREFIX "SLCM");
+ASUS_HANDLE(ledd_set, ASUS_LAPTOP_PREFIX "SLCM");
 
 /*
  * Bluetooth and WLAN
  * WLED and BLED are not handled like other XLED, because in some dsdt
  * they also control the WLAN/Bluetooth device.
  */
-ASUS_HANDLE(wl_switch, ASUS_HOTK_PREFIX "WLED");
-ASUS_HANDLE(bt_switch, ASUS_HOTK_PREFIX "BLED");
-ASUS_HANDLE(wireless_status, ASUS_HOTK_PREFIX "RSTS");	/* All new models */
+ASUS_HANDLE(wl_switch, ASUS_LAPTOP_PREFIX "WLED");
+ASUS_HANDLE(bt_switch, ASUS_LAPTOP_PREFIX "BLED");
+ASUS_HANDLE(wireless_status, ASUS_LAPTOP_PREFIX "RSTS");	/* All new models */
 
 /* Brightness */
-ASUS_HANDLE(brightness_set, ASUS_HOTK_PREFIX "SPLV");
-ASUS_HANDLE(brightness_get, ASUS_HOTK_PREFIX "GPLV");
+ASUS_HANDLE(brightness_set, ASUS_LAPTOP_PREFIX "SPLV");
+ASUS_HANDLE(brightness_get, ASUS_LAPTOP_PREFIX "GPLV");
 
 /* Backlight */
 ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
@@ -157,7 +157,7 @@ ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
 	    "\\Q10");		/* A2x, L2D, L3D, M2E */
 
 /* Display */
-ASUS_HANDLE(display_set, ASUS_HOTK_PREFIX "SDSP");
+ASUS_HANDLE(display_set, ASUS_LAPTOP_PREFIX "SDSP");
 ASUS_HANDLE(display_get,
 	    /* A6B, A6K A6R A7D F3JM L4R M6R A3G M6A M6V VX-1 V6J V6V W3Z */
 	    "\\_SB.PCI0.P0P1.VGA.GETD",
@@ -182,24 +182,24 @@ ASUS_HANDLE(display_get,
 	    /* A3F A6F A3N A3L M6N W3N W6A */
 	    "\\SSTE");
 
-ASUS_HANDLE(ls_switch, ASUS_HOTK_PREFIX "ALSC"); /* Z71A Z71V */
-ASUS_HANDLE(ls_level, ASUS_HOTK_PREFIX "ALSL");	 /* Z71A Z71V */
+ASUS_HANDLE(ls_switch, ASUS_LAPTOP_PREFIX "ALSC"); /* Z71A Z71V */
+ASUS_HANDLE(ls_level, ASUS_LAPTOP_PREFIX "ALSL");	 /* Z71A Z71V */
 
 /* GPS */
 /* R2H use different handle for GPS on/off */
-ASUS_HANDLE(gps_on, ASUS_HOTK_PREFIX "SDON");	/* R2H */
-ASUS_HANDLE(gps_off, ASUS_HOTK_PREFIX "SDOF");	/* R2H */
-ASUS_HANDLE(gps_status, ASUS_HOTK_PREFIX "GPST");
+ASUS_HANDLE(gps_on, ASUS_LAPTOP_PREFIX "SDON");	/* R2H */
+ASUS_HANDLE(gps_off, ASUS_LAPTOP_PREFIX "SDOF");	/* R2H */
+ASUS_HANDLE(gps_status, ASUS_LAPTOP_PREFIX "GPST");
 
 /* Keyboard light */
-ASUS_HANDLE(kled_set, ASUS_HOTK_PREFIX "SLKB");
-ASUS_HANDLE(kled_get, ASUS_HOTK_PREFIX "GLKB");
+ASUS_HANDLE(kled_set, ASUS_LAPTOP_PREFIX "SLKB");
+ASUS_HANDLE(kled_get, ASUS_LAPTOP_PREFIX "GLKB");
 
 /*
  * This is the main structure, we can use it to store anything interesting
  * about the hotk device
  */
-struct asus_hotk {
+struct asus_laptop {
 	char *name;		/* laptop name */
 
 	struct platform_device *platform_device;
@@ -216,13 +216,13 @@ struct asus_hotk {
 
 /*
  * This header is made available to allow proper configuration given model,
- * revision number , ... this info cannot go in struct asus_hotk because it is
+ * revision number , ... this info cannot go in struct asus_laptop because it is
  * available before the hotk
  */
 static struct acpi_table_header *asus_info;
 
 /* The actual device the driver binds to */
-static struct asus_hotk *hotk;
+static struct asus_laptop *asus;
 
 /* The backlight device /sys/class/backlight */
 static struct backlight_device *asus_backlight_device;
@@ -353,7 +353,7 @@ static int read_wireless_status(int mask)
 	acpi_status rv = AE_OK;
 
 	if (!wireless_status_handle)
-		return (hotk->status & mask) ? 1 : 0;
+		return (asus->status & mask) ? 1 : 0;
 
 	rv = acpi_evaluate_integer(wireless_status_handle, NULL, NULL, &status);
 	if (ACPI_FAILURE(rv))
@@ -361,7 +361,7 @@ static int read_wireless_status(int mask)
 	else
 		return (status & mask) ? 1 : 0;
 
-	return (hotk->status & mask) ? 1 : 0;
+	return (asus->status & mask) ? 1 : 0;
 }
 
 static int read_gps_status(void)
@@ -375,7 +375,7 @@ static int read_gps_status(void)
 	else
 		return status ? 1 : 0;
 
-	return (hotk->status & GPS_ON) ? 1 : 0;
+	return (asus->status & GPS_ON) ? 1 : 0;
 }
 
 /* Generic LED functions */
@@ -387,12 +387,12 @@ static int read_status(int mask)
 	else if (mask == GPS_ON)
 		return read_gps_status();
 
-	return (hotk->status & mask) ? 1 : 0;
+	return (asus->status & mask) ? 1 : 0;
 }
 
 static void write_status(acpi_handle handle, int out, int mask)
 {
-	hotk->status = (out) ? (hotk->status | mask) : (hotk->status & ~mask);
+	asus->status = (out) ? (asus->status | mask) : (asus->status & ~mask);
 
 	switch (mask) {
 	case MLED_ON:
@@ -586,15 +586,15 @@ static ssize_t show_infos(struct device *dev,
 	 * to 1
 	 */
 
-	len += sprintf(page, ASUS_HOTK_NAME " " ASUS_LAPTOP_VERSION "\n");
-	len += sprintf(page + len, "Model reference    : %s\n", hotk->name);
+	len += sprintf(page, ASUS_LAPTOP_NAME " " ASUS_LAPTOP_VERSION "\n");
+	len += sprintf(page + len, "Model reference    : %s\n", asus->name);
 	/*
 	 * The SFUN method probably allows the original driver to get the list
 	 * of features supported by a given model. For now, 0x0100 or 0x0800
 	 * bit signifies that the laptop is equipped with a Wi-Fi MiniPCI card.
 	 * The significance of others is yet to be found.
 	 */
-	rv = acpi_evaluate_integer(hotk->handle, "SFUN", NULL, &temp);
+	rv = acpi_evaluate_integer(asus->handle, "SFUN", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
 		len += sprintf(page + len, "SFUN value         : %#x\n",
 			       (uint) temp);
@@ -604,7 +604,7 @@ static ssize_t show_infos(struct device *dev,
 	 * The significance of others is yet to be found.
 	 * If we don't find the method, we assume the device are present.
 	 */
-	rv = acpi_evaluate_integer(hotk->handle, "HRWS", NULL, &temp);
+	rv = acpi_evaluate_integer(asus->handle, "HRWS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
 		len += sprintf(page + len, "HRWS value         : %#x\n",
 			       (uint) temp);
@@ -615,7 +615,7 @@ static ssize_t show_infos(struct device *dev,
 	 * Note: since not all the laptops provide this method, errors are
 	 * silently ignored.
 	 */
-	rv = acpi_evaluate_integer(hotk->handle, "ASYM", NULL, &temp);
+	rv = acpi_evaluate_integer(asus->handle, "ASYM", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
 		len += sprintf(page + len, "ASYM value         : %#x\n",
 			       (uint) temp);
@@ -673,7 +673,7 @@ static ssize_t store_status(const char *buf, size_t count,
 static ssize_t show_ledd(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "0x%08x\n", hotk->ledd_status);
+	return sprintf(buf, "0x%08x\n", asus->ledd_status);
 }
 
 static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
@@ -686,7 +686,7 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 		if (write_acpi_int(ledd_set_handle, NULL, value))
 			pr_warning("LED display write failed\n");
 		else
-			hotk->ledd_status = (u32) value;
+			asus->ledd_status = (u32) value;
 	}
 	return rv;
 }
@@ -789,13 +789,13 @@ static void set_light_sens_switch(int value)
 {
 	if (write_acpi_int(ls_switch_handle, NULL, value))
 		pr_warning("Error setting light sensor switch\n");
-	hotk->light_switch = value;
+	asus->light_switch = value;
 }
 
 static ssize_t show_lssw(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", hotk->light_switch);
+	return sprintf(buf, "%d\n", asus->light_switch);
 }
 
 static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
@@ -814,13 +814,13 @@ static void set_light_sens_level(int value)
 {
 	if (write_acpi_int(ls_level_handle, NULL, value))
 		pr_warning("Error setting light sensor level\n");
-	hotk->light_level = value;
+	asus->light_level = value;
 }
 
 static ssize_t show_lslvl(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", hotk->light_level);
+	return sprintf(buf, "%d\n", asus->light_level);
 }
 
 static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
@@ -929,23 +929,23 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	}
 
 	/* TODO Find a better way to handle events count. */
-	count = hotk->event_count[event % 128]++;
-	acpi_bus_generate_proc_event(hotk->device, event, count);
-	acpi_bus_generate_netlink_event(hotk->device->pnp.device_class,
-					dev_name(&hotk->device->dev), event,
+	count = asus->event_count[event % 128]++;
+	acpi_bus_generate_proc_event(asus->device, event, count);
+	acpi_bus_generate_netlink_event(asus->device->pnp.device_class,
+					dev_name(&asus->device->dev), event,
 					count);
 
-	if (hotk->inputdev) {
+	if (asus->inputdev) {
 		key = asus_get_entry_by_scancode(event);
 		if (!key)
 			return ;
 
 		switch (key->type) {
 		case KE_KEY:
-			input_report_key(hotk->inputdev, key->keycode, 1);
-			input_sync(hotk->inputdev);
-			input_report_key(hotk->inputdev, key->keycode, 0);
-			input_sync(hotk->inputdev);
+			input_report_key(asus->inputdev, key->keycode, 1);
+			input_sync(asus->inputdev);
+			input_report_key(asus->inputdev, key->keycode, 0);
+			input_sync(asus->inputdev);
 			break;
 		}
 	}
@@ -996,42 +996,42 @@ static int asus_platform_init(void)
 {
 	int result;
 
-	hotk->platform_device = platform_device_alloc(ASUS_HOTK_FILE, -1);
-	if (!hotk->platform_device)
+	asus->platform_device = platform_device_alloc(ASUS_LAPTOP_FILE, -1);
+	if (!asus->platform_device)
 		return -ENOMEM;
 
-	result = platform_device_add(hotk->platform_device);
+	result = platform_device_add(asus->platform_device);
 	if (result)
 		goto fail_platform_device;
 
-	result = sysfs_create_group(&hotk->platform_device->dev.kobj,
+	result = sysfs_create_group(&asus->platform_device->dev.kobj,
 				    &platform_attribute_group);
 	if (result)
 		goto fail_sysfs;
 	return 0;
 
 fail_sysfs:
-	platform_device_del(hotk->platform_device);
+	platform_device_del(asus->platform_device);
 fail_platform_device:
-	platform_device_put(hotk->platform_device);
+	platform_device_put(asus->platform_device);
 	return result;
 }
 
 static void asus_platform_exit(void)
 {
-	sysfs_remove_group(&hotk->platform_device->dev.kobj,
+	sysfs_remove_group(&asus->platform_device->dev.kobj,
 			   &platform_attribute_group);
-	platform_device_unregister(hotk->platform_device);
+	platform_device_unregister(asus->platform_device);
 }
 
 static struct platform_driver platform_driver = {
 	.driver = {
-		   .name = ASUS_HOTK_FILE,
+		   .name = ASUS_LAPTOP_FILE,
 		   .owner = THIS_MODULE,
 		   }
 };
 
-static void asus_hotk_add_fs(void)
+static void asus_laptop_add_fs(void)
 {
 	ASUS_SET_DEVICE_ATTR(infos, 0444, show_infos, NULL);
 
@@ -1080,10 +1080,11 @@ static int asus_handle_init(char *name, acpi_handle * handle,
 			 ARRAY_SIZE(object##_paths))
 
 /*
- * This function is used to initialize the hotk with right values. In this
- * method, we can make all the detection we want, and modify the hotk struct
+ * This function is used to initialize the context with right values. In this
+ * method, we can make all the detection we want, and modify the asus_laptop
+ * struct
  */
-static int asus_hotk_get_info(void)
+static int asus_laptop_get_info(void)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *model = NULL;
@@ -1104,14 +1105,14 @@ static int asus_hotk_get_info(void)
 		pr_warning("Couldn't get the DSDT table header\n");
 
 	/* We have to write 0 on init this far for all ASUS models */
-	if (write_acpi_int_ret(hotk->handle, "INIT", 0, &buffer)) {
+	if (write_acpi_int_ret(asus->handle, "INIT", 0, &buffer)) {
 		pr_err("Hotkey initialization failed\n");
 		return -ENODEV;
 	}
 
 	/* This needs to be called for some laptops to init properly */
 	status =
-	    acpi_evaluate_integer(hotk->handle, "BSTS", NULL, &bsts_result);
+	    acpi_evaluate_integer(asus->handle, "BSTS", NULL, &bsts_result);
 	if (ACPI_FAILURE(status))
 		pr_warning("Error calling BSTS\n");
 	else if (bsts_result)
@@ -1119,7 +1120,7 @@ static int asus_hotk_get_info(void)
 		       (uint) bsts_result);
 
 	/* This too ... */
-	write_acpi_int(hotk->handle, "CWAP", wapf);
+	write_acpi_int(asus->handle, "CWAP", wapf);
 
 	/*
 	 * Try to match the object returned by INIT to the specific model.
@@ -1141,8 +1142,8 @@ static int asus_hotk_get_info(void)
 			break;
 		}
 	}
-	hotk->name = kstrdup(string, GFP_KERNEL);
-	if (!hotk->name)
+	asus->name = kstrdup(string, GFP_KERNEL);
+	if (!asus->name)
 		return -ENOMEM;
 
 	if (*string)
@@ -1166,7 +1167,7 @@ static int asus_hotk_get_info(void)
 	 * If we don't find the method, we assume the device are present.
 	 */
 	status =
-	    acpi_evaluate_integer(hotk->handle, "HRWS", NULL, &hwrs_result);
+	    acpi_evaluate_integer(asus->handle, "HRWS", NULL, &hwrs_result);
 	if (ACPI_FAILURE(status))
 		hwrs_result = WL_HWRS | BT_HWRS;
 
@@ -1206,30 +1207,30 @@ static int asus_input_init(struct device *dev)
 	const struct key_entry *key;
 	int result;
 
-	hotk->inputdev = input_allocate_device();
-	if (!hotk->inputdev) {
+	asus->inputdev = input_allocate_device();
+	if (!asus->inputdev) {
 		pr_info("Unable to allocate input device\n");
 		return 0;
 	}
-	hotk->inputdev->name = "Asus Laptop extra buttons";
-	hotk->inputdev->dev.parent = dev;
-	hotk->inputdev->phys = ASUS_HOTK_FILE "/input0";
-	hotk->inputdev->id.bustype = BUS_HOST;
-	hotk->inputdev->getkeycode = asus_getkeycode;
-	hotk->inputdev->setkeycode = asus_setkeycode;
+	asus->inputdev->name = "Asus Laptop extra buttons";
+	asus->inputdev->dev.parent = dev;
+	asus->inputdev->phys = ASUS_LAPTOP_FILE "/input0";
+	asus->inputdev->id.bustype = BUS_HOST;
+	asus->inputdev->getkeycode = asus_getkeycode;
+	asus->inputdev->setkeycode = asus_setkeycode;
 
 	for (key = asus_keymap; key->type != KE_END; key++) {
 		switch (key->type) {
 		case KE_KEY:
-			set_bit(EV_KEY, hotk->inputdev->evbit);
-			set_bit(key->keycode, hotk->inputdev->keybit);
+			set_bit(EV_KEY, asus->inputdev->evbit);
+			set_bit(key->keycode, asus->inputdev->keybit);
 			break;
 		}
 	}
-	result = input_register_device(hotk->inputdev);
+	result = input_register_device(asus->inputdev);
 	if (result) {
 		pr_info("Unable to register input device\n");
-		input_free_device(hotk->inputdev);
+		input_free_device(asus->inputdev);
 	}
 	return result;
 }
@@ -1257,8 +1258,8 @@ static void asus_led_exit(void)
 
 static void asus_input_exit(void)
 {
-	if (hotk->inputdev)
-		input_unregister_device(hotk->inputdev);
+	if (asus->inputdev)
+		input_unregister_device(asus->inputdev);
 }
 
 static int asus_backlight_init(struct device *dev)
@@ -1266,7 +1267,7 @@ static int asus_backlight_init(struct device *dev)
 	struct backlight_device *bd;
 
 	if (brightness_set_handle && lcd_switch_handle) {
-		bd = backlight_device_register(ASUS_HOTK_FILE, dev,
+		bd = backlight_device_register(ASUS_LAPTOP_FILE, dev,
 					       NULL, &asusbl_ops);
 		if (IS_ERR(bd)) {
 			pr_err("Could not register asus backlight device\n");
@@ -1354,19 +1355,19 @@ static int __devinit asus_acpi_init(struct acpi_device *device)
 {
 	int result = 0;
 
-	result = acpi_bus_get_status(hotk->device);
+	result = acpi_bus_get_status(asus->device);
 	if (result)
 		return result;
-	if (!hotk->device->status.present) {
+	if (!asus->device->status.present) {
 		pr_err("Hotkey device not present, aborting\n");
 		return -ENODEV;
 	}
 
-	result = asus_hotk_get_info();
+	result = asus_laptop_get_info();
 	if (result)
 		return result;
 
-	asus_hotk_add_fs();
+	asus_laptop_add_fs();
 
 	/* WLED and BLED are on by default */
 	write_status(bt_switch_handle, 1, BT_ON);
@@ -1384,17 +1385,17 @@ static int __devinit asus_acpi_init(struct acpi_device *device)
 		set_kled_lvl(1);
 
 	/* LED display is off by default */
-	hotk->ledd_status = 0xFFF;
+	asus->ledd_status = 0xFFF;
 
 	/* Set initial values of light sensor and level */
 	hotk->light_switch = 0;	/* Default to light sensor disabled */
 	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (ls_switch_handle)
-		set_light_sens_switch(hotk->light_switch);
+		set_light_sens_switch(asus->light_switch);
 
 	if (ls_level_handle)
-		set_light_sens_level(hotk->light_level);
+		set_light_sens_level(asus->light_level);
 
 	/* GPS is on by default */
 	write_status(NULL, 1, GPS_ON);
@@ -1407,14 +1408,14 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 
 	pr_notice("Asus Laptop Support version %s\n",
 		  ASUS_LAPTOP_VERSION);
-	hotk = kzalloc(sizeof(struct asus_hotk), GFP_KERNEL);
-	if (!hotk)
+	asus = kzalloc(sizeof(struct asus_laptop), GFP_KERNEL);
+	if (!asus)
 		return -ENOMEM;
-	hotk->handle = device->handle;
-	strcpy(acpi_device_name(device), ASUS_HOTK_DEVICE_NAME);
-	strcpy(acpi_device_class(device), ASUS_HOTK_CLASS);
-	device->driver_data = hotk;
-	hotk->device = device;
+	asus->handle = device->handle;
+	strcpy(acpi_device_name(device), ASUS_LAPTOP_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ASUS_LAPTOP_CLASS);
+	device->driver_data = asus;
+	asus->device = device;
 
 	result = asus_acpi_init(device);
 	if (result)
@@ -1429,17 +1430,17 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 		goto fail_platform;
 
 	if (!acpi_video_backlight_support()) {
-		result = asus_backlight_init(&hotk->platform_device->dev);
+		result = asus_backlight_init(&asus->platform_device->dev);
 		if (result)
 			goto fail_backlight;
 	} else
 		pr_info("Backlight controlled by ACPI video driver\n");
 
-	result = asus_input_init(&hotk->platform_device->dev);
+	result = asus_input_init(&asus->platform_device->dev);
 	if (result)
 		goto fail_input;
 
-	result = asus_led_init(&hotk->platform_device->dev);
+	result = asus_led_init(&asus->platform_device->dev);
 	if (result)
 		goto fail_led;
 
@@ -1453,8 +1454,8 @@ fail_input:
 fail_backlight:
 	asus_platform_exit();
 fail_platform:
-	kfree(hotk->name);
-	kfree(hotk);
+	kfree(asus->name);
+	kfree(asus);
 
 	return result;
 }
@@ -1466,8 +1467,8 @@ static int asus_acpi_remove(struct acpi_device *device, int type)
 	asus_input_exit();
 	asus_platform_exit();
 
-	kfree(hotk->name);
-	kfree(hotk);
+	kfree(asus->name);
+	kfree(asus);
 	return 0;
 }
 
@@ -1479,8 +1480,8 @@ static const struct acpi_device_id asus_device_ids[] = {
 MODULE_DEVICE_TABLE(acpi, asus_device_ids);
 
 static struct acpi_driver asus_acpi_driver = {
-	.name = ASUS_HOTK_NAME,
-	.class = ASUS_HOTK_CLASS,
+	.name = ASUS_LAPTOP_NAME,
+	.class = ASUS_LAPTOP_CLASS,
 	.owner = THIS_MODULE,
 	.ids = asus_device_ids,
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
-- 
1.6.6.1

