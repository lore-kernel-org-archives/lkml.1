Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZFVLQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZFVLQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZFVLQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:16:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:46800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbZFVLQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:16:28 -0400
Subject: [PATCH 1/2 -tip] perf_counter: parse-events.c define separate
 declarations for H/W and S/W events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 16:43:14 +0530
Message-Id: <1245669194.17153.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define separate declarations for H/W and S/W events to :
1. shorten name to save some space so that we can add more members
2. Fix alignment
3. Avoid declaring HARDWARE/SOFTWARE again and again.

Removed unused CR(x, y)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.0.6



