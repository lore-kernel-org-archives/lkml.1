Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZJVWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZJVWLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbZJVWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:11:23 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49454 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbZJVWLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:11:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18z+CYW9PHjLt8DEBF4zvCa
Subject: [PATCH 01/10] omap: Fix omap-keypad by restoring old keypad.h without
	breaking omap2 boards that use matrix_keypad
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date: Thu, 22 Oct 2009 15:11:20 -0700
Message-ID: <20091022221120.27408.19252.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Only mach-omap2 boards are currently using matrix_keypad. Allow
mach-omap1 boards to use the old style keypad.h without breaking.

Created against linux-2.6.32-rc5.
Compile tested with omap_3430sdp_defconfig and rx51_defconfig.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-ldp.c              |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/board-rx51.c             |    1 -
 arch/arm/mach-omap2/board-zoom2.c            |    2 +-
 arch/arm/plat-omap/include/mach/keypad.h     |    5 ++++-
 8 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index efaf053..0acb556 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/i2c/twl4030.h>
@@ -38,7 +39,6 @@
 #include <mach/gpmc.h>
 
 #include <mach/control.h>
-#include <mach/keypad.h>
 #include <mach/gpmc-smc91x.h>
 
 #include "sdram-qimonda-hyb18m512160af-6.h"
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index d110a7f..d57ec2f 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/gpio_keys.h>
 #include <linux/workqueue.h>
 #include <linux/err.h>
@@ -41,7 +42,6 @@
 #include <asm/delay.h>
 #include <mach/control.h>
 #include <mach/usb.h>
-#include <mach/keypad.h>
 
 #include "mmc-twl4030.h"
 
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index e4ec0c5..4c4d7f8 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -20,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/leds.h>
 
 #include <linux/spi/spi.h>
@@ -37,7 +38,6 @@
 #include <mach/usb.h>
 #include <mach/common.h>
 #include <mach/mcspi.h>
-#include <mach/keypad.h>
 
 #include "sdram-micron-mt46h32m32lf-6.h"
 #include "mmc-twl4030.h"
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 7f6bf87..5326e0d 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -27,6 +27,7 @@
 #include <linux/i2c/twl4030.h>
 #include <linux/leds.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/gpio_keys.h>
 
 #include <asm/mach-types.h>
@@ -39,7 +40,6 @@
 #include <mach/hardware.h>
 #include <mach/mcspi.h>
 #include <mach/usb.h>
-#include <mach/keypad.h>
 #include <mach/mux.h>
 
 #include "sdram-micron-mt46h32m32lf-6.h"
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 2b0eb1b..e34d96a 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
@@ -27,7 +28,6 @@
 #include <mach/common.h>
 #include <mach/dma.h>
 #include <mach/gpmc.h>
-#include <mach/keypad.h>
 #include <mach/onenand.h>
 #include <mach/gpmc-smc91x.h>
 
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index f9196c3..78869a9 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -26,7 +26,6 @@
 #include <mach/mux.h>
 #include <mach/board.h>
 #include <mach/common.h>
-#include <mach/keypad.h>
 #include <mach/dma.h>
 #include <mach/gpmc.h>
 #include <mach/usb.h>
diff --git a/arch/arm/mach-omap2/board-zoom2.c b/arch/arm/mach-omap2/board-zoom2.c
index fd3369d..ea00486 100644
--- a/arch/arm/mach-omap2/board-zoom2.c
+++ b/arch/arm/mach-omap2/board-zoom2.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
 #include <linux/gpio.h>
 #include <linux/i2c/twl4030.h>
 #include <linux/regulator/machine.h>
@@ -22,7 +23,6 @@
 
 #include <mach/common.h>
 #include <mach/usb.h>
-#include <mach/keypad.h>
 
 #include "mmc-twl4030.h"
 #include "sdram-micron-mt46h32m32lf-6.h"
diff --git a/arch/arm/plat-omap/include/mach/keypad.h b/arch/arm/plat-omap/include/mach/keypad.h
index d91b9be..3ae52cc 100644
--- a/arch/arm/plat-omap/include/mach/keypad.h
+++ b/arch/arm/plat-omap/include/mach/keypad.h
@@ -10,7 +10,7 @@
 #ifndef ASMARM_ARCH_KEYPAD_H
 #define ASMARM_ARCH_KEYPAD_H
 
-#include <linux/input/matrix_keypad.h>
+#warning: Please update the board to use matrix_keypad.h instead
 
 struct omap_kp_platform_data {
 	int rows;
@@ -37,6 +37,9 @@ struct omap_kp_platform_data {
 
 #define KEY_PERSISTENT		0x00800000
 #define KEYNUM_MASK		0x00EFFFFF
+#define KEY(col, row, val) (((col) << 28) | ((row) << 24) | (val))
+#define PERSISTENT_KEY(col, row) (((col) << 28) | ((row) << 24) | \
+						KEY_PERSISTENT)
 
 #endif
 

