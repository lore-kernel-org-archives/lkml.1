Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbZGDBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbZGDBnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZGDBmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:42:37 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4785 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbZGDBmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:42:33 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:42:29 -0700
Subject: [PATCH v2 2/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 2/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SLDtS9EU5UM2TbmM18yOXTeNOw==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C0F@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C0C4CG20366182-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 075b11bdfff8ee13d9f3c4208e1a1c89b0d8d1ed Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 14:34:18 -0700
Subject: [PATCH 02/18] add mach-bcmring Kconfig/Makefile/Makefile.boot

add mach-bcmring Kconfig file
add Makefile and Makefile.boot files

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/Kconfig       |   21 +++++++++++++++++++++
 arch/arm/mach-bcmring/Makefile      |    8 ++++++++
 arch/arm/mach-bcmring/Makefile.boot |    6 ++++++
 3 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/Kconfig
 create mode 100644 arch/arm/mach-bcmring/Makefile
 create mode 100644 arch/arm/mach-bcmring/Makefile.boot

diff --git a/arch/arm/mach-bcmring/Kconfig b/arch/arm/mach-bcmring/Kconfig
new file mode 100644
index 0000000..457b438
--- /dev/null
+++ b/arch/arm/mach-bcmring/Kconfig
@@ -0,0 +1,21 @@
+choice
+       prompt "Processor selection in BCMRING family of devices"
+       depends on ARCH_BCMRING
+       default ARCH_BCM11107
+
+config ARCH_FPGA11107
+       bool "FPGA11107"
+
+config ARCH_BCM11107
+       bool "BCM11107"
+endchoice
+
+menu "BCMRING Options"
+       depends on ARCH_BCMRING
+
+config BCM_ZRELADDR
+       hex "Compressed ZREL ADDR"
+
+endmenu
+
+# source "drivers/char/bcmring/Kconfig"
diff --git a/arch/arm/mach-bcmring/Makefile b/arch/arm/mach-bcmring/Makefile
new file mode 100644
index 0000000..f8d9fce
--- /dev/null
+++ b/arch/arm/mach-bcmring/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Object file lists.
+
+obj-y := arch.o mm.o irq.o clock.o core.o timer.o dma.o
+obj-y += csp/
diff --git a/arch/arm/mach-bcmring/Makefile.boot b/arch/arm/mach-bcmring/Makefile.boot
new file mode 100644
index 0000000..fb53b28
--- /dev/null
+++ b/arch/arm/mach-bcmring/Makefile.boot
@@ -0,0 +1,6 @@
+# Address where decompressor will be written and eventually executed.
+#
+# default to SDRAM
+zreladdr-y      := $(CONFIG_BCM_ZRELADDR)
+params_phys-y   := 0x00000800
+
--
1.6.0.6




Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


