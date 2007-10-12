Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXJLWyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXJLWyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbXJLWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:49992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbXJLWWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/75] sysfs: make s_elem an anonymous union
Date: Fri, 12 Oct 2007 15:17:05 -0700
Message-Id: <11922277261501-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277222714-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Make s_elem an anonymous union.  Prefixing with s_elem makes things
needlessly longer without any advantage.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c     |   14 +++++++-------
 fs/sysfs/dir.c     |    4 ++--
 fs/sysfs/file.c    |   14 +++++++-------
 fs/sysfs/inode.c   |    2 +-
 fs/sysfs/symlink.c |    4 ++--
 fs/sysfs/sysfs.h   |   10 +++++-----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9c8f882..247ea19 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -30,8 +30,8 @@ static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -87,8 +87,8 @@ static int
 flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -140,8 +140,8 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
 
 	mutex_lock(&bb->mutex);
@@ -167,7 +167,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 static int open(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
+	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct bin_buffer *bb = NULL;
 	int error;
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index fc615ee..6ee76a8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -273,7 +273,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	parent_sd = sd->s_parent;
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
-		sysfs_put(sd->s_elem.symlink.target_sd);
+		sysfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
@@ -630,7 +630,7 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_elem.dir.kobj = kobj;
+	sd->s_dir.kobj = kobj;
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8f1ebd8..3c91a57 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -73,7 +73,7 @@ struct sysfs_buffer {
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
@@ -88,7 +88,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 		return -ENODEV;
 
 	buffer->event = atomic_read(&attr_sd->s_event);
-	count = ops->show(kobj, attr_sd->s_elem.attr.attr, buffer->page);
+	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
 	sysfs_put_active_two(attr_sd);
 
@@ -188,7 +188,7 @@ static int
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
@@ -196,7 +196,7 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	rc = ops->store(kobj, attr_sd->s_elem.attr.attr, buffer->page, count);
+	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
 	sysfs_put_active_two(attr_sd);
 
@@ -240,7 +240,7 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
@@ -336,7 +336,7 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active_two(attr_sd))
@@ -396,7 +396,7 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_elem.attr.attr = (void *)attr;
+	sd->s_attr.attr = (void *)attr;
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0d706a8..b6ac4e6 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -172,7 +172,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->s_elem.bin_attr.bin_attr;
+		bin_attr = sd->s_bin_attr.bin_attr;
 		inode->i_size = bin_attr->size;
 		inode->i_fop = &bin_fops;
 		break;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 8ad38bc..ffa82e9 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -86,7 +86,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	if (!sd)
 		goto out_put;
 
-	sd->s_elem.symlink.target_sd = target_sd;
+	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
@@ -142,7 +142,7 @@ static int sysfs_getlink(struct dentry *dentry, char * path)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
+	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6cf61c8..2a68bfa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -32,11 +32,11 @@ struct sysfs_dirent {
 	const char		*s_name;
 
 	union {
-		struct sysfs_elem_dir		dir;
-		struct sysfs_elem_symlink	symlink;
-		struct sysfs_elem_attr		attr;
-		struct sysfs_elem_bin_attr	bin_attr;
-	}			s_elem;
+		struct sysfs_elem_dir		s_dir;
+		struct sysfs_elem_symlink	s_symlink;
+		struct sysfs_elem_attr		s_attr;
+		struct sysfs_elem_bin_attr	s_bin_attr;
+	};
 
 	unsigned int		s_flags;
 	ino_t			s_ino;
-- 
1.5.3.4

