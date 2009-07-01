Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZGAOBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZGAOBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZGAOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:01:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbZGAOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:01:31 -0400
Date: Wed, 1 Jul 2009 14:00:52 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jaswinder@kernel.org,
       peterz@infradead.org, efault@gmx.de, jaswinderrajput@gmail.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246453578.3072.1.camel@ht.satnam>
References: <1246453578.3072.1.camel@ht.satnam>
Subject: [tip:perfcounters/urgent] perf list: Add cache events
Message-ID: <tip-73c24cb86c51ff6445b292d9914d31236204393b@git.kernel.org>
Git-Commit-ID: 73c24cb86c51ff6445b292d9914d31236204393b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:00:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73c24cb86c51ff6445b292d9914d31236204393b
Gitweb:     http://git.kernel.org/tip/73c24cb86c51ff6445b292d9914d31236204393b
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 18:36:18 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 15:25:03 +0200

perf list: Add cache events

After:

$ ./perf list

List of pre-defined events (to be used in -e):

  cpu-cycles OR cycles                     [Hardware event]
  instructions                             [Hardware event]
  cache-references                         [Hardware event]
  cache-misses                             [Hardware event]
  branch-instructions OR branches          [Hardware event]
  branch-misses                            [Hardware event]
  bus-cycles                               [Hardware event]

  cpu-clock                                [Software event]
  task-clock                               [Software event]
  page-faults OR faults                    [Software event]
  minor-faults                             [Software event]
  major-faults                             [Software event]
  context-switches OR cs                   [Software event]
  cpu-migrations OR migrations             [Software event]

  L1-d$-loads                              [Hardware cache event]
  L1-d$-load-misses                        [Hardware cache event]
  L1-d$-stores                             [Hardware cache event]
  L1-d$-store-misses                       [Hardware cache event]
  L1-d$-prefetches                         [Hardware cache event]
  L1-d$-prefetch-misses                    [Hardware cache event]
  L1-i$-loads                              [Hardware cache event]
  L1-i$-load-misses                        [Hardware cache event]
  L1-i$-prefetches                         [Hardware cache event]
  L1-i$-prefetch-misses                    [Hardware cache event]
  LLC-loads                                [Hardware cache event]
  LLC-load-misses                          [Hardware cache event]
  LLC-stores                               [Hardware cache event]
  LLC-store-misses                         [Hardware cache event]
  LLC-prefetches                           [Hardware cache event]
  LLC-prefetch-misses                      [Hardware cache event]
  dTLB-loads                               [Hardware cache event]
  dTLB-load-misses                         [Hardware cache event]
  dTLB-stores                              [Hardware cache event]
  dTLB-store-misses                        [Hardware cache event]
  dTLB-prefetches                          [Hardware cache event]
  dTLB-prefetch-misses                     [Hardware cache event]
  iTLB-loads                               [Hardware cache event]
  iTLB-load-misses                         [Hardware cache event]
  branch-loads                             [Hardware cache event]
  branch-load-misses                       [Hardware cache event]

  rNNN                                     [raw hardware event descriptor]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1246453578.3072.1.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aed7090..5184959 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -428,7 +428,7 @@ static const char * const event_type_descriptors[] = {
 void print_events(void)
 {
 	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, prev_type = -1;
+	unsigned int i, type, op, prev_type = -1;
 	char name[40];
 
 	fprintf(stderr, "\n");
@@ -453,6 +453,21 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				fprintf(stderr, "  %-40s [%s]\n",
+					event_cache_name(type, op, i),
+					event_type_descriptors[4]);
+			}
+		}
+	}
+
+	fprintf(stderr, "\n");
 	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
