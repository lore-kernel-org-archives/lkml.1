Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZCEXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZCEXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZCEXZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:25:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:48669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754902AbZCEXZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:25:10 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/BufEI2cTB0RMeYRv8LW91PiOLdl51oKEkeyK22N
	OH6uc7VzuHrNPn
Date: Fri, 6 Mar 2009 00:25:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Tony Breeds <tony@bakeyournoodle.com>,
       Kumar Gala <galak@kernel.crashing.org>, torvalds@linux-foundation.org,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Subject: [PATCH] powerpc: fix linkstation and storcenter compilation breakage
In-Reply-To: <20090304214541.GA2917@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0903060016500.4980@axis700.grange>
References: <20090302094303.GA29819@ime.usp.br> <20090303024837.GC24834@bilbo.ozlabs.org>
 <20090303083455.GA22397@ime.usp.br> <Pine.LNX.4.64.0903040828150.4864@axis700.grange>
 <20090304214541.GA2917@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defining flash partition table in platform code is deprecated, and due to 
recent changes linkstation and storcenter do not compile any more with 
their default configurations because of undefined references to 
physmap_set_partitions(). Instead of fixing them by using the correct 
kernel configuration macro in preprocessor conditional, remove partition 
table definitions altogether. Instead add support for partition definition 
on the command-line and in device tree to the default configurations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
Kumar, could you push this up ASAP, please? This fixes

[Bug #12811] undefined reference to `physmap_set_partitions' on powerpc

diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index aa5855a..15900dc 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29-rc2
-# Mon Jan 26 15:35:29 2009
+# Linux kernel version: 2.6.29-rc6
+# Fri Mar  6 00:07:38 2009
 #
 # CONFIG_PPC64 is not set
 
@@ -71,6 +71,15 @@ CONFIG_POSIX_MQUEUE=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
@@ -88,6 +97,7 @@ CONFIG_NAMESPACES=y
 # CONFIG_IPC_NS is not set
 # CONFIG_USER_NS is not set
 # CONFIG_PID_NS is not set
+# CONFIG_NET_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
@@ -153,11 +163,6 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
-# CONFIG_TREE_RCU is not set
-# CONFIG_PREEMPT_RCU is not set
-# CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_FREEZER is not set
 
 #
@@ -294,7 +299,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NET_NS is not set
 CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
@@ -508,8 +512,8 @@ CONFIG_MTD_CONCAT=y
 CONFIG_MTD_PARTITIONS=y
 # CONFIG_MTD_TESTS is not set
 # CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-# CONFIG_MTD_OF_PARTS is not set
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_OF_PARTS=y
 # CONFIG_MTD_AR7_PARTS is not set
 
 #
@@ -587,7 +591,6 @@ CONFIG_MTD_PHYSMAP=y
 # LPDDR flash memory drivers
 #
 # CONFIG_MTD_LPDDR is not set
-# CONFIG_MTD_QINFO_PROBE is not set
 
 #
 # UBI - Unsorted block images
@@ -617,13 +620,19 @@ CONFIG_BLK_DEV_RAM_SIZE=8192
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_PHANTOM is not set
-# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
 # CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_HP_ILO is not set
 # CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_AT24 is not set
+CONFIG_EEPROM_LEGACY=m
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -839,6 +848,7 @@ CONFIG_R8169=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_ATL1C is not set
 # CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_CHELSIO_T1 is not set
@@ -1037,8 +1047,6 @@ CONFIG_I2C_MPC=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_EEPROM_AT24 is not set
-CONFIG_EEPROM_LEGACY=m
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index 86512c8..9490346 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29-rc2
-# Mon Jan 26 15:35:46 2009
+# Linux kernel version: 2.6.29-rc6
+# Fri Mar  6 00:09:08 2009
 #
 # CONFIG_PPC64 is not set
 
@@ -71,6 +71,15 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_GROUP_SCHED=y
@@ -144,11 +153,6 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
-# CONFIG_TREE_RCU is not set
-# CONFIG_PREEMPT_RCU is not set
-# CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_FREEZER is not set
 
 #
@@ -377,8 +381,8 @@ CONFIG_MTD=y
 CONFIG_MTD_PARTITIONS=y
 # CONFIG_MTD_TESTS is not set
 # CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-# CONFIG_MTD_OF_PARTS is not set
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_OF_PARTS=y
 # CONFIG_MTD_AR7_PARTS is not set
 
 #
@@ -452,7 +456,6 @@ CONFIG_MTD_PHYSMAP=y
 # LPDDR flash memory drivers
 #
 # CONFIG_MTD_LPDDR is not set
-# CONFIG_MTD_QINFO_PROBE is not set
 
 #
 # UBI - Unsorted block images
@@ -478,13 +481,19 @@ CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_PHANTOM is not set
-# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
 # CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_HP_ILO is not set
 # CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_AT24 is not set
+# CONFIG_EEPROM_LEGACY is not set
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 CONFIG_IDE=y
 
@@ -677,6 +686,7 @@ CONFIG_R8169=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_ATL1C is not set
 # CONFIG_JME is not set
 # CONFIG_NETDEV_10000 is not set
 # CONFIG_TR is not set
@@ -818,8 +828,6 @@ CONFIG_I2C_MPC=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_EEPROM_AT24 is not set
-# CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
@@ -1159,6 +1167,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
 # CONFIG_NETWORK_FILESYSTEMS is not set
+CONFIG_EXPORTFS=m
 
 #
 # Partition Types
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 2ca7be6..244f997 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/initrd.h>
-#include <linux/mtd/physmap.h>
 #include <linux/of_platform.h>
 
 #include <asm/time.h>
@@ -22,39 +21,6 @@
 
 #include "mpc10x.h"
 
-static struct mtd_partition linkstation_physmap_partitions[] = {
-	{
-		.name   = "mtd_firmimg",
-		.offset = 0x000000,
-		.size   = 0x300000,
-	},
-	{
-		.name   = "mtd_bootcode",
-		.offset = 0x300000,
-		.size   = 0x070000,
-	},
-	{
-		.name   = "mtd_status",
-		.offset = 0x370000,
-		.size   = 0x010000,
-	},
-	{
-		.name   = "mtd_conf",
-		.offset = 0x380000,
-		.size   = 0x080000,
-	},
-	{
-		.name   = "mtd_allflash",
-		.offset = 0x000000,
-		.size   = 0x400000,
-	},
-	{
-		.name   = "mtd_data",
-		.offset = 0x310000,
-		.size   = 0x0f0000,
-	},
-};
-
 static __initdata struct of_device_id of_bus_ids[] = {
 	{ .type = "soc", },
 	{ .compatible = "simple-bus", },
@@ -99,10 +65,6 @@ static int __init linkstation_add_bridge(struct device_node *dev)
 static void __init linkstation_setup_arch(void)
 {
 	struct device_node *np;
-#ifdef CONFIG_MTD_PHYSMAP
-	physmap_set_partitions(linkstation_physmap_partitions,
-			       ARRAY_SIZE(linkstation_physmap_partitions));
-#endif
 
 	/* Lookup PCI host bridges */
 	for_each_compatible_node(np, "pci", "mpc10x-pci")
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index 8864e48..613070e 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/initrd.h>
-#include <linux/mtd/physmap.h>
 #include <linux/of_platform.h>
 
 #include <asm/system.h>
@@ -26,32 +25,6 @@
 #include "mpc10x.h"
 
 
-#ifdef CONFIG_MTD_PHYSMAP
-static struct mtd_partition storcenter_physmap_partitions[] = {
-	{
-		.name   = "kernel",
-		.offset = 0x000000,
-		.size   = 0x170000,
-	},
-	{
-		.name   = "rootfs",
-		.offset = 0x170000,
-		.size   = 0x590000,
-	},
-	{
-		.name   = "uboot",
-		.offset = 0x700000,
-		.size   = 0x040000,
-	},
-	{
-		.name   = "config",
-		.offset = 0x740000,
-		.size   = 0x0c0000,
-	},
-};
-#endif
-
-
 static __initdata struct of_device_id storcenter_of_bus[] = {
 	{ .name = "soc", },
 	{},
@@ -96,11 +69,6 @@ static void __init storcenter_setup_arch(void)
 {
 	struct device_node *np;
 
-#ifdef CONFIG_MTD_PHYSMAP
-	physmap_set_partitions(storcenter_physmap_partitions,
-			       ARRAY_SIZE(storcenter_physmap_partitions));
-#endif
-
 	/* Lookup PCI host bridges */
 	for_each_compatible_node(np, "pci", "mpc10x-pci")
 		storcenter_add_bridge(np);
