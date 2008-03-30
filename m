Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYC3Dc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYC3Dc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 23:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYC3DcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 23:32:20 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:45440 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYC3DcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 23:32:19 -0400
Date: Sat, 29 Mar 2008 23:32:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 7/7] fs: update kbuild to include OMFS
Message-ID: <20080330033212.GE18825@hash.localnet>
References: <1206578760-9050-7-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206578760-9050-7-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this patch including changes:
 - select CRC_ITU_T for crc

>From a12ce5ce080c2c442a4fffa58a04a13abc688da7 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sat, 22 Mar 2008 15:02:37 -0400
Subject: [PATCH] fs: update kbuild to include OMFS

Adds OMFS to the fs Kconfig and Makefile

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/Kconfig       |   13 +++++++++++++
 fs/Makefile      |    1 +
 fs/omfs/Makefile |    7 +++++++
 3 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..33bb755 100644
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
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com 

