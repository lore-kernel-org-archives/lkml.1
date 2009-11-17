Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZKQPJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZKQPJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZKQPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:09:16 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56693 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZKQPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:09:15 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH v2 3/4] perf bench: Modify builtin-bench.c for new subsystem "mem"
Date: Wed, 18 Nov 2009 00:09:09 +0900
Message-Id: <1258470550-29476-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091117.233635.184176449.mitake@dcl.info.waseda.ac.jp>
References: <20091117.233635.184176449.mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies builtin-bench.c to make it be able to
invoke suites of subsystem "mem".

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/builtin-bench.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 90c39ba..e043eb8 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -12,6 +12,7 @@
  *
  * Available subsystem list:
  *  sched ... scheduler and IPC mechanism
+ *  mem   ... memory access performance
  *
  */
 
@@ -43,6 +44,15 @@ static struct bench_suite sched_suites[] = {
 	  NULL                  }
 };
 
+static struct bench_suite mem_suites[] = {
+	{ "memcpy",
+	  "Simple memory copy in various ways",
+	  bench_mem_memcpy },
+	{ NULL,
+	  NULL,
+	  NULL             }
+};
+
 struct bench_subsys {
 	const char *name;
 	const char *summary;
@@ -53,9 +63,12 @@ static struct bench_subsys subsystems[] = {
 	{ "sched",
 	  "scheduler and IPC mechanism",
 	  sched_suites },
+	{ "mem",
+	  "memory access performance",
+	  mem_suites },
 	{ NULL,
 	  NULL,
-	  NULL         }
+	  NULL       }
 };
 
 static void dump_suites(int subsys_index)
-- 
1.6.5.2

