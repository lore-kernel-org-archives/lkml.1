Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZJEWz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZJEWz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZJEWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:55:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49329 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZJEWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:53:08 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 21/21] ceph: Kconfig, Makefile
Date: Mon,  5 Oct 2009 15:50:51 -0700
Message-Id: <1254783051-26217-22-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1254783051-26217-21-git-send-email-sage@newdream.net>
References: <1254783051-26217-1-git-send-email-sage@newdream.net>
 <1254783051-26217-2-git-send-email-sage@newdream.net>
 <1254783051-26217-3-git-send-email-sage@newdream.net>
 <1254783051-26217-4-git-send-email-sage@newdream.net>
 <1254783051-26217-5-git-send-email-sage@newdream.net>
 <1254783051-26217-6-git-send-email-sage@newdream.net>
 <1254783051-26217-7-git-send-email-sage@newdream.net>
 <1254783051-26217-8-git-send-email-sage@newdream.net>
 <1254783051-26217-9-git-send-email-sage@newdream.net>
 <1254783051-26217-10-git-send-email-sage@newdream.net>
 <1254783051-26217-11-git-send-email-sage@newdream.net>
 <1254783051-26217-12-git-send-email-sage@newdream.net>
 <1254783051-26217-13-git-send-email-sage@newdream.net>
 <1254783051-26217-14-git-send-email-sage@newdream.net>
 <1254783051-26217-15-git-send-email-sage@newdream.net>
 <1254783051-26217-16-git-send-email-sage@newdream.net>
 <1254783051-26217-17-git-send-email-sage@newdream.net>
 <1254783051-26217-18-git-send-email-sage@newdream.net>
 <1254783051-26217-19-git-send-email-sage@newdream.net>
 <1254783051-26217-20-git-send-email-sage@newdream.net>
 <1254783051-26217-21-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options and Makefile.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 MAINTAINERS      |    9 +++++++++
 fs/ceph/Kconfig  |   26 ++++++++++++++++++++++++++
 fs/ceph/Makefile |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/Kconfig
 create mode 100644 fs/ceph/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 09a2028..a39545a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1314,6 +1314,15 @@ F:	arch/powerpc/include/asm/spu*.h
 F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
+CEPH DISTRIBUTED FILE SYSTEM CLIENT
+M:	Sage Weil <sage@newdream.net>
+L:	ceph-devel@lists.sourceforge.net
+W:	http://ceph.newdream.net/
+T:	git git://ceph.newdream.net/linux-ceph-client.git
+S:	Supported
+F:	Documentation/filesystems/ceph.txt
+F:	fs/ceph
+
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
 M:	David Vrabel <david.vrabel@csr.com>
 L:	linux-usb@vger.kernel.org
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
index 0000000..7da6d69
--- /dev/null
+++ b/fs/ceph/Makefile
@@ -0,0 +1,36 @@
+#
+# Makefile for CEPH filesystem.
+#
+
+ifneq ($(KERNELRELEASE),)
+
+obj-$(CONFIG_CEPH_FS) += ceph.o
+
+ceph-objs := super.o inode.o dir.o file.o addr.o ioctl.o \
+	export.o caps.o snap.o xattr.o \
+	messenger.o msgpool.o buffer.o \
+	mds_client.o mdsmap.o \
+	mon_client.o \
+	osd_client.o osdmap.o crush/crush.o crush/mapper.o \
+	debugfs.o \
+	ceph_fs.o ceph_strings.o ceph_frag.o
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

