Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbZFXUls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbZFXUls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbZFXUlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:41:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:51946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760560AbZFXUlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:41:39 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090623195656.GC8777@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 02:11:00 +0530
Message-Id: <1245876060.3038.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 

> here's an edited version of my suggestions:
> 
> >       259250339  dL1-loads              (scaled from 22.73%)
> >         1187200  dL1-load-misses        (scaled from 23.01%)
> >          150454  dL1-stores             (scaled from 23.01%)
> >          494252  dL1-prefetches         (scaled from 23.29%)
> >          362661  dL1-prefetch-misses    (scaled from 23.73%)
> >       247343449  iL1-loads              (scaled from 23.71%)
> >         4804990  iL1-load-misses        (scaled from 23.85%)
> >          108711  iL1-prefetches         (scaled from 23.83%)
> >         6260313  LLC-loads              (scaled from 23.82%)
> >          605425  LLC-load-misses        (scaled from 23.82%)
> >         6898075  LLC-stores             (scaled from 23.96%)
> >       248334160  dTLB-loads             (scaled from 23.95%)
> >         3812835  dTLB-load-misses       (scaled from 23.87%)
> >       253208496  iTLB-loads             (scaled from 23.73%)
> >            5873  iTLB-load-misses       (scaled from 23.46%)
> >       110891027  branches               (scaled from 23.21%)
> >         5529622  branch-misses          (scaled from 23.02%)
> 
> We can leave out 'refs' i think - without any qualification 
> statements like '247343449 iL1-loads' are still unambigious i think.
> 
> Plus we can abbreviate dL1/iL1/dTLB/iTLB. The capitalization 
> matters. Also, note that it's LLC (Last Level Cache), not L2.
> 
> ( Sidenote: L2 can still be an alias for LLC, even though some CPUs 
>   have a L3 too. )
> 
> Note, branches are special - we dont really have 'branch loads', 
> branches are executions. 'Branches' and 'Branch-misses' are the 
> right term.
> 

[PATCH] perf_counter tools: shorten names for events

Special handling for branches as branches are special
we don't really have 'branch loads', branches are executions.
'Branches' and 'Branch-misses' are the right term.

On AMD box:
$ ./perf stat -e l1d -e l1d-misses -e l1d-write -e l1d-prefetch -e l1d-prefetch-miss -e l1i -e l1i-misses -e l1i-prefetch -e l2 -e l2-misses -e l2-write -e dtlb -e dtlb-misses -e itlb -e itlb-misses -e bpu -e bpu-misses -- ls -lR /usr/include/ > /dev/null

Before :

 Performance counter stats for 'ls -lR /usr/include/':

      248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
        1001433  L1-data-Cache-Load-Misses  (scaled from 23.34%)
         153691  L1-data-Cache-Store-Referencees  (scaled from 23.34%)
         423248  L1-data-Cache-Prefetch-Referencees  (scaled from 23.33%)
         302138  L1-data-Cache-Prefetch-Misses  (scaled from 23.25%)
      251217546  L1-instruction-Cache-Load-Referencees  (scaled from 23.25%)
        5757005  L1-instruction-Cache-Load-Misses  (scaled from 23.23%)
          93435  L1-instruction-Cache-Prefetch-Referencees  (scaled from 23.24%)
        6496073  L2-Cache-Load-Referencees  (scaled from 23.32%)
         609485  L2-Cache-Load-Misses  (scaled from 23.45%)
        6876991  L2-Cache-Store-Referencees  (scaled from 23.71%)
      248922840  Data-TLB-Cache-Load-Referencees  (scaled from 23.94%)
        5828386  Data-TLB-Cache-Load-Misses  (scaled from 24.17%)
      257613506  Instruction-TLB-Cache-Load-Referencees  (scaled from 24.20%)
           6833  Instruction-TLB-Cache-Load-Misses  (scaled from 23.88%)
      109043606  Branch-Cache-Load-Referencees  (scaled from 23.64%)
        5552296  Branch-Cache-Load-Misses  (scaled from 23.42%)

    0.413702461  seconds time elapsed.

After :

 Performance counter stats for 'ls -lR /usr/include/':

      283542921  dL1-loads             (scaled from 23.28%)
        1848314  dL1-load-misses       (scaled from 22.94%)
         168963  dL1-stores            (scaled from 22.94%)
         739249  dL1-prefetches        (scaled from 22.45%)
         501021  dL1-prefetch-misses   (scaled from 22.25%)
      275037259  iL1-loads             (scaled from 23.40%)
        6030825  iL1-load-misses       (scaled from 23.26%)
         166760  iL1-prefetches        (scaled from 24.31%)
        7224781  LLC-loads             (scaled from 24.76%)
         821097  LLC-load-misses       (scaled from 24.07%)
        7070549  LLC-stores            (scaled from 24.45%)
      251586242  dTLB-loads            (scaled from 24.65%)
        5127780  dTLB-load-misses      (scaled from 23.99%)
      276782014  iTLB-loads            (scaled from 23.77%)
          16787  iTLB-load-misses      (scaled from 23.72%)
      123408502  branches              (scaled from 22.88%)
        5843856  branch-misses         (scaled from 22.87%)

    1.417039891  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   45 ++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 06af2fa..fa6e2e5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,23 +71,23 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
-	{ "L1-data",		"l1-d",		"l1d"			},
-	{ "L1-instruction",	"l1-i",		"l1i"			},
-	{ "L2",			"l2"					},
-	{ "Data-TLB",		"dtlb",		"d-tlb"			},
-	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
-	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
+ { "dL1",	"L1-d",		"l1d",					},
+ { "iL1",	"L1-i",		"l1i",					},
+ { "LLC",	"L2",							},
+ { "dTLB",	"d-tlb",						},
+ { "iTLB",	"i-tlb",						},
+ { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
 };
 
 static char *hw_cache_op[][MAX_ALIASES] = {
-	{ "Load",		"read"					},
-	{ "Store",		"write"					},
-	{ "Prefetch",		"speculative-read", "speculative-load"	},
+ { "load",	"loads",	"read",					},
+ { "store",	"stores",	"write",				},
+ { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
 static char *hw_cache_result[][MAX_ALIASES] = {
-	{ "Reference",		"ops",		"access"		},
-	{ "Miss"							},
+ { "refs",	"ops",		"access",				},
+ { "misses",	"miss",							},
 };
 
 char *event_name(int counter)
@@ -123,10 +123,25 @@ char *event_name(int counter)
 		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
 			return "unknown-ext-hardware-cache-result";
 
-		sprintf(name, "%s-Cache-%s-%ses",
-			hw_cache[cache_type][0],
-			hw_cache_op[cache_op][0],
-			hw_cache_result[cache_result][0]);
+		/*
+		 * special handling for branches
+		 * we are only interested in BPU, READ
+		 */ 
+		if (cache_type == PERF_COUNT_HW_CACHE_BPU && cache_op)
+			return "unknown";
+		else if (cache_type == PERF_COUNT_HW_CACHE_BPU) {
+			if (cache_result)
+				sprintf(name, "%s-%s", hw_cache[cache_type][0],
+					hw_cache_result[cache_result][0]);
+			else
+				sprintf(name, "%s", hw_cache[cache_type][1]);
+		} else if (cache_result)
+			sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
+				hw_cache_op[cache_op][0],
+				hw_cache_result[cache_result][0]);
+		else
+			sprintf(name, "%s-%s", hw_cache[cache_type][0],
+				hw_cache_op[cache_op][1]);
 
 		return name;
 	}
-- 
1.6.0.6



