Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXJZIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXJZIRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXJZIRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:17:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47930 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXJZIRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:17:36 -0400
Date: Fri, 26 Oct 2007 12:17:22 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] De-constify sched.h
Message-ID: <20071026081721.GA6244@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please revert commit a8972ccf00b7184a743eb6cd9bc7f3443357910c aka
"sched: constify sched.h" or apply the following patch instead.

[PATCH] De-constify sched.h

1) Patch doesn't change any code here, so gcc is already smart enough to "feel"
   constness in such simple functions.
2) There is no such thing as const task_struct. Anyone who think otherwise
   deserves compiler warning.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/sched.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1201,7 +1201,7 @@ static inline int rt_prio(int prio)
 	return 0;
 }
 
-static inline int rt_task(const struct task_struct *p)
+static inline int rt_task(struct task_struct *p)
 {
 	return rt_prio(p->prio);
 }
@@ -1216,22 +1216,22 @@ static inline void set_task_pgrp(struct task_struct *tsk, pid_t pgrp)
 	tsk->signal->__pgrp = pgrp;
 }
 
-static inline struct pid *task_pid(const struct task_struct *task)
+static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
 }
 
-static inline struct pid *task_tgid(const struct task_struct *task)
+static inline struct pid *task_tgid(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
-static inline struct pid *task_pgrp(const struct task_struct *task)
+static inline struct pid *task_pgrp(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PGID].pid;
 }
 
-static inline struct pid *task_session(const struct task_struct *task)
+static inline struct pid *task_session(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_SID].pid;
 }
@@ -1260,7 +1260,7 @@ struct pid_namespace;
  * see also pid_nr() etc in include/linux/pid.h
  */
 
-static inline pid_t task_pid_nr(const struct task_struct *tsk)
+static inline pid_t task_pid_nr(struct task_struct *tsk)
 {
 	return tsk->pid;
 }
@@ -1273,7 +1273,7 @@ static inline pid_t task_pid_vnr(struct task_struct *tsk)
 }
 
 
-static inline pid_t task_tgid_nr(const struct task_struct *tsk)
+static inline pid_t task_tgid_nr(struct task_struct *tsk)
 {
 	return tsk->tgid;
 }
@@ -1286,7 +1286,7 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
-static inline pid_t task_pgrp_nr(const struct task_struct *tsk)
+static inline pid_t task_pgrp_nr(struct task_struct *tsk)
 {
 	return tsk->signal->__pgrp;
 }
@@ -1299,7 +1299,7 @@ static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
 }
 
 
-static inline pid_t task_session_nr(const struct task_struct *tsk)
+static inline pid_t task_session_nr(struct task_struct *tsk)
 {
 	return tsk->signal->__session;
 }
@@ -1326,7 +1326,7 @@ static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
  */
-static inline int pid_alive(const struct task_struct *p)
+static inline int pid_alive(struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }
@@ -1337,7 +1337,7 @@ static inline int pid_alive(const struct task_struct *p)
  *
  * Check if a task structure is the first user space task the kernel created.
  */
-static inline int is_global_init(const struct task_struct *tsk)
+static inline int is_global_init(struct task_struct *tsk)
 {
 	return tsk->pid == 1;
 }
@@ -1474,7 +1474,7 @@ extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
-static inline int rt_mutex_getprio(const struct task_struct *p)
+static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
@@ -1726,7 +1726,7 @@ extern void wait_task_inactive(struct task_struct * p);
  * all we care about is that we have a task with the appropriate
  * pid, we don't actually care if we have the right task.
  */
-static inline int has_group_leader_pid(const struct task_struct *p)
+static inline int has_group_leader_pid(struct task_struct *p)
 {
 	return p->pid == p->tgid;
 }
@@ -1743,7 +1743,7 @@ static inline struct task_struct *next_thread(const struct task_struct *p)
 			  struct task_struct, thread_group);
 }
 
-static inline int thread_group_empty(const struct task_struct *p)
+static inline int thread_group_empty(struct task_struct *p)
 {
 	return list_empty(&p->thread_group);
 }

