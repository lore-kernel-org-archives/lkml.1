Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZFVLkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZFVLkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZFVLjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:39:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZFVLju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:39:50 -0400
Date: Mon, 22 Jun 2009 11:38:34 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245669194.17153.6.camel@localhost.localdomain>
References: <1245669194.17153.6.camel@localhost.localdomain>
Subject: [tip:perfcounters/urgent] perf_counter tools: Define separate declarations for H/W and S/W events
Message-ID: <tip-51e268423151fc7bb41945bde7843160b6a14c32@git.kernel.org>
Git-Commit-ID: 51e268423151fc7bb41945bde7843160b6a14c32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Jun 2009 11:38:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51e268423151fc7bb41945bde7843160b6a14c32
Gitweb:     http://git.kernel.org/tip/51e268423151fc7bb41945bde7843160b6a14c32
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Mon, 22 Jun 2009 16:43:14 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Jun 2009 13:29:57 +0200

perf_counter tools: Define separate declarations for H/W and S/W events

Define separate declarations for H/W and S/W events to:

 1. Shorten name to save some space so that we can add more members
 2. Fix alignment
 3. Avoid declaring HARDWARE/SOFTWARE again and again.

Removed unused CR(x, y)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245669194.17153.6.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   42 ++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 35d04da..12abab3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -18,30 +18,30 @@ struct event_symbol {
 	char	*symbol;
 };
 
-#define C(x, y) .type = PERF_TYPE_##x, .config = PERF_COUNT_##y
-#define CR(x, y) .type = PERF_TYPE_##x, .config = y
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
 static struct event_symbol event_symbols[] = {
-  { C(HARDWARE, HW_CPU_CYCLES),		"cpu-cycles",		},
-  { C(HARDWARE, HW_CPU_CYCLES),		"cycles",		},
-  { C(HARDWARE, HW_INSTRUCTIONS),	"instructions",		},
-  { C(HARDWARE, HW_CACHE_REFERENCES),	"cache-references",	},
-  { C(HARDWARE, HW_CACHE_MISSES),	"cache-misses",		},
-  { C(HARDWARE, HW_BRANCH_INSTRUCTIONS),"branch-instructions",	},
-  { C(HARDWARE, HW_BRANCH_INSTRUCTIONS),"branches",		},
-  { C(HARDWARE, HW_BRANCH_MISSES),	"branch-misses",	},
-  { C(HARDWARE, HW_BUS_CYCLES),		"bus-cycles",		},
-
-  { C(SOFTWARE, SW_CPU_CLOCK),		"cpu-clock",		},
-  { C(SOFTWARE, SW_TASK_CLOCK),		"task-clock",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS),	"page-faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS),	"faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS_MIN),	"minor-faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS_MAJ),	"major-faults",		},
-  { C(SOFTWARE, SW_CONTEXT_SWITCHES),	"context-switches",	},
-  { C(SOFTWARE, SW_CONTEXT_SWITCHES),	"cs",			},
-  { C(SOFTWARE, SW_CPU_MIGRATIONS),	"cpu-migrations",	},
-  { C(SOFTWARE, SW_CPU_MIGRATIONS),	"migrations",		},
+  { CHW(CPU_CYCLES),		"cpu-cycles",		},
+  { CHW(CPU_CYCLES),		"cycles",		},
+  { CHW(INSTRUCTIONS),		"instructions",		},
+  { CHW(CACHE_REFERENCES),	"cache-references",	},
+  { CHW(CACHE_MISSES),		"cache-misses",		},
+  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	},
+  { CHW(BRANCH_INSTRUCTIONS),	"branches",		},
+  { CHW(BRANCH_MISSES),		"branch-misses",	},
+  { CHW(BUS_CYCLES),		"bus-cycles",		},
+
+  { CSW(CPU_CLOCK),		"cpu-clock",		},
+  { CSW(TASK_CLOCK),		"task-clock",		},
+  { CSW(PAGE_FAULTS),		"page-faults",		},
+  { CSW(PAGE_FAULTS),		"faults",		},
+  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		},
+  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		},
+  { CSW(CONTEXT_SWITCHES),	"context-switches",	},
+  { CSW(CONTEXT_SWITCHES),	"cs",			},
+  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	},
+  { CSW(CPU_MIGRATIONS),	"migrations",		},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
