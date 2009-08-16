Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZHPJ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZHPJ0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZHPJ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:26:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:30159 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZHPJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uW82A3ARkZt3ZTcZ1or2jIeuM4xb7GT6P+5NAUvX+nQzxJfOHsFBQRFNFQyWhrM+0b
         fDOP+pxAlJcJf3tSNrLYd19k/Jp8ERLI5LbfJ/b0vEhaIXJe1goMiDv0Xe40g23Mg2nN
         A1W+nVDXFk3ZXYf0yIH//YGXCrIcU11+V4doM=
Message-ID: <4A87D0D0.3030600@gmail.com>
Date: Sun, 16 Aug 2009 17:26:40 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] ARM: Add all nuc960 platform files to mach-w90x900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add new nuc960 platform files to mach-w90x900.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/Kconfig          |   15 +++++++
 arch/arm/mach-w90x900/Makefile         |    2 +
 arch/arm/mach-w90x900/mach-nuc960evb.c |   61 +++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc960.c         |   70 ++++++++++++++++++++++++++++++++
 arch/arm/mach-w90x900/nuc960.h         |   28 +++++++++++++
 5 files changed, 176 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/mach-nuc960evb.c
 create mode 100644 arch/arm/mach-w90x900/nuc960.c
 create mode 100644 arch/arm/mach-w90x900/nuc960.h

diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
index c70407c..8fd4624 100644
--- a/arch/arm/mach-w90x900/Kconfig
+++ b/arch/arm/mach-w90x900/Kconfig
@@ -10,6 +10,11 @@ config CPU_NUC950
 	help
 	  Support for NUCP950 of Nuvoton W90X900 CPUs.
 
+config CPU_NUC960
+	bool
+	help
+	  Support for NUCP960 of Nuvoton W90X900 CPUs.
+
 menu "W90P910 Machines"
 
 config MACH_W90P910EVB
@@ -30,4 +35,14 @@ config MACH_W90P950EVB
 
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
index 8cdbb91..093c5da 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -10,8 +10,10 @@ obj-y				+= clksel.o
 
 obj-$(CONFIG_CPU_W90P910)	+= w90p910.o mfp-w90p910.o
 obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
+obj-$(CONFIG_CPU_NUC960)	+= nuc960.o
 
 # machine support
 
 obj-$(CONFIG_MACH_W90P910EVB)	+= mach-w90p910evb.o
 obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
+obj-$(CONFIG_MACH_W90N960EVB)	+= mach-nuc960evb.o
diff --git a/arch/arm/mach-w90x900/mach-nuc960evb.c b/arch/arm/mach-w90x900/mach-nuc960evb.c
new file mode 100644
index 0000000..e727832
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc960evb.c
@@ -0,0 +1,61 @@
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
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <linux/mtd/physmap.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach-types.h>
+
+#include <mach/regs-serial.h>
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
+	.init_irq	= w90x900_init_irq,
+	.init_machine	= nuc960evb_init,
+	.timer		= &w90x900_timer,
+MACHINE_END
diff --git a/arch/arm/mach-w90x900/nuc960.c b/arch/arm/mach-w90x900/nuc960.c
new file mode 100644
index 0000000..ae9014e
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc960.c
@@ -0,0 +1,70 @@
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
+static struct platform_device *nuc960_dev[] __initdata = {
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
index 0000000..c81228c
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
+extern void w90x900_init_irq(void);
+extern struct sys_timer w90x900_timer;
+
+/* extern file from nuc960.c */
+
+extern void nuc960_board_init(void);
+extern void nuc960_init_clocks(void);
+extern void nuc960_map_io(void);
-- 
1.5.6.3
