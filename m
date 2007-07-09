Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXGIQme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXGIQme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbXGIQY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462AbXGIQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:55 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] dump more lock values
Date: Mon,  9 Jul 2007 17:03:01 +0100
Message-Id: <11839970981366-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970963525-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
 <1183997089710-git-send-email-swhiteho@redhat.com>
 <11839970914023-git-send-email-swhiteho@redhat.com>
 <11839970921764-git-send-email-swhiteho@redhat.com>
 <11839970941232-git-send-email-swhiteho@redhat.com>
 <11839970963525-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Add two more output fields (lkb_flags and rsb nodeid) to the new debugfs
file that dumps one lock per line.  Also, dump all locks instead of just
mastered locks.  Accordingly, use a suffix of _locks instead of _master.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 9f5de37..12c3bfd 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -27,7 +27,7 @@ static struct dentry *dlm_root;
 
 struct rsb_iter {
 	int entry;
-	int master;
+	int locks;
 	int header;
 	struct dlm_ls *ls;
 	struct list_head *next;
@@ -60,8 +60,8 @@ static char *print_lockmode(int mode)
 	}
 }
 
-static void print_lock(struct seq_file *s, struct dlm_lkb *lkb,
-		       struct dlm_rsb *res)
+static void print_resource_lock(struct seq_file *s, struct dlm_lkb *lkb,
+				struct dlm_rsb *res)
 {
 	seq_printf(s, "%08x %s", lkb->lkb_id, print_lockmode(lkb->lkb_grmode));
 
@@ -134,15 +134,15 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 	/* Print the locks attached to this resource */
 	seq_printf(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue)
-		print_lock(s, lkb, res);
+		print_resource_lock(s, lkb, res);
 
 	seq_printf(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue)
-		print_lock(s, lkb, res);
+		print_resource_lock(s, lkb, res);
 
 	seq_printf(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue)
-		print_lock(s, lkb, res);
+		print_resource_lock(s, lkb, res);
 
 	if (list_empty(&res->res_lookup))
 		goto out;
@@ -160,8 +160,7 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 	return 0;
 }
 
-static void print_master_lock(struct seq_file *s, struct dlm_lkb *lkb,
-			      struct dlm_rsb *r)
+static void print_lock(struct seq_file *s, struct dlm_lkb *lkb, struct dlm_rsb *r)
 {
 	struct dlm_user_args *ua;
 	unsigned int waiting = 0;
@@ -176,37 +175,40 @@ static void print_master_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	if (lkb->lkb_timestamp)
 		waiting = jiffies_to_msecs(jiffies - lkb->lkb_timestamp);
 
-	/* id nodeid remid pid xid flags sts grmode rqmode time_ms len name */
+	/* id nodeid remid pid xid exflags flags sts grmode rqmode time_ms
+	   r_nodeid r_len r_name */
 
-	seq_printf(s, "%x %d %x %u %llu %x %d %d %d %u %d \"%s\"\n",
+	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %u %u %d \"%s\"\n",
 		   lkb->lkb_id,
 		   lkb->lkb_nodeid,
 		   lkb->lkb_remid,
 		   lkb->lkb_ownpid,
 		   (unsigned long long)xid,
 		   lkb->lkb_exflags,
+		   lkb->lkb_flags,
 		   lkb->lkb_status,
 		   lkb->lkb_grmode,
 		   lkb->lkb_rqmode,
 		   waiting,
+		   r->res_nodeid,
 		   r->res_length,
 		   r->res_name);
 }
 
-static int print_master_resource(struct dlm_rsb *r, struct seq_file *s)
+static int print_locks(struct dlm_rsb *r, struct seq_file *s)
 {
 	struct dlm_lkb *lkb;
 
 	lock_rsb(r);
 
 	list_for_each_entry(lkb, &r->res_grantqueue, lkb_statequeue)
-		print_master_lock(s, lkb, r);
+		print_lock(s, lkb, r);
 
 	list_for_each_entry(lkb, &r->res_convertqueue, lkb_statequeue)
-		print_master_lock(s, lkb, r);
+		print_lock(s, lkb, r);
 
 	list_for_each_entry(lkb, &r->res_waitqueue, lkb_statequeue)
-		print_master_lock(s, lkb, r);
+		print_lock(s, lkb, r);
 
 	unlock_rsb(r);
 	return 0;
@@ -325,14 +327,14 @@ static int rsb_seq_show(struct seq_file *file, void *iter_ptr)
 {
 	struct rsb_iter *ri = iter_ptr;
 
-	if (ri->master) {
+	if (ri->locks) {
 		if (ri->header) {
-			seq_printf(file, "id nodeid remid pid xid flags sts "
-					 "grmode rqmode time_ms len name\n");
+			seq_printf(file, "id nodeid remid pid xid exflags flags "
+					 "sts grmode rqmode time_ms r_nodeid "
+					 "r_len r_name\n");
 			ri->header = 0;
 		}
-		if (is_master(ri->rsb))
-			print_master_resource(ri->rsb, file);
+		print_locks(ri->rsb, file);
 	} else {
 		print_resource(ri->rsb, file);
 	}
@@ -371,10 +373,10 @@ static const struct file_operations rsb_fops = {
 };
 
 /*
- * Dump master lock state
+ * Dump state in compact per-lock listing
  */
 
-static struct rsb_iter *master_iter_init(struct dlm_ls *ls, loff_t *pos)
+static struct rsb_iter *locks_iter_init(struct dlm_ls *ls, loff_t *pos)
 {
 	struct rsb_iter *ri;
 
@@ -385,7 +387,7 @@ static struct rsb_iter *master_iter_init(struct dlm_ls *ls, loff_t *pos)
 	ri->ls = ls;
 	ri->entry = 0;
 	ri->next = NULL;
-	ri->master = 1;
+	ri->locks = 1;
 
 	if (*pos == 0)
 		ri->header = 1;
@@ -398,12 +400,12 @@ static struct rsb_iter *master_iter_init(struct dlm_ls *ls, loff_t *pos)
 	return ri;
 }
 
-static void *master_seq_start(struct seq_file *file, loff_t *pos)
+static void *locks_seq_start(struct seq_file *file, loff_t *pos)
 {
 	struct rsb_iter *ri;
 	loff_t n = *pos;
 
-	ri = master_iter_init(file->private, pos);
+	ri = locks_iter_init(file->private, pos);
 	if (!ri)
 		return NULL;
 
@@ -417,19 +419,19 @@ static void *master_seq_start(struct seq_file *file, loff_t *pos)
 	return ri;
 }
 
-static struct seq_operations master_seq_ops = {
-	.start = master_seq_start,
+static struct seq_operations locks_seq_ops = {
+	.start = locks_seq_start,
 	.next  = rsb_seq_next,
 	.stop  = rsb_seq_stop,
 	.show  = rsb_seq_show,
 };
 
-static int master_open(struct inode *inode, struct file *file)
+static int locks_open(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq;
 	int ret;
 
-	ret = seq_open(file, &master_seq_ops);
+	ret = seq_open(file, &locks_seq_ops);
 	if (ret)
 		return ret;
 
@@ -439,9 +441,9 @@ static int master_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations master_fops = {
+static const struct file_operations locks_fops = {
 	.owner   = THIS_MODULE,
-	.open    = master_open,
+	.open    = locks_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = seq_release
@@ -515,14 +517,14 @@ int dlm_create_debug_file(struct dlm_ls *ls)
 	}
 
 	memset(name, 0, sizeof(name));
-	snprintf(name, DLM_LOCKSPACE_LEN+8, "%s_master", ls->ls_name);
-
-	ls->ls_debug_master_dentry = debugfs_create_file(name,
-							 S_IFREG | S_IRUGO,
-							 dlm_root,
-							 ls,
-							 &master_fops);
-	if (!ls->ls_debug_master_dentry) {
+	snprintf(name, DLM_LOCKSPACE_LEN+8, "%s_locks", ls->ls_name);
+
+	ls->ls_debug_locks_dentry = debugfs_create_file(name,
+							S_IFREG | S_IRUGO,
+							dlm_root,
+							ls,
+							&locks_fops);
+	if (!ls->ls_debug_locks_dentry) {
 		debugfs_remove(ls->ls_debug_waiters_dentry);
 		debugfs_remove(ls->ls_debug_rsb_dentry);
 		return -ENOMEM;
@@ -537,8 +539,8 @@ void dlm_delete_debug_file(struct dlm_ls *ls)
 		debugfs_remove(ls->ls_debug_rsb_dentry);
 	if (ls->ls_debug_waiters_dentry)
 		debugfs_remove(ls->ls_debug_waiters_dentry);
-	if (ls->ls_debug_master_dentry)
-		debugfs_remove(ls->ls_debug_master_dentry);
+	if (ls->ls_debug_locks_dentry)
+		debugfs_remove(ls->ls_debug_locks_dentry);
 }
 
 int dlm_register_debugfs(void)
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 8ac0818..74901e9 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -471,7 +471,7 @@ struct dlm_ls {
 
 	struct dentry		*ls_debug_rsb_dentry; /* debugfs */
 	struct dentry		*ls_debug_waiters_dentry; /* debugfs */
-	struct dentry		*ls_debug_master_dentry; /* debugfs */
+	struct dentry		*ls_debug_locks_dentry; /* debugfs */
 
 	wait_queue_head_t	ls_uevent_wait;	/* user part of join/leave */
 	int			ls_uevent_result;
-- 
1.5.1.2

