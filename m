Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZFWM3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZFWM3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFWM30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:29:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:60902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbZFWM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:29:25 -0400
Subject: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 17:58:50 +0530
Message-Id: <1245760130.3776.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

      259250339  L1-d-load-refs        (scaled from 22.73%)
        1187200  L1-d-load-miss        (scaled from 23.01%)
         150454  L1-d-store-refs       (scaled from 23.01%)
         494252  L1-d-prefetch-refs    (scaled from 23.29%)
         362661  L1-d-prefetch-miss    (scaled from 23.73%)
      247343449  L1-i-load-refs        (scaled from 23.71%)
        4804990  L1-i-load-miss        (scaled from 23.85%)
         108711  L1-i-prefetch-refs    (scaled from 23.83%)
        6260313  L2-load-refs          (scaled from 23.82%)
         605425  L2-load-miss          (scaled from 23.82%)
        6898075  L2-store-refs         (scaled from 23.96%)
      248334160  d-TLB-load-refs       (scaled from 23.95%)
        3812835  d-TLB-load-miss       (scaled from 23.87%)
      253208496  i-TLB-load-refs       (scaled from 23.73%)
           5873  i-TLB-load-miss       (scaled from 23.46%)
      110891027  Branch-load-refs      (scaled from 23.21%)
        5529622  Branch-load-miss      (scaled from 23.02%)

    0.374790195  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 06af2fa..5c4b532 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,23 +71,23 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
-	{ "L1-data",		"l1-d",		"l1d"			},
-	{ "L1-instruction",	"l1-i",		"l1i"			},
+	{ "L1-d",		"l1d"					},
+	{ "L1-i",		"l1i"					},
 	{ "L2",			"l2"					},
-	{ "Data-TLB",		"dtlb",		"d-tlb"			},
-	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
+	{ "d-TLB",		"dtlb",					},
+	{ "i-TLB",		"itlb",					},
 	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
 };
 
 static char *hw_cache_op[][MAX_ALIASES] = {
-	{ "Load",		"read"					},
-	{ "Store",		"write"					},
-	{ "Prefetch",		"speculative-read", "speculative-load"	},
+	{ "load",		"read"					},
+	{ "store",		"write"					},
+	{ "prefetch",		"speculative-read", "speculative-load"	},
 };
 
 static char *hw_cache_result[][MAX_ALIASES] = {
-	{ "Reference",		"ops",		"access"		},
-	{ "Miss"							},
+	{ "refs",		"ops",		"access"		},
+	{ "miss"							},
 };
 
 char *event_name(int counter)
@@ -123,7 +123,7 @@ char *event_name(int counter)
 		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
 			return "unknown-ext-hardware-cache-result";
 
-		sprintf(name, "%s-Cache-%s-%ses",
+		sprintf(name, "%s-%s-%s",
 			hw_cache[cache_type][0],
 			hw_cache_op[cache_op][0],
 			hw_cache_result[cache_result][0]);
-- 
1.6.0.6



