Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZAUJ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZAUJ3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZAUJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:29:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21535 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZAUJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:29:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=DStkg+rxu0w0pS95N/SEU4StN3d2bA9DX+Urpm4foU9ew6DeE2SGTMsQyoqa7vkEB
	RnD+yYgkKrZc9OlLfNjSw==
From: Paul Menage <menage@google.com>
Subject: [PATCH] Fix cgroup.h comments
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2009 01:29:01 -0800
Message-ID: <20090121092509.28625.67938.stgit@menage.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cgroup.h comments

This patch fixes the style of some multi-line comments in cgroup.h to
match Documentation/CodingStyle

Signed-off-by: Paul Menage <menage@google.com>

---

(This is also my first attempt at using git/stgit for local patch
management in place of quilt - feel free to shout if this format isn't
quite how you'd like it)

 include/linux/cgroup.h |   71 ++++++++++++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e4e8e11..c62627e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -47,14 +47,18 @@ enum cgroup_subsys_id {
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
 struct cgroup_subsys_state {
-	/* The cgroup that this subsystem is attached to. Useful
+	/*
+	 * The cgroup that this subsystem is attached to. Useful
 	 * for subsystems that want to know about the cgroup
-	 * hierarchy structure */
+	 * hierarchy structure
+	 */
 	struct cgroup *cgroup;
 
-	/* State maintained by the cgroup system to allow subsystems
+	/*
+	 * State maintained by the cgroup system to allow subsystems
 	 * to be "busy". Should be accessed via css_get(),
-	 * css_tryget() and and css_put(). */
+	 * css_tryget() and and css_put().
+	 */
 
 	atomic_t refcnt;
 
@@ -120,8 +124,10 @@ static inline void css_put(struct cgroup_subsys_state *css)
 enum {
 	/* Control Group is dead */
 	CGRP_REMOVED,
-	/* Control Group has previously had a child cgroup or a task,
-	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
+	/*
+	 * Control Group has previously had a child cgroup or a task,
+	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set)
+	 */
 	CGRP_RELEASABLE,
 	/* Control Group requires release notifications to userspace */
 	CGRP_NOTIFY_ON_RELEASE,
@@ -130,9 +136,10 @@ enum {
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	/* count users of this cgroup. >0 means busy, but doesn't
-	 * necessarily indicate the number of tasks in the
-	 * cgroup */
+	/*
+	 * count users of this cgroup. >0 means busy, but doesn't
+	 * necessarily indicate the number of tasks in the cgroup
+	 */
 	atomic_t count;
 
 	/*
@@ -142,7 +149,7 @@ struct cgroup {
 	struct list_head sibling;	/* my parent's children */
 	struct list_head children;	/* my children */
 
-	struct cgroup *parent;	/* my parent */
+	struct cgroup *parent;		/* my parent */
 	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
@@ -177,11 +184,12 @@ struct cgroup {
 	struct rcu_head rcu_head;
 };
 
-/* A css_set is a structure holding pointers to a set of
+/*
+ * A css_set is a structure holding pointers to a set of
  * cgroup_subsys_state objects. This saves space in the task struct
  * object and speeds up fork()/exit(), since a single inc/dec and a
- * list_add()/del() can bump the reference count on the entire
- * cgroup set for a task.
+ * list_add()/del() can bump the reference count on the entire cgroup
+ * set for a task.
  */
 
 struct css_set {
@@ -226,13 +234,8 @@ struct cgroup_map_cb {
 	void *state;
 };
 
-/* struct cftype:
- *
- * The files in the cgroup filesystem mostly have a very simple read/write
- * handling, some common function will take care of it. Nevertheless some cases
- * (read tasks) are special and therefore I define this structure for every
- * kind of file.
- *
+/*
+ * struct cftype: handler definitions for cgroup control files
  *
  * When reading/writing to a file:
  *	- the cgroup to use is file->f_dentry->d_parent->d_fsdata
@@ -241,8 +244,10 @@ struct cgroup_map_cb {
 
 #define MAX_CFTYPE_NAME 64
 struct cftype {
-	/* By convention, the name should begin with the name of the
-	 * subsystem, followed by a period */
+	/*
+	 * By convention, the name should begin with the name of the
+	 * subsystem, followed by a period
+	 */
 	char name[MAX_CFTYPE_NAME];
 	int private;
 
@@ -321,13 +326,17 @@ struct cgroup_scanner {
 	struct ptr_heap *heap;
 };
 
-/* Add a new file to the given cgroup directory. Should only be
- * called by subsystems from within a populate() method */
+/*
+ * Add a new file to the given cgroup directory. Should only be
+ * called by subsystems from within a populate() method
+ */
 int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		       const struct cftype *cft);
 
-/* Add a set of new files to the given cgroup directory. Should
- * only be called by subsystems from within a populate() method */
+/*
+ * Add a set of new files to the given cgroup directory. Should
+ * only be called by subsystems from within a populate() method
+ */
 int cgroup_add_files(struct cgroup *cgrp,
 			struct cgroup_subsys *subsys,
 			const struct cftype cft[],
@@ -418,7 +427,8 @@ struct cgroup_iter {
 	struct list_head *task;
 };
 
-/* To iterate across the tasks in a cgroup:
+/*
+ * To iterate across the tasks in a cgroup:
  *
  * 1) call cgroup_iter_start to intialize an iterator
  *
@@ -427,9 +437,10 @@ struct cgroup_iter {
  *
  * 3) call cgroup_iter_end() to destroy the iterator.
  *
- * Or, call cgroup_scan_tasks() to iterate through every task in a cpuset.
- *    - cgroup_scan_tasks() holds the css_set_lock when calling the test_task()
- *      callback, but not while calling the process_task() callback.
+ * Or, call cgroup_scan_tasks() to iterate through every task in a
+ * cgroup - cgroup_scan_tasks() holds the css_set_lock when calling
+ * the test_task() callback, but not while calling the process_task()
+ * callback.
  */
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it);
 struct task_struct *cgroup_iter_next(struct cgroup *cgrp,

