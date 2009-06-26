Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZFZX1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZFZX1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZFZX0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:26:54 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1782 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZFZX0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:26:53 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 16:26:42 -0700
Subject: [PATCH v1 1/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 1/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn2tZAZR5Qj3N8/RRCTNAldwWeX4g==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C2@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665B86BE6007092309-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As a newcomer to the kernel community, this is our first attempt to submit code to Linux kernel for a new Broadcom SoC (BCMRing) support.  The patches can be applied to the latest mainline git tree.

This batch of submission contains only the core arch code and mtd nand driver. We use AMBA serial driver.
It boots to busybox with serial console.

The following is the first patch, adding Kconfig option and modify the Makefile in arch/arm directory.

Let me know if any questions.

Thanks,

>From 432df145d3d3d0c6d5d122259b472657d715e55c Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 15:45:10 -0700
Subject: [PATCH 1/6] add bcmring Kconfig option and modify the Makefile

---
 arch/arm/Kconfig  |   14 ++++++++++++++
 arch/arm/Makefile |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aef63c8..c6d2b19 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -637,6 +637,18 @@ config ARCH_OMAP
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
+config ARCH_BCMRING
+	bool "Broadcom BCMRING"
+	depends on MMU
+	select CPU_V6
+	select ARM_AMBA
+	select COMMON_CLKDEV
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+	help
+	  Support for Broadcom's BCMRing platform.
+
 endchoice
 
 source "arch/arm/mach-clps711x/Kconfig"
@@ -730,6 +742,8 @@ source "arch/arm/mach-u300/Kconfig"
 
 source "arch/arm/mach-w90x900/Kconfig"
 
+source "arch/arm/mach-bcmring/Kconfig"
+
 # Definitions to make life easier
 config ARCH_ACORN
 	bool
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c877d6d..f1a96f5 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -112,6 +112,7 @@ endif
 # by CONFIG_* macro name.
 machine-$(CONFIG_ARCH_AAEC2000)		:= aaec2000
 machine-$(CONFIG_ARCH_AT91)		:= at91
+machine-$(CONFIG_ARCH_BCMRING)    := bcmring
 machine-$(CONFIG_ARCH_CLPS711X)		:= clps711x
 machine-$(CONFIG_ARCH_DAVINCI)		:= davinci
 machine-$(CONFIG_ARCH_EBSA110)		:= ebsa110
-- 
1.6.0.6


 
Leo Hao Chen
Software Engineer
Broadcom Canada Inc.
