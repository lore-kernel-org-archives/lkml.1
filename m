Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZFYW3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZFYW3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZFYW3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:29:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:41917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZFYW3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:29:09 -0400
Subject: Re: [PATCH -tip] perf_counter tools: add support to set of
 multiple events in one short
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245963764.10962.2.camel@hpdv5.satnam>
References: <1245963764.10962.2.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 03:58:34 +0530
Message-Id: <1245968914.10962.12.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 02:32 +0530, Jaswinder Singh Rajput wrote:
> Add support for HARDWARE and SOFTWARE events :
>  perf stat -e all-sw-events
>  perf stat -e sw-events
>  perf stat -e all-hw-events
>  perf stat -e hw-events
> 
> On AMD box :
> 
> ./perf stat -e hw-events -e all-sw-events -- ls -lR > /dev/null
> 
>  Performance counter stats for 'ls -lR':
> 
>         9977353  cycles               #    557.193 M/sec  (scaled from 21.81%)
>         4244800  instructions         #      0.425 IPC    (scaled from 27.51%)
>         2953188  cache-references     #    164.923 M/sec  (scaled from 89.10%)
>           72469  cache-misses         #      4.047 M/sec  (scaled from 89.13%)
>          775760  branches             #     43.323 M/sec  (scaled from 89.10%)
>           57814  branch-misses        #      3.229 M/sec  (scaled from 83.34%)
>   <not counted>  bus-cycles
>       17.970985  cpu-clock-msecs
>       17.906460  task-clock-msecs     #      0.955 CPUs
>             386  page-faults          #      0.022 M/sec
>             386  minor-faults         #      0.022 M/sec
>               0  major-faults         #      0.000 M/sec
>               4  context-switches     #      0.000 M/sec
>               1  CPU-migrations       #      0.000 M/sec
> 
>     0.018750671  seconds time elapsed.
> 
> Reported-by : Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/util/parse-events.c |   66 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 64 insertions(+), 2 deletions(-)

Please treat :
 [PATCH -tip] perf_counter tools: add support to set of multiple events in one short
as 
 [PATCH 1/2-tip] perf_counter tools: add support to set of multiple events in one short

And here is 2/2 :

[PATCH 2/2 -tip] perf_counter tools: Add support for all CACHE events

Add support for all CACHE events :
 perf stat -e all-cache-events
 perf stat -e cache-events

On AMD box (<not-counted> events are not available for AMD):

./perf stat -e all-cache-events -- ls -lR /usr/include/ > /dev/null

 Performance counter stats for 'ls -lR /usr/include/':

      246370884  L1-d$-loads           (scaled from 23.55%)
        1074018  L1-d$-load-misses     (scaled from 23.38%)
         150708  L1-d$-stores          (scaled from 23.57%)
  <not counted>  L1-d$-store-misses
         428804  L1-d$-prefetches      (scaled from 23.47%)
         314446  L1-d$-prefetch-misses  (scaled from 23.42%)
      252626137  L1-i$-loads           (scaled from 23.24%)
        3985110  L1-i$-load-misses     (scaled from 23.24%)
          93754  L1-i$-prefetches      (scaled from 23.34%)
  <not counted>  L1-i$-prefetch-misses
        5202314  LLC-loads             (scaled from 23.34%)
         525467  LLC-load-misses       (scaled from 23.25%)
        5220558  LLC-stores            (scaled from 23.21%)
  <not counted>  LLC-store-misses
  <not counted>  LLC-prefetches
  <not counted>  LLC-prefetch-misses
      251954203  dTLB-loads            (scaled from 23.70%)
        5297550  dTLB-load-misses      (scaled from 23.96%)
  <not counted>  dTLB-stores
  <not counted>  dTLB-store-misses
  <not counted>  dTLB-prefetches
  <not counted>  dTLB-prefetch-misses
      248561524  iTLB-loads            (scaled from 24.15%)
           4693  iTLB-load-misses      (scaled from 24.18%)
      106992392  branch-loads          (scaled from 23.67%)
        5239561  branch-load-misses    (scaled from 23.43%)

    0.395946903  seconds time elapsed.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cfc622b..c1cd93e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -40,14 +40,63 @@ static struct event_symbol event_symbols[] = {
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
+struct event_cache_symbol {
+	u8	type;
+	u64	config;
+};
+
 struct event_type_symbol {
 	char	*symbol;
 	char	*alias;
 };
 
+#define CHCACHE(x, y, z)						\
+.type = PERF_TYPE_HW_CACHE,						\
+.config = (PERF_COUNT_HW_CACHE_##x | (PERF_COUNT_HW_CACHE_OP_##y << 8) |\
+	   (PERF_COUNT_HW_CACHE_RESULT_##z << 16))
+
+/* Generalized Hardware cache counters events		*/
+static struct event_cache_symbol event_cache_symbols[] = {
+  { CHCACHE(L1D,	READ,		ACCESS)		},
+  { CHCACHE(L1D,	READ,		MISS)		},
+  { CHCACHE(L1D,	WRITE,		ACCESS)		},
+  { CHCACHE(L1D,	WRITE,		MISS)		},
+  { CHCACHE(L1D,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1D,	PREFETCH,	MISS)		},
+
+  { CHCACHE(L1I,	READ,		ACCESS)		},
+  { CHCACHE(L1I,	READ,		MISS)		},
+  { CHCACHE(L1I,	PREFETCH,	ACCESS)		},
+  { CHCACHE(L1I,	PREFETCH,	MISS)		},
+
+  { CHCACHE(LL,		READ,		ACCESS)		},
+  { CHCACHE(LL,		READ,		MISS)		},
+  { CHCACHE(LL,		WRITE,		ACCESS)		},
+  { CHCACHE(LL,		WRITE,		MISS)		},
+  { CHCACHE(LL,		PREFETCH,	ACCESS)		},
+  { CHCACHE(LL,		PREFETCH,	MISS)		},
+
+  { CHCACHE(DTLB,	READ,		ACCESS)		},
+  { CHCACHE(DTLB,	READ,		MISS)		},
+  { CHCACHE(DTLB,	WRITE,		ACCESS)		},
+  { CHCACHE(DTLB,	WRITE,		MISS)		},
+  { CHCACHE(DTLB,	PREFETCH,	ACCESS)		},
+  { CHCACHE(DTLB,	PREFETCH,	MISS)		},
+
+  { CHCACHE(ITLB,	READ,		ACCESS)		},
+  { CHCACHE(ITLB,	READ,		MISS)		},
+
+  { CHCACHE(BPU,	READ,		ACCESS)		},
+  { CHCACHE(BPU,	READ,		MISS)		},
+
+};
+
 static struct event_type_symbol event_type_symbols[] = {
- [PERF_TYPE_HARDWARE] = { "hw-events",		"all-hw-events",	},
- [PERF_TYPE_SOFTWARE] = { "sw-events",		"all-sw-events",	},
+ [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
+ [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
+ [PERF_TYPE_TRACEPOINT]	= { "",			"",			},
+ [PERF_TYPE_HW_CACHE]	= { "cache-events",	"all-cache-events",	},
+ [PERF_TYPE_RAW]	= { "",			"",			},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -264,8 +313,18 @@ static int set_multiple_events(unsigned int type)
 				nr_counters++;
 			}
 		}
+		break;
 
+	case PERF_TYPE_HW_CACHE:
+		for (i = 0; i < ARRAY_SIZE(event_cache_symbols); i++) {
+			memset(&attr, 0, sizeof(attr));
+			attr.type = event_cache_symbols[i].type;
+			attr.config = event_cache_symbols[i].config;
+			attrs[nr_counters] = attr;
+			nr_counters++;
+		}
 		break;
+
 	default:
 		return -1;
 	}
@@ -279,9 +338,10 @@ static int set_multiple_events(unsigned int type)
 
 static int check_type_events(const char *str, unsigned int i)
 {
-	if (!strncmp(str, event_type_symbols[i].symbol,
-		     strlen(event_type_symbols[i].symbol)))
-		return 1;
+	if (strlen(event_type_symbols[i].symbol))
+		if (!strncmp(str, event_type_symbols[i].symbol,
+			     strlen(event_type_symbols[i].symbol)))
+			return 1;
 
 	if (strlen(event_type_symbols[i].alias))
 		if (!strncmp(str, event_type_symbols[i].alias,
-- 
1.6.0.6




