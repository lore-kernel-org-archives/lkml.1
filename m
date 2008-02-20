Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbYBTRL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbYBTRL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbYBTRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:09:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35653 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932189AbYBTRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:09:23 -0500
Subject: [PATCH 5/6] regulator: regulator framework build.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 17:09:21 +0000
Message-Id: <1203527361.4071.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to build the regulator core.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 drivers/Kconfig            |    2 ++
 drivers/Makefile           |    1 +
 drivers/regulator/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/regulator/Makefile |    9 +++++++++
 4 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/Kconfig
 create mode 100644 drivers/regulator/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3a0e354..cc5946c 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -62,6 +62,8 @@ source "drivers/hwmon/Kconfig"
 
 source "drivers/thermal/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index e5e394a..3d0264e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
 obj-$(CONFIG_THERMAL)		+= thermal/
+obj-$(CONFIG_REGULATOR)		+= regulator/
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
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
index 0000000..3f70871
--- /dev/null
+++ b/drivers/regulator/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for regulator drivers.
+#
+
+obj-$(CONFIG_REGULATOR) += reg-core.o
+
+ifeq ($(CONFIG_REGULATOR_DEBUG),y)
+	EXTRA_CFLAGS		+= -DDEBUG
+endif
-- 
1.5.4.2



