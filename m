Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZICGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZICGrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZICGrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:47:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:42698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZICGrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:47:18 -0400
Date: Thu, 3 Sep 2009 06:46:45 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, stable@kernel.org,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <19103.8514.709300.585484@cargo.ozlabs.ibm.com>
References: <19103.8514.709300.585484@cargo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter/powerpc: Fix cache event codes for POWER7
Message-ID: <tip-a3df6f7d3090e611bcc774cd2cba45ae016d37e1@git.kernel.org>
Git-Commit-ID: a3df6f7d3090e611bcc774cd2cba45ae016d37e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 06:46:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3df6f7d3090e611bcc774cd2cba45ae016d37e1
Gitweb:     http://git.kernel.org/tip/a3df6f7d3090e611bcc774cd2cba45ae016d37e1
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 3 Sep 2009 11:52:02 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 08:41:53 +0200

perf_counter/powerpc: Fix cache event codes for POWER7

I had the codes for L1 D-cache load accesses and misses swapped
around, and the wrong codes for LL-cache accesses and misses.
This corrects them.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <19103.8514.709300.585484@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
