Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXEFRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXEFRmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXEFRmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:42:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60172 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXEFRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:42:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 5/5] fs: Remove path_walk export
Date: Sun,  6 May 2007 13:41:29 -0400
Message-Id: <11784732902360-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c            |    3 +--
 include/linux/namei.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d9eb621..7a98676 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1026,7 +1026,7 @@ static int fastcall link_path_walk(const char *name, struct nameidata *nd)
 	return result;
 }
 
-int fastcall path_walk(const char * name, struct nameidata *nd)
+static int fastcall path_walk(const char * name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
@@ -2835,7 +2835,6 @@ EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(path_release);
-EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d60a5eb..e378e1f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -72,7 +72,6 @@ extern int FASTCALL(__user_walk_fd(int dfd, const char __user *, unsigned, struc
 extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
-extern int FASTCALL(path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
 extern void path_release_on_umount(struct nameidata *);
 
-- 
1.5.2.rc1.20.g86b9

