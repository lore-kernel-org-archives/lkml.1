Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZKJTBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZKJTBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbZKJTBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:01:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:37399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZKJTBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:01:47 -0500
Date: Tue, 10 Nov 2009 19:01:12 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257865442-20252-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Improve sched-pipe.c with more comfortable output
Message-ID: <tip-ff676b193a401b23c84a79a7ec06559f3eaae917@git.kernel.org>
Git-Commit-ID: ff676b193a401b23c84a79a7ec06559f3eaae917
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff676b193a401b23c84a79a7ec06559f3eaae917
Gitweb:     http://git.kernel.org/tip/ff676b193a401b23c84a79a7ec06559f3eaae917
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 11 Nov 2009 00:04:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 19:56:45 +0100

perf bench: Improve sched-pipe.c with more comfortable output

This patch improves sched-pipe.c with more comfortable output.

Change points are comment style description and
formatting numerical values and its units.

Example:

 | % ./perf bench sched pipe
 | # Running sched/pipe benchmark...
 | # Extecuted 1000000 pipe operations between two tasks
 |
 |      Total time:5.822 [sec]
 |
 |        5.822553 usecs/op
 |          171745 ops/sec

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257865442-20252-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-pipe.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index a9ac186..238185f 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -92,17 +92,18 @@ int bench_sched_pipe(int argc, const char **argv,
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
-		printf("(executing %d pipe operations between two tasks)\n\n",
+		printf("# Extecuted %d pipe operations between two tasks\n\n",
 			loops);
 
 		result_usec = diff.tv_sec * 1000000;
 		result_usec += diff.tv_usec;
 
-		printf("\tTotal time:%lu.%03lu sec\n",
-		       diff.tv_sec, diff.tv_usec / 1000);
-		printf("\t\t%lf usecs/op\n",
+		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
+		       diff.tv_sec, diff.tv_usec/1000);
+
+		printf(" %14lf usecs/op\n",
 		       (double)result_usec / (double)loops);
-		printf("\t\t%d ops/sec\n",
+		printf(" %14d ops/sec\n",
 		       (int)((double)loops /
 			     ((double)result_usec / (double)1000000)));
 		break;
