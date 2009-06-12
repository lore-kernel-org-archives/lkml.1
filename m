Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZFLMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZFLMZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZFLMZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:25:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:51474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZFLMZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:25:10 -0400
Date: Fri, 12 Jun 2009 12:24:37 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, jaswinder@kernel.org, sachinp@in.ibm.com,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jaswinder@kernel.org, sachinp@in.ibm.com,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1244788494.5554.1.camel@ht.satnam>
References: <1244788494.5554.1.camel@ht.satnam>
Subject: [tip:perfcounters/core] powerpc, perf_counter: Fix performance counter event types
Message-ID: <tip-4c921126fe553440261f56691c5f60fbaaa486d6@git.kernel.org>
Git-Commit-ID: 4c921126fe553440261f56691c5f60fbaaa486d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:24:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c921126fe553440261f56691c5f60fbaaa486d6
Gitweb:     http://git.kernel.org/tip/4c921126fe553440261f56691c5f60fbaaa486d6
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Fri, 12 Jun 2009 12:04:54 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:21:11 +0200

powerpc, perf_counter: Fix performance counter event types

Sachin Sant reported these compiler errors:

 CC      arch/powerpc/kernel/power7-pmu.o
arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undeclared here (not in a function)

Which happened because a last-minute rename of symbols crossed with
the Power7 support patch.

Fix this by using the new symbol names.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
LKML-Reference: <1244788494.5554.1.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/power7-pmu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index b3f7d12..b72e7a1 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -294,12 +294,12 @@ static void power7_disable_pmc(unsigned int pmc, u64 mmcr[])
 }
 
 static int power7_generic_events[] = {
-	[PERF_COUNT_CPU_CYCLES] = 0x1e,
-	[PERF_COUNT_INSTRUCTIONS] = 2,
-	[PERF_COUNT_CACHE_REFERENCES] = 0xc880,		/* LD_REF_L1_LSU */
-	[PERF_COUNT_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1 */
-	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN */
-	[PERF_COUNT_BRANCH_MISSES] = 0x400f6,		/* BR_MPRED */
+	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
+	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
+	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
+	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
+	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
