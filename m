Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319Ab0BZQ2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:28:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:33392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965054Ab0BZQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:28:32 -0500
Date: Fri, 26 Feb 2010 16:27:34 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267198583.22519.684.camel@laptop>
References: <1267198583.22519.684.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Fix preempt warning in perf_clock()
Message-ID: <tip-24691ea964cc0123e386b661e03a86a481c6ee79@git.kernel.org>
Git-Commit-ID: 24691ea964cc0123e386b661e03a86a481c6ee79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 16:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24691ea964cc0123e386b661e03a86a481c6ee79
Gitweb:     http://git.kernel.org/tip/24691ea964cc0123e386b661e03a86a481c6ee79
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 26 Feb 2010 16:36:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 17:25:00 +0100

perf_event: Fix preempt warning in perf_clock()

A recent commit introduced a preemption warning for
perf_clock(), use raw_smp_processor_id() to avoid this, it
really doesn't matter which cpu we use here.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1267198583.22519.684.camel@laptop>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 05b6c6b..aa6155b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -249,7 +249,7 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return cpu_clock(raw_smp_processor_id());
 }
 
 /*
