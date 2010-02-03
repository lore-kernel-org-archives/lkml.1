Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0BCFRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:17:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34290 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0BCFRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:17:10 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       r.herring@freescale.com, bryan.wu@canonical.com
Subject: [PATCHv2 06/11] mxc: enable support for Freescale i.MX5 series of processors
Date: Tue,  2 Feb 2010 21:16:28 -0800
Message-Id: <240f12ca87d7666f31263aabc620a9ec197cd8ff.1265173480.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
 <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
 <ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com>
 <f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Makefiles to enable Freescale i.MX51 processor. Separated to help
ease the review process.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/Makefile               |    1 +
 arch/arm/mach-mx5/Kconfig       |   11 +++++++++++
 arch/arm/mach-mx5/Makefile      |    7 +++++++
 arch/arm/mach-mx5/Makefile.boot |    3 +++
 arch/arm/plat-mxc/Kconfig       |    8 ++++++++
 5 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mx5/Kconfig
 create mode 100644 arch/arm/mach-mx5/Makefile
 create mode 100644 arch/arm/mach-mx5/Makefile.boot

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 9e75825..52232d2 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -146,6 +146,7 @@ machine-$(CONFIG_ARCH_MX1)		:= mx1
 machine-$(CONFIG_ARCH_MX2)		:= mx2
 machine-$(CONFIG_ARCH_MX25)		:= mx25
 machine-$(CONFIG_ARCH_MX3)		:= mx3
+machine-$(CONFIG_ARCH_MX5)		:= mx5
 machine-$(CONFIG_ARCH_MXC91231)		:= mxc91231
 machine-$(CONFIG_ARCH_NETX)		:= netx
 machine-$(CONFIG_ARCH_NOMADIK)		:= nomadik
diff --git a/arch/arm/mach-mx5/Kconfig b/arch/arm/mach-mx5/Kconfig
new file mode 100644
index 0000000..ccd96fd
--- /dev/null
+++ b/arch/arm/mach-mx5/Kconfig
@@ -0,0 +1,11 @@
+if ARCH_MX5
+
+config ARCH_MX51
+	bool
+	default y
+	select MXC_TZIC
+	select ARCH_MXC_IOMUX_V3
+
+comment "MX5 platforms:"
+
+endif
diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
new file mode 100644
index 0000000..d74ce4f
--- /dev/null
+++ b/arch/arm/mach-mx5/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Object file lists.
+obj-y   := cpu.o mm.o clock.o devices.o
+
diff --git a/arch/arm/mach-mx5/Makefile.boot b/arch/arm/mach-mx5/Makefile.boot
new file mode 100644
index 0000000..9939a19
--- /dev/null
+++ b/arch/arm/mach-mx5/Makefile.boot
@@ -0,0 +1,3 @@
+   zreladdr-y	:= 0x90008000
+params_phys-y	:= 0x90000100
+initrd_phys-y	:= 0x90800000
diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index 59558c4..cea51a0 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -41,6 +41,13 @@ config ARCH_MXC91231
 	help
 	  This enables support for systems based on the Freescale MXC91231 family
 
+config ARCH_MX5
+	bool "MX5-based"
+	select CPU_V7
+	select COMMON_CLKDEV
+	help
+	  This enables support for systems based on the Freescale i.MX51 family
+
 endchoice
 
 source "arch/arm/mach-mx1/Kconfig"
@@ -48,6 +55,7 @@ source "arch/arm/mach-mx2/Kconfig"
 source "arch/arm/mach-mx3/Kconfig"
 source "arch/arm/mach-mx25/Kconfig"
 source "arch/arm/mach-mxc91231/Kconfig"
+source "arch/arm/mach-mx5/Kconfig"
 
 endmenu
 
-- 
1.6.3.3

