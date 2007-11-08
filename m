Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbXKHVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbXKHVco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761265AbXKHVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:32:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761251AbXKHVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:32:36 -0500
Message-Id: <200711082131.lA8LVgkb015134@imap1.linux-foundation.org>
Subject: [patch 1/2] get_task_comm(): return the result
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, drepper@redhat.com, mingo@elte.hu,
       roland@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 08 Nov 2007 13:31:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

It was dumb to make get_task_comm() return void.  Change it to return a
pointer to the resulting output for caller convenience.

Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    3 ++-
 include/linux/sched.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~get_task_comm-return-the-result include/linux/sched.h
--- a/include/linux/sched.h~get_task_comm-return-the-result
+++ a/include/linux/sched.h
@@ -1692,7 +1692,7 @@ extern long do_fork(unsigned long, unsig
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
-extern void get_task_comm(char *to, struct task_struct *tsk);
+extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 extern void wait_task_inactive(struct task_struct * p);
diff -puN fs/exec.c~get_task_comm-return-the-result fs/exec.c
--- a/fs/exec.c~get_task_comm-return-the-result
+++ a/fs/exec.c
@@ -947,12 +947,13 @@ static void flush_old_files(struct files
 	spin_unlock(&files->file_lock);
 }
 
-void get_task_comm(char *buf, struct task_struct *tsk)
+char *get_task_comm(char *buf, struct task_struct *tsk)
 {
 	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
 	strncpy(buf, tsk->comm, sizeof(tsk->comm));
 	task_unlock(tsk);
+	return buf;
 }
 
 void set_task_comm(struct task_struct *tsk, char *buf)
_
