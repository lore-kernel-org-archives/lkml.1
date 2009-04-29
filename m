Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZD2LGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZD2LGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZD2LGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:06:09 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:4279 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758681AbZD2LGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:06:07 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 07:06:07 EDT
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KIUZGW-04-0XE-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 27/29] x86/perfcounters: remove vendor check in fixed_mode_idx()
Date: Wed, 29 Apr 2009 12:47:24 +0200
Message-ID: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0633 (UTC) FILETIME=[5BCAE110:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function fixed_mode_idx() is used generically. Now it checks the
num_counters_fixed value instead of the vendor to decide if fixed
counters are present.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 4b8715b..d1c8036 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -542,7 +542,7 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 {
 	unsigned int event;
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
 	if (unlikely(hwc->nmi))
-- 
1.6.1.3


