Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0BBHwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:33 -0500
Received: from iksaif.net ([88.191.73.63]:50262 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab0BBHwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:11 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 16/28] asus-laptop: rename function talking directly to acpi with asus_xxx scheme
Date: Tue,  2 Feb 2010 08:38:59 +0100
Message-Id: <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   38 ++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 2349e88..ae4f808 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -394,7 +394,7 @@ ASUS_LED_HANDLER(gled, GLED_ON);
 /*
  * Keyboard backlight (also a LED)
  */
-static int get_kled_lvl(void)
+static int asus_kled_lvl(void)
 {
 	unsigned long long kblv;
 	struct acpi_object_list params;
@@ -409,12 +409,12 @@ static int get_kled_lvl(void)
 	rv = acpi_evaluate_integer(kled_get_handle, NULL, &params, &kblv);
 	if (ACPI_FAILURE(rv)) {
 		pr_warning("Error reading kled level\n");
-		return 0;
+		return -ENODEV;
 	}
 	return kblv;
 }
 
-static int set_kled_lvl(struct asus_laptop *asus, int kblv)
+static int asus_kled_set(struct asus_laptop *asus, int kblv)
 {
 	if (kblv > 0)
 		kblv = (1 << 7) | (kblv & 0x7F);
@@ -441,12 +441,12 @@ static void kled_led_update(struct work_struct *work)
 {
 	struct asus_laptop *asus = work_to_asus(work, kled);
 
-	set_kled_lvl(asus, asus->leds.kled_wk);
+	asus_kled_set(asus, asus->leds.kled_wk);
 }
 
 static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
 {
-	return get_kled_lvl();
+	return asus_kled_lvl();
 }
 
 #define ASUS_LED_UNREGISTER(object)				\
@@ -555,7 +555,7 @@ static void lcd_blank(struct asus_laptop *asus, int blank)
 	}
 }
 
-static int read_brightness(struct backlight_device *bd)
+static int asus_read_brightness(struct backlight_device *bd)
 {
 	unsigned long long value;
 	acpi_status rv = AE_OK;
@@ -567,7 +567,7 @@ static int read_brightness(struct backlight_device *bd)
 	return value;
 }
 
-static int set_brightness(struct backlight_device *bd, int value)
+static int asus_set_brightness(struct backlight_device *bd, int value)
 {
 	if (write_acpi_int(brightness_set_handle, NULL, value)) {
 		pr_warning("Error changing brightness\n");
@@ -582,7 +582,7 @@ static int update_bl_status(struct backlight_device *bd)
 	int rv;
 	int value = bd->props.brightness;
 
-	rv = set_brightness(bd, value);
+	rv = asus_set_brightness(bd, value);
 	if (rv)
 		return rv;
 
@@ -591,7 +591,7 @@ static int update_bl_status(struct backlight_device *bd)
 }
 
 static struct backlight_ops asusbl_ops = {
-	.get_brightness = read_brightness,
+	.get_brightness = asus_read_brightness,
 	.update_status = update_bl_status,
 };
 
@@ -612,7 +612,7 @@ static int asus_backlight_init(struct asus_laptop *asus)
 		asus->backlight_device = bd;
 
 		bd->props.max_brightness = 15;
-		bd->props.brightness = read_brightness(NULL);
+		bd->props.brightness = asus_read_brightness(NULL);
 		bd->props.power = FB_BLANK_UNBLANK;
 		backlight_update_status(bd);
 	}
@@ -818,7 +818,7 @@ static ssize_t store_bluetooth(struct device *dev,
 /*
  * Display
  */
-static void set_display(struct asus_laptop *asus, int value)
+static void asus_set_display(struct asus_laptop *asus, int value)
 {
 	/* no sanity check needed for now */
 	if (write_acpi_int(display_set_handle, NULL, value))
@@ -874,14 +874,14 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0)
-		set_display(asus, value);
+		asus_set_display(asus, value);
 	return rv;
 }
 
 /*
  * Light Sens
  */
-static void set_light_sens_switch(struct asus_laptop *asus, int value)
+static void asus_als_switch(struct asus_laptop *asus, int value)
 {
 	if (write_acpi_int(ls_switch_handle, NULL, value))
 		pr_warning("Error setting light sensor switch\n");
@@ -904,12 +904,12 @@ static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0)
-		set_light_sens_switch(asus, value ? 1 : 0);
+		asus_als_switch(asus, value ? 1 : 0);
 
 	return rv;
 }
 
-static void set_light_sens_level(struct asus_laptop *asus, int value)
+static void asus_als_level(struct asus_laptop *asus, int value)
 {
 	if (write_acpi_int(ls_level_handle, NULL, value))
 		pr_warning("Error setting light sensor level\n");
@@ -934,7 +934,7 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 	if (rv > 0) {
 		value = (0 < value) ? ((15 < value) ? 15 : value) : 0;
 		/* 0 <= value <= 15 */
-		set_light_sens_level(asus, value);
+		asus_als_level(asus, value);
 	}
 
 	return rv;
@@ -1419,7 +1419,7 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 
 	/* Keyboard Backlight is on by default */
 	if (kled_set_handle)
-		set_kled_lvl(asus, 1);
+		asus_kled_set(asus, 1);
 
 	/* LED display is off by default */
 	asus->ledd_status = 0xFFF;
@@ -1429,10 +1429,10 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (ls_switch_handle)
-		set_light_sens_switch(asus, asus->light_switch);
+		asus_als_switch(asus, asus->light_switch);
 
 	if (ls_level_handle)
-		set_light_sens_level(asus, asus->light_level);
+		asus_als_level(asus, asus->light_level);
 
 	/* GPS is on by default */
 	asus_gps_switch(asus, 1);
-- 
1.6.6.1

