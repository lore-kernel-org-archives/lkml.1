Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYDLXBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYDLXBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYDLW7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:59:07 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35386 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYDLW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 7/7] omfs: update kbuild to include OMFS
Date: Sat, 12 Apr 2008 18:58:41 -0400
Message-Id: <1208041121-26787-8-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Adds OMFS to the fs Kconfig and Makefile

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/Kconfig       |   13 +++++++++++++
 fs/Makefile      |    1 +
 fs/omfs/Makefile |    7 +++++++
 3 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index c509123..5dd8f94 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1418,6 +1418,19 @@ config HPFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called hpfs.  If unsure, say N.
 
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
 
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
diff --git a/fs/Makefile b/fs/Makefile
index 1e7a11b..68decdd 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -119,3 +119,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_OMFS_FS)		+= omfs/
diff --git a/fs/omfs/Makefile b/fs/omfs/Makefile
new file mode 100644
index 0000000..d17d9ac
--- /dev/null
+++ b/fs/omfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux omfs filesystem routines.
+#
+
+obj-$(CONFIG_OMFS_FS) += omfs.o
+
+omfs-objs := bitmap.o checksum.o dir.o file.o inode.o
-- 
1.5.4.2


