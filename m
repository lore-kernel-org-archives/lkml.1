Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbXIZD3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbXIZD3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbXIZD25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:28:57 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34876 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbXIZD2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:28:55 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/25] Unionfs: display informational messages only if debug is on
Date: Tue, 25 Sep 2007 23:09:42 -0400
Message-Id: <11907762061611-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is to avoid filling the console/logs with messages that are primarily
of debugging use.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    4 ++--
 fs/unionfs/dentry.c     |    6 +++---
 fs/unionfs/union.h      |    4 ++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 87cbb09..e69ccf6 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -394,8 +394,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
 	    is_robranch(dentry)) {
-		printk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
-		       dentry->d_name.name);
+		dprintk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
+			dentry->d_name.name);
 		err = do_delayed_copyup(file);
 	}
 
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 9e0742d..08b5722 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -46,9 +46,9 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 
 	/* if the dentry is unhashed, do NOT revalidate */
 	if (d_deleted(dentry)) {
-		printk(KERN_DEBUG "unionfs: unhashed dentry being "
-		       "revalidated: %*s\n",
-		       dentry->d_name.len, dentry->d_name.name);
+		dprintk(KERN_DEBUG "unionfs: unhashed dentry being "
+			"revalidated: %*s\n",
+			dentry->d_name.len, dentry->d_name.name);
 		goto out;
 	}
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 140b8ae..5e9843b 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -507,6 +507,8 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 
 #ifdef CONFIG_UNION_FS_DEBUG
 
+#define dprintk(args...)		printk(args)
+
 /* useful for tracking code reachability */
 #define UDBG printk("DBG:%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)
 
@@ -543,6 +545,8 @@ extern void __show_inode_counts(const struct inode *inode,
 
 #else /* not CONFIG_UNION_FS_DEBUG */
 
+#define dprintk(args...)		do { } while (0)
+
 /* we leave useful hooks for these check functions throughout the code */
 #define unionfs_check_inode(i)		do { } while(0)
 #define unionfs_check_dentry(d)	do { } while(0)
-- 
1.5.2.2

