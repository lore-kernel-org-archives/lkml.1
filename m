Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYAXWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYAXWe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbYAXWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:25 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52057 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbYAXWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:24 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 7/9] bfs: coding style cleanup in include/linux/bfs_fs.h
Date: Fri, 25 Jan 2008 01:32:06 +0300
Message-Id: <1201213928-18183-8-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up errors found by checkpatch.pl.

Before the patch:

$ ./scripts/checkpatch.pl --file  include/linux/bfs_fs.h | grep total
total: 5 errors, 3 warnings, 80 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  include/linux/bfs_fs.h | grep total
total: 0 errors, 0 warnings, 83 lines checked

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 include/linux/bfs_fs.h |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/bfs_fs.h b/include/linux/bfs_fs.h
index 8ed6dfd..d7b11a6 100644
--- a/include/linux/bfs_fs.h
+++ b/include/linux/bfs_fs.h
@@ -36,7 +36,7 @@ struct bfs_inode {
 	__u32 i_padding[4];
 };
 
-#define BFS_NAMELEN		14	
+#define BFS_NAMELEN		14
 #define BFS_DIRENT_SIZE		16
 #define BFS_DIRS_PER_BLOCK	32
 
@@ -61,20 +61,23 @@ struct bfs_super_block {
 
 
 #define BFS_OFF2INO(offset) \
-        ((((offset) - BFS_BSIZE) / sizeof(struct bfs_inode)) + BFS_ROOT_INO)
+	((((offset) - BFS_BSIZE) / sizeof(struct bfs_inode)) + BFS_ROOT_INO)
 
 #define BFS_INO2OFF(ino) \
 	((__u32)(((ino) - BFS_ROOT_INO) * sizeof(struct bfs_inode)) + BFS_BSIZE)
 #define BFS_NZFILESIZE(ip) \
-        ((le32_to_cpu((ip)->i_eoffset) + 1) -  le32_to_cpu((ip)->i_sblock) * BFS_BSIZE)
+	((le32_to_cpu((ip)->i_eoffset) + 1) - \
+	 le32_to_cpu((ip)->i_sblock) * BFS_BSIZE)
 
 #define BFS_FILESIZE(ip) \
-        ((ip)->i_sblock == 0 ? 0 : BFS_NZFILESIZE(ip))
+	((ip)->i_sblock == 0 ? 0 : BFS_NZFILESIZE(ip))
 
 #define BFS_FILEBLOCKS(ip) \
-        ((ip)->i_sblock == 0 ? 0 : (le32_to_cpu((ip)->i_eblock) + 1) -  le32_to_cpu((ip)->i_sblock))
+	((ip)->i_sblock == 0 ? 0 : (le32_to_cpu((ip)->i_eblock) + 1) - \
+	 le32_to_cpu((ip)->i_sblock))
 #define BFS_UNCLEAN(bfs_sb, sb)	\
-	((le32_to_cpu(bfs_sb->s_from) != -1) && (le32_to_cpu(bfs_sb->s_to) != -1) && !(sb->s_flags & MS_RDONLY))
-
+	((le32_to_cpu(bfs_sb->s_from) != -1) && \
+	(le32_to_cpu(bfs_sb->s_to) != -1) && \
+	!(sb->s_flags & MS_RDONLY))
 
 #endif	/* _LINUX_BFS_FS_H */
-- 
1.5.3

