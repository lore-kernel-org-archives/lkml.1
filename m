Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZIHW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZIHW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZIHW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:58:09 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57563 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZIHW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:57:42 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 20/20] ceph: Kconfig, Makefile
Date: Tue,  8 Sep 2009 15:56:41 -0700
Message-Id: <1252450601-17610-21-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1252450601-17610-20-git-send-email-sage@newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
 <1252450601-17610-2-git-send-email-sage@newdream.net>
 <1252450601-17610-3-git-send-email-sage@newdream.net>
 <1252450601-17610-4-git-send-email-sage@newdream.net>
 <1252450601-17610-5-git-send-email-sage@newdream.net>
 <1252450601-17610-6-git-send-email-sage@newdream.net>
 <1252450601-17610-7-git-send-email-sage@newdream.net>
 <1252450601-17610-8-git-send-email-sage@newdream.net>
 <1252450601-17610-9-git-send-email-sage@newdream.net>
 <1252450601-17610-10-git-send-email-sage@newdream.net>
 <1252450601-17610-11-git-send-email-sage@newdream.net>
 <1252450601-17610-12-git-send-email-sage@newdream.net>
 <1252450601-17610-13-git-send-email-sage@newdream.net>
 <1252450601-17610-14-git-send-email-sage@newdream.net>
 <1252450601-17610-15-git-send-email-sage@newdream.net>
 <1252450601-17610-16-git-send-email-sage@newdream.net>
 <1252450601-17610-17-git-send-email-sage@newdream.net>
 <1252450601-17610-18-git-send-email-sage@newdream.net>
 <1252450601-17610-19-git-send-email-sage@newdream.net>
 <1252450601-17610-20-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options and Makefile.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/Kconfig       |    1 +
 fs/Makefile      |    1 +
 fs/ceph/Kconfig  |   26 ++++++++++++++++++++++++++
 fs/ceph/Makefile |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/Kconfig
 create mode 100644 fs/ceph/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index 0e7da7b..fe7341c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -233,6 +233,7 @@ config NFS_COMMON
 
 source "net/sunrpc/Kconfig"
 source "fs/smbfs/Kconfig"
+source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
 source "fs/ncpfs/Kconfig"
 source "fs/coda/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..5ef73a0 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
+obj-$(CONFIG_CEPH_FS)		+= ceph/
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
new file mode 100644
index 0000000..bc1fbd9
--- /dev/null
+++ b/fs/ceph/Kconfig
@@ -0,0 +1,26 @@
+config CEPH_FS
+        tristate "Ceph distributed file system (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
+	select LIBCRC32C
+	help
+	  Choose Y or M here to include support for mounting the
+	  experimental Ceph distributed file system.  Ceph is an extremely
+	  scalable file system designed to provide high performance,
+	  reliable access to petabytes of storage.
+
+	  More information at http://ceph.newdream.net/.
+
+	  If unsure, say N.
+
+config CEPH_FS_PRETTYDEBUG
+	bool "Include file:line in ceph debug output"
+	depends on CEPH_FS
+	default n
+	help
+	  If you say Y here, debug output will include a filename and
+	  line to aid debugging.  This icnreases kernel size and slows
+	  execution slightly when debug call sites are enabled (e.g.,
+	  via CONFIG_DYNAMIC_DEBUG).
+
+	  If unsure, say N.
+
diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
new file mode 100644
index 0000000..ba1e6a5
--- /dev/null
+++ b/fs/ceph/Makefile
@@ -0,0 +1,35 @@
+#
+# Makefile for CEPH filesystem.
+#
+
+ifneq ($(KERNELRELEASE),)
+
+obj-$(CONFIG_CEPH_FS) += ceph.o
+
+ceph-objs := super.o inode.o dir.o file.o addr.o ioctl.o \
+	export.o caps.o snap.o \
+	messenger.o \
+	mds_client.o mdsmap.o \
+	mon_client.o \
+	osd_client.o osdmap.o crush/crush.o crush/mapper.o \
+	debugfs.o
+
+else
+#Otherwise we were called directly from the command
+# line; invoke the kernel build system.
+
+KERNELDIR ?= /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+
+default: all
+
+all:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules
+
+modules_install:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules_install
+
+clean:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
+
+endif
-- 
1.5.6.5

