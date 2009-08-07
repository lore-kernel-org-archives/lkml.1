Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZHGP3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZHGP3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZHGP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:29:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51383 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZHGP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:29:41 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH 6/8] Regulator: Add board-omap35x-pmic.c to arch/arm/mach-omap2/
Date: Fri,  7 Aug 2009 20:59:26 +0530
Message-Id: <1249658966-11062-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added arch/arm/mach-omap2/board-omap35x-pmic.c file which will
have the board specific information for different regulators
and will do the regulator initialization depending on the one
which is available.

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 arch/arm/mach-omap2/board-omap35x-pmic.c |  121 ++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap35x-pmic.c

diff --git a/arch/arm/mach-omap2/board-omap35x-pmic.c b/arch/arm/mach-omap2/board-omap35x-pmic.c
new file mode 100644
index 0000000..11db66f
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap35x-pmic.c
@@ -0,0 +1,121 @@
+/*
+ * board-omap35x-pmic.c
+ *
+ * Board specific information for different regulators and platforms.
+ *
+ * Copyright (C) 2009 Texas Instrument Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <mach/common.h>
+
+/*
+ * Definitions specific to TWL4030
+ */
+
+/*
+ * Definitions specific to TPS6235x
+ */
+
+/*
+ * Definitions specific to TPS65023
+ */
+
+/*
+ * Definitions specific to TPS65073
+ */
+
+static int flag_pmic_twl4030;
+static int flag_pmic_tps6235x;
+static int flag_pmic_tps65023;
+static int flag_pmic_tps65073;
+
+/*
+ * Detect the current PMIC, set one of the flags
+ */
+static inline int detect_pmic(void)
+{
+#if defined(CONFIG_TWL4030_CORE)
+	flag_pmic_twl4030 = 1;
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS6235X)
+	flag_pmic_tps6235x = 1;
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS65023)
+	flag_pmic_tps65023 = 1;
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS65073)
+	flag_pmic_tps65073 = 1;
+#endif
+
+	return 0;
+}
+
+/* Functions to detect which PMIC is present */
+
+int pmic_is_twl4030(void)
+{
+	return flag_pmic_twl4030;
+}
+
+int pmic_is_tps6235x(void)
+{
+	return flag_pmic_tps6235x;
+}
+
+int pmic_is_tps65020(void) { return 0; }
+
+int pmic_is_tps65021(void) { return 0; }
+
+int pmic_is_tps65022(void) { return 0; }
+
+int pmic_is_tps65023(void)
+{
+	return flag_pmic_tps65023;
+}
+
+int pmic_is_tps65073(void)
+{
+	return flag_pmic_tps65073;
+}
+
+int pmic_is_tps65950(void)
+{
+	return flag_pmic_twl4030;
+}
+
+/* Detects the PMIC and initializes it accordingly */
+int oma35x_pmic_init(void)
+{
+#if defined(CONFIG_TWL4030_CORE)
+	/* do stuff specific to TWL4030 */
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS6235X)
+	/* do stuff specific to TPS62350 */
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS65023)
+	/* do stuff specific to TPS65023 */
+#endif
+
+#if defined(CONFIG_OMAP3EVM_TPS65073)
+	/* do stuff specific to TPS65073 */
+#endif
+
+	return 0;
+}
+
-- 
1.6.2.4

