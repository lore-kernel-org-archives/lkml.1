Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZFVP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZFVP2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZFVP2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:47700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbZFVP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:28:06 -0400
Date: Mon, 22 Jun 2009 15:27:34 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245683846.12092.1.camel@localhost.localdomain>
References: <1245683846.12092.1.camel@localhost.localdomain>
Subject: [tip:perfcounters/urgent] perf_counter tools: Set alias for page-faults
Message-ID: <tip-c0c22dbfa8ba3c5045eeb9c76d2822ffc44fefc3@git.kernel.org>
Git-Commit-ID: c0c22dbfa8ba3c5045eeb9c76d2822ffc44fefc3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Jun 2009 15:27:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0c22dbfa8ba3c5045eeb9c76d2822ffc44fefc3
Gitweb:     http://git.kernel.org/tip/c0c22dbfa8ba3c5045eeb9c76d2822ffc44fefc3
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Mon, 22 Jun 2009 20:47:26 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Jun 2009 17:25:53 +0200

perf_counter tools: Set alias for page-faults

"faults" should be alias for "page-faults"

Also fixed alignment and 80 characters issue

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245683846.12092.1.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
