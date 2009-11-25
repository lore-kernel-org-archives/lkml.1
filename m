Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZKYKFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZKYKFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbZKYKFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:05:52 -0500
Received: from smtp.nokia.com ([192.100.122.233]:19373 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573AbZKYKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:05:50 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCHv2 1/3] twl4030-regulator: Add all TWL regulators to twreg_info
Date: Wed, 25 Nov 2009 12:04:53 +0200
Message-Id: <1259143495-9480-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-OriginalArrivalTime: 25 Nov 2009 10:05:03.0684 (UTC) FILETIME=[C1D3D040:01CA6DB6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define all twl4030 regulators in the twlreg_info table, along with
appropriate VSEL tables for adjustable regulators

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/regulator/twl4030-regulator.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 9365140..75da6af 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -260,7 +260,18 @@ static const u16 VSIM_VSEL_table[] = {
 static const u16 VDAC_VSEL_table[] = {
 	1200, 1300, 1800, 1800,
 };
-
+static const u16 VDD1_VSEL_table[] = {
+	800, 1450,
+};
+static const u16 VDD2_VSEL_table[] = {
+	800, 1450, 1500,
+};
+static const u16 VIO_VSEL_table[] = {
+	1800, 1850,
+};
+static const u16 VINTANA2_VSEL_table[] = {
+	2500, 2750,
+};
 
 static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
@@ -390,27 +401,19 @@ static struct regulator_ops twl4030fixed_ops = {
  * software control over them after boot.
  */
 static struct twlreg_info twl4030_regs[] = {
-	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
-	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
 	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
 	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
 	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
-	/*
 	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
-	*/
 	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
 	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9),
 	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
-	/*
-	TWL_ADJUSTABLE_LDO(VINTANA1, 0x3f, 11),
+	TWL_FIXED_LDO(VINTANA1, 0x3f, 1500, 11),
 	TWL_ADJUSTABLE_LDO(VINTANA2, 0x43, 12),
-	TWL_ADJUSTABLE_LDO(VINTDIG, 0x47, 13),
-	TWL_SMPS(VIO, 0x4b, 14),
-	TWL_SMPS(VDD1, 0x55, 15),
-	TWL_SMPS(VDD2, 0x63, 16),
-	 */
+	TWL_FIXED_LDO(VINTDIG, 0x47, 1500, 13),
+	TWL_ADJUSTABLE_LDO(VIO, 0x4b, 14),
+	TWL_ADJUSTABLE_LDO(VDD1, 0x55, 15),
+	TWL_ADJUSTABLE_LDO(VDD2, 0x63, 16),
 	TWL_FIXED_LDO(VUSB1V5, 0x71, 1500, 17),
 	TWL_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
 	TWL_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
-- 
1.6.3.3

