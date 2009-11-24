Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbZKXOj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbZKXOj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933060AbZKXOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:39:27 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53787 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbZKXOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:39:26 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Michel Lespinasse <walken@google.com>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] perf bench: Fix misc files to build files related to futex
Date: Tue, 24 Nov 2009 23:39:15 +0900
Message-Id: <1259073555-7312-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091118033741.GB23808@google.com>
References: <20091118033741.GB23808@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes misc files including Makefile
 to build files related to futex.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile        |    1 +
 tools/perf/bench/bench.h   |    3 ++-
 tools/perf/builtin-bench.c |   16 ++++++++++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f1537a9..fdc4920 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -420,6 +420,7 @@ BUILTIN_OBJS += builtin-bench.o
 BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
 BUILTIN_OBJS += bench/mem-memcpy.o
+BUILTIN_OBJS += bench/futex-wait.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..8010f97 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -3,7 +3,8 @@
 
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
-extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
+extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix);
+extern int bench_futex_wait(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e043eb8..0c421bf 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -53,6 +53,15 @@ static struct bench_suite mem_suites[] = {
 	  NULL             }
 };
 
+static struct bench_suite futex_suites[] = {
+	{ "wait",
+	  "Iterating locking/unlocking with many threads",
+	  bench_futex_wait },
+	{ NULL,
+	  NULL,
+	  NULL             }
+};
+
 struct bench_subsys {
 	const char *name;
 	const char *summary;
@@ -65,10 +74,13 @@ static struct bench_subsys subsystems[] = {
 	  sched_suites },
 	{ "mem",
 	  "memory access performance",
-	  mem_suites },
+	  mem_suites   },
+	{ "futex",
+	  "fast userspace mutex",
+	  futex_suites },
 	{ NULL,
 	  NULL,
-	  NULL       }
+	  NULL         }
 };
 
 static void dump_suites(int subsys_index)
-- 
1.6.5.2

