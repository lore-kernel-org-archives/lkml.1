Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbZHGPaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbZHGPaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZHGP3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:29:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59006 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZHGP3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:29:51 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH 8/8] Regulator: Added board-dependent code for TPS65073
Date: Fri,  7 Aug 2009 20:59:34 +0530
Message-Id: <1249658974-11151-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added OMAP35x specific code for TPS65073 in board-omap35x-pmic.c

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 arch/arm/mach-omap2/board-omap35x-pmic.c |   95 +++++++++++++++++++++++++++++-
 1 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap35x-pmic.c b/arch/arm/mach-omap2/board-omap35x-pmic.c
index 0bf47fd..2c33965 100644
--- a/arch/arm/mach-omap2/board-omap35x-pmic.c
+++ b/arch/arm/mach-omap2/board-omap35x-pmic.c
@@ -124,6 +124,98 @@ static struct i2c_board_info __initdata board_tps65023_instances[] = {
 /*
  * Definitions specific to TPS65073
  */
+#if defined(CONFIG_OMAP3EVM_TPS65073)
+/* MPU voltage regulator of DCDC type */
+struct regulator_consumer_supply tps65073_mpu_consumers = {
+	.supply = "vdd1",
+};
+
+/* CORE voltage regulator of DCDC type */
+struct regulator_consumer_supply tps65073_core_consumers = {
+	.supply = "vdd2",
+};
+
+/* SRAM/MEM/WKUP_BG/VDDS voltage regulator of DCDC type */
+struct regulator_consumer_supply tps65073_vdds_consumers = {
+	.supply = "vdds",
+};
+
+/* DPLL voltage regulator of LDO type */
+struct regulator_consumer_supply tps65073_dpll_consumers = {
+	.supply = "dpll",
+};
+
+/* MMC voltage regulator of LDO type */
+struct regulator_consumer_supply tps65073_mmc_consumers = {
+	.supply = "mmc",
+};
+
+struct regulator_init_data tps65073_regulator_data[] = {
+	{
+		.constraints = {
+			.min_uV = 725000,
+			.max_uV = 3300000,
+			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS),
+			.boot_on = 1,
+		},
+		.num_consumer_supplies = 1,
+		.consumer_supplies = &tps65073_vdds_consumers,
+	},
+	{
+		.constraints = {
+			.min_uV = 725000,
+			.max_uV = 3300000,
+			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS),
+			.boot_on = 1,
+		},
+		.num_consumer_supplies = 1,
+		.consumer_supplies = &tps65073_core_consumers,
+	},
+	{
+		.constraints = {
+			.min_uV = 725000,
+			.max_uV = 3300000,
+			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS),
+			.boot_on = 1,
+		},
+		.num_consumer_supplies = 1,
+		.consumer_supplies = &tps65073_mpu_consumers,
+	},
+	{
+		.constraints = {
+			.min_uV = 1000000,
+			.max_uV = 3300000,
+			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS),
+			.boot_on = 1,
+		},
+		.num_consumer_supplies = 1,
+		.consumer_supplies = &tps65073_dpll_consumers,
+	},
+	{
+		.constraints = {
+			.min_uV = 725000,
+			.max_uV = 3300000,
+			.valid_ops_mask = (REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS),
+			.boot_on = 1,
+		},
+		.num_consumer_supplies = 1,
+		.consumer_supplies = &tps65073_mmc_consumers,
+	},
+};
+
+static struct i2c_board_info __initdata board_tps65073_instances[] = {
+	{
+		I2C_BOARD_INFO("tps6507x", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.platform_data = &tps65073_regulator_data[0],
+	},
+};
+#endif
 
 static int flag_pmic_twl4030;
 static int flag_pmic_tps6235x;
@@ -204,7 +296,8 @@ int oma35x_pmic_init(void)
 #endif
 
 #if defined(CONFIG_OMAP3EVM_TPS65073)
-	/* do stuff specific to TPS65073 */
+	omap_register_i2c_bus(1, 400, board_tps65073_instances,
+		ARRAY_SIZE(board_tps65073_instances));
 #endif
 
 	return 0;
-- 
1.6.2.4

