Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZGANHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZGANHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZGANHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:07:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:54249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZGANHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:07:43 -0400
Subject: [PATCH -tip] perf list: Add cache events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 18:36:18 +0530
Message-Id: <1246453578.3072.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
-- 
1.6.0.6



