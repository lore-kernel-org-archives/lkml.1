Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZEXHDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZEXHDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZEXHCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:35716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbZEXHCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:32 -0400
Date: Sun, 24 May 2009 07:01:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.796275849@chello.nl>
References: <20090523163012.796275849@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Simplify context cleanup
Message-ID: <tip-aa9c67f53d1969cf1db4c9c2db3a78c4ceb96469@git.kernel.org>
Git-Commit-ID: aa9c67f53d1969cf1db4c9c2db3a78c4ceb96469
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:01:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa9c67f53d1969cf1db4c9c2db3a78c4ceb96469
Gitweb:     http://git.kernel.org/tip/aa9c67f53d1969cf1db4c9c2db3a78c4ceb96469
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:28:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 19:37:47 +0200

perf_counter: Simplify context cleanup

Use perf_counter_remove_from_context() to remove counters from
the context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.796275849@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d162d2f..0e97f89 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3416,10 +3416,7 @@ __perf_counter_exit_task(struct task_struct *child,
 	struct perf_counter *parent_counter;
 
 	update_counter_times(child_counter);
-
-	spin_lock_irq(&child_ctx->lock);
-	list_del_counter(child_counter, child_ctx);
-	spin_unlock_irq(&child_ctx->lock);
+	perf_counter_remove_from_context(child_counter);
 
 	parent_counter = child_counter->parent;
 	/*
