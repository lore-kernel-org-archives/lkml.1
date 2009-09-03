Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZICBw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZICBw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZICBw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:52:27 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52434 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZICBw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:52:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19103.8514.709300.585484@cargo.ozlabs.ibm.com>
Date: Thu, 3 Sep 2009 11:52:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter/powerpc: Fix cache event codes for POWER7
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had the codes for L1 D-cache load accesses and misses swapped around,
and the wrong codes for LL-cache accesses and misses.  This corrects
them.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Ingo, if you have perfcounter fixes that you are going to ask Linus to
pull before .32, please include this.

 arch/powerpc/kernel/power7-pmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 388cf57..018d094 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -317,7 +317,7 @@ static int power7_generic_events[] = {
  */
 static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-		[C(OP_READ)] = {	0x400f0,	0xc880	},
+		[C(OP_READ)] = {	0xc880,		0x400f0	},
 		[C(OP_WRITE)] = {	0,		0x300f0	},
 		[C(OP_PREFETCH)] = {	0xd8b8,		0	},
 	},
@@ -327,8 +327,8 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_PREFETCH)] = {	0x408a,		0	},
 	},
 	[C(LL)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-		[C(OP_READ)] = {	0x6080,		0x6084	},
-		[C(OP_WRITE)] = {	0x6082,		0x6086	},
+		[C(OP_READ)] = {	0x16080,	0x26080	},
+		[C(OP_WRITE)] = {	0x16082,	0x26082	},
 		[C(OP_PREFETCH)] = {	0,		0	},
 	},
 	[C(DTLB)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-- 
1.6.0.4

