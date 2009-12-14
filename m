Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZLNIBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZLNIBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZLNIBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:01:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:58399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbZLNIBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:01:32 -0500
Date: Mon, 14 Dec 2009 08:00:36 GMT
From: tip-bot for David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       davem@davemloft.net, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       davem@davemloft.net, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091213.235622.53363059.davem@davemloft.net>
References: <20091213.235622.53363059.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Fix build failure on sparc
Message-ID: <tip-2cd9046cc53dd2625e2cf5854d6cbb1ba61de914@git.kernel.org>
Git-Commit-ID: 2cd9046cc53dd2625e2cf5854d6cbb1ba61de914
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cd9046cc53dd2625e2cf5854d6cbb1ba61de914
Gitweb:     http://git.kernel.org/tip/2cd9046cc53dd2625e2cf5854d6cbb1ba61de914
Author:     David Miller <davem@davemloft.net>
AuthorDate: Sun, 13 Dec 2009 23:56:22 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:59:12 +0100

perf sched: Fix build failure on sparc

Here, tvec->tv_usec is "unsigned int" not "unsigned long".

Since the type is different on every platform, it's probably
best to just use long printf formats and cast.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091213.235622.53363059.davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-messaging.c |    6 ++++--
 tools/perf/bench/sched-pipe.c      |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index e249eb2..81cee78 100644
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
index 2354f38..4f77c7c 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -100,7 +100,8 @@ int bench_sched_pipe(int argc, const char **argv,
 		result_usec += diff.tv_usec;
 
 		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
-		       diff.tv_sec, diff.tv_usec/1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec/1000));
 
 		printf(" %14lf usecs/op\n",
 		       (double)result_usec / (double)loops);
@@ -111,7 +112,8 @@ int bench_sched_pipe(int argc, const char **argv,
 
 	case BENCH_FORMAT_SIMPLE:
 		printf("%lu.%03lu\n",
-		       diff.tv_sec, diff.tv_usec / 1000);
+		       diff.tv_sec,
+		       (unsigned long) (diff.tv_usec / 1000));
 		break;
 
 	default:
