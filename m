Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbZFMOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbZFMOvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762240AbZFMOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:50:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761851AbZFMOuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:50:10 -0400
Date: Sat, 13 Jun 2009 14:49:33 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, robert.richter@amd.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, efault@gmx.de, jaswinderrajput@gmail.com,
       robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1244835381.2802.2.camel@ht.satnam>
References: <1244835381.2802.2.camel@ht.satnam>
Subject: [tip:perfcounters/core] perf_counter, x86: Update AMD hw caching related event table
Message-ID: <tip-f4db43a38f7387c3b19c9565124c06ab0c5d6e9a@git.kernel.org>
Git-Commit-ID: f4db43a38f7387c3b19c9565124c06ab0c5d6e9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:49:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4db43a38f7387c3b19c9565124c06ab0c5d6e9a
Gitweb:     http://git.kernel.org/tip/f4db43a38f7387c3b19c9565124c06ab0c5d6e9a
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 13 Jun 2009 01:06:21 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 12:58:25 +0200

perf_counter, x86: Update AMD hw caching related event table

All AMD models share the same hw caching related event table.

Also complete the table with more events.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1244835381.2802.2.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3c37c39..77a59a5 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -389,23 +389,23 @@ static u64 intel_pmu_raw_event(u64 event)
 	return event & CORE_EVNTSEL_MASK;
 }
 
-static const u64 amd_0f_hw_cache_event_ids
+static const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0042, /* Data Cache Refills from L2 */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
+		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
 	},
  },
  [ C(L1I ) ] = {
@@ -418,17 +418,17 @@ static const u64 amd_0f_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
 		[ C(RESULT_MISS)   ] = 0,
 	},
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
+		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
@@ -438,8 +438,8 @@ static const u64 amd_0f_hw_cache_event_ids
  },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0,
@@ -1465,16 +1465,10 @@ static int amd_pmu_init(void)
 
 	x86_pmu = amd_pmu;
 
-	switch (boot_cpu_data.x86) {
-	case 0x0f:
-	case 0x10:
-	case 0x11:
-		memcpy(hw_cache_event_ids, amd_0f_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
+	/* Events are common for all AMDs */
+	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
+	       sizeof(hw_cache_event_ids));
 
-		pr_cont("AMD Family 0f/10/11 events, ");
-		break;
-	}
 	return 0;
 }
 
