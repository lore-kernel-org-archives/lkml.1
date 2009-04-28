Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZD1NdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZD1NdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZD1Nc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:32:56 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:51038 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZD1Ncz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:32:55 -0400
Date: Tue, 28 Apr 2009 10:32:00 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] powerpc: minimizing the configuration of
	linkstation_defconfig
Message-ID: <20090428133200.GB12828@ime.usp.br>
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the following issues:


01. makes CFQ the default scheduler, to be in line with the rest of  
the kernel.

02. since linkstations are meant to store files, enable large blk  
devices.

03. disable CONFIG_MIGRATION in in such low memory devices.

04. disable CONFIG_BLK_DEV_RAM.

05. disable CONFIG_SCSI_LOWLEVEL, as no device under that tree is  
used.

06. idem for CONFIG_NETDEV_10000.

07. idem for CONFIG_WIRELESS.

08. idem for CONFIG_HWMON.

09. idem for CONFIG_CRYPTO_HW.

10. disable CONFIG_VIDEO_OUTPUT_CONTROL.

11. keep consistency and disable extended attributes in CIFS, ext3,  
and NFS.

12. enable CONFIG_PRINTK_TIME.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

This is the patch for tidying the defconfig.

--- a/arch/powerpc/configs/linkstation_defconfig	2009-04-28 09:53:38.000000000 -0300
+++ b/arch/powerpc/configs/linkstation_defconfig	2009-04-28 10:14:11.000000000 -0300
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.30-rc3
-# Tue Apr 28 09:53:38 2009
+# Tue Apr 28 10:14:11 2009
 #
 # CONFIG_PPC64 is not set
 
@@ -155,7 +155,7 @@
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_BLOCK=y
-# CONFIG_LBD is not set
+CONFIG_LBD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_BLK_DEV_INTEGRITY is not set
 
@@ -166,11 +166,11 @@
 CONFIG_IOSCHED_AS=y
 CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=y
-CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_AS is not set
 # CONFIG_DEFAULT_DEADLINE is not set
-# CONFIG_DEFAULT_CFQ is not set
+CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="anticipatory"
+CONFIG_DEFAULT_IOSCHED="cfq"
 # CONFIG_FREEZER is not set
 
 #
@@ -252,7 +252,7 @@
 CONFIG_FLAT_NODE_MEM_MAP=y
 CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
-CONFIG_MIGRATION=y
+# CONFIG_MIGRATION is not set
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
@@ -492,13 +492,7 @@
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-CONFIG_WIRELESS=y
-# CONFIG_CFG80211 is not set
-CONFIG_WIRELESS_OLD_REGULATORY=y
-CONFIG_WIRELESS_EXT=y
-CONFIG_WIRELESS_EXT_SYSFS=y
-# CONFIG_LIB80211 is not set
-# CONFIG_MAC80211 is not set
+# CONFIG_WIRELESS is not set
 # CONFIG_WIMAX is not set
 # CONFIG_RFKILL is not set
 # CONFIG_NET_9P is not set
@@ -625,10 +619,7 @@
 # CONFIG_BLK_DEV_NBD is not set
 # CONFIG_BLK_DEV_SX8 is not set
 # CONFIG_BLK_DEV_UB is not set
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=2
-CONFIG_BLK_DEV_RAM_SIZE=8192
-# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_BLK_DEV_RAM is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 # CONFIG_BLK_DEV_HD is not set
@@ -688,49 +679,7 @@
 # CONFIG_SCSI_ISCSI_ATTRS is not set
 # CONFIG_SCSI_SAS_LIBSAS is not set
 # CONFIG_SCSI_SRP_ATTRS is not set
-CONFIG_SCSI_LOWLEVEL=y
-# CONFIG_ISCSI_TCP is not set
-# CONFIG_SCSI_CXGB3_ISCSI is not set
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_3W_9XXX is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-# CONFIG_SCSI_AIC94XX is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ADVANSYS is not set
-# CONFIG_SCSI_ARCMSR is not set
-# CONFIG_MEGARAID_NEWGEN is not set
-# CONFIG_MEGARAID_LEGACY is not set
-# CONFIG_MEGARAID_SAS is not set
-# CONFIG_SCSI_MPT2SAS is not set
-# CONFIG_SCSI_HPTIOP is not set
-# CONFIG_SCSI_BUSLOGIC is not set
-# CONFIG_LIBFC is not set
-# CONFIG_LIBFCOE is not set
-# CONFIG_FCOE is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_EATA is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_GDTH is not set
-# CONFIG_SCSI_IPS is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_MVSAS is not set
-# CONFIG_SCSI_STEX is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_IPR is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_QLA_FC is not set
-# CONFIG_SCSI_QLA_ISCSI is not set
-# CONFIG_SCSI_LPFC is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_NSP32 is not set
-# CONFIG_SCSI_DEBUG is not set
-# CONFIG_SCSI_SRP is not set
+# CONFIG_SCSI_LOWLEVEL is not set
 # CONFIG_SCSI_DH is not set
 # CONFIG_SCSI_OSD_INITIATOR is not set
 CONFIG_ATA=y
@@ -872,25 +821,7 @@
 # CONFIG_ATL1E is not set
 # CONFIG_ATL1C is not set
 # CONFIG_JME is not set
-CONFIG_NETDEV_10000=y
-# CONFIG_CHELSIO_T1 is not set
-CONFIG_CHELSIO_T3_DEPENDS=y
-# CONFIG_CHELSIO_T3 is not set
-# CONFIG_ENIC is not set
-# CONFIG_IXGBE is not set
-# CONFIG_IXGB is not set
-# CONFIG_S2IO is not set
-# CONFIG_VXGE is not set
-# CONFIG_MYRI10GE is not set
-# CONFIG_NETXEN_NIC is not set
-# CONFIG_NIU is not set
-# CONFIG_MLX4_EN is not set
-# CONFIG_MLX4_CORE is not set
-# CONFIG_TEHUTI is not set
-# CONFIG_BNX2X is not set
-# CONFIG_QLGE is not set
-# CONFIG_SFC is not set
-# CONFIG_BE2NET is not set
+# CONFIG_NETDEV_10000 is not set
 # CONFIG_TR is not set
 
 #
@@ -1085,68 +1016,7 @@
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7462 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ADT7475 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_I5K_AMB is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_G760A is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_LTC4215 is not set
-# CONFIG_SENSORS_LTC4245 is not set
-# CONFIG_SENSORS_LM95241 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_PCF8591 is not set
-# CONFIG_SENSORS_SIS5595 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VIA686A is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_VT8231 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 # CONFIG_WATCHDOG is not set
@@ -1193,7 +1063,7 @@
 # CONFIG_AGP is not set
 # CONFIG_DRM is not set
 # CONFIG_VGASTATE is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=m
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 # CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
@@ -1460,21 +1330,19 @@
 # CONFIG_EXT2_FS_XIP is not set
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
-CONFIG_EXT3_FS_XATTR=y
-# CONFIG_EXT3_FS_POSIX_ACL is not set
-# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT3_FS_XATTR is not set
 # CONFIG_EXT4_FS is not set
 CONFIG_JBD=y
-CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-CONFIG_FS_POSIX_ACL=y
+# CONFIG_FS_POSIX_ACL is not set
 CONFIG_FILE_LOCKING=y
 CONFIG_XFS_FS=m
 # CONFIG_XFS_QUOTA is not set
 # CONFIG_XFS_POSIX_ACL is not set
 # CONFIG_XFS_RT is not set
 # CONFIG_XFS_DEBUG is not set
+# CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
 # CONFIG_BTRFS_FS is not set
 CONFIG_DNOTIFY=y
@@ -1546,7 +1414,7 @@
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
-CONFIG_NFS_V3_ACL=y
+# CONFIG_NFS_V3_ACL is not set
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
@@ -1556,7 +1424,6 @@
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
 CONFIG_EXPORTFS=m
-CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
@@ -1649,7 +1516,7 @@
 #
 # Kernel hacking
 #
-# CONFIG_PRINTK_TIME is not set
+CONFIG_PRINTK_TIME=y
 CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=1024
@@ -1832,8 +1699,6 @@
 # Random Number Generation
 #
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRYPTO_HW=y
-# CONFIG_CRYPTO_DEV_HIFN_795X is not set
-# CONFIG_CRYPTO_DEV_TALITOS is not set
+# CONFIG_CRYPTO_HW is not set
 # CONFIG_PPC_CLOCK is not set
 # CONFIG_VIRTUALIZATION is not set


-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
