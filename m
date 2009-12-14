Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZLNH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZLNH4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZLNH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:56:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49388
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038AbZLNH4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:56:22 -0500
Date: Sun, 13 Dec 2009 23:56:22 -0800 (PST)
Message-Id: <20091213.235622.53363059.davem@davemloft.net>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix perf build failure on sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here, tvec->tv_usec is "unsigned int" not "unsigned long".

Since the type is different on every platform, it's probably best to
just use long printf formats and cast.

Signed-off-by: David S. Miller <davem@davemloft.net>


diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 605a2a9..2953ac3 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -320,10 +320,12 @@ int bench_sched_messaging(int argc, const char **argv,
 		       num_groups, num_groups * 2 * num_fds,
 		       thread_mode ? "threads" : "processes");
 		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
-		       diff.tv_sec, diff.tv_usec/1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+		printf("%lu.%03lu\n", diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	default:
 		/* reaching here is something disaster */
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 238185f..89c31d3 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -99,7 +99,8 @@ int bench_sched_pipe(int argc, const char **argv,
 		result_usec += diff.tv_usec;
 
 		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
-		       diff.tv_sec, diff.tv_usec/1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 
 		printf(" %14lf usecs/op\n",
 		       (double)result_usec / (double)loops);
@@ -110,7 +111,8 @@ int bench_sched_pipe(int argc, const char **argv,
 
 	case BENCH_FORMAT_SIMPLE:
 		printf("%lu.%03lu\n",
-		       diff.tv_sec, diff.tv_usec / 1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec / 1000));
 		break;
 
 	default:
