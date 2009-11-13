Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZKMEXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZKMEXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 23:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZKMEXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 23:23:33 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50398 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbZKMEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 23:23:07 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH 3/4] perf bench: Modify builtin-bench.c for new subsystem "mem"
Date: Fri, 13 Nov 2009 13:23:05 +0900
Message-Id: <1258086186-32317-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies builtin-bench.c to make new subsystem
"mem" executable.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
---
 tools/perf/builtin-bench.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 90c39ba..0e58fdf 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -12,7 +12,7 @@
  *
  * Available subsystem list:
  *  sched ... scheduler and IPC mechanism
- *
+ *  mem   ... memory access performance
  */
 
 #include "perf.h"
@@ -43,6 +43,15 @@ static struct bench_suite sched_suites[] = {
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
@@ -53,7 +62,9 @@ static struct bench_subsys subsystems[] = {
 	{ "sched",
 	  "scheduler and IPC mechanism",
 	  sched_suites },
+	{ "mem",
+	  "memory access performance",
+	  mem_suites   },
 	{ NULL,
 	  NULL,
 	  NULL         }
-- 
1.6.5.2

