Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZEYLHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZEYLHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZEYLHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:59118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZEYLHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:07:21 -0400
Date: Mon, 25 May 2009 11:06:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Move child perfcounter init to after scheduler init
Message-ID: <tip-e4cbb4e3ac8b09fdb11e39e5a5611bfab0a7cd1a@git.kernel.org>
Git-Commit-ID: e4cbb4e3ac8b09fdb11e39e5a5611bfab0a7cd1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 11:06:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4cbb4e3ac8b09fdb11e39e5a5611bfab0a7cd1a
Gitweb:     http://git.kernel.org/tip/e4cbb4e3ac8b09fdb11e39e5a5611bfab0a7cd1a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 19 May 2009 15:50:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 13:05:06 +0200

perf_counter: Move child perfcounter init to after scheduler init

Initialize a task's perfcounters (inherit from parent, etc.) after
the child task's scheduler fields have been initialized already.

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e72a09f..675e01e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -984,7 +984,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	rt_mutex_init_task(p);
-	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
@@ -1096,6 +1095,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
+	perf_counter_init_task(p);
 
 	if ((retval = audit_alloc(p)))
 		goto bad_fork_cleanup_policy;
