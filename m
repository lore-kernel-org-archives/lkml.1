Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZHRLKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZHRLKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbZHRLKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:10:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:23148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759AbZHRLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=C8t+mHTVvf5KAojOR0Lli138UiVpt/VbzuqyAuJRfZV+4YDBGCFO+YN0e5Dqyoi0Gr
         0sDEog5riKNPKMtD0jQxgoVqjWrU77jpyQBHFMWmRQEVj96884zTxwQojR3oMlHTu3S8
         TBhlI18m+Ivkc+FzuPz1R0yjcLa780HRX8TME=
Message-ID: <4A8A8BFE.1000709@gmail.com>
Date: Tue, 18 Aug 2009 19:09:50 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 3/3] ARM: Add nuc960 paltform files to w90x900 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add nuc960 paltform files to w90x900 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/Kconfig          |   15 +++++++++
 arch/arm/mach-w90x900/Makefile         |    2 +
 arch/arm/mach-w90x900/mach-nuc960evb.c |   44 ++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc960.c         |   54 ++++++++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc960.h         |   28 ++++++++++++++++
 5 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/mach-nuc960evb.c
 create mode 100644 arch/arm/mach-w90x900/nuc960.c
 create mode 100644 arch/arm/mach-w90x900/nuc960.h

diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
index 163b801..69bab32 100644
--- a/arch/arm/mach-w90x900/Kconfig
+++ b/arch/arm/mach-w90x900/Kconfig
@@ -10,6 +10,11 @@ config CPU_NUC950
 	help
 	  Support for NUCP950 of Nuvoton NUC900 CPUs.
 
+config CPU_NUC960
+	bool
+	help
+	  Support for NUCP960 of Nuvoton NUC900 CPUs.
+
 menu "W90P910 Machines"
 
 config MACH_W90P910EVB
@@ -31,4 +36,14 @@ config MACH_W90P950EVB
 
 endmenu
 
+menu "NUC960 Machines"
+
+config MACH_W90N960EVB
+	bool "Nuvoton NUC960 Evaluation Board"
+	select CPU_NUC960
+	help
+	   Say Y here if you are using the Nuvoton NUC960EVB
+
+endmenu
+
 endif
diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index a4622b5..828c032 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -10,8 +10,10 @@ obj-y				+= clksel.o dev.o cpu.o
 
 obj-$(CONFIG_CPU_W90P910)	+= nuc910.o
 obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
+obj-$(CONFIG_CPU_NUC960)	+= nuc960.o
 
 # machine support
 
 obj-$(CONFIG_MACH_W90P910EVB)	+= mach-nuc910evb.o
 obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
+obj-$(CONFIG_MACH_W90N960EVB)	+= mach-nuc960evb.o
diff --git a/arch/arm/mach-w90x900/mach-nuc960evb.c b/arch/arm/mach-w90x900/mach-nuc960evb.c
new file mode 100644
index 0000000..e3a46f1
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc960evb.c
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/arm/mach-w90x900/mach-nuc960evb.c
+ *
+ * Based on mach-s3c2410/mach-smdk2410.c by Jonas Dietsche
+ *
+ * Copyright (C) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <mach/map.h>
+
+#include "nuc960.h"
+
+static void __init nuc960evb_map_io(void)
+{
+	nuc960_map_io();
+	nuc960_init_clocks();
+}
+
+static void __init nuc960evb_init(void)
+{
+	nuc960_board_init();
+}
+
+MACHINE_START(W90N960EVB, "W90N960EVB")
+	/* Maintainer: Wan ZongShun */
+	.phys_io	= W90X900_PA_UART,
+	.io_pg_offst	= (((u32)W90X900_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= 0,
+	.map_io		= nuc960evb_map_io,
+	.init_irq	= nuc900_init_irq,
+	.init_machine	= nuc960evb_init,
+	.timer		= &nuc900_timer,
+MACHINE_END
diff --git a/arch/arm/mach-w90x900/nuc960.c b/arch/arm/mach-w90x900/nuc960.c
new file mode 100644
index 0000000..8851a3a
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc960.c
@@ -0,0 +1,54 @@
+/*
+ * linux/arch/arm/mach-w90x900/nuc960.c
+ *
+ * Based on linux/arch/arm/plat-s3c24xx/s3c244x.c by Ben Dooks
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC960 cpu support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/map.h>
+#include <mach/hardware.h>
+#include "cpu.h"
+
+/* define specific CPU platform device */
+
+static struct platform_device *nuc960_dev[] __initdata = {
+	&nuc900_device_kpi,
+	&nuc900_device_fmi,
+};
+
+/* define specific CPU platform io map */
+
+static struct map_desc nuc960evb_iodesc[] __initdata = {
+};
+
+/*Init NUC960 evb io*/
+
+void __init nuc960_map_io(void)
+{
+	nuc900_map_io(nuc960evb_iodesc, ARRAY_SIZE(nuc960evb_iodesc));
+}
+
+/*Init NUC960 clock*/
+
+void __init nuc960_init_clocks(void)
+{
+	nuc900_init_clocks();
+}
+
+/*Init NUC960 board info*/
+
+void __init nuc960_board_init(void)
+{
+	nuc900_board_init(nuc960_dev, ARRAY_SIZE(nuc960_dev));
+}
diff --git a/arch/arm/mach-w90x900/nuc960.h b/arch/arm/mach-w90x900/nuc960.h
new file mode 100644
index 0000000..f0c07cb
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc960.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-w90x900/nuc960.h
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
+extern void nuc900_init_irq(void);
+extern struct sys_timer nuc900_timer;
+
+/* extern file from nuc960.c */
+
+extern void nuc960_board_init(void);
+extern void nuc960_init_clocks(void);
+extern void nuc960_map_io(void);
-- 
1.5.6.3
