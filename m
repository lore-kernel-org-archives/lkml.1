Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZFINci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZFINci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZFINcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:32:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:31787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZFINcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="420128967"
Date: Tue, 9 Jun 2009 21:15:53 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Correct some event and umask values
	for Intel processors
Message-ID: <20090609131553.GA12489@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct some event and UMASK values according to Intel SDM.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 arch/x86/kernel/cpu/perf_counter.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 56001fe..40978aa 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -119,7 +119,7 @@ static const u64 nehalem_hw_cache_event_ids
  },
  [ C(L1I ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0480, /* L1I.READS                    */
+		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                    */
 		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                   */
 	},
 	[ C(OP_WRITE) ] = {
@@ -162,7 +162,7 @@ static const u64 nehalem_hw_cache_event_ids
  [ C(ITLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x01c0, /* INST_RETIRED.ANY_P           */
-		[ C(RESULT_MISS)   ] = 0x0185, /* ITLB_MISS_RETIRED            */
+		[ C(RESULT_MISS)   ] = 0x20c8, /* ITLB_MISS_RETIRED            */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = -1,
@@ -291,7 +291,7 @@ static const u64 atom_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x2241, /* L1D_CACHE.ST               */
+		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE.ST               */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
@@ -301,8 +301,8 @@ static const u64 atom_hw_cache_event_ids
  },
  [ C(L1I ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0080, /* L1I.READS                  */
-		[ C(RESULT_MISS)   ] = 0x0081, /* L1I.MISSES                 */
+		[ C(RESULT_ACCESS) ] = 0x0380, /* L1I.READS                  */
+		[ C(RESULT_MISS)   ] = 0x0280, /* L1I.MISSES                 */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = -1,
@@ -329,11 +329,11 @@ static const u64 atom_hw_cache_event_ids
  },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI  (alias) */
+		[ C(RESULT_ACCESS) ] = 0x2140, /* L1D_CACHE_LD.MESI  (alias) */
 		[ C(RESULT_MISS)   ] = 0x0508, /* DTLB_MISSES.MISS_LD        */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI  (alias) */
+		[ C(RESULT_ACCESS) ] = 0x2240, /* L1D_CACHE_ST.MESI  (alias) */
 		[ C(RESULT_MISS)   ] = 0x0608, /* DTLB_MISSES.MISS_ST        */
 	},
 	[ C(OP_PREFETCH) ] = {
