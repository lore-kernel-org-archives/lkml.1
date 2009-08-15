Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZHOLe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZHOLe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZHOLez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:34:55 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:50865 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZHOLez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vduNZfdVyJPldfGiQa2qtRw6ppPaRsSqLTZ3BJAB8UjnpHBju8n0UUNiewphncrmYu
         IYUzjRzM7viwbTTDYJv/JD9e5vYaYQOPFGHboa778N4se2YWI9K39I0lbOpWYhBvUNDJ
         oA6TAh4F/w1EoQFi1Mn9GnGc5H/9Go8huiGZE=
Message-ID: <4A869D5A.60302@gmail.com>
Date: Sat, 15 Aug 2009 19:34:50 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 5/9] ARM: Add nuc950 specific file support for nuc950 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add nuc950.c support for nuc950 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/nuc950.c |   70 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc950.h |   28 ++++++++++++++++
 2 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/nuc950.c
 create mode 100644 arch/arm/mach-w90x900/nuc950.h

diff --git a/arch/arm/mach-w90x900/nuc950.c b/arch/arm/mach-w90x900/nuc950.c
new file mode 100644
index 0000000..60363db
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc950.c
@@ -0,0 +1,70 @@
+/*
+ * linux/arch/arm/mach-w90x900/nuc950.c
+ *
+ * Based on linux/arch/arm/plat-s3c24xx/s3c244x.c by Ben Dooks
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC950 cpu support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/serial_8250.h>
+#include <linux/delay.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/regs-serial.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-ebi.h>
+
+#include "cpu.h"
+
+/* define specific CPU platform device */
+
+static struct platform_device *nuc950_dev[] __initdata = {
+};
+
+/* define specific CPU platform io map */
+
+static struct map_desc nuc950evb_iodesc[] __initdata = {
+};
+
+/*Init NUC950 evb io*/
+
+void __init nuc950_map_io(void)
+{
+	nuc900_map_io(nuc950evb_iodesc, ARRAY_SIZE(nuc950evb_iodesc));
+}
+
+/*Init NUC950 clock*/
+
+void __init nuc950_init_clocks(void)
+{
+	nuc900_init_clocks();
+}
+
+/*Init NUC950 board info*/
+
+void __init nuc950_board_init(void)
+{
+	nuc900_board_init(nuc950_dev, ARRAY_SIZE(nuc950_dev));
+}
diff --git a/arch/arm/mach-w90x900/nuc950.h b/arch/arm/mach-w90x900/nuc950.h
new file mode 100644
index 0000000..d6e8fba
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc950.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-w90x900/nuc950.h
+ *
+ * Copyright (c) 2008 Nuvoton corporation
+ *
+ * Header file for NUC900 CPU support
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+struct map_desc;
+struct sys_timer;
+
+/* core initialisation functions */
+
+extern void w90x900_init_irq(void);
+extern struct sys_timer w90x900_timer;
+
+/* extern file from nuc950.c */
+
+extern void nuc950_board_init(void);
+extern void nuc950_init_clocks(void);
+extern void nuc950_map_io(void);
-- 
1.5.6.3

