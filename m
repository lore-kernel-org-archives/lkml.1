Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZFIOxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZFIOxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZFIOxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:53:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:43928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbZFIOxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:53:31 -0400
Date: Tue, 9 Jun 2009 14:52:58 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       yong.y.wang@intel.com, yong.y.wang@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yong.y.wang@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090609131553.GA12489@ywang-moblin2.bj.intel.com>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter, x86: Correct some event and umask values for Intel processors
Message-ID: <tip-fecc8ac8496fce96069724f54daba8e7078b0082@git.kernel.org>
Git-Commit-ID: fecc8ac8496fce96069724f54daba8e7078b0082
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 09 Jun 2009 14:53:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fecc8ac8496fce96069724f54daba8e7078b0082
Gitweb:     http://git.kernel.org/tip/fecc8ac8496fce96069724f54daba8e7078b0082
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Tue, 9 Jun 2009 21:15:53 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Jun 2009 16:50:07 +0200

perf_counter, x86: Correct some event and umask values for Intel processors

Correct some event and UMASK values according to Intel SDM,
in the Nehalem and Atom tables.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090609131553.GA12489@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

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
