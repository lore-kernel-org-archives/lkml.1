Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbZKZJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbZKZJ5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbZKZJ46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:41455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678AbZKZJ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:55 -0500
Date: Thu, 26 Nov 2009 09:56:23 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, peterz@infradead.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <1259180453-5813-1-git-send-email-fweisbec@gmail.com>
References: <1259180453-5813-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Fix unused function in off-case
Message-ID: <tip-80bbf6b641c8843b9d751a1f299aa7ee073ab9d4@git.kernel.org>
Git-Commit-ID: 80bbf6b641c8843b9d751a1f299aa7ee073ab9d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80bbf6b641c8843b9d751a1f299aa7ee073ab9d4
Gitweb:     http://git.kernel.org/tip/80bbf6b641c8843b9d751a1f299aa7ee073ab9d4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 25 Nov 2009 21:20:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:40:51 +0100

hw-breakpoints: Fix unused function in off-case

bp_perf_event_destroy() is unused in its off-case version, let's
remove it to fix the following warning reported by Stephen
Rothwell in linux-next:

  kernel/perf_event.c:4306: warning: 'bp_perf_event_destroy' defined but not used

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1259180453-5813-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 34a1b9d..f8c7939 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4303,10 +4303,6 @@ void perf_bp_event(struct perf_event *bp, void *data)
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static void bp_perf_event_destroy(struct perf_event *event)
-{
-}
-
 static const struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
