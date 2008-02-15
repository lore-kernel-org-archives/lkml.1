Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbYBOOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbYBOOUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYBOOUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:20:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42679 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755179AbYBOOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:20:18 -0500
Subject: [PATCH 2/4] Voltage and current regulator framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 14:12:29 +0000
Message-Id: <1203084749.3466.215.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator driver API :-

diff --git a/include/linux/regulator/regulator-drv.h b/include/linux/regulator/regulator-drv.h
new file mode 100644
index 0000000..3c9b398
--- /dev/null
+++ b/include/linux/regulator/regulator-drv.h
@@ -0,0 +1,119 @@
+/*
+ * regulator-drv.h -- SoC Regulator support.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Driver Interface.
+ */
+
+
+#ifndef __LINUX_REGULATOR_DRV_H_
+#define __LINUX_REGULATOR_DRV_H_
+
+#include <linux/device.h>
+#include <linux/regulator/regulator.h>
+
+struct regulator_constraints;
+struct regulator_cdev;
+
+/**
+ * struct regulator_ops - regulator operations.
+ *
+ * This struct describes regulator operations.
+ */
+struct regulator_ops {
+
+	/* get/set regulator voltage */
+	int (*set_voltage)(struct regulator_cdev *, int uV);
+	int (*get_voltage)(struct regulator_cdev *);
+
+	/* get/set regulator current  */
+	int (*set_current)(struct regulator_cdev *, int uA);
+	int (*get_current)(struct regulator_cdev *);
+
+	/* enable/disable regulator */
+	int (*enable)(struct regulator_cdev *);
+	int (*disable)(struct regulator_cdev *);
+	int (*is_enabled)(struct regulator_cdev *);
+
+	/* get/set regulator operating mode (defined in regulator.h) */
+	int (*set_mode)(struct regulator_cdev *, unsigned int mode);
+	unsigned int (*get_mode)(struct regulator_cdev *);
+
+	/* get most efficient regulator operating mode for load */
+	unsigned int (*get_optimum_mode)(struct regulator_cdev *, int input_uV,
+		int output_uV, int load_uA);
+};
+
+/*

