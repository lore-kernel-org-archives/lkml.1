Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZJUTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZJUTWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbZJUTWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbZJUTVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:49 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@infradead.org>
Subject: [PATCH 41/41] union-mount: Add support for rename by __union_copyup()
Date: Wed, 21 Oct 2009 12:19:39 -0700
Message-Id: <1256152779-10054-42-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-41-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
 <1256152779-10054-34-git-send-email-vaurora@redhat.com>
 <1256152779-10054-35-git-send-email-vaurora@redhat.com>
 <1256152779-10054-36-git-send-email-vaurora@redhat.com>
 <1256152779-10054-37-git-send-email-vaurora@redhat.com>
 <1256152779-10054-38-git-send-email-vaurora@redhat.com>
 <1256152779-10054-39-git-send-email-vaurora@redhat.com>
 <1256152779-10054-40-git-send-email-vaurora@redhat.com>
 <1256152779-10054-41-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@infradead.org>

It is possible to use __union_copyup() to support rename of regular files
without returning -EXDEV.

XXX - Rewrite as copyup to old name followed by rename() + whiteout()

Signed-off-by: Jan Blunck <jblunck@infradead.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |  350 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 344 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e3e8e98..8419e1e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1842,6 +1842,239 @@ out:
 	return res;
 }
 
+/**
+ * do_union_hash_lookup() - walk down the union stack and lookup_hash()
+ * @nd: nameidata of parent to lookup from
+ * @name: pathname component to lookup
+ * @path: path to store result of lookup in
+ *
+ * Walk down the union stack and search for single pathname component name. It
+ * is assumed that the caller already did a lookup_hash() in the topmost parent
+ * that gave negative lookup result. Therefore this does call lookup_hash() in
+ * every lower layer (!) of the union stack. If a directory is found the union
+ * stack for that is assembled as well.
+ *
+ * Note:
+ * The caller needs to take care of holding a valid reference to the topmost
+ * parent.
+ * On error we leave @path untouched as well as when we don't find anything.
+ */
+static int do_union_hash_lookup(struct nameidata *nd, struct qstr *name,
+				struct path *path)
+{
+	struct path next;
+	int err = 0;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		/* rehash because of d_op->d_hash() by the previous layer */
+		name->hash = full_name_hash(name->name, name->len);
+
+		mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+		err = lookup_hash(nd, name, &next);
+		mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+
+		if (err)
+			break;
+
+		if (next.dentry->d_inode) {
+			mntget(next.mnt);
+			if (!S_ISDIR(next.dentry->d_inode->i_mode)) {
+				*path = next;
+				break;
+			}
+			err = __hash_lookup_build_union(nd, name, &next);
+			if (err)
+				path_put(&next);
+			else
+				*path = next;
+			break;
+		}
+
+		path_put_conditional(&next, nd);
+
+		if ((IS_OPAQUE(nd->path.dentry->d_inode) &&
+		     !d_is_fallthru(next.dentry)) ||
+		    d_is_whiteout(next.dentry))
+			break;
+	}
+
+	return err;
+}
+
+/**
+ * _hash_lookup_union() - lookup single pathname component
+ * @nd: nameidata of parent to lookup from
+ * @name: pathname component to lookup
+ * @path: path to store result of lookup in
+ *
+ * Returns the topmost parent locked and the target dentry found in the union
+ * or the topmost negative target dentry otherwise.
+ *
+ * Note:
+ * Returns topmost parent locked even on error.
+ */
+static int _hash_lookup_union(struct nameidata *nd, struct qstr *name,
+			      struct path *path)
+{
+	struct path parent = nd->path;
+	struct path topmost;
+	int err;
+
+	mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+	err = lookup_hash(nd, name, path);
+	if (err)
+		return err;
+
+	/* return if we found something and it isn't a directory we are done */
+	if (path->dentry->d_inode && !S_ISDIR(path->dentry->d_inode->i_mode))
+		return 0;
+
+	/* stop lookup if the parent directory is marked opaque */
+	if ((IS_OPAQUE(nd->path.dentry->d_inode) &&
+	     !d_is_fallthru(path->dentry)) ||
+	    d_is_whiteout(path->dentry))
+		return 0;
+
+	if (!strcmp(path->mnt->mnt_sb->s_type->name, "proc") ||
+	    !strcmp(path->mnt->mnt_sb->s_type->name, "sysfs"))
+		return 0;
+
+	mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+
+	/*
+	 * safe a reference to the topmost parent for walking the union stack
+	 */
+	path_get(&parent);
+	topmost = *path;
+
+	if (path->dentry->d_inode && S_ISDIR(path->dentry->d_inode->i_mode)) {
+		err = __hash_lookup_build_union(nd, name, path);
+		if (err)
+			goto err_lock_parent;
+		goto out_lock_and_revalidate_parent;
+	}
+
+	err = do_union_hash_lookup(nd, name, path);
+	if (err)
+		goto err_lock_parent;
+
+out_lock_and_revalidate_parent:
+	/* seems that we haven't found anything, so return the topmost */
+	path_to_nameidata(&parent, nd);
+	mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+
+	if (topmost.dentry == path->dentry) {
+		spin_lock(&path->dentry->d_lock);
+		if (nd->path.dentry != path->dentry->d_parent) {
+			spin_unlock(&path->dentry->d_lock);
+			dput(path->dentry);
+			name->hash = full_name_hash(name->name, name->len);
+			err = lookup_hash(nd, name, path);
+			if (err)
+				return err;
+			/* FIXME: What if we find a directory here ... */
+			return err;
+		}
+		spin_unlock(&path->dentry->d_lock);
+	} else
+		dput(topmost.dentry);
+
+	return 0;
+
+err_lock_parent:
+	path_to_nameidata(&parent, nd);
+	path_put_conditional(path, nd);
+	mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+	return err;
+}
+
+/**
+ * lookup_rename_source() - lookup the source used by rename
+ *
+ * This is a special version of _hash_lookup_union() which becomes necessary
+ * for finding the source of a rename on union mounts.
+ *
+ * See comment for _hash_lookup_union() above.
+ */
+static int lookup_rename_source(struct nameidata *oldnd,
+				struct nameidata *newnd,
+				struct dentry **trap, struct qstr *name,
+				struct path *old)
+{
+	struct path parent = oldnd->path;
+	struct path topmost;
+	int err;
+
+	err = lookup_hash(oldnd, name, old);
+	if (err)
+		return err;
+
+	/* return if we found something and it isn't a directory we are done */
+	if (old->dentry->d_inode && !S_ISDIR(old->dentry->d_inode->i_mode))
+		return 0;
+
+	/* stop lookup if the parent directory is marked opaque */
+	if ((IS_OPAQUE(oldnd->path.dentry->d_inode) &&
+	     !d_is_fallthru(old->dentry)) ||
+	    d_is_whiteout(old->dentry))
+		return 0;
+
+	if (!strcmp(old->mnt->mnt_sb->s_type->name, "proc") ||
+	    !strcmp(old->mnt->mnt_sb->s_type->name, "sysfs"))
+		return 0;
+
+	unlock_rename(oldnd->path.dentry, newnd->path.dentry);
+
+	/*
+	 * safe a reference to the topmost parent for walking the union stack
+	 */
+	path_get(&parent);
+	topmost = *old;
+
+	if (old->dentry->d_inode && S_ISDIR(old->dentry->d_inode->i_mode)) {
+		err = __hash_lookup_build_union(oldnd, name, old);
+		if (err)
+			goto err_lock;
+		goto out_lock_and_revalidate_parent;
+	}
+
+	err = do_union_hash_lookup(oldnd, name, old);
+	if (err)
+		goto err_lock;
+
+out_lock_and_revalidate_parent:
+	path_to_nameidata(&parent, oldnd);
+	*trap = lock_rename(oldnd->path.dentry, newnd->path.dentry);
+
+	/*
+	 * If we return the topmost dentry we have to make sure that it has not
+	 * been moved away while we gave up the topmost parents i_mutex lock.
+	 */
+	if (topmost.dentry == old->dentry) {
+		spin_lock(&old->dentry->d_lock);
+		if (oldnd->path.dentry != old->dentry->d_parent) {
+			spin_unlock(&old->dentry->d_lock);
+			dput(old->dentry);
+			name->hash = full_name_hash(name->name, name->len);
+			err = lookup_hash(oldnd, name, old);
+			if (err)
+				return err;
+			/* FIXME: What if we find a directory here ... */
+			return err;
+		}
+		spin_unlock(&old->dentry->d_lock);
+	} else
+		dput(topmost.dentry);
+
+	return 0;
+
+err_lock:
+	path_to_nameidata(&parent, oldnd);
+	path_put_conditional(old, oldnd);
+	*trap = lock_rename(oldnd->path.dentry, newnd->path.dentry);
+	return err;
+}
+
 static int __lookup_one_len(const char *name, struct qstr *this,
 		struct dentry *base, int len)
 {
@@ -3544,6 +3777,91 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return error;
 }
 
+static int vfs_rename_union(struct nameidata *oldnd, struct path *old,
+			    struct nameidata *newnd, struct path *new)
+{
+	struct inode *old_dir = oldnd->path.dentry->d_inode;
+	struct inode *new_dir = newnd->path.dentry->d_inode;
+	struct qstr old_name;
+	char *name;
+	struct dentry *dentry;
+	int error;
+
+	if (old->dentry->d_inode == new->dentry->d_inode)
+		return 0;
+	error = may_whiteout(old_dir, old->dentry, 0);
+	if (error)
+		return error;
+	if (!old_dir->i_op || !old_dir->i_op->whiteout)
+		return -EPERM;
+
+	if (!new->dentry->d_inode)
+		error = may_create(new_dir, new->dentry);
+	else
+		error = may_delete(new_dir, new->dentry, 0);
+	if (error)
+		return error;
+
+	vfs_dq_init(old_dir);
+	vfs_dq_init(new_dir);
+
+	error = -EBUSY;
+	if (d_mountpoint(old->dentry) || d_mountpoint(new->dentry))
+		return error;
+
+	error = -ENOMEM;
+	name = kmalloc(old->dentry->d_name.len, GFP_KERNEL);
+	if (!name)
+		return error;
+	strncpy(name, old->dentry->d_name.name, old->dentry->d_name.len);
+	name[old->dentry->d_name.len] = 0;
+	old_name.len = old->dentry->d_name.len;
+	old_name.hash = old->dentry->d_name.hash;
+	old_name.name = name;
+
+	/* possibly delete the existing new file */
+	if ((newnd->path.dentry == new->dentry->d_parent) &&
+	    new->dentry->d_inode) {
+		/* FIXME: inode may be truncated while we hold a lock */
+		error = vfs_unlink(new_dir, new->dentry);
+		if (error)
+			goto freename;
+
+		dentry = __lookup_hash(&new->dentry->d_name,
+				       newnd->path.dentry, newnd);
+		if (IS_ERR(dentry))
+			goto freename;
+
+		dput(new->dentry);
+		new->dentry = dentry;
+	}
+
+	/* copyup to the new file */
+	error = __union_copyup(old, newnd, new);
+	if (error)
+		goto freename;
+
+	/* whiteout the old file */
+	dentry = __lookup_hash(&old_name, oldnd->path.dentry, oldnd);
+	error = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto freename;
+	error = vfs_whiteout(old_dir, dentry, 0);
+	dput(dentry);
+
+	/* FIXME: This is acutally unlink() && create() ... */
+/*
+  if (!error) {
+  const char *new_name = old_dentry->d_name.name;
+  fsnotify_move(old_dir, new_dir, old_name.name, new_name, 0,
+  new_dentry->d_inode, old_dentry->d_inode);
+  }
+*/
+freename:
+	kfree(old_name.name);
+	return error;
+}
+
 SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
@@ -3582,7 +3900,20 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
 	trap = lock_rename(new_dir, old_dir);
 
-	error = hash_lookup_union(&oldnd, &oldnd.last, &old);
+	/*
+	 * For union mounts we need to call a giant lookup_rename_source()
+	 * instead.
+	 * First lock_rename() and look on the topmost fs like you would do in
+	 * the normal rename, if you find something which is not a directory,
+	 * go ahead and lookup target and do normal rename.
+	 * If you find a negative dentry, unlock_rename() and continue as
+	 * _hash_lookup_union() would do without locking the topmost parent
+	 * at the end. After that do lock_rename() of the source parent and the
+	 * target parent and do a copyup with additional whiteout creation at
+	 * the end.
+	 */
+//	error = hash_lookup_union(&oldnd, &oldnd.last, &old);
+	error = lookup_rename_source(&oldnd, &newnd, &trap, &oldnd.last, &old);
 	if (error)
 		goto exit3;
 	/* source must exist */
@@ -3601,19 +3932,21 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EINVAL;
 	if (old.dentry == trap)
 		goto exit4;
-	error = hash_lookup_union(&newnd, &newnd.last, &new);
+	/* target is always on topmost fs, even with unions */
+	error = lookup_hash(&newnd, &newnd.last, &new);
 	if (error)
 		goto exit4;
 	/* target should not be an ancestor of source */
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
-	/* renaming on unions is done by the user-space */
+	/* renaming of directories on unions is done by the user-space */
 	error = -EXDEV;
-	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt))
-		goto exit5;
-	if (is_unionized(newnd.path.dentry, newnd.path.mnt))
+	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt) &&
+	    S_ISDIR(old.dentry->d_inode->i_mode))
 		goto exit5;
+//	if (is_unionized(newnd.path.dentry, newnd.path.mnt))
+//		goto exit5;
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
@@ -3622,6 +3955,11 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 				     &newnd.path, new.dentry);
 	if (error)
 		goto exit6;
+	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt) &&
+	    (old.dentry->d_parent != oldnd.path.dentry)) {
+		error = vfs_rename_union(&oldnd, &old, &newnd, &new);
+		goto exit6;
+	}
 	error = vfs_rename(old_dir->d_inode, old.dentry,
 				   new_dir->d_inode, new.dentry);
 exit6:
-- 
1.6.3.3

