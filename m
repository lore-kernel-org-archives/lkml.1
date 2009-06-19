Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbZFSWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbZFSWhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbZFSWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44736 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbZFSWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:08 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 21/21] ceph: Kconfig, Makefile
Date: Fri, 19 Jun 2009 15:31:42 -0700
Message-Id: <1245450702-31343-22-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245450702-31343-21-git-send-email-sage@newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <1245450702-31343-2-git-send-email-sage@newdream.net>
 <1245450702-31343-3-git-send-email-sage@newdream.net>
 <1245450702-31343-4-git-send-email-sage@newdream.net>
 <1245450702-31343-5-git-send-email-sage@newdream.net>
 <1245450702-31343-6-git-send-email-sage@newdream.net>
 <1245450702-31343-7-git-send-email-sage@newdream.net>
 <1245450702-31343-8-git-send-email-sage@newdream.net>
 <1245450702-31343-9-git-send-email-sage@newdream.net>
 <1245450702-31343-10-git-send-email-sage@newdream.net>
 <1245450702-31343-11-git-send-email-sage@newdream.net>
 <1245450702-31343-12-git-send-email-sage@newdream.net>
 <1245450702-31343-13-git-send-email-sage@newdream.net>
 <1245450702-31343-14-git-send-email-sage@newdream.net>
 <1245450702-31343-15-git-send-email-sage@newdream.net>
 <1245450702-31343-16-git-send-email-sage@newdream.net>
 <1245450702-31343-17-git-send-email-sage@newdream.net>
 <1245450702-31343-18-git-send-email-sage@newdream.net>
 <1245450702-31343-19-git-send-email-sage@newdream.net>
 <1245450702-31343-20-git-send-email-sage@newdream.net>
 <1245450702-31343-21-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options and Makefile.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/staging/Kconfig       |    2 ++
 fs/staging/Makefile      |    1 +
 fs/staging/ceph/Kconfig  |   14 ++++++++++++++
 fs/staging/ceph/Makefile |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100644 fs/staging/ceph/Kconfig
 create mode 100644 fs/staging/ceph/Makefile

diff --git a/fs/staging/Kconfig b/fs/staging/Kconfig
index 605d8ae..bed45e4 100644
--- a/fs/staging/Kconfig
+++ b/fs/staging/Kconfig
@@ -42,5 +42,7 @@ config FSSTAGING_EXCLUDE_BUILD
 
 if !FSSTAGING_EXCLUDE_BUILD
 
+source "fs/staging/ceph/Kconfig"
+
 endif # !FSSTAGING_EXCLUDE_BUILD
 endif # FSSTAGING
diff --git a/fs/staging/Makefile b/fs/staging/Makefile
index 7ddeb16..38c9d39 100644
--- a/fs/staging/Makefile
+++ b/fs/staging/Makefile
@@ -3,3 +3,4 @@
 # fix for build system bug...
 obj-$(CONFIG_FSSTAGING)		+= fsstaging.o
 
+obj-$(CONFIG_CEPH_FS)		+= ceph/
\ No newline at end of file
diff --git a/fs/staging/ceph/Kconfig b/fs/staging/ceph/Kconfig
new file mode 100644
index 0000000..32090d3
--- /dev/null
+++ b/fs/staging/ceph/Kconfig
@@ -0,0 +1,14 @@
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
diff --git a/fs/staging/ceph/Makefile b/fs/staging/ceph/Makefile
new file mode 100644
index 0000000..ba1e6a5
--- /dev/null
+++ b/fs/staging/ceph/Makefile
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

