Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZHRLHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZHRLHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZHRLHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:07:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:54387 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692AbZHRLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qr1ePetKPzGnRewiHzniNrk75vftRx1X2CPViHuEyWnPai75shUZwuLZNU+z48PTth
         /7+LfMtzwLvYXG2K41exq91tf4UQ+RuacKpFkhbLoSj//3JAbXvL+dzzXUcbIYXPRElg
         HZR0FUmYT3Lbg3Ehdmre0maDosCkKqmZvbRAQ=
Message-ID: <4A8A8B7D.9030803@gmail.com>
Date: Tue, 18 Aug 2009 19:07:41 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 2/3] ARM: Add nuc950 paltform files to w90x900 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add nuc950 paltform files to w90x900 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/Kconfig          |   15 +++++++++
 arch/arm/mach-w90x900/Makefile         |    2 +
 arch/arm/mach-w90x900/mach-nuc950evb.c |   44 ++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc950.c         |   54 ++++++++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc950.h         |   28 ++++++++++++++++
 5 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/mach-nuc950evb.c
 create mode 100644 arch/arm/mach-w90x900/nuc950.c
 create mode 100644 arch/arm/mach-w90x900/nuc950.h

diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
index 8e4178f..163b801 100644
--- a/arch/arm/mach-w90x900/Kconfig
+++ b/arch/arm/mach-w90x900/Kconfig
@@ -5,6 +5,11 @@ config CPU_W90P910
 	help
 	  Support for W90P910 of Nuvoton W90X900 CPUs.
 
+config CPU_NUC950
+	bool
+	help
+	  Support for NUCP950 of Nuvoton NUC900 CPUs.
+
 menu "W90P910 Machines"
 
 config MACH_W90P910EVB
@@ -16,4 +21,14 @@ config MACH_W90P910EVB
 
 endmenu
 
+menu "NUC950 Machines"
+
+config MACH_W90P950EVB
+	bool "Nuvoton NUC950 Evaluation Board"
+	select CPU_NUC950
+	help
+	   Say Y here if you are using the Nuvoton NUC950EVB
+
+endmenu
+
 endif
diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index e38aa32..a4622b5 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -9,7 +9,9 @@ obj-y				+= clksel.o dev.o cpu.o
 # W90X900 CPU support files
 
 obj-$(CONFIG_CPU_W90P910)	+= nuc910.o
+obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
 
 # machine support
 
 obj-$(CONFIG_MACH_W90P910EVB)	+= mach-nuc910evb.o
+obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
diff --git a/arch/arm/mach-w90x900/mach-nuc950evb.c b/arch/arm/mach-w90x900/mach-nuc950evb.c
new file mode 100644
index 0000000..cef903b
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc950evb.c
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/arm/mach-w90x900/mach-nuc950evb.c
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
+#include "nuc950.h"
+
+static void __init nuc950evb_map_io(void)
+{
+	nuc950_map_io();
+	nuc950_init_clocks();
+}
+
+static void __init nuc950evb_init(void)
+{
+	nuc950_board_init();
+}
+
+MACHINE_START(W90P950EVB, "W90P950EVB")
+	/* Maintainer: Wan ZongShun */
+	.phys_io	= W90X900_PA_UART,
+	.io_pg_offst	= (((u32)W90X900_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= 0,
+	.map_io		= nuc950evb_map_io,
+	.init_irq	= nuc900_init_irq,
+	.init_machine	= nuc950evb_init,
+	.timer		= &nuc900_timer,
+MACHINE_END
diff --git a/arch/arm/mach-w90x900/nuc950.c b/arch/arm/mach-w90x900/nuc950.c
new file mode 100644
index 0000000..1495081
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc950.c
@@ -0,0 +1,54 @@
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
+#include <linux/platform_device.h>
+#include <asm/mach/map.h>
+#include <mach/hardware.h>
+#include "cpu.h"
+
+/* define specific CPU platform device */
+
+static struct platform_device *nuc950_dev[] __initdata = {
+	&nuc900_device_kpi,
+	&nuc900_device_fmi,
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
index 0000000..98a1148
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
+extern void nuc900_init_irq(void);
+extern struct sys_timer nuc900_timer;
+
+/* extern file from nuc950.c */
+
+extern void nuc950_board_init(void);
+extern void nuc950_init_clocks(void);
+extern void nuc950_map_io(void);
-- 
1.5.6.3
