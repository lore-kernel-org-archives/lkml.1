Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZFVPSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZFVPSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFVPSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:18:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:43243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZFVPSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:18:45 -0400
Subject: [PATCH -tip] perf_counter util: set alias for page-faults
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 20:47:26 +0530
Message-Id: <1245683846.12092.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


faults should be alias for page-faults

Also fixed alignment and 80 characters issue

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f569548..06af2fa 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -33,8 +33,7 @@ static struct event_symbol event_symbols[] = {
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
-  { CSW(PAGE_FAULTS),		"page-faults",		""		},
-  { CSW(PAGE_FAULTS),		"faults",		""		},
+  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
   { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
@@ -71,24 +70,24 @@ static char *sw_event_names[] = {
 
 #define MAX_ALIASES 8
 
-static char *hw_cache [][MAX_ALIASES] = {
-	{ "L1-data"		, "l1-d", "l1d"					},
-	{ "L1-instruction"	, "l1-i", "l1i"					},
-	{ "L2"			, "l2"						},
-	{ "Data-TLB"		, "dtlb", "d-tlb"				},
-	{ "Instruction-TLB"	, "itlb", "i-tlb"				},
-	{ "Branch"		, "bpu" , "btb", "bpc"				},
+static char *hw_cache[][MAX_ALIASES] = {
+	{ "L1-data",		"l1-d",		"l1d"			},
+	{ "L1-instruction",	"l1-i",		"l1i"			},
+	{ "L2",			"l2"					},
+	{ "Data-TLB",		"dtlb",		"d-tlb"			},
+	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
+	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
 };
 
-static char *hw_cache_op [][MAX_ALIASES] = {
-	{ "Load"		, "read"					},
-	{ "Store"		, "write"					},
-	{ "Prefetch"		, "speculative-read", "speculative-load"	},
+static char *hw_cache_op[][MAX_ALIASES] = {
+	{ "Load",		"read"					},
+	{ "Store",		"write"					},
+	{ "Prefetch",		"speculative-read", "speculative-load"	},
 };
 
-static char *hw_cache_result [][MAX_ALIASES] = {
-	{ "Reference"		, "ops", "access"				},
-	{ "Miss"								},
+static char *hw_cache_result[][MAX_ALIASES] = {
+	{ "Reference",		"ops",		"access"		},
+	{ "Miss"							},
 };
 
 char *event_name(int counter)
@@ -160,7 +159,8 @@ static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
 	return -1;
 }
 
-static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
+static int
+parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 {
 	int cache_type = -1, cache_op = 0, cache_result = 0;
 
@@ -201,7 +201,7 @@ static int check_events(const char *str, unsigned int i)
 
 	if (strlen(event_symbols[i].alias))
 		if (!strncmp(str, event_symbols[i].alias,
-		      strlen(event_symbols[i].alias)))
+			     strlen(event_symbols[i].alias)))
 			return 1;
 	return 0;
 }
-- 
1.6.0.6



