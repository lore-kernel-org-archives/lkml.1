Return-Path: <linux-kernel-owner+w=401wt.eu-S971057AbXFHW03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971057AbXFHW03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937265AbXFHW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:26:13 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:41934
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756645AbXFHW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:26:10 -0400
Message-ID: <4669D767.6030709@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:25:43 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 7/7] Replace DPRINTK with pr_debug_pid in autofs4
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
-/* #define DEBUG */
-
-#ifdef DEBUG
-#define DPRINTK(fmt,args...) do { pr_debug("pid %d: %s: " fmt "\n" ,
current->pid , __FUNCTION__ , ##args); } while(0)
-#else
-#define DPRINTK(fmt,args...) do {} while(0)
-#endif
-
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
Index: linux/fs/autofs4/expire.c
===================================================================
--- linux.orig/fs/autofs4/expire.c
+++ linux/fs/autofs4/expire.c
@@ -50,7 +50,7 @@ static int autofs4_mount_busy(struct vfs
 	struct dentry *top = dentry;
 	int status = 1;

-	DPRINTK("dentry %p %.*s",
+	pr_debug_pid("dentry %p %.*s",
 		dentry, (int)dentry->d_name.len, dentry->d_name.name);

 	mntget(mnt);
@@ -72,7 +72,7 @@ static int autofs4_mount_busy(struct vfs

 	status = 0;
 done:
-	DPRINTK("returning = %d", status);
+	pr_debug_pid("returning = %d", status);
 	mntput(mnt);
 	dput(dentry);
 	return status;
@@ -110,7 +110,7 @@ static int autofs4_direct_busy(struct vf
 				unsigned long timeout,
 				int do_now)
 {
-	DPRINTK("top %p %.*s",
+	pr_debug_pid("top %p %.*s",
 		top, (int) top->d_name.len, top->d_name.name);

 	/* If it's busy update the expiry counters */
@@ -139,7 +139,7 @@ static int autofs4_tree_busy(struct vfsm
 	struct autofs_info *top_ino = autofs4_dentry_ino(top);
 	struct dentry *p;

-	DPRINTK("top %p %.*s",
+	pr_debug_pid("top %p %.*s",
 		top, (int)top->d_name.len, top->d_name.name);

 	/* Negative dentry - give up */
@@ -152,7 +152,7 @@ static int autofs4_tree_busy(struct vfsm
 		if (!simple_positive(p))
 			continue;

-		DPRINTK("dentry %p %.*s",
+		pr_debug_pid("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);

 		p = dget(p);
@@ -211,7 +211,7 @@ static struct dentry *autofs4_check_leav
 {
 	struct dentry *p;

-	DPRINTK("parent %p %.*s",
+	pr_debug_pid("parent %p %.*s",
 		parent, (int)parent->d_name.len, parent->d_name.name);

 	spin_lock(&dcache_lock);
@@ -220,7 +220,7 @@ static struct dentry *autofs4_check_leav
 		if (!simple_positive(p))
 			continue;

-		DPRINTK("dentry %p %.*s",
+		pr_debug_pid("dentry %p %.*s",
 			p, (int) p->d_name.len, p->d_name.name);

 		p = dget(p);
@@ -323,7 +323,7 @@ static struct dentry *autofs4_expire_ind
 		 *	   offset (autofs-5.0+).
 		 */
 		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
+			pr_debug_pid("checking mountpoint %p %.*s",
 				dentry, (int)dentry->d_name.len, dentry->d_name.name);

 			/* Can we umount this guy */
@@ -373,7 +373,7 @@ next:
 	}

 	if (expired) {
-		DPRINTK("returning %p %.*s",
+		pr_debug_pid("returning %p %.*s",
 			expired, (int)expired->d_name.len, expired->d_name.name);
 		spin_lock(&dcache_lock);
 		list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
Index: linux/fs/autofs4/inode.c
===================================================================
--- linux.orig/fs/autofs4/inode.c
+++ linux/fs/autofs4/inode.c
@@ -124,7 +124,7 @@ resume:
 		next = next->next;
 		spin_unlock(&dcache_lock);

-		DPRINTK("dentry %p %.*s",
+		pr_debug_pid("dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);

 		dput(dentry);
@@ -137,7 +137,7 @@ resume:
 		next = this_parent->d_u.d_child.next;
 		this_parent = this_parent->d_parent;
 		spin_unlock(&dcache_lock);
-		DPRINTK("parent dentry %p %.*s",
+		pr_debug_pid("parent dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 		dput(dentry);
 		spin_lock(&dcache_lock);
@@ -169,7 +169,7 @@ void autofs4_kill_sb(struct super_block
 	kfree(sbi);

 out_kill_sb:
-	DPRINTK("shutting down");
+	pr_debug_pid("shutting down");
 	kill_anon_super(sb);
 }

@@ -315,7 +315,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi = kmalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
-	DPRINTK("starting up, sbi = %p",sbi);
+	pr_debug_pid("starting up, sbi = %p",sbi);

 	memset(sbi, 0, sizeof(*sbi));

@@ -391,7 +391,7 @@ int autofs4_fill_super(struct super_bloc
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;

-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	pr_debug_pid("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
Index: linux/fs/autofs4/root.c
===================================================================
--- linux.orig/fs/autofs4/root.c
+++ linux/fs/autofs4/root.c
@@ -76,7 +76,7 @@ static int autofs4_root_readdir(struct f
 	struct autofs_sb_info *sbi = autofs4_sbi(file->f_path.dentry->d_sb);
 	int oz_mode = autofs4_oz_mode(sbi);

-	DPRINTK("called, filp->f_pos = %lld", file->f_pos);
+	pr_debug_pid("called, filp->f_pos = %lld", file->f_pos);

 	/*
 	 * Don't set reghost flag if:
@@ -87,7 +87,7 @@ static int autofs4_root_readdir(struct f
 	if (oz_mode && file->f_pos == 0 && sbi->reghost_enabled)
 		sbi->needs_reghost = 1;

-	DPRINTK("needs_reghost = %d", sbi->needs_reghost);
+	pr_debug_pid("needs_reghost = %d", sbi->needs_reghost);

 	return dcache_readdir(file, dirent, filldir);
 }
@@ -107,14 +107,14 @@ static int autofs4_dir_open(struct inode
 	cursor = file->private_data;
 	cursor->d_fsdata = NULL;

-	DPRINTK("file=%p dentry=%p %.*s",
+	pr_debug_pid("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);

 	if (autofs4_oz_mode(sbi))
 		goto out;

 	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
+		pr_debug_pid("dentry busy");
 		dcache_dir_close(inode, file);
 		status = -EBUSY;
 		goto out;
@@ -176,14 +176,14 @@ static int autofs4_dir_close(struct inod
 	struct dentry *cursor = file->private_data;
 	int status = 0;

-	DPRINTK("file=%p dentry=%p %.*s",
+	pr_debug_pid("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);

 	if (autofs4_oz_mode(sbi))
 		goto out;

 	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
+		pr_debug_pid("dentry busy");
 		status = -EBUSY;
 		goto out;
 	}
@@ -208,14 +208,14 @@ static int autofs4_dir_readdir(struct fi
 	struct dentry *cursor = file->private_data;
 	int status;

-	DPRINTK("file=%p dentry=%p %.*s",
+	pr_debug_pid("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);

 	if (autofs4_oz_mode(sbi))
 		goto out;

 	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
+		pr_debug_pid("dentry busy");
 		return -EBUSY;
 	}

@@ -248,12 +248,12 @@ static int try_to_fill_dentry(struct den
            when expiration is done to trigger mount request with a new
            dentry */
 	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
-		DPRINTK("waiting for expire %p name=%.*s",
+		pr_debug_pid("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);

 		status = autofs4_wait(sbi, dentry, NFY_NONE);

-		DPRINTK("expire done status=%d", status);
+		pr_debug_pid("expire done status=%d", status);

 		/*
 		 * If the directory still exists the mount request must
@@ -265,7 +265,7 @@ static int try_to_fill_dentry(struct den
 			return -EAGAIN;
 	}

-	DPRINTK("dentry=%p %.*s ino=%p",
+	pr_debug_pid("dentry=%p %.*s ino=%p",
 		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);

 	/*
@@ -273,12 +273,12 @@ static int try_to_fill_dentry(struct den
 	 * isn't one already
 	 */
 	if (dentry->d_inode == NULL) {
-		DPRINTK("waiting for mount name=%.*s",
+		pr_debug_pid("waiting for mount name=%.*s",
 			 dentry->d_name.len, dentry->d_name.name);

 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);

-		DPRINTK("mount done status=%d", status);
+		pr_debug_pid("mount done status=%d", status);

 		/* Turn this into a real negative dentry? */
 		if (status == -ENOENT) {
@@ -293,7 +293,7 @@ static int try_to_fill_dentry(struct den
 	/* Trigger mount for path component or follow link */
 	} else if (flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY) ||
 			current->link_count) {
-		DPRINTK("waiting for mount name=%.*s",
+		pr_debug_pid("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);

 		spin_lock(&dentry->d_lock);
@@ -301,7 +301,7 @@ static int try_to_fill_dentry(struct den
 		spin_unlock(&dentry->d_lock);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);

-		DPRINTK("mount done status=%d", status);
+		pr_debug_pid("mount done status=%d", status);

 		if (status) {
 			spin_lock(&dentry->d_lock);
@@ -330,7 +330,7 @@ static void *autofs4_follow_link(struct
 	unsigned int lookup_type;
 	int status;

-	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
+	pr_debug_pid("dentry=%p %.*s oz_mode=%d nd->flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
 		nd->flags);

@@ -341,12 +341,12 @@ static void *autofs4_follow_link(struct

 	/* If an expire request is pending wait for it. */
 	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
-		DPRINTK("waiting for active request %p name=%.*s",
+		pr_debug_pid("waiting for active request %p name=%.*s",
 			dentry, dentry->d_name.len, dentry->d_name.name);

 		status = autofs4_wait(sbi, dentry, NFY_NONE);

-		DPRINTK("request done status=%d", status);
+		pr_debug_pid("request done status=%d", status);
 	}

 	/*
@@ -435,7 +435,7 @@ static int autofs4_revalidate(struct den
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) &&
 	    __simple_empty(dentry)) {
-		DPRINTK("dentry=%p %.*s, emptydir",
+		pr_debug_pid("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dcache_lock);
 		/* The daemon never causes a mount to trigger */
@@ -461,7 +461,7 @@ void autofs4_dentry_release(struct dentr
 {
 	struct autofs_info *inf;

-	DPRINTK("releasing %p", de);
+	pr_debug_pid("releasing %p", de);

 	inf = autofs4_dentry_ino(de);
 	de->d_fsdata = NULL;
@@ -571,7 +571,7 @@ static struct dentry *autofs4_lookup(str
 	struct dentry *unhashed;
 	int oz_mode;

-	DPRINTK("name = %.*s",
+	pr_debug_pid("name = %.*s",
 		dentry->d_name.len, dentry->d_name.name);

 	/* File name too long to exist */
@@ -581,7 +581,7 @@ static struct dentry *autofs4_lookup(str
 	sbi = autofs4_sbi(dir->i_sb);
 	oz_mode = autofs4_oz_mode(sbi);

-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
+	pr_debug_pid("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, process_group(current), sbi->catatonic, oz_mode);

 	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent,
&dentry->d_name);
@@ -602,18 +602,18 @@ static struct dentry *autofs4_lookup(str
 		d_add(dentry, NULL);
 	} else {
 		struct autofs_info *ino = autofs4_dentry_ino(unhashed);
-		DPRINTK("rehash %p with %p", dentry, unhashed);
+		pr_debug_pid("rehash %p with %p", dentry, unhashed);
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete but the directory has been removed
 		 * so it must have been successful, so just wait for it.
 		 */
 		if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
-			DPRINTK("wait for incomplete expire %p name=%.*s",
+			pr_debug_pid("wait for incomplete expire %p name=%.*s",
 				unhashed, unhashed->d_name.len,
 				unhashed->d_name.name);
 			autofs4_wait(sbi, unhashed, NFY_NONE);
-			DPRINTK("request completed");
+			pr_debug_pid("request completed");
 		}
 		d_rehash(unhashed);
 		dentry = unhashed;
@@ -695,7 +695,7 @@ static int autofs4_dir_symlink(struct in
 	struct inode *inode;
 	char *cp;

-	DPRINTK("%s <- %.*s", symname,
+	pr_debug_pid("%s <- %.*s", symname,
 		dentry->d_name.len, dentry->d_name.name);

 	if (!autofs4_oz_mode(sbi))
@@ -792,7 +792,7 @@ static int autofs4_dir_rmdir(struct inod
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	
-	DPRINTK("dentry %p, removing %.*s",
+	pr_debug_pid("dentry %p, removing %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);

 	if (!autofs4_oz_mode(sbi))
@@ -836,7 +836,7 @@ static int autofs4_dir_mkdir(struct inod
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;

-	DPRINTK("dentry %p, creating %.*s",
+	pr_debug_pid("dentry %p, creating %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);

 	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
@@ -903,7 +903,7 @@ static inline int autofs4_ask_reghost(st
 {
 	int status;

-	DPRINTK("returning %d", sbi->needs_reghost);
+	pr_debug_pid("returning %d", sbi->needs_reghost);

 	status = put_user(sbi->needs_reghost, p);
 	if (status)
@@ -923,7 +923,7 @@ static inline int autofs4_toggle_reghost

 	status = get_user(val, p);

-	DPRINTK("reghost = %d", val);
+	pr_debug_pid("reghost = %d", val);

 	if (status)
 		return status;
@@ -943,7 +943,7 @@ static inline int autofs4_ask_umount(str
 	if (may_umount(mnt))
 		status = 1;

-	DPRINTK("returning %d", status);
+	pr_debug_pid("returning %d", status);

 	status = put_user(status, p);

@@ -972,7 +972,7 @@ static int autofs4_root_ioctl(struct ino
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;

-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
+	pr_debug_pid("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
 		cmd,arg,sbi,process_group(current));

 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
Index: linux/fs/autofs4/waitq.c
===================================================================
--- linux.orig/fs/autofs4/waitq.c
+++ linux/fs/autofs4/waitq.c
@@ -28,7 +28,7 @@ void autofs4_catatonic_mode(struct autof
 {
 	struct autofs_wait_queue *wq, *nwq;

-	DPRINTK("entering catatonic mode");
+	pr_debug_pid("entering catatonic mode");

 	sbi->catatonic = 1;
 	wq = sbi->queues;
@@ -91,7 +91,7 @@ static void autofs4_notify_daemon(struct
 	} pkt;
 	size_t pktsz;

-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
+	pr_debug_pid("wait id = 0x%08lx, name = %.*s, type=%d",
 		wq->wait_queue_token, wq->len, wq->name, type);

 	memset(&pkt,0,sizeof pkt); /* For security reasons */
@@ -318,7 +318,7 @@ int autofs4_wait(struct autofs_sb_info *
 					autofs_ptype_expire_indirect;
 		}

-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+		pr_debug_pid("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
 			(unsigned long) wq->wait_queue_token, wq->len, wq->name, notify);

 		/* autofs4_notify_daemon() may block */
@@ -327,7 +327,7 @@ int autofs4_wait(struct autofs_sb_info *
 		atomic_inc(&wq->wait_ctr);
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(name);
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
+		pr_debug_pid("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
 			(unsigned long) wq->wait_queue_token, wq->len, wq->name, notify);
 	}

@@ -358,7 +358,7 @@ int autofs4_wait(struct autofs_sb_info *
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	} else {
-		DPRINTK("skipped sleeping");
+		pr_debug_pid("skipped sleeping");
 	}

 	status = wq->status;

-- 
