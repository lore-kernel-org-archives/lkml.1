Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYINTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYINTIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYINTIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:08:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:50923 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYINTId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:08:33 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 27/27] nilfs2: update makefile and Kconfig
Date: Mon, 15 Sep 2008 04:08:24 +0900
Message-Id: <1221419304-18572-28-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1221419304-18572-27-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-14-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-15-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-16-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-20-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-21-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-22-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-23-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-24-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-25-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-26-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-27-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a Makefile for the nilfs2 file system, and updates the
makefile and Kconfig file in the file system directory.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/Kconfig         |   26 ++++++++++++++++++++++++++
 fs/Makefile        |    1 +
 fs/nilfs2/Makefile |    5 +++++
 3 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 fs/nilfs2/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index abccb5d..294092c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1383,6 +1383,32 @@ config MINIX_FS
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
 
+config NILFS2_FS
+	tristate "NILFS2 file system support (EXPERIMENTAL)"
+	depends on BLOCK && EXPERIMENTAL
+	select CRC32
+	help
+	  NILFS2 is a log-structured file system (LFS) supporting continuous
+	  snapshotting.  In addition to versioning capability of the entire
+	  file system, users can even restore files mistakenly overwritten or
+	  destroyed just a few seconds ago.  Since this file system can keep
+	  consistency like conventional LFS, it achieves quick recovery after
+	  system crashes.
+
+	  NILFS2 creates a number of checkpoints every few seconds or per
+	  synchronous write basis (unless there is no change).  Users can
+	  select significant versions among continuously created checkpoints,
+	  and can change them into snapshots which will be preserved for long
+	  periods until they are changed back to checkpoints.  Each
+	  snapshot is mountable as a read-only file system concurrently with
+	  its writable mount, and this feature is convenient for online backup.
+
+	  Some features including atime, extended attributes, and POSIX ACLs,
+	  are not supported yet.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called nilfs2.  If unsure, say N.
+
 config OMFS_FS
 	tristate "SonicBlue Optimized MPEG File System support"
 	depends on BLOCK
diff --git a/fs/Makefile b/fs/Makefile
index a1482a5..ddcf879 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,3 +122,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_NILFS2_FS)		+= nilfs2/
diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
new file mode 100644
index 0000000..df3e62c
--- /dev/null
+++ b/fs/nilfs2/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_NILFS2_FS) += nilfs2.o
+nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
+	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
+	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
+	ifile.o alloc.o gcinode.o ioctl.o gcdat.o
-- 
1.5.6.3

