Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYJVQTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYJVQTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYJVQTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:19:23 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:47811 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbYJVQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:19:22 -0400
Message-ID: <48FF522E.1070209@euromail.se>
Date: Wed, 22 Oct 2008 18:17:50 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: akpm@osdl.org, Nicolas Boichat <nicolas@boichat.ch>,
       lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwmon: applesmc: Add support for Macbook 5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KsgQ6-0006nt-3O.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KsgQ6-0006nt-3O a1b0857a32a79f9a1e77bad364a07be9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer, backlight and temperature sensor
support for the new unibody Macbook 5.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: David M. Lary <dmlary@gmail.com>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 80d545d..074f7f4 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -118,6 +118,9 @@ static const char* temperature_sensors_sets[][36] = {
 	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
 /* Set 10: iMac 5,1 */
 	{ "TA0P", "TC0D", "TC0P", "TG0D", "TH0P", "TO0P", "Tm0P", NULL },
+/* Set 11: Macbook 5,1 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0P", "TN0D", "TN0P",
+	  "TTF0", "Th0H", "Th1H", "ThFH", "Ts0P", "Ts0S", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1280,6 +1283,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 9 },
 /* iMac 5: light sensor only, temperature set 10 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 10 },
+/* MacBook 5: accelerometer, backlight and temperature set 11 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1309,6 +1314,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
 		&applesmc_dmi_data[6]},
+	{ applesmc_dmi_match, "Apple MacBook 5", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5") },
+		&applesmc_dmi_data[11]},
 	{ applesmc_dmi_match, "Apple MacBook", {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
-- 
1.5.6.3

