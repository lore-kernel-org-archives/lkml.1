Return-Path: <linux-kernel-owner+w=401wt.eu-S935411AbYCFSOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411AbYCFSOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934811AbYCFSMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:12:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37220 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935770AbYCFSMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:12:20 -0500
Subject: [UPDATED v3][PATCH 6/7] regulator: kbuild
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:12:16 +0000
Message-Id: <1204827137.15360.152.camel@a10323.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Makefile and Kconfig for regulator core.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 drivers/Kconfig            |    2 ++
 drivers/Makefile           |    1 +
 drivers/regulator/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/regulator/Makefile |    7 +++++++
 4 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/Kconfig
 create mode 100644 drivers/regulator/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3a0e354..9a3aa1c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -90,6 +90,8 @@ source "drivers/edac/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index e5e394a..4ba0062 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -86,6 +86,7 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+obj-$(CONFIG_REGULATOR)	+= regulator/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
new file mode 100644
index 0000000..51b8d06
--- /dev/null
+++ b/drivers/regulator/Kconfig
@@ -0,0 +1,32 @@
+menu "Voltage and Current regulators"
+
+config REGULATOR
+	bool "Voltage and Current Regulator Support"
+	default n
+	help
+	  Generic Voltage and Current Regulator support.
+
+	  This framework is designed to provide a generic interface to voltage
+	  and current regulators within the Linux kernel. It's intended to
+	  provide voltage and current control to client or consumer drivers and
+	  also provide status information to user space applications through a
+	  sysfs interface.
+
+	  The intention is to allow systems to dynamically control regulator
+	  output in order to save power and prolong battery life. This applies
+	  to both voltage regulators (where voltage output is controllable) and
+	  current sinks (where current output is controllable).
+
+	  This framework safely compiles out if not selected so that client
+	  drivers can still be used in systems with no software controllable
+	  regulators.
+
+	  If unsure, say no.
+
+config REGULATOR_DEBUG
+	bool "Regulator debug support"
+	depends on REGULATOR
+	help
+	  Say yes here to enable debugging support.
+
+endmenu
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
new file mode 100644
index 0000000..6f3f948
--- /dev/null
+++ b/drivers/regulator/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for regulator drivers.
+#
+
+obj-$(CONFIG_REGULATOR) += reg-core.o
+
+ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.5.4.3

