Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZGLC6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZGLC6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 22:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZGLC6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 22:58:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:39827 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZGLC6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 22:58:24 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] fs/Kconfig: move nilfs2 out
Date: Sun, 12 Jul 2009 11:52:48 +0900
Message-Id: <1247367168-30734-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.3.3
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 12 Jul 2009 11:58:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/Kconfig file was split into individual fs/*/Kconfig files before
nilfs was merged.  I've found the current config entry of nilfs is
tainting the work.  Sorry, I didn't notice.  This fixes the violation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/Kconfig        |   27 +--------------------------
 fs/nilfs2/Kconfig |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)
 create mode 100644 fs/nilfs2/Kconfig

diff --git a/fs/Kconfig b/fs/Kconfig
index a97263b..0e7da7b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -186,32 +186,7 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
-
-config NILFS2_FS
-	tristate "NILFS2 file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
-	select CRC32
-	help
-	  NILFS2 is a log-structured file system (LFS) supporting continuous
-	  snapshotting.  In addition to versioning capability of the entire
-	  file system, users can even restore files mistakenly overwritten or
-	  destroyed just a few seconds ago.  Since this file system can keep
-	  consistency like conventional LFS, it achieves quick recovery after
-	  system crashes.
-
-	  NILFS2 creates a number of checkpoints every few seconds or per
-	  synchronous write basis (unless there is no change).  Users can
-	  select significant versions among continuously created checkpoints,
-	  and can change them into snapshots which will be preserved for long
-	  periods until they are changed back to checkpoints.  Each
-	  snapshot is mountable as a read-only file system concurrently with
-	  its writable mount, and this feature is convenient for online backup.
-
-	  Some features including atime, extended attributes, and POSIX ACLs,
-	  are not supported yet.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called nilfs2.  If unsure, say N.
+source "fs/nilfs2/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
new file mode 100644
index 0000000..72da095
--- /dev/null
+++ b/fs/nilfs2/Kconfig
@@ -0,0 +1,25 @@
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
-- 
1.6.3.3

