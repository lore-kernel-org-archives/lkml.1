Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZERQQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZERQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZERQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:13:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZERQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:30 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 28/32] union-mount: Basic fallthru definitions
Date: Mon, 18 May 2009 18:09:24 +0200
Message-Id: <1242662968-11684-29-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

Define the fallthru dcache flag and file system op.

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 include/linux/dcache.h |    6 ++++++
 include/linux/fs.h     |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 7930b07..9534813 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -192,6 +192,7 @@ d_iput:		no		no		no       yes
 #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched */
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 #define DCACHE_WHITEOUT		0x0080	/* This negative dentry is a whiteout */
+#define DCACHE_FALLTHRU		0x0100	/* Keep looking in the file system below */
 
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
@@ -373,6 +374,11 @@ static inline int d_is_whiteout(struct dentry *dentry)
 	return (dentry->d_flags & DCACHE_WHITEOUT);
 }
 
+static inline int d_is_fallthru(struct dentry *dentry)
+{
+	return (dentry->d_flags & DCACHE_FALLTHRU);
+}
+
 static inline struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7f07768..dd9c859 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1351,6 +1351,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
-- 
1.6.1.3

