Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZKJTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZKJTB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbZKJTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:01:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:37381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757609AbZKJTBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:01:24 -0500
Date: Tue, 10 Nov 2009 19:00:55 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257865442-20252-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Improve builtin-bench.c for more friendly output
Message-ID: <tip-79e295d4bd0f524257299e7c4e42f643f21abcc2@git.kernel.org>
Git-Commit-ID: 79e295d4bd0f524257299e7c4e42f643f21abcc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79e295d4bd0f524257299e7c4e42f643f21abcc2
Gitweb:     http://git.kernel.org/tip/79e295d4bd0f524257299e7c4e42f643f21abcc2
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 11 Nov 2009 00:04:00 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 19:56:44 +0100

perf bench: Improve builtin-bench.c for more friendly output

This patch makes output of perf bench more friendly.
Current style of putput, keeping user wait
and printing everything suddenly when we finish,
may confuse users.

So I improved it:

 | % perf bench sched messaging
 | # Running sched/messaging benchmark...  <- printed right after invocation
 | # 20 sender and receiver processes per group
 | # 10 groups == 400 processes run
 |
 |      Total time: 1.476 [sec]

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257865442-20252-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-bench.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index c7505ea..90c39ba 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -156,6 +156,10 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 			if (strcmp(subsystems[i].suites[j].name, argv[1]))
 				continue;
 
+			if (bench_format == BENCH_FORMAT_DEFAULT)
+				printf("# Running %s/%s benchmark...\n",
+				       subsystems[i].name,
+				       subsystems[i].suites[j].name);
 			status = subsystems[i].suites[j].fn(argc - 1,
 							    argv + 1, prefix);
 			goto end;
