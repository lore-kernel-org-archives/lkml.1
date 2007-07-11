Return-Path: <linux-kernel-owner+w=401wt.eu-S936816AbXGKX6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936816AbXGKX6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935275AbXGKXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:33499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935325AbXGKXhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/61] sysfs: make kobj point to sysfs_dirent instead of dentry
Date: Wed, 11 Jul 2007 16:32:13 -0700
Message-Id: <1184196995958-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969912096-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

As kobj sysfs dentries and inodes are gonna be made reclaimable,
dentry can't be used as naming token for sysfs file/directory, replace
kobj->dentry with kobj->sd.  The only external interface change is
shadow directory handling.  All other changes are contained in kobj
and sysfs.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c          |    6 +-
 fs/sysfs/dir.c          |  119 +++++++++++++++++++++++------------------------
 fs/sysfs/file.c         |   47 +++++++++---------
 fs/sysfs/group.c        |   55 +++++++++++-----------
 fs/sysfs/inode.c        |   11 ++--
 fs/sysfs/symlink.c      |   22 ++++-----
 fs/sysfs/sysfs.h        |   10 ++--
 include/linux/kobject.h |    9 ++--
 include/linux/sysfs.h   |   19 ++++---
 lib/kobject.c           |   10 ++--
 10 files changed, 156 insertions(+), 152 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 3c5574a..55796bd 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -234,9 +234,9 @@ const struct file_operations bin_fops = {
 
 int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
-	BUG_ON(!kobj || !kobj->dentry || !attr);
+	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->dentry, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
+	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
 }
 
 
@@ -248,7 +248,7 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 
 void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
-	if (sysfs_hash_and_remove(kobj->dentry, attr->attr.name) < 0) {
+	if (sysfs_hash_and_remove(kobj->sd, attr->attr.name) < 0) {
 		printk(KERN_ERR "%s: "
 			"bad dentry or inode or no such file: \"%s\"\n",
 			__FUNCTION__, attr->attr.name);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4762a9a..31b6cf3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -368,9 +368,10 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 	return sd;
 }
 
-static int create_dir(struct kobject *kobj, struct dentry *parent,
-		      const char *name, struct dentry **p_dentry)
+static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
+		      const char *name, struct sysfs_dirent **p_sd)
 {
+	struct dentry *parent = parent_sd->s_dentry;
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 	struct dentry *dentry;
@@ -409,14 +410,14 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 
 	/* link in */
 	error = -EEXIST;
-	if (sysfs_find_dirent(parent->d_fsdata, name))
+	if (sysfs_find_dirent(parent_sd, name))
 		goto out_iput;
 
 	sysfs_instantiate(dentry, inode);
 	inc_nlink(parent->d_inode);
-	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
+	sysfs_attach_dirent(sd, parent_sd, dentry);
 
-	*p_dentry = dentry;
+	*p_sd = sd;
 	error = 0;
 	goto out_unlock;	/* pin directory dentry in core */
 
@@ -433,38 +434,37 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	return error;
 }
 
-
-int sysfs_create_subdir(struct kobject * k, const char * n, struct dentry ** d)
+int sysfs_create_subdir(struct kobject *kobj, const char *name,
+			struct sysfs_dirent **p_sd)
 {
-	return create_dir(k,k->dentry,n,d);
+	return create_dir(kobj, kobj->sd, name, p_sd);
 }
 
 /**
  *	sysfs_create_dir - create a directory for an object.
  *	@kobj:		object we're creating directory for. 
- *	@shadow_parent:	parent parent object.
+ *	@shadow_parent:	parent object.
  */
-
-int sysfs_create_dir(struct kobject * kobj, struct dentry *shadow_parent)
+int sysfs_create_dir(struct kobject *kobj,
+		     struct sysfs_dirent *shadow_parent_sd)
 {
-	struct dentry * dentry = NULL;
-	struct dentry * parent;
+	struct sysfs_dirent *parent_sd, *sd;
 	int error = 0;
 
 	BUG_ON(!kobj);
 
-	if (shadow_parent)
-		parent = shadow_parent;
+	if (shadow_parent_sd)
+		parent_sd = shadow_parent_sd;
 	else if (kobj->parent)
-		parent = kobj->parent->dentry;
+		parent_sd = kobj->parent->sd;
 	else if (sysfs_mount && sysfs_mount->mnt_sb)
-		parent = sysfs_mount->mnt_sb->s_root;
+		parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
 	else
 		return -EFAULT;
 
-	error = create_dir(kobj,parent,kobject_name(kobj),&dentry);
+	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
 	if (!error)
-		kobj->dentry = dentry;
+		kobj->sd = sd;
 	return error;
 }
 
@@ -525,18 +525,16 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 };
 
-static void remove_dir(struct dentry * d)
+static void remove_dir(struct sysfs_dirent *sd)
 {
-	struct dentry *parent = d->d_parent;
-	struct sysfs_dirent *sd = d->d_fsdata;
+	struct dentry *parent = sd->s_parent->s_dentry;
 
 	mutex_lock(&parent->d_inode->i_mutex);
 
 	sysfs_unlink_sibling(sd);
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
-		 atomic_read(&d->d_count));
+	pr_debug(" o %s removing done\n", sd->s_name);
 
 	mutex_unlock(&parent->d_inode->i_mutex);
 
@@ -545,25 +543,26 @@ static void remove_dir(struct dentry * d)
 	sysfs_put(sd);
 }
 
-void sysfs_remove_subdir(struct dentry * d)
+void sysfs_remove_subdir(struct sysfs_dirent *sd)
 {
-	remove_dir(d);
+	remove_dir(sd);
 }
 
 
-static void __sysfs_remove_dir(struct dentry *dentry)
+static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_dirent *removed = NULL;
-	struct sysfs_dirent *parent_sd;
 	struct sysfs_dirent **pos;
+	struct dentry *dir;
 
-	if (!dentry)
+	if (!dir_sd)
 		return;
 
-	pr_debug("sysfs %s: removing dir\n",dentry->d_name.name);
-	mutex_lock(&dentry->d_inode->i_mutex);
-	parent_sd = dentry->d_fsdata;
-	pos = &parent_sd->s_children;
+	dir = dir_sd->s_dentry;
+
+	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
+	mutex_lock(&dir->d_inode->i_mutex);
+	pos = &dir_sd->s_children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
@@ -575,7 +574,7 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 		} else
 			pos = &(*pos)->s_sibling;
 	}
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_unlock(&dir->d_inode->i_mutex);
 
 	while (removed) {
 		struct sysfs_dirent *sd = removed;
@@ -588,7 +587,7 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 		sysfs_put(sd);
 	}
 
-	remove_dir(dentry);
+	remove_dir(dir_sd);
 }
 
 /**
@@ -602,25 +601,25 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 
 void sysfs_remove_dir(struct kobject * kobj)
 {
-	struct dentry *d = kobj->dentry;
+	struct sysfs_dirent *sd = kobj->sd;
 
 	spin_lock(&kobj_sysfs_assoc_lock);
-	kobj->dentry = NULL;
+	kobj->sd = NULL;
 	spin_unlock(&kobj_sysfs_assoc_lock);
 
-	__sysfs_remove_dir(d);
+	__sysfs_remove_dir(sd);
 }
 
-int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
+int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 		     const char *new_name)
 {
-	struct sysfs_dirent *sd = kobj->dentry->d_fsdata;
-	struct sysfs_dirent *parent_sd = new_parent->d_fsdata;
+	struct sysfs_dirent *sd = kobj->sd;
+	struct dentry *new_parent = new_parent_sd->s_dentry;
 	struct dentry *new_dentry;
 	char *dup_name;
 	int error;
 
-	if (!new_parent)
+	if (!new_parent_sd)
 		return -EFAULT;
 
 	down_write(&sysfs_rename_sem);
@@ -637,9 +636,9 @@ int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 	 * shadows of the same directory
 	 */
 	error = -EINVAL;
-	if (kobj->dentry->d_parent->d_inode != new_parent->d_inode ||
+	if (sd->s_parent->s_dentry->d_inode != new_parent->d_inode ||
 	    new_dentry->d_parent->d_inode != new_parent->d_inode ||
-	    new_dentry == kobj->dentry)
+	    new_dentry == sd->s_dentry)
 		goto out_dput;
 
 	error = -EEXIST;
@@ -661,12 +660,12 @@ int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 
 	/* move under the new parent */
 	d_add(new_dentry, NULL);
-	d_move(kobj->dentry, new_dentry);
+	d_move(sd->s_dentry, new_dentry);
 
 	sysfs_unlink_sibling(sd);
-	sysfs_get(parent_sd);
+	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
-	sd->s_parent = parent_sd;
+	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
 	error = 0;
@@ -691,9 +690,9 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent)
 	int error;
 
 	old_parent_dentry = kobj->parent ?
-		kobj->parent->dentry : sysfs_mount->mnt_sb->s_root;
+		kobj->parent->sd->s_dentry : sysfs_mount->mnt_sb->s_root;
 	new_parent_dentry = new_parent ?
-		new_parent->dentry : sysfs_mount->mnt_sb->s_root;
+		new_parent->sd->s_dentry : sysfs_mount->mnt_sb->s_root;
 
 	if (old_parent_dentry->d_inode == new_parent_dentry->d_inode)
 		return 0;	/* nothing to move */
@@ -705,7 +704,7 @@ again:
 	}
 
 	new_parent_sd = new_parent_dentry->d_fsdata;
-	sd = kobj->dentry->d_fsdata;
+	sd = kobj->sd;
 
 	new_dentry = lookup_one_len(kobj->name, new_parent_dentry,
 				    strlen(kobj->name));
@@ -715,7 +714,7 @@ again:
 	} else
 		error = 0;
 	d_add(new_dentry, NULL);
-	d_move(kobj->dentry, new_dentry);
+	d_move(sd->s_dentry, new_dentry);
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
@@ -885,7 +884,7 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
 	struct inode *inode;
 	struct inode_operations *i_op;
 
-	inode = kobj->dentry->d_inode;
+	inode = kobj->sd->s_dentry->d_inode;
 	if (inode->i_op != &sysfs_dir_inode_operations)
 		return -EINVAL;
 
@@ -912,16 +911,16 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
  *	directory.
  */
 
-struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
+struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 {
-	struct dentry *dir = kobj->dentry;
+	struct dentry *dir = kobj->sd->s_dentry;
 	struct inode *inode = dir->d_inode;
 	struct dentry *parent = dir->d_parent;
 	struct sysfs_dirent *parent_sd = parent->d_fsdata;
 	struct dentry *shadow;
 	struct sysfs_dirent *sd;
 
-	shadow = ERR_PTR(-EINVAL);
+	sd = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
 		goto out;
 
@@ -944,25 +943,25 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	dget(shadow);		/* Extra count - pin the dentry in core */
 
 out:
-	return shadow;
+	return sd;
 nomem:
 	dput(shadow);
-	shadow = ERR_PTR(-ENOMEM);
+	sd = ERR_PTR(-ENOMEM);
 	goto out;
 }
 
 /**
  *	sysfs_remove_shadow_dir - remove an object's directory.
- *	@shadow: dentry of shadow directory
+ *	@shadow_sd: sysfs_dirent of shadow directory
  *
  *	The only thing special about this is that we remove any files in
  *	the directory before we remove the directory, and we've inlined
  *	what used to be sysfs_rmdir() below, instead of calling separately.
  */
 
-void sysfs_remove_shadow_dir(struct dentry *shadow)
+void sysfs_remove_shadow_dir(struct sysfs_dirent *shadow_sd)
 {
-	__sysfs_remove_dir(shadow);
+	__sysfs_remove_dir(shadow_sd);
 }
 
 const struct file_operations sysfs_dir_operations = {
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e448b88..20703b9 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -385,7 +385,7 @@ static struct dentry *step_down(struct dentry *dir, const char * name)
 
 void sysfs_notify(struct kobject * k, char *dir, char *attr)
 {
-	struct dentry *de = k->dentry;
+	struct dentry *de = k->sd->s_dentry;
 	if (de)
 		dget(de);
 	if (de && dir)
@@ -412,16 +412,17 @@ const struct file_operations sysfs_file_operations = {
 };
 
 
-int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
+int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
+		   int type)
 {
-	struct sysfs_dirent * parent_sd = dir->d_fsdata;
+	struct dentry *dir = dir_sd->s_dentry;
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
 	struct sysfs_dirent *sd;
 	int error = 0;
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	if (sysfs_find_dirent(parent_sd, attr->name)) {
+	if (sysfs_find_dirent(dir_sd, attr->name)) {
 		error = -EEXIST;
 		goto out_unlock;
 	}
@@ -432,7 +433,7 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 		goto out_unlock;
 	}
 	sd->s_elem.attr.attr = (void *)attr;
-	sysfs_attach_dirent(sd, parent_sd, NULL);
+	sysfs_attach_dirent(sd, dir_sd, NULL);
 
  out_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
@@ -448,9 +449,9 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 
 int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 {
-	BUG_ON(!kobj || !kobj->dentry || !attr);
+	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->dentry, attr, SYSFS_KOBJ_ATTR);
+	return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
 
 }
 
@@ -464,16 +465,16 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 int sysfs_add_file_to_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-	struct dentry *dir;
+	struct sysfs_dirent *dir_sd;
 	int error;
 
-	dir = lookup_one_len(group, kobj->dentry, strlen(group));
-	if (IS_ERR(dir))
-		error = PTR_ERR(dir);
-	else {
-		error = sysfs_add_file(dir, attr, SYSFS_KOBJ_ATTR);
-		dput(dir);
-	}
+	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (!dir_sd)
+		return -ENOENT;
+
+	error = sysfs_add_file(dir_sd, attr, SYSFS_KOBJ_ATTR);
+	sysfs_put(dir_sd);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
@@ -486,7 +487,7 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
  */
 int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 {
-	struct dentry * dir = kobj->dentry;
+	struct dentry *dir = kobj->sd->s_dentry;
 	struct dentry * victim;
 	int res = -ENOENT;
 
@@ -522,7 +523,7 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
  */
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
-	struct dentry *dir = kobj->dentry;
+	struct dentry *dir = kobj->sd->s_dentry;
 	struct dentry *victim;
 	struct inode * inode;
 	struct iattr newattrs;
@@ -560,7 +561,7 @@ EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
 void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr)
 {
-	sysfs_hash_and_remove(kobj->dentry, attr->name);
+	sysfs_hash_and_remove(kobj->sd, attr->name);
 }
 
 
@@ -573,12 +574,12 @@ void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr)
 void sysfs_remove_file_from_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-	struct dentry *dir;
+	struct sysfs_dirent *dir_sd;
 
-	dir = lookup_one_len(group, kobj->dentry, strlen(group));
-	if (!IS_ERR(dir)) {
-		sysfs_hash_and_remove(dir, attr->name);
-		dput(dir);
+	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (dir_sd) {
+		sysfs_hash_and_remove(dir_sd, attr->name);
+		sysfs_put(dir_sd);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 52eed2a..f318b73 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -18,26 +18,25 @@
 #include "sysfs.h"
 
 
-static void remove_files(struct dentry * dir, 
-			 const struct attribute_group * grp)
+static void remove_files(struct sysfs_dirent *dir_sd,
+			 const struct attribute_group *grp)
 {
 	struct attribute *const* attr;
 
 	for (attr = grp->attrs; *attr; attr++)
-		sysfs_hash_and_remove(dir,(*attr)->name);
+		sysfs_hash_and_remove(dir_sd, (*attr)->name);
 }
 
-static int create_files(struct dentry * dir,
-			const struct attribute_group * grp)
+static int create_files(struct sysfs_dirent *dir_sd,
+			const struct attribute_group *grp)
 {
 	struct attribute *const* attr;
 	int error = 0;
 
-	for (attr = grp->attrs; *attr && !error; attr++) {
-		error = sysfs_add_file(dir, *attr, SYSFS_KOBJ_ATTR);
-	}
+	for (attr = grp->attrs; *attr && !error; attr++)
+		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
 	if (error)
-		remove_files(dir,grp);
+		remove_files(dir_sd, grp);
 	return error;
 }
 
@@ -45,44 +44,44 @@ static int create_files(struct dentry * dir,
 int sysfs_create_group(struct kobject * kobj, 
 		       const struct attribute_group * grp)
 {
-	struct dentry * dir;
+	struct sysfs_dirent *sd;
 	int error;
 
-	BUG_ON(!kobj || !kobj->dentry);
+	BUG_ON(!kobj || !kobj->sd);
 
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj,grp->name,&dir);
+		error = sysfs_create_subdir(kobj, grp->name, &sd);
 		if (error)
 			return error;
 	} else
-		dir = kobj->dentry;
-	dir = dget(dir);
-	if ((error = create_files(dir,grp))) {
+		sd = kobj->sd;
+	sysfs_get(sd);
+	error = create_files(sd, grp);
+	if (error) {
 		if (grp->name)
-			sysfs_remove_subdir(dir);
+			sysfs_remove_subdir(sd);
 	}
-	dput(dir);
+	sysfs_put(sd);
 	return error;
 }
 
 void sysfs_remove_group(struct kobject * kobj, 
 			const struct attribute_group * grp)
 {
-	struct dentry * dir;
+	struct sysfs_dirent *dir_sd = kobj->sd;
+	struct sysfs_dirent *sd;
 
 	if (grp->name) {
-		dir = lookup_one_len_kern(grp->name, kobj->dentry,
-				strlen(grp->name));
-		BUG_ON(IS_ERR(dir));
-	}
-	else
-		dir = dget(kobj->dentry);
+		sd = sysfs_get_dirent(dir_sd, grp->name);
+		BUG_ON(!sd);
+	} else
+		sd = sysfs_get(dir_sd);
 
-	remove_files(dir,grp);
+	remove_files(sd, grp);
 	if (grp->name)
-		sysfs_remove_subdir(dir);
-	/* release the ref. taken in this routine */
-	dput(dir);
+		sysfs_remove_subdir(sd);
+
+	sysfs_put(sd);
 }
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e2f6ef1..1be8537 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -275,22 +275,23 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	}
 }
 
-int sysfs_hash_and_remove(struct dentry * dir, const char * name)
+int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
+	struct dentry *dir;
 	struct sysfs_dirent **pos, *sd;
-	struct sysfs_dirent *parent_sd;
 	int found = 0;
 
-	if (!dir)
+	if (!dir_sd)
 		return -ENOENT;
 
+	dir = dir_sd->s_dentry;
+
 	if (dir->d_inode == NULL)
 		/* no inode means this hasn't been made visible yet */
 		return -ENOENT;
 
-	parent_sd = dir->d_fsdata;
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
+	for (pos = &dir_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
 
 		if (!sysfs_type(sd))
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 45b62e2..43cc522 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -66,7 +66,6 @@ static int sysfs_add_link(struct sysfs_dirent * parent_sd, const char * name,
  */
 int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
 {
-	struct dentry *dentry = NULL;
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
 	int error = -EEXIST;
@@ -75,29 +74,28 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	if (!kobj) {
 		if (sysfs_mount && sysfs_mount->mnt_sb)
-			dentry = sysfs_mount->mnt_sb->s_root;
+			parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
 	} else
-		dentry = kobj->dentry;
+		parent_sd = kobj->sd;
 
-	if (!dentry)
+	if (!parent_sd)
 		return -EFAULT;
-	parent_sd = dentry->d_fsdata;
 
-	/* target->dentry can go away beneath us but is protected with
+	/* target->sd can go away beneath us but is protected with
 	 * kobj_sysfs_assoc_lock.  Fetch target_sd from it.
 	 */
 	spin_lock(&kobj_sysfs_assoc_lock);
-	if (target->dentry)
-		target_sd = sysfs_get(target->dentry->d_fsdata);
+	if (target->sd)
+		target_sd = sysfs_get(target->sd);
 	spin_unlock(&kobj_sysfs_assoc_lock);
 
 	if (!target_sd)
 		return -ENOENT;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
-	if (!sysfs_find_dirent(dentry->d_fsdata, name))
+	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
+	if (!sysfs_find_dirent(parent_sd, name))
 		error = sysfs_add_link(parent_sd, name, target_sd);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
 
 	if (error)
 		sysfs_put(target_sd);
@@ -114,7 +112,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 void sysfs_remove_link(struct kobject * kobj, const char * name)
 {
-	sysfs_hash_and_remove(kobj->dentry,name);
+	sysfs_hash_and_remove(kobj->sd, name);
 }
 
 static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f1629b4..27a5f4b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -69,12 +69,14 @@ extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
 				struct sysfs_dirent *parent_sd,
 				struct dentry *dentry);
 
-extern int sysfs_add_file(struct dentry *, const struct attribute *, int);
-extern int sysfs_hash_and_remove(struct dentry * dir, const char * name);
+extern int sysfs_add_file(struct sysfs_dirent *dir_sd,
+			  const struct attribute *attr, int type);
+extern int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 extern struct sysfs_dirent *sysfs_find(struct sysfs_dirent *dir, const char * name);
 
-extern int sysfs_create_subdir(struct kobject *, const char *, struct dentry **);
-extern void sysfs_remove_subdir(struct dentry *);
+extern int sysfs_create_subdir(struct kobject *kobj, const char *name,
+			       struct sysfs_dirent **p_sd);
+extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index c288e41..06cbf41 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -55,7 +55,7 @@ struct kobject {
 	struct kobject		* parent;
 	struct kset		* kset;
 	struct kobj_type	* ktype;
-	struct dentry		* dentry;
+	struct sysfs_dirent	* sd;
 	wait_queue_head_t	poll;
 };
 
@@ -71,13 +71,14 @@ extern void kobject_init(struct kobject *);
 extern void kobject_cleanup(struct kobject *);
 
 extern int __must_check kobject_add(struct kobject *);
-extern int __must_check kobject_shadow_add(struct kobject *, struct dentry *);
+extern int __must_check kobject_shadow_add(struct kobject *kobj,
+					   struct sysfs_dirent *shadow_parent);
 extern void kobject_del(struct kobject *);
 
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_shadow_rename(struct kobject *kobj,
-						struct dentry *new_parent,
-						const char *new_name);
+					      struct sysfs_dirent *new_parent,
+					      const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
 extern int __must_check kobject_register(struct kobject *);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2a6df64..4c43030 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -19,6 +19,7 @@ struct kobject;
 struct module;
 struct nameidata;
 struct dentry;
+struct sysfs_dirent;
 
 /* FIXME
  * The *owner field is no longer used, but leave around
@@ -92,13 +93,14 @@ extern int sysfs_schedule_callback(struct kobject *kobj,
 		void (*func)(void *), void *data, struct module *owner);
 
 extern int __must_check
-sysfs_create_dir(struct kobject *, struct dentry *);
+sysfs_create_dir(struct kobject *kobj, struct sysfs_dirent *shadow_parent_sd);
 
 extern void
 sysfs_remove_dir(struct kobject *);
 
 extern int __must_check
-sysfs_rename_dir(struct kobject *, struct dentry *, const char *new_name);
+sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
+		 const char *new_name);
 
 extern int __must_check
 sysfs_move_dir(struct kobject *, struct kobject *);
@@ -138,8 +140,8 @@ void sysfs_notify(struct kobject * k, char *dir, char *attr);
 
 extern int sysfs_make_shadowed_dir(struct kobject *kobj,
 	void * (*follow_link)(struct dentry *, struct nameidata *));
-extern struct dentry *sysfs_create_shadow_dir(struct kobject *kobj);
-extern void sysfs_remove_shadow_dir(struct dentry *dir);
+extern struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj);
+extern void sysfs_remove_shadow_dir(struct sysfs_dirent *shadow_sd);
 
 extern int __must_check sysfs_init(void);
 
@@ -151,7 +153,8 @@ static inline int sysfs_schedule_callback(struct kobject *kobj,
 	return -ENOSYS;
 }
 
-static inline int sysfs_create_dir(struct kobject * k, struct dentry *shadow)
+static inline int sysfs_create_dir(struct kobject *kobj,
+				   struct sysfs_dirent *shadow_parent_sd)
 {
 	return 0;
 }
@@ -161,9 +164,9 @@ static inline void sysfs_remove_dir(struct kobject * k)
 	;
 }
 
-static inline int sysfs_rename_dir(struct kobject * k,
-					struct dentry *new_parent,
-					const char *new_name)
+static inline int sysfs_rename_dir(struct kobject *kobj,
+				   struct sysfs_dirent *new_parent_sd,
+				   const char *new_name)
 {
 	return 0;
 }
diff --git a/lib/kobject.c b/lib/kobject.c
index b4ebd76..4b08e0f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -44,7 +44,7 @@ static int populate_dir(struct kobject * kobj)
 	return error;
 }
 
-static int create_dir(struct kobject * kobj, struct dentry *shadow_parent)
+static int create_dir(struct kobject *kobj, struct sysfs_dirent *shadow_parent)
 {
 	int error = 0;
 	if (kobject_name(kobj)) {
@@ -162,7 +162,7 @@ static void unlink(struct kobject * kobj)
  *	@shadow_parent: sysfs directory to add to.
  */
 
-int kobject_shadow_add(struct kobject * kobj, struct dentry *shadow_parent)
+int kobject_shadow_add(struct kobject *kobj, struct sysfs_dirent *shadow_parent)
 {
 	int error = 0;
 	struct kobject * parent;
@@ -338,7 +338,7 @@ int kobject_rename(struct kobject * kobj, const char *new_name)
 	/* Note : if we want to send the new name alone, not the full path,
 	 * we could probably use kobject_name(kobj); */
 
-	error = sysfs_rename_dir(kobj, kobj->parent->dentry, new_name);
+	error = sysfs_rename_dir(kobj, kobj->parent->sd, new_name);
 
 	/* This function is mostly/only used for network interface.
 	 * Some hotplug package track interfaces by their name and
@@ -361,8 +361,8 @@ out:
  *	@new_name: object's new name
  */
 
-int kobject_shadow_rename(struct kobject * kobj, struct dentry *new_parent,
-			  const char *new_name)
+int kobject_shadow_rename(struct kobject *kobj,
+			  struct sysfs_dirent *new_parent, const char *new_name)
 {
 	int error = 0;
 
-- 
1.5.2.2

