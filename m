Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYDCRKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYDCRKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbYDCRJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:09:53 -0400
Received: from lazybastard.de ([212.112.238.170]:35971 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbYDCRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:09:51 -0400
Message-Id: <20080401181332.853833001@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 1/15] Makefiles and Kconfig
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.24logfs/fs/Kconfig~logfs	2008-03-24 12:39:10.190939342 +0100
+++ linux-2.6.24logfs/fs/Kconfig	2008-04-01 19:48:18.517351063 +0200
@@ -1385,6 +1385,23 @@ config JFFS2_CMODE_FAVOURLZO
 
 endchoice
 
+config LOGFS
+	bool "Log Filesystem (EXPERIMENTAL)"
+	depends on (MTD || BLOCK) && EXPERIMENTAL
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	select CRC32
+	help
+	  Flash filesystem aimed to scale efficiently to large devices.
+	  In comparison to JFFS2 it offers significantly faster mount
+	  times and potentially less RAM usage, although the latter has
+	  not been measured yet.
+
+	  In its current state it is still very experimental and should
+	  not be used for other than testing purposes.
+
+	  If unsure, say N.
+
 config CRAMFS
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
--- linux-2.6.24logfs/fs/Makefile~logfs	2008-03-24 12:39:10.190939342 +0100
+++ linux-2.6.24logfs/fs/Makefile	2008-03-24 12:40:08.127616634 +0100
@@ -99,6 +99,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_LOGFS)		+= logfs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
--- /dev/null	2008-03-30 12:15:48.586669308 +0200
+++ linux-2.6.24logfs/fs/logfs/Makefile	2008-04-01 19:48:07.170961891 +0200
@@ -0,0 +1,14 @@
+obj-$(CONFIG_LOGFS)	+= logfs.o
+
+logfs-y	+= compr.o
+logfs-y	+= dir.o
+logfs-y	+= file.o
+logfs-y	+= gc.o
+logfs-y	+= inode.o
+logfs-y	+= journal.o
+logfs-y	+= memtree.o
+logfs-y	+= readwrite.o
+logfs-y	+= segment.o
+logfs-y	+= super.o
+logfs-$(CONFIG_BLOCK)	+= dev_bdev.o
+logfs-$(CONFIG_MTD)	+= dev_mtd.o

