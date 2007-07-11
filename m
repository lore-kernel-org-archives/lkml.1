Return-Path: <linux-kernel-owner+w=401wt.eu-S935412AbXGKX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbXGKX5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935294AbXGKXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:33462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935288AbXGKXgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/61] sysfs: rename sysfs_dirent->s_type to s_flags and make room for flags
Date: Wed, 11 Jul 2007 16:32:10 -0700
Message-Id: <11841969814023-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969771935-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Rename sysfs_dirent->s_type to s_flags, pack type into lower eight
bits and reserve the rest for flags.  sysfs_type() can used to access
the type.  All existing sd->s_type accesses are converted to use
sysfs_type().  While at it, type test is changed to equality test
instead of bit-and test where appropriate.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |   33 ++++++++++++++++++++-------------
 fs/sysfs/inode.c      |    8 ++++----
 fs/sysfs/mount.c      |    2 +-
 fs/sysfs/sysfs.h      |    7 ++++++-
 include/linux/sysfs.h |    3 +++
 5 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b4074ad..eb9bc0a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -218,9 +218,9 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
  repeat:
 	parent_sd = sd->s_parent;
 
-	if (sd->s_type & SYSFS_KOBJ_LINK)
+	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_elem.symlink.target_sd);
-	if (sd->s_type & SYSFS_COPY_NAME)
+	if (sysfs_type(sd) & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
@@ -282,7 +282,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	sd->s_name = name;
 	sd->s_mode = mode;
-	sd->s_type = type;
+	sd->s_flags = type;
 
 	return sd;
 
@@ -330,7 +330,7 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 	struct sysfs_dirent * sd;
 
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if (sd->s_type) {
+		if (sysfs_type(sd)) {
 			if (strcmp(sd->s_name, new))
 				continue;
 			else
@@ -446,11 +446,12 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent * sd;
+	struct bin_attribute *bin_attr;
 	struct inode *inode;
 	int found = 0;
 
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if ((sd->s_type & SYSFS_NOT_PINNED) &&
+		if ((sysfs_type(sd) & SYSFS_NOT_PINNED) &&
 		    !strcmp(sd->s_name, dentry->d_name.name)) {
 			found = 1;
 			break;
@@ -468,16 +469,22 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
-		if (sd->s_type & SYSFS_KOBJ_ATTR) {
+		switch (sysfs_type(sd)) {
+		case SYSFS_KOBJ_ATTR:
 			inode->i_size = PAGE_SIZE;
 			inode->i_fop = &sysfs_file_operations;
-		} else if (sd->s_type & SYSFS_KOBJ_BIN_ATTR) {
-			struct bin_attribute *bin_attr =
-				sd->s_elem.bin_attr.bin_attr;
+			break;
+		case SYSFS_KOBJ_BIN_ATTR:
+			bin_attr = sd->s_elem.bin_attr.bin_attr;
 			inode->i_size = bin_attr->size;
 			inode->i_fop = &bin_fops;
-		} else if (sd->s_type & SYSFS_KOBJ_LINK)
+			break;
+		case SYSFS_KOBJ_LINK:
 			inode->i_op = &sysfs_symlink_inode_operations;
+			break;
+		default:
+			BUG();
+		}
 	}
 
 	sysfs_instantiate(dentry, inode);
@@ -532,7 +539,7 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
-		if (sd->s_type && (sd->s_type & SYSFS_NOT_PINNED)) {
+		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
 			*pos = sd->s_sibling;
 			sd->s_sibling = removed;
 			removed = sd;
@@ -775,7 +782,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				const char * name;
 				int len;
 
-				if (!next->s_type)
+				if (!sysfs_type(next))
 					continue;
 
 				name = next->s_name;
@@ -824,7 +831,7 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
 			pos = &sd->s_children;
 			while (n && *pos) {
 				struct sysfs_dirent *next = *pos;
-				if (next->s_type)
+				if (sysfs_type(next))
 					n--;
 				pos = &(*pos)->s_sibling;
 			}
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 63daa06..ee3a5d9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -242,7 +242,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 
 	dput(dentry);
 	/* XXX: unpin if directory, this will go away soon */
-	if (sd->s_type & SYSFS_DIR)
+	if (sysfs_type(sd) == SYSFS_DIR)
 		dput(dentry);
 
 	/* adjust nlink and update timestamp */
@@ -254,7 +254,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 
 		inode->i_ctime = curtime;
 		drop_nlink(inode);
-		if (sd->s_type & SYSFS_DIR)
+		if (sysfs_type(sd) == SYSFS_DIR)
 			drop_nlink(inode);
 
 		mutex_unlock(&inode->i_mutex);
@@ -267,7 +267,7 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 		mutex_lock(&inode->i_mutex);
 
 		inode->i_ctime = inode->i_mtime = curtime;
-		if (sd->s_type & SYSFS_DIR)
+		if (sysfs_type(sd) == SYSFS_DIR)
 			drop_nlink(inode);
 
 		mutex_unlock(&inode->i_mutex);
@@ -293,7 +293,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
 
-		if (!sd->s_type)
+		if (!sysfs_type(sd))
 			continue;
 		if (!strcmp(sd->s_name, name)) {
 			*pos = sd->s_sibling;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4be9593..078537e 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -26,7 +26,7 @@ static const struct super_operations sysfs_ops = {
 
 static struct sysfs_dirent sysfs_root = {
 	.s_count	= ATOMIC_INIT(1),
-	.s_type		= SYSFS_ROOT,
+	.s_flags	= SYSFS_ROOT,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
 };
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6f8aaf3..06b5085 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -34,7 +34,7 @@ struct sysfs_dirent {
 		struct sysfs_elem_bin_attr	bin_attr;
 	}			s_elem;
 
-	int			s_type;
+	unsigned int		s_flags;
 	umode_t			s_mode;
 	ino_t			s_ino;
 	struct dentry		* s_dentry;
@@ -86,6 +86,11 @@ extern const struct file_operations bin_fops;
 extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
+static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_TYPE_MASK;
+}
+
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 161e19a..5813550 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -74,6 +74,7 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
+#define SYSFS_TYPE_MASK		0x00ff
 #define SYSFS_ROOT		0x0001
 #define SYSFS_DIR		0x0002
 #define SYSFS_KOBJ_ATTR 	0x0004
@@ -82,6 +83,8 @@ struct sysfs_ops {
 #define SYSFS_NOT_PINNED	(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR | SYSFS_KOBJ_LINK)
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
+#define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+
 #ifdef CONFIG_SYSFS
 
 extern int sysfs_schedule_callback(struct kobject *kobj,
-- 
1.5.2.2

