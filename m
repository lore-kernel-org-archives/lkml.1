Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZEZH6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZEZH6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZEZH6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:58:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:59111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZEZH63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:58:29 -0400
Date: Tue, 26 May 2009 07:57:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Initialize ->oncpu properly
Message-ID: <tip-329d876d6fd326109f191ae0fb2798b8834fb70b@git.kernel.org>
Git-Commit-ID: 329d876d6fd326109f191ae0fb2798b8834fb70b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 07:57:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  329d876d6fd326109f191ae0fb2798b8834fb70b
Gitweb:     http://git.kernel.org/tip/329d876d6fd326109f191ae0fb2798b8834fb70b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 08:10:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 09:54:13 +0200

perf_counter: Initialize ->oncpu properly

This shouldnt matter normally (and i have not seen any
misbehavior), because active counters always have a
proper ->oncpu value - but nevertheless initialize the
field properly to -1.

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 070f92d..367299f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3122,6 +3122,8 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->group_leader		= group_leader;
 	counter->pmu			= NULL;
 	counter->ctx			= ctx;
+	counter->oncpu			= -1;
+
 	get_ctx(ctx);
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
