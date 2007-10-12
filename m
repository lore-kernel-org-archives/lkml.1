Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbXJLW4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbXJLW4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbXJLWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:53568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbXJLWWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/75] sysfs: implement sysfs_open_dirent
Date: Fri, 12 Oct 2007 15:17:09 -0700
Message-Id: <11922277441791-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277403355-git-send-email-gregkh@suse.de>
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
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
 <11922277364080-git-send-email-gregkh@suse.de>
 <11922277403355-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Implement sysfs_open_dirent which represents an open file (attribute)
sysfs_dirent.  A file sysfs_dirent with one or more open files have
one sysfs_dirent and all sysfs_buffers (one for each open instance)
are linked to it.

sysfs_open_dirent doesn't actually do anything yet but will be used to
off-load things which are specific for open file sysfs_dirent from it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c  |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |    3 +
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3c91a57..b13ba94 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -49,6 +49,22 @@ static struct sysfs_ops subsys_sysfs_ops = {
 	.store	= subsys_attr_store,
 };
 
+/*
+ * There's one sysfs_buffer for each open file and one
+ * sysfs_open_dirent for each sysfs_dirent with one or more open
+ * files.
+ *
+ * filp->private_data points to sysfs_buffer and
+ * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
+ * is protected by sysfs_open_dirent_lock.
+ */
+static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+
+struct sysfs_open_dirent {
+	atomic_t		refcnt;
+	struct list_head	buffers; /* goes through sysfs_buffer.list */
+};
+
 struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
@@ -57,6 +73,7 @@ struct sysfs_buffer {
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
+	struct list_head	list;
 };
 
 /**
@@ -237,6 +254,86 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 	return len;
 }
 
+/**
+ *	sysfs_get_open_dirent - get or create sysfs_open_dirent
+ *	@sd: target sysfs_dirent
+ *	@buffer: sysfs_buffer for this instance of open
+ *
+ *	If @sd->s_attr.open exists, increment its reference count;
+ *	otherwise, create one.  @buffer is chained to the buffers
+ *	list.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
+				 struct sysfs_buffer *buffer)
+{
+	struct sysfs_open_dirent *od, *new_od = NULL;
+
+ retry:
+	spin_lock(&sysfs_open_dirent_lock);
+
+	if (!sd->s_attr.open && new_od) {
+		sd->s_attr.open = new_od;
+		new_od = NULL;
+	}
+
+	od = sd->s_attr.open;
+	if (od) {
+		atomic_inc(&od->refcnt);
+		list_add_tail(&buffer->list, &od->buffers);
+	}
+
+	spin_unlock(&sysfs_open_dirent_lock);
+
+	if (od) {
+		kfree(new_od);
+		return 0;
+	}
+
+	/* not there, initialize a new one and retry */
+	new_od = kmalloc(sizeof(*new_od), GFP_KERNEL);
+	if (!new_od)
+		return -ENOMEM;
+
+	atomic_set(&new_od->refcnt, 0);
+	INIT_LIST_HEAD(&new_od->buffers);
+	goto retry;
+}
+
+/**
+ *	sysfs_put_open_dirent - put sysfs_open_dirent
+ *	@sd: target sysfs_dirent
+ *	@buffer: associated sysfs_buffer
+ *
+ *	Put @sd->s_attr.open and unlink @buffer from the buffers list.
+ *	If reference count reaches zero, disassociate and free it.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
+				  struct sysfs_buffer *buffer)
+{
+	struct sysfs_open_dirent *od = sd->s_attr.open;
+
+	spin_lock(&sysfs_open_dirent_lock);
+
+	list_del(&buffer->list);
+	if (atomic_dec_and_test(&od->refcnt))
+		sd->s_attr.open = NULL;
+	else
+		od = NULL;
+
+	spin_unlock(&sysfs_open_dirent_lock);
+
+	kfree(od);
+}
+
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
@@ -298,19 +395,29 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	buffer->ops = ops;
 	file->private_data = buffer;
 
+	/* make sure we have open dirent struct */
+	error = sysfs_get_open_dirent(attr_sd, buffer);
+	if (error)
+		goto err_free;
+
 	/* open succeeded, put active references */
 	sysfs_put_active_two(attr_sd);
 	return 0;
 
+ err_free:
+	kfree(buffer);
  err_out:
 	sysfs_put_active_two(attr_sd);
 	return error;
 }
 
-static int sysfs_release(struct inode * inode, struct file * filp)
+static int sysfs_release(struct inode *inode, struct file *filp)
 {
+	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
 
+	sysfs_put_open_dirent(sd, buffer);
+
 	if (buffer->page)
 		free_page((unsigned long)buffer->page);
 	kfree(buffer);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 42b0327..3adce7d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,3 +1,5 @@
+struct sysfs_open_dirent;
+
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
@@ -11,6 +13,7 @@ struct sysfs_elem_symlink {
 
 struct sysfs_elem_attr {
 	struct attribute	*attr;
+	struct sysfs_open_dirent *open;
 };
 
 struct sysfs_elem_bin_attr {
-- 
1.5.3.4

