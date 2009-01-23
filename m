Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZAWWiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZAWWiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbZAWWh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:37:59 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43421 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZAWWh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:37:58 -0500
Message-ID: <497A46B6.4080808@vt.edu>
Date: Fri, 23 Jan 2009 17:37:42 -0500
From: Bharath Ramesh <bramesh@vt.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>, Nicolas Boichat <nicolas@boichat.ch>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for MacPro 3 temperature sensors
Content-Type: multipart/mixed;
 boundary="------------080007040102030908020101"
X-Mirapoint-Received-SPF: 198.82.161.56 authsmtp2.cc.vt.edu bramesh@vt.edu 2 pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080007040102030908020101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

MacPro 3 have more temperature sensors than the previous MacPro's also 
the sensor THTG has been removed. This patch add supports for the newer 
temperature sensors in the MacPro3.


I have tested this on the MacPro 3 that I have and I am able to read the 
sensors. If there is any thing else that needs to be check I will be 
more than happy to test it out.

Regards,

Bharath

--------------080007040102030908020101
Content-Type: text/plain;
 name="applesmc_macpro3_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="applesmc_macpro3_patch"

--- linux-2.6/drivers/hwmon/applesmc.c.orig	2009-01-23 17:22:30.000000000 -0500
+++ linux-2.6/drivers/hwmon/applesmc.c	2009-01-23 17:25:35.000000000 -0500
@@ -83,7 +83,7 @@
 /*
  * Temperature sensors keys (sp78 - 2 bytes).
  */
-static const char* temperature_sensors_sets[][36] = {
+static const char* temperature_sensors_sets[][41] = {
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
@@ -135,6 +135,13 @@ static const char* temperature_sensors_s
 	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TN0D", "TTF0",
 	  "TV0P", "TVFP", "TW0P", "Th0P", "Tp0P", "Tp1P", "TpFP", "Ts0P",
 	  "Ts0S", NULL },
+/* Set 16: Mac Pro 3,1 (2 x Quad-Core) */
+	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
+	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "TH0P", "TH1P",
+	  "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S", "TM1P",
+	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
+	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
+	  NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1153,6 +1160,16 @@ static SENSOR_DEVICE_ATTR(temp34_input, 
 					applesmc_show_temperature, NULL, 33);
 static SENSOR_DEVICE_ATTR(temp35_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 34);
+static SENSOR_DEVICE_ATTR(temp36_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 35);
+static SENSOR_DEVICE_ATTR(temp37_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 36);
+static SENSOR_DEVICE_ATTR(temp38_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 37);
+static SENSOR_DEVICE_ATTR(temp39_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 38);
+static SENSOR_DEVICE_ATTR(temp40_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 39);
 
 static struct attribute *temperature_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
@@ -1190,6 +1207,11 @@ static struct attribute *temperature_att
 	&sensor_dev_attr_temp33_input.dev_attr.attr,
 	&sensor_dev_attr_temp34_input.dev_attr.attr,
 	&sensor_dev_attr_temp35_input.dev_attr.attr,
+	&sensor_dev_attr_temp36_input.dev_attr.attr,
+	&sensor_dev_attr_temp37_input.dev_attr.attr,
+	&sensor_dev_attr_temp38_input.dev_attr.attr,
+	&sensor_dev_attr_temp39_input.dev_attr.attr,
+	&sensor_dev_attr_temp40_input.dev_attr.attr,
 	NULL
 };
 
@@ -1312,6 +1334,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
 /* MacBook Air 2,1: accelerometer, backlight and temperature set 15 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
+/* MacPro3,1: temperature set 16 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1369,6 +1393,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple MacPro3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro3") },
+		&applesmc_dmi_data[16]},
 	{ applesmc_dmi_match, "Apple MacPro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },

--------------080007040102030908020101--
