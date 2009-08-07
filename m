Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZHGGNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZHGGNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZHGGNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:13:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37222 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbZHGGNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:13:37 -0400
Date: Thu, 6 Aug 2009 23:13:54 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: [RFC][v4][PATCH 5/7]: Add target_pids parameter to copy_process()
Message-ID: <20090807061354.GE20672@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807061103.GA19343@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v4][PATCH 5/7]: Add target_pids parameter to copy_process()

Add a 'target_pids' parameter to copy_process().  The new parameter will be
used in a follow-on patch when clone_with_pids() is implemented.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2009-08-05 19:35:08.000000000 -0700
+++ linux-2.6/kernel/fork.c	2009-08-05 19:35:34.000000000 -0700
@@ -949,12 +949,12 @@
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
@@ -1330,7 +1330,7 @@
 	struct pt_regs regs;
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-			    &init_struct_pid, 0);
+			    &init_struct_pid, NULL, 0);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
@@ -1353,6 +1353,7 @@
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	pid_t *target_pids = NULL;
 
 	/*
 	 * Do some preliminary argument and permissions checking before we
@@ -1393,7 +1394,7 @@
 		trace = tracehook_prepare_clone(clone_flags);
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, target_pids, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
