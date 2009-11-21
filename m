Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZKUNnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZKUNnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZKUNns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:60970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZKUNnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:43:46 -0500
Date: Sat, 21 Nov 2009 13:43:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212509.000272254@chello.nl>
References: <20091120212509.000272254@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify __perf_event_read
Message-ID: <tip-58e5ad1de3d6ad931c84f0cc8ef0655c922f30ad@git.kernel.org>
Git-Commit-ID: 58e5ad1de3d6ad931c84f0cc8ef0655c922f30ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58e5ad1de3d6ad931c84f0cc8ef0655c922f30ad
Gitweb:     http://git.kernel.org/tip/58e5ad1de3d6ad931c84f0cc8ef0655c922f30ad
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:39 +0100

perf: Simplify __perf_event_read

cpuctx is always active, task context is always active for
current

the previous condition verifies that if its a task context its
for current, hence we can assume ctx->is_active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212509.000272254@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index af150bb..028619d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1526,10 +1526,9 @@ static void __perf_event_read(void *info)
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	if (ctx->is_active)
-		update_context_time(ctx);
-	event->pmu->read(event);
+	update_context_time(ctx);
 	update_event_times(event);
+	event->pmu->read(event);
 }
 
 static u64 perf_event_read(struct perf_event *event)
