Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbZKYS6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbZKYS6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbZKYS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:58:36 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46786 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759515AbZKYS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:58:35 -0500
Date: Wed, 25 Nov 2009 10:58:42 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com,
       Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com,
       Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com,
       mtk.manpages@googlemail.com, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>
Subject: [v13][PATCH 05/12] Add target_pids parameter to copy_process()
Message-ID: <20091125185842.GF30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 05/12] Add target_pids parameter to copy_process()

Add a 'target_pids' parameter to copy_process().  The new parameter will be
used in a follow-on patch when eclone() is implemented.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 00adf9f..72c76a1 100644
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

