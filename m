Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZKWN1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZKWN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZKWN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:27:30 -0500
Received: from smtp.nokia.com ([192.100.122.230]:39943 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZKWN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:27:29 -0500
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
In-Reply-To: <20091120112812.GC20236@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com>
	 <20091118133938.GE6592@rakim.wolfsonmicro.main>
	 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
	 <20091118144145.GA16852@rakim.wolfsonmicro.main>
	 <4B04EDE8.1010906@nokia.com>
	 <20091119092412.GA4696@codecarver.research.nokia.com>
	 <20091119103054.GC9763@rakim.wolfsonmicro.main>
	 <20091120100633.GE3733@sortiz.org> <1258713145.3640.11.camel@odin>
	 <20091120112812.GC20236@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 15:26:28 +0200
Message-ID: <1258982788.24901.171.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2009 13:26:46.0121 (UTC) FILETIME=[9A9DA590:01CA6C40]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl4030-mfd: Add all TWL regulators to RegFW

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Acked-by: Mark Brown <broonie@opensource.wolfonmicro.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/twl4030-core.c            |   26 ++++++++++++++++++++++++--
 drivers/regulator/twl4030-regulator.c |   26 +++++++++++++++++---------
 include/linux/i2c/twl4030.h           |    8 ++++++--
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 0ee81e4..2d659e6 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -572,11 +572,21 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	}
 
 	if (twl_has_regulator()) {
-		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
-		*/
+
+		child = add_regulator(TWL4030_REG_VIO, pdata->vio);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VDD1, pdata->vdd1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VDD2, pdata->vdd2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
 
 		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
 		if (IS_ERR(child))
@@ -592,6 +602,18 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 				pdata->vaux2);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VINTANA1, pdata->vintana1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VINTANA2, pdata->vintana2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VINTDIG, pdata->vintdig);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
 	}
 
 	if (twl_has_regulator() && usb_transceiver) {
diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index e2032fb..edd1a1f 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -260,6 +260,18 @@ static const u16 VSIM_VSEL_table[] = {
 static const u16 VDAC_VSEL_table[] = {
 	1200, 1300, 1800, 1800,
 };
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
@@ -397,20 +409,16 @@ static struct twlreg_info twl4030_regs[] = {
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
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index c188961..bf143d8 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -440,8 +440,12 @@ struct twl4030_platform_data {
 	struct regulator_init_data		*vaux2;
 	struct regulator_init_data		*vaux3;
 	struct regulator_init_data		*vaux4;
-
-	/* REVISIT more to come ... _nothing_ should be hard-wired */
+	struct regulator_init_data		*vio;
+	struct regulator_init_data		*vdd1;
+	struct regulator_init_data		*vdd2;
+	struct regulator_init_data		*vintana1;
+	struct regulator_init_data		*vintana2;
+	struct regulator_init_data		*vintdig;
 };
 
 /*----------------------------------------------------------------------*/
-- 
1.6.3.3


