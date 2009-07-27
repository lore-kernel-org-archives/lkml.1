Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZG0Nqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZG0Nqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZG0Nqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59116 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407AbZG0Nq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/22] mfd: Export ISEL values from WM831x core
Date: Mon, 27 Jul 2009 14:45:57 +0100
Message-Id: <1248702372-29534-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current settings which can be used with the WM831x current sinks
can't easily be mapped between register values and currents at run
time without a lookup table since the values scale logarithmically
to match the way the human eye interprets brightness. This lookup
table is inclided in the core since several drivers need to use it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c            |   64 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/regulator.h |   21 +++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/wm831x/regulator.h

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 33eaea2..49b7885 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -24,6 +24,70 @@
 #include <linux/mfd/wm831x/irq.h>
 #include <linux/mfd/wm831x/auxadc.h>
 #include <linux/mfd/wm831x/otp.h>
+#include <linux/mfd/wm831x/regulator.h>
+
+/* Current settings - values are 2*2^(reg_val/4) microamps.  These are
+ * exported since they are used by multiple drivers.
+ */
+int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL] = {
+	2,
+	2,
+	3,
+	3,
+	4,
+	5,
+	6,
+	7,
+	8,
+	10,
+	11,
+	13,
+	16,
+	19,
+	23,
+	27,
+	32,
+	38,
+	45,
+	54,
+	64,
+	76,
+	91,
+	108,
+	128,
+	152,
+	181,
+	215,
+	256,
+	304,
+	362,
+	431,
+	512,
+	609,
+	724,
+	861,
+	1024,
+	1218,
+	1448,
+	1722,
+	2048,
+	2435,
+	2896,
+	3444,
+	4096,
+	4871,
+	5793,
+	6889,
+	8192,
+	9742,
+	11585,
+	13777,
+	16384,
+	19484,
+	23170,
+	27554,
+};
+EXPORT_SYMBOL_GPL(wm831x_isinkv_values);
 
 enum wm831x_parent {
 	WM8310 = 0,
diff --git a/include/linux/mfd/wm831x/regulator.h b/include/linux/mfd/wm831x/regulator.h
new file mode 100644
index 0000000..b5d58fb
--- /dev/null
+++ b/include/linux/mfd/wm831x/regulator.h
@@ -0,0 +1,21 @@
+/*
+ * linux/mfd/wm831x/regulator.h -- Regulator definitons for wm831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_REGULATOR_H__
+#define __MFD_WM831X_REGULATOR_H__
+
+#define WM831X_ISINK_MAX_ISEL 56
+extern int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL];
+
+#endif
-- 
1.6.3.3

