Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZCAJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZCAJWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCAJVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:21:25 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:46103 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbZCAJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:21:19 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent@lvivier.info>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/6] m68k: Add install target
Date: Sun,  1 Mar 2009 10:21:10 +0100
Message-Id: <1235899275-23630-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235899275-23630-1-git-send-email-geert@linux-m68k.org>
References: <1235899275-23630-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent@lvivier.info>

This patch enables the use of "make install" on m68k architecture
to copy kernel to /boot.

Signed-off-by: Laurent Vivier <Laurent@lvivier.info>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile   |    3 ++
 arch/m68k/install.sh |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 arch/m68k/install.sh

diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 8133dbc..570d85c 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -117,3 +117,6 @@ endif
 
 archclean:
 	rm -f vmlinux.gz vmlinux.bz2
+
+install:
+	sh $(srctree)/arch/m68k/install.sh $(KERNELRELEASE) vmlinux.gz System.map "$(INSTALL_PATH)"
diff --git a/arch/m68k/install.sh b/arch/m68k/install.sh
new file mode 100644
index 0000000..9c6bae6
--- /dev/null
+++ b/arch/m68k/install.sh
@@ -0,0 +1,52 @@
+#!/bin/sh
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1995 by Linus Torvalds
+#
+# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
+#
+# "make install" script for m68k architecture
+#
+# Arguments:
+#   $1 - kernel version
+#   $2 - kernel image file
+#   $3 - kernel map file
+#   $4 - default install path (blank if root directory)
+#
+
+verify () {
+	if [ ! -f "$1" ]; then
+		echo ""                                                   1>&2
+		echo " *** Missing file: $1"                              1>&2
+		echo ' *** You need to run "make" before "make install".' 1>&2
+		echo ""                                                   1>&2
+		exit 1
+	fi
+}
+
+# Make sure the files actually exist
+verify "$2"
+verify "$3"
+
+# User may have a custom install script
+
+if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
+if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
+
+# Default install - same as make zlilo
+
+if [ -f $4/vmlinuz ]; then
+	mv $4/vmlinuz $4/vmlinuz.old
+fi
+
+if [ -f $4/System.map ]; then
+	mv $4/System.map $4/System.old
+fi
+
+cat $2 > $4/vmlinuz
+cp $3 $4/System.map
+
+sync
-- 
1.6.1.3

