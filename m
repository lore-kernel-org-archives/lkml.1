Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZIRWOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZIRWOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbZIRWOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:14:36 -0400
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:23232 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758769AbZIRWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:12:20 -0400
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: RmMbAiIVM1lz_MKq_TkY.aW0_kF7okHuNbqy4Ar21vNb81SJKL8CtxF.O2eut8DwaJON7f.3vFf3qrkfYBWkfK2gLQ1mf224upVeJZA8vzbSxQCWVf07QJ8Zb7Kowbmxa_UG6UpD2Yc.rxnTCb8FiGDgFMd9yNfOZK0tzQTVGDnw52YcxS.Mp.mKkFvzbb2pOJXnoXpJSVUFNSzCxbVyo620SgmoZq_Er2Yn_9Q9hWr4j30MAoHxYOU25q0DCTkzHH6P.mVc0U7fhs6FKlNn7IDWvLjmIpR7GrPfli7PvAFgmv2FBcypTqciXOxBx1i7s3DZMvIMT_1CDf6ZjK5jSLBMQMZn.R5kmIveTaWUbGMGlCfERsSxGeNVY5Rgfr.Y.XZ1cw47hggEqHgFuLampnHtsLrHWKtFOnw1KH5zoY5l4I5wSBZhYR4RAkbFB5g_T1UHZxx9jRIiGJNucU7rBmh2PVR7MzAowEQSBDf9MMA6FH1DNX-Yahoo-Newman-Property: ymail-3
Subject: [RFC PATCH 19/19] Target_Core_Mod Makefile/Kconfig and div64.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@lst.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Florian Haas <florian.haas@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Daniel Walker <dwalker@fifo99.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 15:09:37 -0700
Message-Id: <1253311777.4498.162.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC PATCH 19/19] Target_Core_Mod Makefile/Kconfig and div64.c

This patch adds the remaining Kbuild and Kconfig items for TCM

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
 
diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
new file mode 100644
index 0000000..4dd0f53
--- /dev/null
+++ b/drivers/target/Kbuild
@@ -0,0 +1,54 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
+
+target_core_mod-y		:= target_core_configfs.o \
+				   target_core_device.o \
+				   target_core_hba.o \
+				   target_core_plugin.o \
+				   target_core_pr.o \
+				   target_core_alua.o \
+				   target_core_scdb.o \
+				   target_core_seobj.o \
+				   target_core_tmr.o \
+				   target_core_tpg.o \
+				   target_core_transport.o \
+				   target_core_ua.o
+
+ifdef CONFIG_TCM_IBLOCK
+target_core_mod-y		+= target_core_iblock.o
+EXTRA_CFLAGS			+= -DPYX_IBLOCK
+endif
+
+ifdef CONFIG_TCM_PSCSI
+target_core_mod-y		+= target_core_pscsi.o
+EXTRA_CFLAGS			+= -DPARALLEL_SCSI
+endif
+
+ifdef CONFIG_TCM_STGT
+target_core_mod-y		+= target_core_stgt.o
+EXTRA_CFLAGS			+= -DSTGT_PLUGIN
+endif
+
+ifdef CONFIG_TCM_RAMDISK
+target_core_mod-y		+= target_core_rd.o
+EXTRA_CFLAGS			+= -DPYX_RAMDISK
+endif
+
+ifdef CONFIG_TCM_FILEIO
+target_core_mod-y		+= target_core_file.o
+EXTRA_CFLAGS			+= -DPYX_FILEIO
+endif
+
+ifdef CONFIG_TCM_SNMP
+target_core_mod-y		+= target_core_mib.o
+EXTRA_CFLAGS			+= -DSNMP_SUPPORT
+endif
+
+ifdef CONFIG_TCM_PSCSI_VPD_PAGE_CHECK
+EXTRA_CFLAGS			+= -DLINUX_VPD_PAGE_CHECK
+endif
+
+ifdef CONFIG_TCM_DEBUG_DEV
+EXTRA_CFLAGS			+= -DDEBUG_DEV
+endif
+
+obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
new file mode 100644
index 0000000..607036e
--- /dev/null
+++ b/drivers/target/Kconfig
@@ -0,0 +1,64 @@
+config TARGET_CORE
+        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
+	select CONFIGFS_FS
+        default m
+        ---help---
+        Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled control path for target_core_mod
+
+config TCM_IBLOCK
+	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
+	depends on TARGET_CORE
+	default y
+	---help---
+	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered access to Linux/Block devices using BIO in TCM
+
+config TCM_PSCSI
+	tristate "TCM/pSCSI Subsystem Plugin for Linux/SCSI"
+	depends on TARGET_CORE
+	default y
+	---help---
+	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered passthrough access to Linux/SCSI devices in TCM	
+
+config TCM_PSCSI_VPD_PAGE_CHECK
+	tristate "TCM/pSCSI EVPD Page Emulation for Linux/SCSI"
+	depends on TARGET_CORE && TCM_PSCSI
+	default y
+	---help---
+	Say Y here to enable the TCM/pSCSI EVPD emulation that is required to register emulated SCSI LUNs on some non Linux OSes when using the Linux/SCSI passthrough for certain devices.
+
+config TCM_FILEIO
+	tristate "TCM/FILEIO Subsystem Plugin for Linux/VFS"
+	depends on TARGET_CORE
+	default y
+	---help---
+	Say Y here to enable the TCM/FILEIO subsystem plugin for buffered access to Linux/VFS files or block devices in TCM
+
+config TCM_RAMDISK
+	tristate "TCM/RAMDISK Subsystem Plugin"
+	depends on TARGET_CORE
+	default y
+	---help---
+	Say Y here to enable the TCM/RAMDISK subsystem plugins for internal struct page ramdisk device access for performance testing and debugging
+
+config TCM_STGT
+	tristate "TCM/STGT Subsystem Plugin"
+	depends on TARGET_CORE && EXPERIMENTAL
+	select SCSI_TGT
+	default y
+	---help---
+	Say Y here to enable the WIP TCM/STGT subsystem plugin for accessing STGT device in TCM
+
+config TCM_SNMP
+	tristate "TCM SCSI MIBs"
+	depends on TARGET_CORE && PROC_FS
+	default y
+	---help---
+	Say Y here to enable the SCSI MIBs via procfs for TCM
+
+config TCM_DEBUG_DEV
+	tristate "TCM Debug device code"
+	depends on TARGET_CORE
+	default n
+	---help---
+	Say Y here to enable the TCM Debug device code
+	


