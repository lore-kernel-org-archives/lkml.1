Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYAXWdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYAXWdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbYAXWcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:23 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52056 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYAXWcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:22 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 5/9] bfs: move function prototype to the proper header file
Date: Fri, 25 Jan 2008 01:32:04 +0300
Message-Id: <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dump_imap() routine is defined in bs/bfs/inode.c and used both in
the same file and in fs/bfs/dir.c. This patch adds an extern function
declaration to the private bfs.h header file.

The effect is that one warning issued by checkpatch.pl is gone.

Before the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 0 errors, 1 warnings, 370 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 0 errors, 0 warnings, 368 lines checked

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/bfs.h   |    3 +++
 fs/bfs/dir.c   |    2 --
 fs/bfs/inode.c |    2 --
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 090b96e..ecc74bb 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -54,4 +54,7 @@ extern const struct address_space_operations bfs_aops;
 extern const struct inode_operations bfs_dir_inops;
 extern const struct file_operations bfs_dir_operations;
 
+/* inode.c */
+extern void dump_imap(const char *, struct super_block *);
+
 #endif /* _FS_BFS_BFS_H */
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 5462a5b..2964505 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -81,8 +81,6 @@ const struct file_operations bfs_dir_operations = {
 	.fsync		= file_fsync,
 };
 
-extern void dump_imap(const char *, struct super_block *);
-
 static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 						struct nameidata *nd)
 {
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 5191990..91d5686 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -30,8 +30,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block *s);
-
 static void bfs_read_inode(struct inode *inode)
 {
 	unsigned long ino = inode->i_ino;
-- 
1.5.3

