Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYGJP1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYGJP1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbYGJP0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:26:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45136 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757344AbYGJP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:26:45 -0400
Subject: [PATCH 08/15] regulator: core kbuild files
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:26:43 +0100
Message-Id: <1215703603.13431.64.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds kernel build support for the regulator core.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 arch/arm/Kconfig           |    2 +
 drivers/Makefile           |    1 +
 drivers/regulator/Kconfig  |   49 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/regulator/Makefile |   10 +++++++++
 4 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/Kconfig
 create mode 100644 drivers/regulator/Makefile

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..2e532fb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1179,6 +1179,8 @@ source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/uio/Kconfig"
 
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index f65deda..2e2229e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -94,3 +94,4 @@ obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
+obj-$(CONFIG_REGULATOR)		+= regulator/
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
new file mode 100644
index 0000000..84f89ec
--- /dev/null
+++ b/drivers/regulator/Kconfig
@@ -0,0 +1,49 @@
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
+config REGULATOR_FIXED_VOLTAGE
+	tristate
+	default n
+	select REGULATOR
+
+config REGULATOR_VIRTUAL_CONSUMER
+	tristate "Virtual regulator consumer support"
+	default n
+	select REGULATOR
+	help
+	  This driver provides a virtual consumer for the voltage and
+          current regulator API which provides sysfs controls for
+          configuring the supplies requested.  This is mainly useful
+          for test purposes.
+
+          If unsure, say no.
+
+endmenu
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
new file mode 100644
index 0000000..29528b7
--- /dev/null
+++ b/drivers/regulator/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for regulator drivers.
+#
+
+
+obj-$(CONFIG_REGULATOR) += core.o
+obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
+obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
+
+ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.5.4.3



