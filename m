Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZKJPEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZKJPEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKJPEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:04:07 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63582 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbZKJPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:04:06 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf bench: Fix sched-pipe.c for more confortable output
Date: Wed, 11 Nov 2009 00:04:01 +0900
Message-Id: <1257865442-20252-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sched-pipe.c for more confortable output.
Change points are comment style description and
formatting numerical values and its units.

Example of use:
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
---
 tools/perf/bench/sched-pipe.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index a9ac186..97291fe 100644
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
+		printf(" %14s:%lu.%03lu [sec]\n\n", "Total time",
+		       diff.tv_sec, diff.tv_usec/1000);
+
+		printf(" %14lf usecs/op\n",
 		       (double)result_usec / (double)loops);
-		printf("\t\t%d ops/sec\n",
+		printf(" %14d ops/sec\n",
 		       (int)((double)loops /
 			     ((double)result_usec / (double)1000000)));
 		break;
-- 
1.5.6.5

