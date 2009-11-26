Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZKZDV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZKZDV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbZKZDVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:21:55 -0500
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:14571
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224AbZKZDVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:21:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACiDDUt8qYZ9/2dsb2JhbACER78YkGCBL4IuVQSBcoEV
X-IronPort-AV: E=Sophos;i="4.47,290,1257091200"; 
   d="scan'208";a="583332835"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 1/3] autofs4 - coding style fixes
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 26 Nov 2009 11:21:54 +0800
Message-ID: <20091126032154.5691.20876.stgit@zeus.themaw.net>
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

 fs/autofs4/autofs_i.h  |   26 +++++++++++-----------
 fs/autofs4/dev-ioctl.c |    3 ++-
 fs/autofs4/expire.c    |   36 +++++++++++++++++-------------
 fs/autofs4/init.c      |    7 ++----
 fs/autofs4/inode.c     |   22 +++++++++----------
 fs/autofs4/root.c      |   57 +++++++++++++++++++++++++++---------------------
 fs/autofs4/symlink.c   |    5 +---
 fs/autofs4/waitq.c     |   21 +++++++++---------
 8 files changed, 92 insertions(+), 85 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 0118d67..b4a0d82 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -1,7 +1,4 @@
-/* -*- c -*- ------------------------------------------------------------- *
- *   
- * linux/fs/autofs/autofs_i.h
- *
+/*
  *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
  *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
@@ -101,7 +98,7 @@ struct autofs_info {
 	} u;
 };
 
-#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
 #define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
 #define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 #define AUTOFS_INF_REHASH	(1<<3) /* dentry in transit to ->lookup() */
@@ -158,11 +155,13 @@ static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
 	return (struct autofs_info *)(dentry->d_fsdata);
 }
 
-/* autofs4_oz_mode(): do we see the man behind the curtain?  (The
-   processes which do manipulations for us in user space sees the raw
-   filesystem without "magic".) */
-
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
+/*
+ * autofs4_oz_mode(): do we see the man behind the curtain?  (The
+ * processes which do manipulations for us in user space sees the raw
+ * filesystem without "magic".)
+ */
+static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+{
 	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
 }
 
@@ -225,12 +224,13 @@ extern const struct file_operations autofs4_root_operations;
 /* Initializing function */
 
 int autofs4_fill_super(struct super_block *, void *, int);
-struct autofs_info *autofs4_init_ino(struct autofs_info *, struct autofs_sb_info *sbi, mode_t mode);
+struct autofs_info *autofs4_init_ino(struct autofs_info *,
+				     struct autofs_sb_info *, mode_t);
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
+int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
 void autofs4_catatonic_mode(struct autofs_sb_info *);
 
 static inline int autofs4_follow_mount(struct path *path)
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 00bf8fc..a0dcc5b 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -620,7 +620,8 @@ static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 }
 
 /* ioctl dispatcher */
-static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+static int
+_autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
 {
 	struct autofs_dev_ioctl *param;
 	struct file *fp;
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 74bc9aa..204c4fe 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/expire.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
@@ -144,7 +141,7 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
  * The tree is not busy iff no mountpoints are busy
  */
 static int autofs4_tree_busy(struct vfsmount *mnt,
-	       		     struct dentry *top,
+			     struct dentry *top,
 			     unsigned long timeout,
 			     int do_now)
 {
@@ -319,10 +316,14 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 	spin_lock(&dcache_lock);
 	next = root->d_subdirs.next;
 
-	/* On exit from the loop expire is set to a dgot dentry
-	 * to expire or it's NULL */
-	while ( next != &root->d_subdirs ) {
-		struct dentry *dentry = list_entry(next, struct dentry, d_u.d_child);
+	/*
+	 * On exit from the loop expire is set to a dgot dentry
+	 * to expire or it's NULL
+	 */
+	while (next != &root->d_subdirs) {
+		struct dentry *dentry;
+
+		dentry = list_entry(next, struct dentry, d_u.d_child);
 
 		/* Negative dentry - give up */
 		if (!simple_positive(dentry)) {
@@ -343,8 +344,8 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		 *	   offset (autofs-5.0+).
 		 */
 		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
+			DPRINTK("checking mountpoint %p %.*s", dentry,
+				(int)dentry->d_name.len, dentry->d_name.name);
 
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 2;
@@ -456,12 +457,13 @@ int autofs4_expire_run(struct super_block *sb,
 	struct dentry *dentry;
 	int ret = 0;
 
-	memset(&pkt,0,sizeof pkt);
+	memset(&pkt, 0, sizeof pkt);
 
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	if ((dentry = autofs4_expire_indirect(sb, mnt, sbi, 0)) == NULL)
+	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
+	if (dentry == NULL)
 		return -EAGAIN;
 
 	pkt.len = dentry->d_name.len;
@@ -469,7 +471,7 @@ int autofs4_expire_run(struct super_block *sb,
 	pkt.name[pkt.len] = '\0';
 	dput(dentry);
 
-	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
@@ -496,8 +498,10 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	if (dentry) {
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
 
-		/* This is synchronous because it makes the daemon a
-                   little easier */
+		/*
+		 * This is synchronous because it makes the daemon a
+		 * little easier
+		 */
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 9722e4b..11cc42b 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/init.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
@@ -46,6 +43,6 @@ static void __exit exit_autofs4_fs(void)
 	unregister_filesystem(&autofs_fs_type);
 }
 
-module_init(init_autofs4_fs) 
+module_init(init_autofs4_fs)
 module_exit(exit_autofs4_fs)
 MODULE_LICENSE("GPL");
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index d0a3de2..5b006db 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/inode.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
@@ -116,7 +113,9 @@ repeat:
 	next = this_parent->d_subdirs.next;
 resume:
 	while (next != &this_parent->d_subdirs) {
-		struct dentry *dentry = list_entry(next, struct dentry, d_u.d_child);
+		struct dentry *dentry;
+
+		dentry = list_entry(next, struct dentry, d_u.d_child);
 
 		/* Negative dentry - don`t care */
 		if (!simple_positive(dentry)) {
@@ -328,7 +327,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
-	DPRINTK("starting up, sbi = %p",sbi);
+	DPRINTK("starting up, sbi = %p", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
@@ -377,7 +376,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
 				&sbi->max_proto)) {
-		printk("autofs: called with bogus options\n");
+		printk(KERN_ERR "autofs: called with bogus options\n");
 		goto fail_dput;
 	}
 
@@ -389,8 +388,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
+		printk(KERN_ERR "autofs: kernel does not match daemon "
+		       "version (%d, %d) kernel (%d, %d)\n",
 			sbi->min_proto, sbi->max_proto,
 			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
@@ -407,7 +406,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
-		printk("autofs: could not open pipe file descriptor\n");
+		printk(KERN_ERR
+		      "autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
 	if (!pipe->f_op || !pipe->f_op->write)
@@ -421,7 +421,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 */
 	s->s_root = root;
 	return 0;
-	
+
 	/*
 	 * Failure ... clean up.
 	 */
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 30cc9dd..c7bb36f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/root.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
@@ -19,13 +16,15 @@
 #include <linux/time.h>
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs4_dir_unlink(struct inode *,struct dentry *);
-static int autofs4_dir_rmdir(struct inode *,struct dentry *);
-static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
-static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
+static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
+static int autofs4_dir_unlink(struct inode *, struct dentry *);
+static int autofs4_dir_rmdir(struct inode *, struct dentry *);
+static int autofs4_dir_mkdir(struct inode *, struct dentry *, int);
+static int autofs4_root_ioctl(struct inode *, struct file *,
+			      unsigned int, unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
+static struct dentry *autofs4_lookup(struct inode *,
+				     struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
 #define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
@@ -243,7 +242,8 @@ static int try_to_fill_dentry(struct dentry *dentry)
 	int status;
 
 	DPRINTK("dentry=%p %.*s ino=%p",
-		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
+		dentry, dentry->d_name.len, dentry->d_name.name,
+		dentry->d_inode);
 
 	/*
 	 * Wait for a pending mount, triggering one if there
@@ -696,7 +696,9 @@ static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs4_lookup(struct inode *dir,
+				     struct dentry *dentry,
+				     struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -763,9 +765,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		/* See if we were interrupted */
 		if (signal_pending(current)) {
 			sigset_t *sigset = &current->pending.signal;
-			if (sigismember (sigset, SIGKILL) ||
-			    sigismember (sigset, SIGQUIT) ||
-			    sigismember (sigset, SIGINT)) {
+			if (sigismember(sigset, SIGKILL) ||
+			    sigismember(sigset, SIGQUIT) ||
+			    sigismember(sigset, SIGINT)) {
 			    if (active)
 				dput(active);
 			    return ERR_PTR(-ERESTARTNOINTR);
@@ -814,7 +816,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	return NULL;
 }
 
-static int autofs4_dir_symlink(struct inode *dir, 
+static int autofs4_dir_symlink(struct inode *dir,
 			       struct dentry *dentry,
 			       const char *symname)
 {
@@ -892,7 +894,7 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	/* This allows root to remove symlinks */
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -923,7 +925,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	DPRINTK("dentry %p, removing %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
@@ -1018,13 +1020,15 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 }
 
 /* Return protocol version */
-static inline int autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
+static inline int
+autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
 {
 	return put_user(sbi->version, p);
 }
 
 /* Return protocol sub version */
-static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
+static inline int
+autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
 {
 	return put_user(sbi->sub_version, p);
 }
@@ -1069,7 +1073,7 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
+		cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
@@ -1080,9 +1084,9 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 	
 	switch(cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,0);
+		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, 0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+		return autofs4_wait_release(sbi, (autofs_wqt_t)arg, -ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
 		autofs4_catatonic_mode(sbi);
 		return 0;
@@ -1098,10 +1102,13 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_run(inode->i_sb,
+					  filp->f_path.mnt, sbi, p);
+
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_multi(inode->i_sb,
+					    filp->f_path.mnt, sbi, p);
 
 	default:
 		return -ENOSYS;
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index b4ea829..296fbd9 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/symlink.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 2341375..a4e55da 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/waitq.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
@@ -114,8 +111,9 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	/* Kernel protocol v4 missing and expire packets */
 	case autofs_ptype_missing:
 	{
-		struct autofs_packet_missing *mp = &pkt.v4_pkt.missing;
+		struct autofs_packet_missing *mp;
 
+		mp = &pkt.v4_pkt.missing;
 		pktsz = sizeof(*mp);
 
 		mp->wait_queue_token = wq->wait_queue_token;
@@ -126,8 +124,9 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	}
 	case autofs_ptype_expire_multi:
 	{
-		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
+		struct autofs_packet_expire_multi *ep;
 
+		ep = &pkt.v4_pkt.expire_multi;
 		pktsz = sizeof(*ep);
 
 		ep->wait_queue_token = wq->wait_queue_token;
@@ -145,8 +144,9 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	case autofs_ptype_missing_direct:
 	case autofs_ptype_expire_direct:
 	{
-		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
+		struct autofs_v5_packet *packet;
 
+		packet = &pkt.v5_pkt.v5_packet;
 		pktsz = sizeof(*packet);
 
 		packet->wait_queue_token = wq->wait_queue_token;
@@ -162,7 +162,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		printk("autofs4_notify_daemon: bad type %d!\n", type);
+		printk(KERN_ERR "autofs4_notify_daemon: bad type %d!\n", type);
 		return;
 	}
 
@@ -239,7 +239,7 @@ autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 static int validate_request(struct autofs_wait_queue **wait,
 			    struct autofs_sb_info *sbi,
 			    struct qstr *qstr,
-			    struct dentry*dentry, enum autofs_notify notify)
+			    struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct autofs_info *ino;
@@ -495,7 +495,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 }
 
 
-int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_token, int status)
+int autofs4_wait_release(struct autofs_sb_info *sbi,
+			 autofs_wqt_t wait_queue_token, int status)
 {
 	struct autofs_wait_queue *wq, **wql;
 

