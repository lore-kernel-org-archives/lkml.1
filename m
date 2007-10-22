Return-Path: <linux-kernel-owner+w=401wt.eu-S1751018AbXJVEAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbXJVEAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXJVEAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:00:16 -0400
Received: from xenotime.net ([66.160.160.81]:52598 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752164AbXJVEAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:00:13 -0400
Date: Sun, 21 Oct 2007 21:00:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: xemul@openvz.org, torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] procfs: fix kernel-doc param warnings
Message-Id: <20071021210010.385c7916.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mnt_flush_task() misplaced kernel-doc.
Fix typos in some of the doc text.

Warning(linux-2.6.23-git17//fs/proc/base.c:2280): No description found for parameter 'mnt'
Warning(linux-2.6.23-git17//fs/proc/base.c:2280): No description found for parameter 'pid'
Warning(linux-2.6.23-git17//fs/proc/base.c:2280): No description found for parameter 'tgid'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/proc/base.c |   46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

--- linux-2.6.23-git17.orig/fs/proc/base.c
+++ linux-2.6.23-git17/fs/proc/base.c
@@ -2255,27 +2255,6 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-/**
- * proc_flush_task -  Remove dcache entries for @task from the /proc dcache.
- *
- * @task: task that should be flushed.
- *
- * Looks in the dcache for
- * /proc/@pid
- * /proc/@tgid/task/@pid
- * if either directory is present flushes it and all of it'ts children
- * from the dcache.
- *
- * It is safe and reasonable to cache /proc entries for a task until
- * that task exits.  After that they just clog up the dcache with
- * useless entries, possibly causing useful dcache entries to be
- * flushed instead.  This routine is proved to flush those useless
- * dcache entries at process exit time.
- *
- * NOTE: This routine is just an optimization so it does not guarantee
- *       that no dcache entries will exist at process exit time it
- *       just makes it very unlikely that any will persist.
- */
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
@@ -2322,10 +2301,29 @@ out:
 	return;
 }
 
-/*
- * when flushing dentries from proc one need to flush them from global
+/**
+ * proc_flush_task -  Remove dcache entries for @task from the /proc dcache.
+ * @task: task that should be flushed.
+ *
+ * When flushing dentries from proc, one needs to flush them from global
  * proc (proc_mnt) and from all the namespaces' procs this task was seen
- * in. this call is supposed to make all this job.
+ * in. This call is supposed to do all of this job.
+ *
+ * Looks in the dcache for
+ * /proc/@pid
+ * /proc/@tgid/task/@pid
+ * if either directory is present flushes it and all of it'ts children
+ * from the dcache.
+ *
+ * It is safe and reasonable to cache /proc entries for a task until
+ * that task exits.  After that they just clog up the dcache with
+ * useless entries, possibly causing useful dcache entries to be
+ * flushed instead.  This routine is proved to flush those useless
+ * dcache entries at process exit time.
+ *
+ * NOTE: This routine is just an optimization so it does not guarantee
+ *       that no dcache entries will exist at process exit time it
+ *       just makes it very unlikely that any will persist.
  */
 
 void proc_flush_task(struct task_struct *task)
---
~Randy
