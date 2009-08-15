Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZHOLfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZHOLfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHOLfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:35:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58038 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZHOLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QeZ8f8SCH+ue+BHk/P2pzXBuW8AKN2okm8M/ZuUlXoXK82D6wzfPyKdr6GUDUGwJdK
         tjUNGkbzoQTNecK+PDWLhO3gdHtOJK0QNtbVZjhnn0Nq+RkeGjGWgBAi91ETAynAg3fk
         ffd+ht7eQNR3r5j6fRaGsbAbfUrAMXD2ncYEI=
Message-ID: <4A869D75.9090908@gmail.com>
Date: Sat, 15 Aug 2009 19:35:17 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 6/9] ARM: Add nuc950 machine file support for nuc950 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Add mach-nuc950.c support for nuc950 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/mach-nuc950evb.c |   61 ++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/mach-nuc950evb.c

diff --git a/arch/arm/mach-w90x900/mach-nuc950evb.c b/arch/arm/mach-w90x900/mach-nuc950evb.c
new file mode 100644
index 0000000..b358c15
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc950evb.c
@@ -0,0 +1,61 @@
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
+	.init_irq	= w90x900_init_irq,
+	.init_machine	= nuc950evb_init,
+	.timer		= &w90x900_timer,
+MACHINE_END
-- 
1.5.6.3

