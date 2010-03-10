Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0CJNNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:13:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:59166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab0CJNNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:13:10 -0500
Date: Wed, 10 Mar 2010 13:12:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Properly account n_added
Message-ID: <tip-356e1f2e0ace2d4b100c8eda9d49b709e8323da5@git.kernel.org>
Git-Commit-ID: 356e1f2e0ace2d4b100c8eda9d49b709e8323da5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:12:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  356e1f2e0ace2d4b100c8eda9d49b709e8323da5
Gitweb:     http://git.kernel.org/tip/356e1f2e0ace2d4b100c8eda9d49b709e8323da5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:49:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:32 +0100

perf, x86: Properly account n_added

Make sure n_added is properly accounted so that we can rely on the value
to reflect the number of added counters. This is needed if its going to
be used for more than a boolean check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b68c4fb..071c840 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -959,7 +959,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->n_events = n;
-	cpuc->n_added  = n - n0;
+	cpuc->n_added += n - n0;
 
 	return 0;
 }
@@ -1302,7 +1302,7 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 	memcpy(cpuc->assign, assign, n0*sizeof(int));
 
 	cpuc->n_events  = n0;
-	cpuc->n_added   = n1;
+	cpuc->n_added  += n1;
 	ctx->nr_active += n1;
 
 	/*
