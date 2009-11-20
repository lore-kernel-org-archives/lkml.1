Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZKTUV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZKTUV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZKTUV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:21:57 -0500
Received: from lazybastard.de ([212.112.238.170]:48487 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZKTUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:21:56 -0500
X-Greylist: delayed 2601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 15:21:56 EST
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
From: Joern Engel <joern@logfs.org>
Subject: [PATCH 17/17] [LogFS] Kconfig and Makefile
References: <20091120181113.GA2159@logfs.org>
Message-Id: <E1NBZJU-0003iQ-Th@longford.logfs.org>
Date: Fri, 20 Nov 2009 20:38:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/Kconfig                          |    1 +
 fs/Makefile                         |    1 +
 fs/logfs/Kconfig                    |   17 +
 fs/logfs/Makefile                   |   13 +
 lib/Kconfig                         |    3 +
 lib/Makefile                        |    1 +

diff --git a/fs/Kconfig b/fs/Kconfig
index 64d44ef..7405f07 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -177,6 +177,7 @@ source "fs/efs/Kconfig"
 source "fs/jffs2/Kconfig"
 # UBIFS File system configuration
 source "fs/ubifs/Kconfig"
+source "fs/logfs/Kconfig"
 source "fs/cramfs/Kconfig"
 source "fs/squashfs/Kconfig"
 source "fs/freevxfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..c3633aa 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
+obj-$(CONFIG_LOGFS)		+= logfs/
 obj-$(CONFIG_UBIFS_FS)		+= ubifs/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
diff --git a/fs/logfs/Kconfig b/fs/logfs/Kconfig
new file mode 100644
index 0000000..daf9a9b
--- /dev/null
+++ b/fs/logfs/Kconfig
@@ -0,0 +1,17 @@
+config LOGFS
+	tristate "LogFS file system (EXPERIMENTAL)"
+	depends on (MTD || BLOCK) && EXPERIMENTAL
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	select CRC32
+	select BTREE
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
diff --git a/fs/logfs/Makefile b/fs/logfs/Makefile
new file mode 100644
index 0000000..4820027
--- /dev/null
+++ b/fs/logfs/Makefile
@@ -0,0 +1,13 @@
+obj-$(CONFIG_LOGFS)	+= logfs.o
+
+logfs-y	+= compr.o
+logfs-y	+= dir.o
+logfs-y	+= file.o
+logfs-y	+= gc.o
+logfs-y	+= inode.o
+logfs-y	+= journal.o
+logfs-y	+= readwrite.o
+logfs-y	+= segment.o
+logfs-y	+= super.o
+logfs-$(CONFIG_BLOCK)	+= dev_bdev.o
+logfs-$(CONFIG_MTD)	+= dev_mtd.o
diff --git a/lib/Kconfig b/lib/Kconfig
index bb1326d..277fbfb 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -156,6 +156,9 @@ config TEXTSEARCH_BM
 config TEXTSEARCH_FSM
 	tristate
 
+config BTREE
+	boolean
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 2e78277..cff8261 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -41,6 +41,7 @@ lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
+obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
