Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXJLW5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXJLW5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbXJLWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:51 -0400
Received: from ns1.suse.de ([195.135.220.2]:53578 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbXJLWWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 66/75] sysfs: move sysfs file poll implementation to sysfs_open_dirent
Date: Fri, 12 Oct 2007 15:17:10 -0700
Message-Id: <11922277493627-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277441791-git-send-email-gregkh@suse.de>
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
 <11922277441791-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Sysfs file poll implementation is scattered over sysfs and kobject.
Event numbering is done in sysfs_dirent but wait itself is done on
kobject.  This not only unecessarily bloats both kobject and
sysfs_dirent but is also buggy - if a sysfs_dirent is removed while
there still are pollers, the associaton betwen the kobject and
sysfs_dirent breaks and kobject may be freed with the pollers still
sleeping on it.

This patch moves whole poll implementation into sysfs_open_dirent.
Each time a sysfs_open_dirent is created, event number restarts from 1
and pollers sleep on sysfs_open_dirent.  As event sequence number is
meaningless without any open file and pollers should have open file
and thus sysfs_open_dirent, this ephemeral event counting works and is
a saner implementation.

This patch fixes the dnagling sleepers bug and reduces the sizes of
kobject and sysfs_dirent by one pointer.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c          |    1 -
 fs/sysfs/file.c         |   25 +++++++++++++++++++------
 fs/sysfs/sysfs.h        |    1 -
 include/linux/kobject.h |    1 -
 lib/kobject.c           |    1 -
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4ad9422..e301a12 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -318,7 +318,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	atomic_set(&sd->s_event, 1);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b13ba94..c05f961 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -62,6 +62,8 @@ static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
+	atomic_t		event;
+	wait_queue_head_t	poll;
 	struct list_head	buffers; /* goes through sysfs_buffer.list */
 };
 
@@ -104,7 +106,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	buffer->event = atomic_read(&attr_sd->s_event);
+	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
 	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
 	sysfs_put_active_two(attr_sd);
@@ -301,6 +303,8 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 		return -ENOMEM;
 
 	atomic_set(&new_od->refcnt, 0);
+	atomic_set(&new_od->event, 1);
+	init_waitqueue_head(&new_od->poll);
 	INIT_LIST_HEAD(&new_od->buffers);
 	goto retry;
 }
@@ -443,17 +447,17 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active_two(attr_sd))
 		goto trigger;
 
-	poll_wait(filp, &kobj->poll, wait);
+	poll_wait(filp, &od->poll, wait);
 
 	sysfs_put_active_two(attr_sd);
 
-	if (buffer->event != atomic_read(&attr_sd->s_event))
+	if (buffer->event != atomic_read(&od->event))
 		goto trigger;
 
 	return 0;
@@ -474,8 +478,17 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
 	if (sd && attr)
 		sd = sysfs_find_dirent(sd, attr);
 	if (sd) {
-		atomic_inc(&sd->s_event);
-		wake_up_interruptible(&k->poll);
+		struct sysfs_open_dirent *od;
+
+		spin_lock(&sysfs_open_dirent_lock);
+
+		od = sd->s_attr.open;
+		if (od) {
+			atomic_inc(&od->event);
+			wake_up_interruptible(&od->poll);
+		}
+
+		spin_unlock(&sysfs_open_dirent_lock);
 	}
 
 	mutex_unlock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3adce7d..269c845 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -46,7 +46,6 @@ struct sysfs_dirent {
 	ino_t			s_ino;
 	umode_t			s_mode;
 	struct iattr		*s_iattr;
-	atomic_t		s_event;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 0777b3f..a8a84fc 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -66,7 +66,6 @@ struct kobject {
 	struct kset		* kset;
 	struct kobj_type	* ktype;
 	struct sysfs_dirent	* sd;
-	wait_queue_head_t	poll;
 };
 
 extern int kobject_set_name(struct kobject *, const char *, ...)
diff --git a/lib/kobject.c b/lib/kobject.c
index e8181d3..fc6db6b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -131,7 +131,6 @@ void kobject_init(struct kobject * kobj)
 		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
-	init_waitqueue_head(&kobj->poll);
 	kobj->kset = kset_get(kobj->kset);
 }
 
-- 
1.5.3.4

