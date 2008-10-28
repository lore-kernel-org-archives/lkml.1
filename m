Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYJ1VN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYJ1VN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYJ1VNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:13:50 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49452 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYJ1VNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:13:50 -0400
Message-ID: <49078047.6040300@euromail.se>
Date: Tue, 28 Oct 2008 22:12:39 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: applesmc: Add support for iMac 8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1Kuvsm-0006yM-3z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Kuvsm-0006yM-3z 99bf8ca8fa21bd7fc5db0fa94c3ccb65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature sensor support for iMac 8.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Klaus Doblmann <klaus.doblmann@gmail.com>
---
 drivers/hwmon/applesmc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 9f04283..be32859 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -125,6 +125,9 @@ static const char* temperature_sensors_sets[][36] = {
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
 	  "TG0F", "TG0H", "TG0P", "TG0T", "TG1H", "TN0D", "TN0P", "TTF0",
 	  "Th2H", "Tm0P", "Ts0P", "Ts0S", NULL },
+/* Set 13: iMac 8,1 */
+	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
+	  "TL0P", "TO0P", "TW0P", "Tm0P", "Tp0P", NULL },
 };

 /* List of keys used to read/write fan speeds */
@@ -1291,6 +1294,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 11 },
 /* MacBook Pro 5: accelerometer, backlight and temperature set 12 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 12 },
+/* iMac 8: light sensor only, temperature set 13 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 13 },
 };

 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1340,6 +1345,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple iMac 8", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
+		&applesmc_dmi_data[13]},
 	{ applesmc_dmi_match, "Apple iMac 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac5") },
-- 
1.5.6.3

