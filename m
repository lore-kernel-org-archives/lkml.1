Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZKZDWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZKZDWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbZKZDWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:22:42 -0500
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:14645
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271AbZKZDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:22:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACiDDUt8qYZ9/2dsb2JhbACER78YggOOXYEvdQIHgTBVBIMHikQ
X-IronPort-AV: E=Sophos;i="4.47,290,1257091200"; 
   d="scan'208";a="583332897"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 3/3] autofs - use consistent function naming
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 26 Nov 2009 11:22:09 +0800
Message-ID: <20091126032209.5691.97987.stgit@zeus.themaw.net>
In-Reply-To: <20091126030623.5691.33759.stgit@zeus.themaw.net>
References: <20091126030623.5691.33759.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 fs/autofs/autofs_i.h  |   94 +++++++--------
 fs/autofs/dev-ioctl.c |   18 +--
 fs/autofs/expire.c    |  117 +++++++++---------
 fs/autofs/init.c      |   12 +-
 fs/autofs/inode.c     |   59 +++++----
 fs/autofs/root.c      |  312 +++++++++++++++++++++++++------------------------
 fs/autofs/symlink.c   |    8 +
 fs/autofs/waitq.c     |   52 ++++----
 8 files changed, 334 insertions(+), 338 deletions(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index b4a0d82..e33b246 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -145,30 +145,30 @@ struct autofs_sb_info {
 	struct list_head expiring_list;
 };
 
-static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
+static inline struct autofs_sb_info *autofs_sbi(struct super_block *sb)
 {
 	return (struct autofs_sb_info *)(sb->s_fs_info);
 }
 
-static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
+static inline struct autofs_info *autofs_dentry_ino(struct dentry *dentry)
 {
 	return (struct autofs_info *)(dentry->d_fsdata);
 }
 
 /*
- * autofs4_oz_mode(): do we see the man behind the curtain?  (The
+ * autofs_oz_mode(): do we see the man behind the curtain?  (The
  * processes which do manipulations for us in user space sees the raw
  * filesystem without "magic".)
  */
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+static inline int autofs_oz_mode(struct autofs_sb_info *sbi)
 {
 	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
-static inline int autofs4_ispending(struct dentry *dentry)
+static inline int autofs_ispending(struct dentry *dentry)
 {
-	struct autofs_info *inf = autofs4_dentry_ino(dentry);
+	struct autofs_info *inf = autofs_dentry_ino(dentry);
 
 	if (inf->flags & AUTOFS_INF_PENDING)
 		return 1;
@@ -179,32 +179,32 @@ static inline int autofs4_ispending(struct dentry *dentry)
 	return 0;
 }
 
-static inline void autofs4_copy_atime(struct file *src, struct file *dst)
+static inline void autofs_copy_atime(struct file *src, struct file *dst)
 {
 	dst->f_path.dentry->d_inode->i_atime =
 		src->f_path.dentry->d_inode->i_atime;
 	return;
 }
 
-struct inode *autofs4_get_inode(struct super_block *, struct autofs_info *);
-void autofs4_free_ino(struct autofs_info *);
+struct inode *autofs_get_inode(struct super_block *, struct autofs_info *);
+void autofs_free_ino(struct autofs_info *);
 
 /* Expiration */
-int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry);
-int autofs4_expire_run(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *,
-			struct autofs_packet_expire __user *);
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when);
-int autofs4_expire_multi(struct super_block *, struct vfsmount *,
+int is_autofs_dentry(struct dentry *);
+int autofs_expire_wait(struct dentry *dentry);
+int autofs_expire_run(struct super_block *, struct vfsmount *,
+		      struct autofs_sb_info *,
+		      struct autofs_packet_expire __user *);
+int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when);
+int autofs_expire_multi(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *, int __user *);
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi, int how);
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi, int how);
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi, int how);
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi, int how);
 
 /* Device node initialization */
 
@@ -213,27 +213,27 @@ void autofs_dev_ioctl_exit(void);
 
 /* Operations structures */
 
-extern const struct inode_operations autofs4_symlink_inode_operations;
-extern const struct inode_operations autofs4_dir_inode_operations;
-extern const struct inode_operations autofs4_root_inode_operations;
-extern const struct inode_operations autofs4_indirect_root_inode_operations;
-extern const struct inode_operations autofs4_direct_root_inode_operations;
-extern const struct file_operations autofs4_dir_operations;
-extern const struct file_operations autofs4_root_operations;
+extern const struct inode_operations autofs_symlink_inode_operations;
+extern const struct inode_operations autofs_dir_inode_operations;
+extern const struct inode_operations autofs_root_inode_operations;
+extern const struct inode_operations autofs_indirect_root_inode_operations;
+extern const struct inode_operations autofs_direct_root_inode_operations;
+extern const struct file_operations autofs_dir_operations;
+extern const struct file_operations autofs_root_operations;
 
 /* Initializing function */
 
-int autofs4_fill_super(struct super_block *, void *, int);
-struct autofs_info *autofs4_init_ino(struct autofs_info *,
-				     struct autofs_sb_info *, mode_t);
+int autofs_fill_super(struct super_block *, void *, int);
+struct autofs_info *autofs_init_ino(struct autofs_info *,
+				    struct autofs_sb_info *, mode_t);
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
-void autofs4_catatonic_mode(struct autofs_sb_info *);
+int autofs_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
+void autofs_catatonic_mode(struct autofs_sb_info *);
 
-static inline int autofs4_follow_mount(struct path *path)
+static inline int autofs_follow_mount(struct path *path)
 {
 	int res = 0;
 
@@ -246,12 +246,12 @@ static inline int autofs4_follow_mount(struct path *path)
 	return res;
 }
 
-static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
+static inline u32 autofs_get_dev(struct autofs_sb_info *sbi)
 {
 	return new_encode_dev(sbi->sb->s_dev);
 }
 
-static inline u64 autofs4_get_ino(struct autofs_sb_info *sbi)
+static inline u64 autofs_get_ino(struct autofs_sb_info *sbi)
 {
 	return sbi->sb->s_root->d_inode->i_ino;
 }
@@ -274,10 +274,10 @@ out:
 	return ret;
 }
 
-static inline void autofs4_add_expiring(struct dentry *dentry)
+static inline void autofs_add_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (list_empty(&ino->expiring))
@@ -287,10 +287,10 @@ static inline void autofs4_add_expiring(struct dentry *dentry)
 	return;
 }
 
-static inline void autofs4_del_expiring(struct dentry *dentry)
+static inline void autofs_del_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
@@ -300,5 +300,5 @@ static inline void autofs4_del_expiring(struct dentry *dentry)
 	return;
 }
 
-void autofs4_dentry_release(struct dentry *);
-extern void autofs4_kill_sb(struct super_block *);
+void autofs_dentry_release(struct dentry *);
+extern void autofs_kill_sb(struct super_block *);
diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
index a0dcc5b..ae357f4 100644
--- a/fs/autofs/dev-ioctl.c
+++ b/fs/autofs/dev-ioctl.c
@@ -168,7 +168,7 @@ static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
 
 	if (f) {
 		inode = f->f_path.dentry->d_inode;
-		sbi = autofs4_sbi(inode->i_sb);
+		sbi = autofs_sbi(inode->i_sb);
 	}
 	return sbi;
 }
@@ -225,7 +225,7 @@ static int test_by_dev(struct path *path, void *p)
 
 static int test_by_type(struct path *path, void *p)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
+	struct autofs_info *ino = autofs_dentry_ino(path->dentry);
 	return ino && ino->sbi->type & *(unsigned *)p;
 }
 
@@ -331,7 +331,7 @@ static int autofs_dev_ioctl_ready(struct file *fp,
 	autofs_wqt_t token;
 
 	token = (autofs_wqt_t) param->ready.token;
-	return autofs4_wait_release(sbi, token, 0);
+	return autofs_wait_release(sbi, token, 0);
 }
 
 /*
@@ -347,7 +347,7 @@ static int autofs_dev_ioctl_fail(struct file *fp,
 
 	token = (autofs_wqt_t) param->fail.token;
 	status = param->fail.status ? param->fail.status : -ENOENT;
-	return autofs4_wait_release(sbi, token, status);
+	return autofs_wait_release(sbi, token, status);
 }
 
 /*
@@ -403,7 +403,7 @@ static int autofs_dev_ioctl_catatonic(struct file *fp,
 				      struct autofs_sb_info *sbi,
 				      struct autofs_dev_ioctl *param)
 {
-	autofs4_catatonic_mode(sbi);
+	autofs_catatonic_mode(sbi);
 	return 0;
 }
 
@@ -450,10 +450,10 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 	if (err)
 		goto out;
 
-	ino = autofs4_dentry_ino(path.dentry);
+	ino = autofs_dentry_ino(path.dentry);
 	if (ino) {
 		err = 0;
-		autofs4_expire_wait(path.dentry);
+		autofs_expire_wait(path.dentry);
 		spin_lock(&sbi->fs_lock);
 		param->requester.uid = ino->uid;
 		param->requester.gid = ino->gid;
@@ -478,7 +478,7 @@ static int autofs_dev_ioctl_expire(struct file *fp,
 	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
-	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
+	return autofs_do_expire_multi(sbi->sb, mnt, sbi, how);
 }
 
 /* Check if autofs mount point is in use */
@@ -696,7 +696,7 @@ _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
 		 * Admin needs to be able to set the mount catatonic in
 		 * order to be able to perform the re-open.
 		 */
-		if (!autofs4_oz_mode(sbi) &&
+		if (!autofs_oz_mode(sbi) &&
 		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
 			err = -EACCES;
 			fput(fp);
diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
index 204c4fe..ad00190 100644
--- a/fs/autofs/expire.c
+++ b/fs/autofs/expire.c
@@ -14,10 +14,10 @@
 static unsigned long now;
 
 /* Check if a dentry can be expired */
-static inline int autofs4_can_expire(struct dentry *dentry,
+static inline int autofs_can_expire(struct dentry *dentry,
 					unsigned long timeout, int do_now)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 
 	/* dentry in the process of being deleted */
 	if (ino == NULL)
@@ -42,7 +42,7 @@ static inline int autofs4_can_expire(struct dentry *dentry,
 }
 
 /* Check a mount point for busyness */
-static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
+static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct dentry *top = dentry;
 	struct path path = {.mnt = mnt, .dentry = dentry};
@@ -56,8 +56,8 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	if (!follow_down(&path))
 		goto done;
 
-	if (is_autofs4_dentry(path.dentry)) {
-		struct autofs_sb_info *sbi = autofs4_sbi(path.dentry->d_sb);
+	if (is_autofs_dentry(path.dentry)) {
+		struct autofs_sb_info *sbi = autofs_sbi(path.dentry->d_sb);
 
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
@@ -75,7 +75,7 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino = autofs_dentry_ino(top);
 		ino->last_used = jiffies;
 		goto done;
 	}
@@ -114,24 +114,23 @@ static struct dentry *next_dentry(struct dentry *p, struct dentry *root)
  * The tree is not busy iff no mountpoints are busy and there are no
  * autofs submounts.
  */
-static int autofs4_direct_busy(struct vfsmount *mnt,
-				struct dentry *top,
-				unsigned long timeout,
-				int do_now)
+static int autofs_direct_busy(struct vfsmount *mnt,
+			      struct dentry *top,
+			      unsigned long timeout, int do_now)
 {
 	DPRINTK("top %p %.*s",
 		top, (int) top->d_name.len, top->d_name.name);
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino = autofs_dentry_ino(top);
 		if (ino)
 			ino->last_used = jiffies;
 		return 1;
 	}
 
 	/* Timeout of a direct mount is determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
+	if (!autofs_can_expire(top, timeout, do_now))
 		return 1;
 
 	return 0;
@@ -140,12 +139,11 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
 /* Check a directory tree of mount points for busyness
  * The tree is not busy iff no mountpoints are busy
  */
-static int autofs4_tree_busy(struct vfsmount *mnt,
+static int autofs_tree_busy(struct vfsmount *mnt,
 			     struct dentry *top,
-			     unsigned long timeout,
-			     int do_now)
+			     unsigned long timeout, int do_now)
 {
-	struct autofs_info *top_ino = autofs4_dentry_ino(top);
+	struct autofs_info *top_ino = autofs_dentry_ino(top);
 	struct dentry *p;
 
 	DPRINTK("top %p %.*s",
@@ -174,13 +172,13 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 		 * If the fs is busy update the expiry counter.
 		 */
 		if (d_mountpoint(p)) {
-			if (autofs4_mount_busy(mnt, p)) {
+			if (autofs_mount_busy(mnt, p)) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
 			}
 		} else {
-			struct autofs_info *ino = autofs4_dentry_ino(p);
+			struct autofs_info *ino = autofs_dentry_ino(p);
 			unsigned int ino_count = atomic_read(&ino->count);
 
 			/*
@@ -207,16 +205,15 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 	spin_unlock(&dcache_lock);
 
 	/* Timeout of a tree mount is ultimately determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
+	if (!autofs_can_expire(top, timeout, do_now))
 		return 1;
 
 	return 0;
 }
 
-static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
-					   struct dentry *parent,
-					   unsigned long timeout,
-					   int do_now)
+static struct dentry *autofs_check_leaves(struct vfsmount *mnt,
+					  struct dentry *parent,
+					  unsigned long timeout, int do_now)
 {
 	struct dentry *p;
 
@@ -237,11 +234,11 @@ static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
 
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, p))
+			if (autofs_mount_busy(mnt, p))
 				goto cont;
 
 			/* Can we expire this guy */
-			if (autofs4_can_expire(p, timeout, do_now))
+			if (autofs_can_expire(p, timeout, do_now))
 				return p;
 		}
 cont:
@@ -253,10 +250,9 @@ cont:
 }
 
 /* Check if we can expire a direct mount (possibly a tree) */
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi,
-				     int how)
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi, int how)
 {
 	unsigned long timeout;
 	struct dentry *root = dget(sb->s_root);
@@ -269,14 +265,14 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 	timeout = sbi->exp_timeout;
 
 	spin_lock(&sbi->fs_lock);
-	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
+	if (!autofs_direct_busy(mnt, root, timeout, do_now)) {
+		struct autofs_info *ino = autofs_dentry_ino(root);
 		if (d_mountpoint(root)) {
 			ino->flags |= AUTOFS_INF_MOUNTPOINT;
 			root->d_mounted--;
 		}
 		ino->flags |= AUTOFS_INF_EXPIRING;
-		autofs4_add_expiring(root);
+		autofs_add_expiring(root);
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		return root;
@@ -293,10 +289,9 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
  *  - it is unused by any user process
  *  - it has been unused for exp_timeout time
  */
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi,
-				       int how)
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi, int how)
 {
 	unsigned long timeout;
 	struct dentry *root = sb->s_root;
@@ -335,7 +330,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		spin_unlock(&dcache_lock);
 
 		spin_lock(&sbi->fs_lock);
-		ino = autofs4_dentry_ino(dentry);
+		ino = autofs_dentry_ino(dentry);
 
 		/*
 		 * Case 1: (i) indirect mount or top level pseudo direct mount
@@ -353,11 +348,11 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 				goto next;
 
 			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, dentry))
+			if (autofs_mount_busy(mnt, dentry))
 				goto next;
 
 			/* Can we expire this guy */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
+			if (autofs_can_expire(dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
@@ -374,7 +369,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			if (atomic_read(&dentry->d_count) > ino_count)
 				goto next;
 
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
+			if (!autofs_tree_busy(mnt, dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
@@ -388,7 +383,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			if (atomic_read(&dentry->d_count) > ino_count)
 				goto next;
 
-			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
+			expired = autofs_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
 				goto found;
@@ -406,9 +401,9 @@ next:
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs4_dentry_ino(expired);
+	ino = autofs_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
-	autofs4_add_expiring(expired);
+	autofs_add_expiring(expired);
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
@@ -417,10 +412,10 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct dentry *dentry)
+int autofs_expire_wait(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
 	/* Block on any pending expire */
@@ -431,7 +426,7 @@ int autofs4_expire_wait(struct dentry *dentry)
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		status = autofs_wait(sbi, dentry, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
 		DPRINTK("expire done status=%d", status);
@@ -447,7 +442,7 @@ int autofs4_expire_wait(struct dentry *dentry)
 }
 
 /* Perform an expiry operation */
-int autofs4_expire_run(struct super_block *sb,
+int autofs_expire_run(struct super_block *sb,
 		      struct vfsmount *mnt,
 		      struct autofs_sb_info *sbi,
 		      struct autofs_packet_expire __user *pkt_p)
@@ -462,7 +457,7 @@ int autofs4_expire_run(struct super_block *sb,
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
+	dentry = autofs_expire_indirect(sb, mnt, sbi, 0);
 	if (dentry == NULL)
 		return -EAGAIN;
 
@@ -475,34 +470,35 @@ int autofs4_expire_run(struct super_block *sb,
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
-	ino = autofs4_dentry_ino(dentry);
+	ino = autofs_dentry_ino(dentry);
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
-	autofs4_del_expiring(dentry);
+	autofs_del_expiring(dentry);
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 
 	return ret;
 }
 
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when)
+int autofs_do_expire_multi(struct super_block *sb,
+			   struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when)
 {
 	struct dentry *dentry;
 	int ret = -EAGAIN;
 
 	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
+		dentry = autofs_expire_direct(sb, mnt, sbi, when);
 	else
-		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
+		dentry = autofs_expire_indirect(sb, mnt, sbi, when);
 
 	if (dentry) {
-		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+		struct autofs_info *ino = autofs_dentry_ino(dentry);
 
 		/*
 		 * This is synchronous because it makes the daemon a
 		 * little easier
 		 */
-		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		ret = autofs_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
 		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
@@ -510,7 +506,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
 		}
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		autofs4_del_expiring(dentry);
+		autofs_del_expiring(dentry);
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
@@ -521,7 +517,8 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 
 /* Call repeatedly until it returns -EAGAIN, meaning there's nothing
    more to be done */
-int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+int autofs_expire_multi(struct super_block *sb,
+			struct vfsmount *mnt,
 			struct autofs_sb_info *sbi, int __user *arg)
 {
 	int do_now = 0;
@@ -529,6 +526,6 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
+	return autofs_do_expire_multi(sb, mnt, sbi, do_now);
 }
 
diff --git a/fs/autofs/init.c b/fs/autofs/init.c
index 11cc42b..9c660c0 100644
--- a/fs/autofs/init.c
+++ b/fs/autofs/init.c
@@ -14,17 +14,17 @@
 static int autofs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
+	return get_sb_nodev(fs_type, flags, data, autofs_fill_super, mnt);
 }
 
 static struct file_system_type autofs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "autofs",
 	.get_sb		= autofs_get_sb,
-	.kill_sb	= autofs4_kill_sb,
+	.kill_sb	= autofs_kill_sb,
 };
 
-static int __init init_autofs4_fs(void)
+static int __init init_autofs_fs(void)
 {
 	int err;
 
@@ -37,12 +37,12 @@ static int __init init_autofs4_fs(void)
 	return err;
 }
 
-static void __exit exit_autofs4_fs(void)
+static void __exit exit_autofs_fs(void)
 {
 	autofs_dev_ioctl_exit();
 	unregister_filesystem(&autofs_fs_type);
 }
 
-module_init(init_autofs4_fs)
-module_exit(exit_autofs4_fs)
+module_init(init_autofs_fs)
+module_exit(exit_autofs_fs)
 MODULE_LICENSE("GPL");
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 5b006db..a431442 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -27,8 +27,8 @@ static void ino_lnkfree(struct autofs_info *ino)
 	}
 }
 
-struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
-				     struct autofs_sb_info *sbi, mode_t mode)
+struct autofs_info *autofs_init_ino(struct autofs_info *ino,
+				    struct autofs_sb_info *sbi, mode_t mode)
 {
 	int reinit = 1;
 
@@ -72,7 +72,7 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 	return ino;
 }
 
-void autofs4_free_ino(struct autofs_info *ino)
+void autofs_free_ino(struct autofs_info *ino)
 {
 	struct autofs_info *p_ino;
 
@@ -81,7 +81,7 @@ void autofs4_free_ino(struct autofs_info *ino)
 		if (ino->dentry->d_inode) {
 			struct dentry *parent = ino->dentry->d_parent;
 			if (atomic_dec_and_test(&ino->count)) {
-				p_ino = autofs4_dentry_ino(parent);
+				p_ino = autofs_dentry_ino(parent);
 				if (p_ino && parent != ino->dentry)
 					atomic_dec(&p_ino->count);
 			}
@@ -100,7 +100,7 @@ void autofs4_free_ino(struct autofs_info *ino)
  * Clean up the dentry tree. This happens with autofs if the user
  * space program goes away due to a SIGKILL, SIGSEGV etc.
  */
-static void autofs4_force_release(struct autofs_sb_info *sbi)
+static void autofs_force_release(struct autofs_sb_info *sbi)
 {
 	struct dentry *this_parent = sbi->sb->s_root;
 	struct list_head *next;
@@ -153,9 +153,9 @@ resume:
 	spin_unlock(&dcache_lock);
 }
 
-void autofs4_kill_sb(struct super_block *sb)
+void autofs_kill_sb(struct super_block *sb)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(sb);
+	struct autofs_sb_info *sbi = autofs_sbi(sb);
 
 	/*
 	 * In the event of a failure in get_sb_nodev the superblock
@@ -167,10 +167,10 @@ void autofs4_kill_sb(struct super_block *sb)
 		goto out_kill_sb;
 
 	/* Free wait queues, close pipe */
-	autofs4_catatonic_mode(sbi);
+	autofs_catatonic_mode(sbi);
 
 	/* Clean up and release dangling references */
-	autofs4_force_release(sbi);
+	autofs_force_release(sbi);
 
 	sb->s_fs_info = NULL;
 	kfree(sbi);
@@ -180,9 +180,9 @@ out_kill_sb:
 	kill_anon_super(sb);
 }
 
-static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
+static int autofs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(mnt->mnt_sb);
 	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
 
 	if (!sbi)
@@ -208,9 +208,9 @@ static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
 	return 0;
 }
 
-static const struct super_operations autofs4_sops = {
+static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
-	.show_options	= autofs4_show_options,
+	.show_options	= autofs_show_options,
 };
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
@@ -300,22 +300,22 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	return (*pipefd < 0);
 }
 
-static struct autofs_info *autofs4_mkroot(struct autofs_sb_info *sbi)
+static struct autofs_info *autofs_mkroot(struct autofs_sb_info *sbi)
 {
 	struct autofs_info *ino;
 
-	ino = autofs4_init_ino(NULL, sbi, S_IFDIR | 0755);
+	ino = autofs_init_ino(NULL, sbi, S_IFDIR | 0755);
 	if (!ino)
 		return NULL;
 
 	return ino;
 }
 
-static const struct dentry_operations autofs4_sb_dentry_operations = {
-	.d_release      = autofs4_dentry_release,
+static const struct dentry_operations autofs_sb_dentry_operations = {
+	.d_release      = autofs_dentry_release,
 };
 
-int autofs4_fill_super(struct super_block *s, void *data, int silent)
+int autofs_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * root_inode;
 	struct dentry * root;
@@ -351,16 +351,16 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = AUTOFS_SUPER_MAGIC;
-	s->s_op = &autofs4_sops;
+	s->s_op = &autofs_sops;
 	s->s_time_gran = 1;
 
 	/*
 	 * Get the root inode and dentry, but defer checking for errors.
 	 */
-	ino = autofs4_mkroot(sbi);
+	ino = autofs_mkroot(sbi);
 	if (!ino)
 		goto fail_free;
-	root_inode = autofs4_get_inode(s, ino);
+	root_inode = autofs_get_inode(s, ino);
 	if (!root_inode)
 		goto fail_ino;
 
@@ -369,7 +369,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		goto fail_iput;
 	pipe = NULL;
 
-	root->d_op = &autofs4_sb_dentry_operations;
+	root->d_op = &autofs_sb_dentry_operations;
 	root->d_fsdata = ino;
 
 	/* Can this call block? */
@@ -380,10 +380,10 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		goto fail_dput;
 	}
 
-	root_inode->i_fop = &autofs4_root_operations;
+	root_inode->i_fop = &autofs_root_operations;
 	root_inode->i_op = autofs_type_trigger(sbi->type) ?
-			&autofs4_direct_root_inode_operations :
-			&autofs4_indirect_root_inode_operations;
+			&autofs_direct_root_inode_operations :
+			&autofs_indirect_root_inode_operations;
 
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
@@ -444,8 +444,7 @@ fail_unlock:
 	return -EINVAL;
 }
 
-struct inode *autofs4_get_inode(struct super_block *sb,
-				struct autofs_info *inf)
+struct inode *autofs_get_inode(struct super_block *sb, struct autofs_info *inf)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -462,11 +461,11 @@ struct inode *autofs4_get_inode(struct super_block *sb,
 
 	if (S_ISDIR(inf->mode)) {
 		inode->i_nlink = 2;
-		inode->i_op = &autofs4_dir_inode_operations;
-		inode->i_fop = &autofs4_dir_operations;
+		inode->i_op = &autofs_dir_inode_operations;
+		inode->i_fop = &autofs_dir_operations;
 	} else if (S_ISLNK(inf->mode)) {
 		inode->i_size = inf->size;
-		inode->i_op = &autofs4_symlink_inode_operations;
+		inode->i_op = &autofs_symlink_inode_operations;
 	}
 
 	return inode;
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index c7bb36f..395cf0e 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -16,65 +16,65 @@
 #include <linux/time.h>
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
-static int autofs4_dir_unlink(struct inode *, struct dentry *);
-static int autofs4_dir_rmdir(struct inode *, struct dentry *);
-static int autofs4_dir_mkdir(struct inode *, struct dentry *, int);
-static int autofs4_root_ioctl(struct inode *, struct file *,
-			      unsigned int, unsigned long);
-static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,
-				     struct dentry *, struct nameidata *);
-static void *autofs4_follow_link(struct dentry *, struct nameidata *);
+static int autofs_dir_symlink(struct inode *, struct dentry *, const char *);
+static int autofs_dir_unlink(struct inode *, struct dentry *);
+static int autofs_dir_rmdir(struct inode *, struct dentry *);
+static int autofs_dir_mkdir(struct inode *, struct dentry *, int);
+static int autofs_root_ioctl(struct inode *, struct file *,
+			     unsigned int, unsigned long);
+static int autofs_dir_open(struct inode *inode, struct file *file);
+static struct dentry *autofs_lookup(struct inode *,
+				    struct dentry *, struct nameidata *);
+static void *autofs_follow_link(struct dentry *, struct nameidata *);
 
 #define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
 #define TRIGGER_INTENTS (LOOKUP_OPEN | LOOKUP_CREATE)
 
-const struct file_operations autofs4_root_operations = {
+const struct file_operations autofs_root_operations = {
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
-	.ioctl		= autofs4_root_ioctl,
+	.ioctl		= autofs_root_ioctl,
 };
 
-const struct file_operations autofs4_dir_operations = {
-	.open		= autofs4_dir_open,
+const struct file_operations autofs_dir_operations = {
+	.open		= autofs_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.readdir	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
 };
 
-const struct inode_operations autofs4_indirect_root_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.symlink	= autofs4_dir_symlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
+const struct inode_operations autofs_indirect_root_inode_operations = {
+	.lookup		= autofs_lookup,
+	.unlink		= autofs_dir_unlink,
+	.symlink	= autofs_dir_symlink,
+	.mkdir		= autofs_dir_mkdir,
+	.rmdir		= autofs_dir_rmdir,
 };
 
-const struct inode_operations autofs4_direct_root_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
-	.follow_link	= autofs4_follow_link,
+const struct inode_operations autofs_direct_root_inode_operations = {
+	.lookup		= autofs_lookup,
+	.unlink		= autofs_dir_unlink,
+	.mkdir		= autofs_dir_mkdir,
+	.rmdir		= autofs_dir_rmdir,
+	.follow_link	= autofs_follow_link,
 };
 
-const struct inode_operations autofs4_dir_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.symlink	= autofs4_dir_symlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
+const struct inode_operations autofs_dir_inode_operations = {
+	.lookup		= autofs_lookup,
+	.unlink		= autofs_dir_unlink,
+	.symlink	= autofs_dir_symlink,
+	.mkdir		= autofs_dir_mkdir,
+	.rmdir		= autofs_dir_rmdir,
 };
 
-static void autofs4_add_active(struct dentry *dentry)
+static void autofs_add_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!ino->active_count) {
@@ -87,10 +87,10 @@ static void autofs4_add_active(struct dentry *dentry)
 	return;
 }
 
-static void autofs4_del_active(struct dentry *dentry)
+static void autofs_del_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		ino->active_count--;
@@ -103,7 +103,7 @@ static void autofs4_del_active(struct dentry *dentry)
 	return;
 }
 
-static void autofs4_add_rehash_entry(struct autofs_info *ino,
+static void autofs_add_rehash_entry(struct autofs_info *ino,
 				     struct rehash_entry *entry)
 {
 	entry->task = current;
@@ -112,7 +112,7 @@ static void autofs4_add_rehash_entry(struct autofs_info *ino,
 	return;
 }
 
-static void autofs4_remove_rehash_entry(struct autofs_info *ino)
+static void autofs_remove_rehash_entry(struct autofs_info *ino)
 {
 	struct list_head *head = &ino->rehash_list;
 	struct rehash_entry *entry;
@@ -126,7 +126,7 @@ static void autofs4_remove_rehash_entry(struct autofs_info *ino)
 	return;
 }
 
-static void autofs4_remove_rehash_entrys(struct autofs_info *ino)
+static void autofs_remove_rehash_entrys(struct autofs_info *ino)
 {
 	struct autofs_sb_info *sbi = ino->sbi;
 	struct rehash_entry *entry, *next;
@@ -152,11 +152,11 @@ static void autofs4_remove_rehash_entrys(struct autofs_info *ino)
 	return;
 }
 
-static void autofs4_revalidate_drop(struct dentry *dentry,
-				    struct rehash_entry *entry)
+static void autofs_revalidate_drop(struct dentry *dentry,
+				   struct rehash_entry *entry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	/*
 	 * Add to the active list so we can pick this up in
 	 * ->lookup(). Also add an entry to a rehash list so
@@ -166,7 +166,7 @@ static void autofs4_revalidate_drop(struct dentry *dentry,
 	spin_lock(&sbi->lookup_lock);
 	if (list_empty(&ino->active))
 		list_add(&ino->active, &sbi->active_list);
-	autofs4_add_rehash_entry(ino, entry);
+	autofs_add_rehash_entry(ino, entry);
 	spin_unlock(&sbi->lookup_lock);
 	if (!(ino->flags & AUTOFS_INF_REHASH)) {
 		ino->flags |= AUTOFS_INF_REHASH;
@@ -178,13 +178,13 @@ static void autofs4_revalidate_drop(struct dentry *dentry,
 	return;
 }
 
-static void autofs4_revalidate_rehash(struct dentry *dentry)
+static void autofs_revalidate_rehash(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino->flags & AUTOFS_INF_REHASH) {
 		spin_lock(&sbi->lookup_lock);
-		autofs4_remove_rehash_entry(ino);
+		autofs_remove_rehash_entry(ino);
 		if (list_empty(&ino->rehash_list)) {
 			spin_unlock(&sbi->lookup_lock);
 			ino->flags &= ~AUTOFS_INF_REHASH;
@@ -196,7 +196,7 @@ static void autofs4_revalidate_rehash(struct dentry *dentry)
 	return;
 }
 
-static unsigned int autofs4_need_mount(unsigned int flags)
+static unsigned int autofs_need_mount(unsigned int flags)
 {
 	unsigned int res = 0;
 	if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS))
@@ -204,15 +204,15 @@ static unsigned int autofs4_need_mount(unsigned int flags)
 	return res;
 }
 
-static int autofs4_dir_open(struct inode *inode, struct file *file)
+static int autofs_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 
 	DPRINTK("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);
 
-	if (autofs4_oz_mode(sbi))
+	if (autofs_oz_mode(sbi))
 		goto out;
 
 	/*
@@ -237,8 +237,8 @@ out:
 
 static int try_to_fill_dentry(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
 	DPRINTK("dentry=%p %.*s ino=%p",
@@ -252,7 +252,7 @@ static int try_to_fill_dentry(struct dentry *dentry)
 	DPRINTK("waiting for mount name=%.*s",
 		 dentry->d_name.len, dentry->d_name.name);
 
-	status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+	status = autofs_wait(sbi, dentry, NFY_MOUNT);
 
 	DPRINTK("mount done status=%d", status);
 
@@ -263,11 +263,11 @@ static int try_to_fill_dentry(struct dentry *dentry)
 }
 
 /* For autofs direct mounts the follow link triggers the mount */
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	int oz_mode = autofs4_oz_mode(sbi);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	int oz_mode = autofs_oz_mode(sbi);
 	unsigned int lookup_type;
 	int status;
 
@@ -294,10 +294,10 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	/* If an expire request is pending everyone must wait. */
-	autofs4_expire_wait(dentry);
+	autofs_expire_wait(dentry);
 
 	/* We trigger a mount for almost all flags */
-	lookup_type = autofs4_need_mount(nd->flags);
+	lookup_type = autofs_need_mount(nd->flags);
 	spin_lock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
 	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
@@ -337,7 +337,7 @@ follow:
 	 * to follow it.
 	 */
 	if (d_mountpoint(dentry)) {
-		if (!autofs4_follow_mount(&nd->path)) {
+		if (!autofs_follow_mount(&nd->path)) {
 			status = -ENOENT;
 			goto out_error;
 		}
@@ -357,11 +357,11 @@ out_error:
  * yet completely filled in, and revalidate has to delay such
  * lookups..
  */
-static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int autofs_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct rehash_entry *entry;
 	int flags = nd ? nd->flags : 0;
 	unsigned int mutex_aquired;
@@ -370,7 +370,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		dentry->d_name.len, dentry->d_name.name, oz_mode);
 
 	/* Daemon never causes a mount to trigger */
-	if (autofs4_oz_mode(sbi))
+	if (autofs_oz_mode(sbi))
 		return 1;
 
 	entry = kmalloc(sizeof(struct rehash_entry), GFP_KERNEL);
@@ -382,7 +382,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 	spin_lock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
 	/* Pending dentry */
-	if (autofs4_ispending(dentry)) {
+	if (autofs_ispending(dentry)) {
 		int status;
 
 		/*
@@ -393,7 +393,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		 */
 		ino->flags |= AUTOFS_INF_PENDING;
 		if (!mutex_aquired) {
-			autofs4_revalidate_drop(dentry, entry);
+			autofs_revalidate_drop(dentry, entry);
 			spin_unlock(&dcache_lock);
 			spin_unlock(&sbi->fs_lock);
 			return 0;
@@ -408,7 +408,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		 * we have been called as ->d_revalidate() and so
 		 * we need to return false and proceed to ->lookup().
 		 */
-		if (autofs4_expire_wait(dentry) == -EAGAIN)
+		if (autofs_expire_wait(dentry) == -EAGAIN)
 			return 0;
 
 		/*
@@ -433,7 +433,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
-		if (autofs4_need_mount(flags) || current->link_count) {
+		if (autofs_need_mount(flags) || current->link_count) {
 			int status;
 
 			/*
@@ -444,7 +444,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 			 */
 			ino->flags |= AUTOFS_INF_PENDING;
 			if (!mutex_aquired) {
-				autofs4_revalidate_drop(dentry, entry);
+				autofs_revalidate_drop(dentry, entry);
 				spin_unlock(&dcache_lock);
 				spin_unlock(&sbi->fs_lock);
 				return 0;
@@ -481,7 +481,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 	return 1;
 }
 
-static void autofs4_free_rehash_entrys(struct autofs_info *inf)
+static void autofs_free_rehash_entrys(struct autofs_info *inf)
 {
 	struct list_head *head = &inf->rehash_list;
 	struct rehash_entry *entry, *next;
@@ -491,17 +491,17 @@ static void autofs4_free_rehash_entrys(struct autofs_info *inf)
 	}
 }
 
-void autofs4_dentry_release(struct dentry *de)
+void autofs_dentry_release(struct dentry *de)
 {
 	struct autofs_info *inf;
 
 	DPRINTK("releasing %p", de);
 
-	inf = autofs4_dentry_ino(de);
+	inf = autofs_dentry_ino(de);
 	de->d_fsdata = NULL;
 
 	if (inf) {
-		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
+		struct autofs_sb_info *sbi = autofs_sbi(de->d_sb);
 
 		if (sbi) {
 			spin_lock(&sbi->lookup_lock);
@@ -510,32 +510,32 @@ void autofs4_dentry_release(struct dentry *de)
 			if (!list_empty(&inf->expiring))
 				list_del(&inf->expiring);
 			if (!list_empty(&inf->rehash_list))
-				autofs4_free_rehash_entrys(inf);
+				autofs_free_rehash_entrys(inf);
 			spin_unlock(&sbi->lookup_lock);
 		}
 
 		inf->dentry = NULL;
 		inf->inode = NULL;
 
-		autofs4_free_ino(inf);
+		autofs_free_ino(inf);
 	}
 }
 
 /* For dentries of directories in the root dir */
-static const struct dentry_operations autofs4_root_dentry_operations = {
-	.d_revalidate	= autofs4_revalidate,
-	.d_release	= autofs4_dentry_release,
+static const struct dentry_operations autofs_root_dentry_operations = {
+	.d_revalidate	= autofs_revalidate,
+	.d_release	= autofs_dentry_release,
 };
 
 /* For other dentries */
-static const struct dentry_operations autofs4_dentry_operations = {
-	.d_revalidate	= autofs4_revalidate,
-	.d_release	= autofs4_dentry_release,
+static const struct dentry_operations autofs_dentry_operations = {
+	.d_revalidate	= autofs_revalidate,
+	.d_release	= autofs_dentry_release,
 };
 
-static struct dentry *autofs4_lookup_active(struct dentry *dentry)
+static struct dentry *autofs_lookup_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
 	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
@@ -567,7 +567,7 @@ restart:
 				spin_unlock(&active->d_lock);
 				spin_unlock(&sbi->lookup_lock);
 				spin_unlock(&dcache_lock);
-				autofs4_remove_rehash_entrys(ino);
+				autofs_remove_rehash_entrys(ino);
 				dput(active);
 				goto restart;
 			}
@@ -600,9 +600,9 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
+static struct dentry *autofs_lookup_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
 	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
@@ -669,14 +669,14 @@ static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
 	 * we check for the hashed dentry and return the newly
 	 * hashed dentry.
 	 */
-	dentry->d_op = &autofs4_root_dentry_operations;
+	dentry->d_op = &autofs_root_dentry_operations;
 
 	/*
 	 * And we need to ensure that the same dentry is used for
 	 * all following lookup calls until it is hashed so that
 	 * the dentry flags are persistent throughout the request.
 	 */
-	ino = autofs4_init_ino(NULL, sbi, 0555);
+	ino = autofs_init_ino(NULL, sbi, 0555);
 	if (!ino)
 		return ERR_PTR(-ENOMEM);
 
@@ -696,9 +696,9 @@ static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir,
-				     struct dentry *dentry,
-				     struct nameidata *nd)
+static struct dentry *autofs_lookup(struct inode *dir,
+				    struct dentry *dentry,
+				    struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -713,19 +713,19 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	sbi = autofs4_sbi(dir->i_sb);
-	oz_mode = autofs4_oz_mode(sbi);
+	sbi = autofs_sbi(dir->i_sb);
+	oz_mode = autofs_oz_mode(sbi);
 
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
 	spin_lock(&sbi->fs_lock);
-	active = autofs4_lookup_active(dentry);
+	active = autofs_lookup_active(dentry);
 	if (active) {
 		dentry = active;
-		ino = autofs4_dentry_ino(dentry);
+		ino = autofs_dentry_ino(dentry);
 		/* If this came from revalidate, rehash it */
-		autofs4_revalidate_rehash(dentry);
+		autofs_revalidate_rehash(dentry);
 		spin_unlock(&sbi->fs_lock);
 	} else {
 		spin_unlock(&sbi->fs_lock);
@@ -734,10 +734,10 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 			return (struct dentry *) ino;
 	}
 
-	autofs4_add_active(dentry);
+	autofs_add_active(dentry);
 
 	if (!oz_mode) {
-		expiring = autofs4_lookup_expiring(dentry);
+		expiring = autofs_lookup_expiring(dentry);
 		mutex_unlock(&dir->i_mutex);
 		if (expiring) {
 			/*
@@ -745,7 +745,7 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 			 * be quite complete but the directory has been removed
 			 * so it must have been successful, so just wait for it.
 			 */
-			autofs4_expire_wait(expiring);
+			autofs_expire_wait(expiring);
 			dput(expiring);
 		}
 		status = try_to_fill_dentry(dentry);
@@ -755,7 +755,7 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 		spin_unlock(&sbi->fs_lock);
 	}
 
-	autofs4_del_active(dentry);
+	autofs_del_active(dentry);
 
 	/*
 	 * If we had a mount fail, check if we had to handle
@@ -816,12 +816,12 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 	return NULL;
 }
 
-static int autofs4_dir_symlink(struct inode *dir,
-			       struct dentry *dentry,
-			       const char *symname)
+static int autofs_dir_symlink(struct inode *dir,
+			      struct dentry *dentry,
+			      const char *symname)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	struct inode *inode;
 	char *cp;
@@ -829,10 +829,10 @@ static int autofs4_dir_symlink(struct inode *dir,
 	DPRINTK("%s <- %.*s", symname,
 		dentry->d_name.len, dentry->d_name.name);
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
-	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
+	ino = autofs_init_ino(ino, sbi, S_IFLNK | 0555);
 	if (!ino)
 		return -ENOMEM;
 
@@ -846,7 +846,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 
 	strcpy(cp, symname);
 
-	inode = autofs4_get_inode(dir->i_sb, ino);
+	inode = autofs_get_inode(dir->i_sb, ino);
 	if (!inode) {
 		kfree(cp);
 		if (!dentry->d_fsdata)
@@ -856,14 +856,14 @@ static int autofs4_dir_symlink(struct inode *dir,
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
+		dentry->d_op = &autofs_root_dentry_operations;
 	else
-		dentry->d_op = &autofs4_dentry_operations;
+		dentry->d_op = &autofs_dentry_operations;
 
 	dentry->d_fsdata = ino;
 	ino->dentry = dget(dentry);
 	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
@@ -887,20 +887,20 @@ static int autofs4_dir_symlink(struct inode *dir,
  * If a process is blocked on the dentry waiting for the expire to finish,
  * it will invalidate the dentry and try to mount with a new one.
  *
- * Also see autofs4_dir_rmdir()..
+ * Also see autofs_dir_rmdir()..
  */
-static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
+static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
 	/* This allows root to remove symlinks */
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		p_ino = autofs_dentry_ino(dentry->d_parent);
 		if (p_ino && dentry->d_parent != dentry)
 			atomic_dec(&p_ino->count);
 	}
@@ -920,16 +920,16 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
+static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
 	DPRINTK("dentry %p, removing %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
 	spin_lock(&dcache_lock);
@@ -943,7 +943,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	spin_unlock(&dcache_lock);
 
 	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		p_ino = autofs_dentry_ino(dentry->d_parent);
 		if (p_ino && dentry->d_parent != dentry)
 			atomic_dec(&p_ino->count);
 	}
@@ -957,24 +957,24 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int autofs_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	struct inode *inode;
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
 	DPRINTK("dentry %p, creating %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
+	ino = autofs_init_ino(ino, sbi, S_IFDIR | 0555);
 	if (!ino)
 		return -ENOMEM;
 
-	inode = autofs4_get_inode(dir->i_sb, ino);
+	inode = autofs_get_inode(dir->i_sb, ino);
 	if (!inode) {
 		if (!dentry->d_fsdata)
 			kfree(ino);
@@ -983,14 +983,14 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
+		dentry->d_op = &autofs_root_dentry_operations;
 	else
-		dentry->d_op = &autofs4_dentry_operations;
+		dentry->d_op = &autofs_dentry_operations;
 
 	dentry->d_fsdata = ino;
 	ino->dentry = dget(dentry);
 	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
@@ -1001,7 +1001,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /* Get/set timeout ioctl() operation */
-static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
+static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 					 unsigned long __user *p)
 {
 	int rv;
@@ -1021,14 +1021,14 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 
 /* Return protocol version */
 static inline int
-autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
+autofs_get_protover(struct autofs_sb_info *sbi, int __user *p)
 {
 	return put_user(sbi->version, p);
 }
 
 /* Return protocol sub version */
 static inline int
-autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
+autofs_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
 {
 	return put_user(sbi->sub_version, p);
 }
@@ -1036,7 +1036,7 @@ autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
 /*
 * Tells the daemon whether it can umount the autofs mount.
 */
-static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
+static inline int autofs_ask_umount(struct vfsmount *mnt, int __user *p)
 {
 	int status = 0;
 
@@ -1050,15 +1050,15 @@ static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
 	return status;
 }
 
-/* Identify autofs4_dentries - this is so we can tell if there's
+/* Identify autofs_dentries - this is so we can tell if there's
    an extra dentry refcount or not.  We only hold a refcount on the
    dentry if its non-negative (ie, d_inode != NULL)
 */
-int is_autofs4_dentry(struct dentry *dentry)
+int is_autofs_dentry(struct dentry *dentry)
 {
 	return dentry && dentry->d_inode &&
-		(dentry->d_op == &autofs4_root_dentry_operations ||
-		 dentry->d_op == &autofs4_dentry_operations) &&
+		(dentry->d_op == &autofs_root_dentry_operations ||
+		 dentry->d_op == &autofs_dentry_operations) &&
 		dentry->d_fsdata != NULL;
 }
 
@@ -1066,10 +1066,10 @@ int is_autofs4_dentry(struct dentry *dentry)
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
+static int autofs_root_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
@@ -1079,36 +1079,36 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
 		return -ENOTTY;
 	
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	
 	switch(cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, 0);
+		return autofs_wait_release(sbi, (autofs_wqt_t)arg, 0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, -ENOENT);
+		return autofs_wait_release(sbi, (autofs_wqt_t)arg, -ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
-		autofs4_catatonic_mode(sbi);
+		autofs_catatonic_mode(sbi);
 		return 0;
 	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
-		return autofs4_get_protover(sbi, p);
+		return autofs_get_protover(sbi, p);
 	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
-		return autofs4_get_protosubver(sbi, p);
+		return autofs_get_protosubver(sbi, p);
 	case AUTOFS_IOC_SETTIMEOUT:
-		return autofs4_get_set_timeout(sbi, p);
+		return autofs_get_set_timeout(sbi, p);
 
 	case AUTOFS_IOC_ASKUMOUNT:
-		return autofs4_ask_umount(filp->f_path.mnt, p);
+		return autofs_ask_umount(filp->f_path.mnt, p);
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,
+		return autofs_expire_run(inode->i_sb,
 					  filp->f_path.mnt, sbi, p);
 
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,
-					    filp->f_path.mnt, sbi, p);
+		return autofs_expire_multi(inode->i_sb,
+					   filp->f_path.mnt, sbi, p);
 
 	default:
 		return -ENOSYS;
diff --git a/fs/autofs/symlink.c b/fs/autofs/symlink.c
index 296fbd9..fcbbe5e 100644
--- a/fs/autofs/symlink.c
+++ b/fs/autofs/symlink.c
@@ -9,14 +9,14 @@
 
 #include "autofs_i.h"
 
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	nd_set_link(nd, (char *)ino->u.symlink);
 	return NULL;
 }
 
-const struct inode_operations autofs4_symlink_inode_operations = {
+const struct inode_operations autofs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
-	.follow_link	= autofs4_follow_link
+	.follow_link	= autofs_follow_link
 };
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index a4e55da..21d92c7 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -16,12 +16,12 @@
 
 /* We make this a static variable rather than a part of the superblock; it
    is better if we don't reassign numbers easily even across filesystems */
-static autofs_wqt_t autofs4_next_wait_queue = 1;
+static autofs_wqt_t autofs_next_wait_queue = 1;
 
 /* These are the signals we allow interrupting a pending mount */
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
 
-void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
+void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 {
 	struct autofs_wait_queue *wq, *nwq;
 
@@ -53,7 +53,7 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 	mutex_unlock(&sbi->wq_mutex);
 }
 
-static int autofs4_write(struct file *file, const void *addr, int bytes)
+static int autofs_write(struct file *file, const void *addr, int bytes)
 {
 	unsigned long sigpipe, flags;
 	mm_segment_t fs;
@@ -88,7 +88,7 @@ static int autofs4_write(struct file *file, const void *addr, int bytes)
 	return (bytes > 0);
 }
 	
-static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
+static void autofs_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
 {
@@ -162,7 +162,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		printk(KERN_ERR "autofs4_notify_daemon: bad type %d!\n", type);
+		printk(KERN_ERR "autofs_notify_daemon: bad type %d!\n", type);
 		return;
 	}
 
@@ -175,14 +175,14 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	mutex_unlock(&sbi->wq_mutex);
 
 	if (pipe) {
-		if (autofs4_write(pipe, &pkt, pktsz))
-			autofs4_catatonic_mode(sbi);
+		if (autofs_write(pipe, &pkt, pktsz))
+			autofs_catatonic_mode(sbi);
 		fput(pipe);
 	}
 }
 
-static int autofs4_getpath(struct autofs_sb_info *sbi,
-			   struct dentry *dentry, char **name)
+static int autofs_getpath(struct autofs_sb_info *sbi,
+			  struct dentry *dentry, char **name)
 {
 	struct dentry *root = sbi->sb->s_root;
 	struct dentry *tmp;
@@ -214,7 +214,7 @@ static int autofs4_getpath(struct autofs_sb_info *sbi,
 }
 
 static struct autofs_wait_queue *
-autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
+autofs_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 {
 	struct autofs_wait_queue *wq;
 
@@ -245,7 +245,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 	struct autofs_info *ino;
 
 	/* Wait in progress, continue; */
-	wq = autofs4_find_wait(sbi, qstr);
+	wq = autofs_find_wait(sbi, qstr);
 	if (wq) {
 		*wait = wq;
 		return 1;
@@ -254,7 +254,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 	*wait = NULL;
 
 	/* If we don't yet have any info this is a new request */
-	ino = autofs4_dentry_ino(dentry);
+	ino = autofs_dentry_ino(dentry);
 	if (!ino)
 		return 1;
 
@@ -276,7 +276,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 			if (mutex_lock_interruptible(&sbi->wq_mutex))
 				return -EINTR;
 
-			wq = autofs4_find_wait(sbi, qstr);
+			wq = autofs_find_wait(sbi, qstr);
 			if (wq) {
 				*wait = wq;
 				return 1;
@@ -310,7 +310,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 	return 1;
 }
 
-int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
+int autofs_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
@@ -345,7 +345,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
-		qstr.len = autofs4_getpath(sbi, dentry, &name);
+		qstr.len = autofs_getpath(sbi, dentry, &name);
 		if (!qstr.len) {
 			kfree(name);
 			return -ENOENT;
@@ -376,15 +376,15 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 			return -ENOMEM;
 		}
 
-		wq->wait_queue_token = autofs4_next_wait_queue;
-		if (++autofs4_next_wait_queue == 0)
-			autofs4_next_wait_queue = 1;
+		wq->wait_queue_token = autofs_next_wait_queue;
+		if (++autofs_next_wait_queue == 0)
+			autofs_next_wait_queue = 1;
 		wq->next = sbi->queues;
 		sbi->queues = wq;
 		init_waitqueue_head(&wq->queue);
 		memcpy(&wq->name, &qstr, sizeof(struct qstr));
-		wq->dev = autofs4_get_dev(sbi);
-		wq->ino = autofs4_get_ino(sbi);
+		wq->dev = autofs_get_dev(sbi);
+		wq->ino = autofs_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
 		wq->pid = current->pid;
@@ -413,8 +413,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 
-		/* autofs4_notify_daemon() may block */
-		autofs4_notify_daemon(sbi, wq, type);
+		/* autofs_notify_daemon() may block */
+		autofs_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
@@ -465,12 +465,12 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		struct dentry *de = NULL;
 
 		/* direct mount or browsable map */
-		ino = autofs4_dentry_ino(dentry);
+		ino = autofs_dentry_ino(dentry);
 		if (!ino) {
 			/* If not lookup actual dentry used */
 			de = d_lookup(dentry->d_parent, &dentry->d_name);
 			if (de)
-				ino = autofs4_dentry_ino(de);
+				ino = autofs_dentry_ino(de);
 		}
 
 		/* Set mount requester */
@@ -495,8 +495,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 }
 
 
-int autofs4_wait_release(struct autofs_sb_info *sbi,
-			 autofs_wqt_t wait_queue_token, int status)
+int autofs_wait_release(struct autofs_sb_info *sbi,
+			autofs_wqt_t wait_queue_token, int status)
 {
 	struct autofs_wait_queue *wq, **wql;
 

