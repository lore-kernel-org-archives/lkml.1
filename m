Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbYJYKnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbYJYKnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYJYKm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:42:58 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:61066 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYJYKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:42:57 -0400
X-Greylist: delayed 4187 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 06:42:57 EDT
Message-ID: <4902E7C7.9010607@euromail.se>
Date: Sat, 25 Oct 2008 11:32:55 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: akpm@osdl.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for Macbook Pro 5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer, backlight and temperature sensor
support for the new unibody Macbook Pro 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 074f7f4..9f04283 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -121,6 +121,10 @@ static const char* temperature_sensors_sets[][36] = {
 /* Set 11: Macbook 5,1 */
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0P", "TN0D", "TN0P",
 	  "TTF0", "Th0H", "Th1H", "ThFH", "Ts0P", "Ts0S", NULL },
+/* Set 12: Macbook Pro 5,1 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
+	  "TG0F", "TG0H", "TG0P", "TG0T", "TG1H", "TN0D", "TN0P", "TTF0",
+	  "Th2H", "Tm0P", "Ts0P", "Ts0S", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1285,6 +1289,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
 /* MacBook 5: accelerometer, backlight and temperature set 11 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
+/* MacBook Pro 5: accelerometer, backlight and temperature set 12 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1294,6 +1300,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },
+		&applesmc_dmi_data[12]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
-- 
1.5.6.3



