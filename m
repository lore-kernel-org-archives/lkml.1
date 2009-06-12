Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZFLGeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZFLGeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZFLGeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:34:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFLGeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:34:04 -0400
Subject: Re: [PowerPC] 2.6.30-git3 build break : perf counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A31ECCD.7030805@in.ibm.com>
References: <4A31ECCD.7030805@in.ibm.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 12:04:54 +0530
Message-Id: <1244788494.5554.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:21 +0530, Sachin Sant wrote:
> 2.6.30-git3 build with CONFIG_PERF_COUNTERS=y failed on a powerpc box.
> 
>  CC      arch/powerpc/kernel/power7-pmu.o
> arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undeclared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:297: error: array index in initializer not of integer type
> arch/powerpc/kernel/power7-pmu.c:297: error: (near initialization for power7_generic_events)
> arch/powerpc/kernel/power7-pmu.c:298: error: PERF_COUNT_INSTRUCTIONS undeclared here (not in a function)
> arch/powerpc/kernel/power7-pmu.c:298: error: array index in initializer not of integer type
> ......<SNIP>......
> 
> Porbably because of commit 526e9a09d2e2dcb6c75c68710465678bb647e5fe
> 

Please check this patch :

[PATCH] powerpc: perf_counter fix performance counter event types

Fix compilation warnings :
 CC      arch/powerpc/kernel/power7-pmu.o
arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undeclared here (not in a function)
arch/powerpc/kernel/power7-pmu.c:297: error: array index in initializer not of integer type
arch/powerpc/kernel/power7-pmu.c:297: error: (near initialization for power7_generic_events)
arch/powerpc/kernel/power7-pmu.c:298: error: PERF_COUNT_INSTRUCTIONS undeclared here (not in a function)
arch/powerpc/kernel/power7-pmu.c:298: error: array index in initializer not of integer type
......<SNIP>......

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.3.2



