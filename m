Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZEFK0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZEFK0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZEFK0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:26:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:35349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZEFK0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:26:42 -0400
Date: Wed, 6 May 2009 10:25:44 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
Subject: [tip:sched/core] sched: emit thread info flags with stack trace
Message-ID: <tip-12b5c43486202dd4ff3cfd59a190984a0dd7f6fd@git.kernel.org>
Git-Commit-ID: 12b5c43486202dd4ff3cfd59a190984a0dd7f6fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 10:25:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12b5c43486202dd4ff3cfd59a190984a0dd7f6fd
Gitweb:     http://git.kernel.org/tip/12b5c43486202dd4ff3cfd59a190984a0dd7f6fd
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 4 May 2009 01:38:05 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 12:09:30 +0200

sched: emit thread info flags with stack trace

When a thread is oom killed and fails to exit, it's helpful to know which
threads have access to memory reserves if the machine livelocks.  This is
done by testing for the TIF_MEMDIE thread info flag and should be
displayed alongside stack traces to identify tasks that have access to
such reserves but are still stuck allocating pages, for instance.

It would probably be helpful in other cases as well, so all thread info
flags are emitted when showing a task.

[ Impact: extend debug printout info ]

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2a43a58..dfe2583 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6610,8 +6610,9 @@ void sched_show_task(struct task_struct *p)
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent));
+	printk(KERN_CONT "%5lu %5d %6d 0x%08x\n", free,
+		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
 }
