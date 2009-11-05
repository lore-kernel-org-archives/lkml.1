Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZKEFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZKEFi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZKEFi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:38:29 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45753 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZKEFi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:38:28 -0500
Date: Wed, 4 Nov 2009 21:39:24 -0800
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [v11][PATCH 5/9] Add target_pids parameter to copy_process()
Message-ID: <20091105053924.GE16142@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105053053.GA11289@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [v11][PATCH 5/9] Add target_pids parameter to copy_process()

Add a 'target_pids' parameter to copy_process().  The new parameter will be
used in a follow-on patch when clone_with_pids() is implemented.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3f1dddf..c8a06de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -975,12 +975,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					unsigned long stack_size,
 					int __user *child_tidptr,
 					struct pid *pid,
+					pid_t *target_pids,
 					int trace)
 {
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
-	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1361,7 +1361,7 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	struct pt_regs regs;
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-			    &init_struct_pid, 0);
+			    &init_struct_pid, NULL, 0);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
@@ -1384,6 +1384,7 @@ long do_fork(unsigned long clone_flags,
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	pid_t *target_pids = NULL;
 
 	/*
 	 * Do some preliminary argument and permissions checking before we
@@ -1424,7 +1425,7 @@ long do_fork(unsigned long clone_flags,
 		trace = tracehook_prepare_clone(clone_flags);
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, target_pids, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
-- 
1.6.0.4

