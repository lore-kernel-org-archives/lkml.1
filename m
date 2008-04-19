Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYDSUjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYDSUjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYDSUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:38:59 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:44830 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbYDSUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:38:58 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, miklos@szeredi.hu,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 7/8] omfs: update kbuild to include OMFS
Date: Sat, 19 Apr 2008 16:37:36 -0400
Message-Id: <1208637457-24969-8-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Adds OMFS to the fs Kconfig and Makefile

    Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
 fs/Kconfig       |   13 +++++++++++++
 fs/Makefile      |    1 +
 fs/omfs/Makefile |    4 ++++
 3 files changed, 18 insertions(+)

Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig	2008-04-19 12:51:44.000000000 -0400
+++ linux-2.6/fs/Kconfig	2008-04-19 12:52:45.000000000 -0400
@@ -1461,6 +1461,19 @@
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
 
+config OMFS_FS
+	tristate "SonicBlue Optimized MPEG File System support"
+	depends on BLOCK
+	select CRC_ITU_T
+	help
+	  This is the proprietary file system used by the Rio Karma music
+	  player and ReplayTV DVR.  Despite the name, this filesystem is not
+	  more efficient than a standard FS for MPEG files, in fact likely
+	  the opposite is true.  Say Y if you have either of these devices
+	  and wish to mount its disk.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called omfs.  If unsure, say N.
 
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile	2008-04-19 12:51:44.000000000 -0400
+++ linux-2.6/fs/Makefile	2008-04-19 12:52:45.000000000 -0400
@@ -121,3 +121,4 @@
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_UNION_FS)		+= unionfs/
+obj-$(CONFIG_OMFS_FS)		+= omfs/
Index: linux-2.6/fs/omfs/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/omfs/Makefile	2008-04-19 12:52:45.000000000 -0400
@@ -0,0 +1,4 @@
+
+obj-$(CONFIG_OMFS_FS) += omfs.o
+
+omfs-y := bitmap.o dir.o file.o inode.o

