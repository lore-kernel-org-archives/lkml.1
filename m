Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZFFNWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZFFNWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZFFNWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:22:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:47398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZFFNWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:22:38 -0400
Date: Sat, 6 Jun 2009 13:22:06 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Fix cache-event printout
Message-ID: <tip-8faf3b547593bf6ea10df631e73204975273c4e0@git.kernel.org>
Git-Commit-ID: 8faf3b547593bf6ea10df631e73204975273c4e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 13:22:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8faf3b547593bf6ea10df631e73204975273c4e0
Gitweb:     http://git.kernel.org/tip/8faf3b547593bf6ea10df631e73204975273c4e0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 13:58:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 14:16:50 +0200

perf_counter tools: Fix cache-event printout

Also standardize the cache printout (so that it can be pasted back
into the command) and sort out the aliases.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/parse-events.c |   56 ++++++++++++------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
index 150fbd2..e0820b4 100644
--- a/Documentation/perf_counter/util/parse-events.c
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -53,45 +53,45 @@ static struct event_symbol event_symbols[] = {
 #define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
 
 static char *hw_event_names[] = {
-	"CPU cycles",
+	"cycles",
 	"instructions",
-	"cache references",
-	"cache misses",
+	"cache-references",
+	"cache-misses",
 	"branches",
-	"branch misses",
-	"bus cycles",
+	"branch-misses",
+	"bus-cycles",
 };
 
 static char *sw_event_names[] = {
-	"cpu clock ticks",
-	"task clock ticks",
-	"pagefaults",
-	"context switches",
-	"CPU migrations",
-	"minor faults",
-	"major faults",
+	"cpu-clock-ticks",
+	"task-clock-ticks",
+	"page-faults",
+	"context-switches",
+	"CPU-migrations",
+	"minor-faults",
+	"major-faults",
 };
 
 #define MAX_ALIASES 8
 
 static char *hw_cache [][MAX_ALIASES] = {
-	{ "l1-d" ,	"l1d" ,	"l1", "l1-data-cache"			},
-	{ "l1-i" ,	"l1i" ,	"l1-instruction-cache"		},
-	{ "l2"  , },
-	{ "dtlb", },
-	{ "itlb", },
-	{ "bpu" , "btb", "branch-cache", NULL },
+	{ "L1-data"		, "l1-d", "l1d", "l1"				},
+	{ "L1-instruction"	, "l1-i", "l1i"					},
+	{ "L2"			, "l2"						},
+	{ "Data-TLB"		, "dtlb", "d-tlb"				},
+	{ "Instruction-TLB"	, "itlb", "i-tlb"				},
+	{ "Branch"		, "bpu" , "btb", "bpc"				},
 };
 
 static char *hw_cache_op [][MAX_ALIASES] = {
-	{ "read"	, "load" },
-	{ "write"	, "store" },
-	{ "prefetch"	, "speculative-read", "speculative-load" },
+	{ "Load"		, "read"					},
+	{ "Store"		, "write"					},
+	{ "Prefetch"		, "speculative-read", "speculative-load"	},
 };
 
 static char *hw_cache_result [][MAX_ALIASES] = {
-	{ "access", "ops" },
-	{ "miss", },
+	{ "Reference"		, "ops", "access"				},
+	{ "Miss"								},
 };
 
 char *event_name(int counter)
@@ -120,14 +120,14 @@ char *event_name(int counter)
 			return "unknown-ext-hardware-cache-type";
 
 		cache_op     = (config >>  8) & 0xff;
-		if (cache_type > PERF_COUNT_HW_CACHE_OP_MAX)
-			return "unknown-ext-hardware-cache-op-type";
+		if (cache_op > PERF_COUNT_HW_CACHE_OP_MAX)
+			return "unknown-ext-hardware-cache-op";
 
 		cache_result = (config >> 16) & 0xff;
-		if (cache_type > PERF_COUNT_HW_CACHE_RESULT_MAX)
-			return "unknown-ext-hardware-cache-result-type";
+		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
+			return "unknown-ext-hardware-cache-result";
 
-		sprintf(name, "%s:%s:%s",
+		sprintf(name, "%s-Cache-%s-%ses",
 			hw_cache[cache_type][0],
 			hw_cache_op[cache_op][0],
 			hw_cache_result[cache_result][0]);
