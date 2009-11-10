Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZKJPEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZKJPEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbZKJPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:04:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63585 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbZKJPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:04:06 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3] perf bench: Fix builtin-bench.c for more friendly output
Date: Wed, 11 Nov 2009 00:04:00 +0900
Message-Id: <1257865442-20252-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257865442-20252-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes output of perf bench more friendly.
Current style of putput, keeping user wait
and print everything suddenly after finish,
will confuse users. So I fixed it.

Example of use(case of messaging):
| % perf bench sched messaging
| # Running sched/messaging benchmark...  <- printed right after invocation
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run

|      Total time:1.476 [sec]

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
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
-- 
1.5.6.5

