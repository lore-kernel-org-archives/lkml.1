Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003Ab0AVO5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0AVO5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0AVO5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:57:30 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16572 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0AVOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:17 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFJ-02-1LC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/12] perf/core, x86: removing p6_pmu_raw_event()
Date: Fri, 22 Jan 2010 15:22:01 +0100
Message-ID: <1264170127-17402-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0424 (UTC) FILETIME=[DC123C00:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is the same as intel_pmu_raw_event(). This patch removes
the duplicate code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5c6244b..1863cda 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -150,24 +150,6 @@ static u64 p6_pmu_event_map(int hw_event)
  */
 #define P6_NOP_EVENT			0x0000002EULL
 
-static u64 p6_pmu_raw_event(u64 hw_event)
-{
-#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define P6_EVNTSEL_INV_MASK		0x00800000ULL
-#define P6_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define P6_EVNTSEL_MASK			\
-	(P6_EVNTSEL_EVENT_MASK |	\
-	 P6_EVNTSEL_UNIT_MASK  |	\
-	 P6_EVNTSEL_EDGE_MASK  |	\
-	 P6_EVNTSEL_INV_MASK   |	\
-	 P6_EVNTSEL_REG_MASK)
-
-	return hw_event & P6_EVNTSEL_MASK;
-}
-
 static const struct event_constraint intel_p6_event_constraints[] =
 {
 	EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
@@ -1978,7 +1960,7 @@ static __initconst struct x86_pmu p6_pmu = {
 	.eventsel		= MSR_P6_EVNTSEL0,
 	.perfctr		= MSR_P6_PERFCTR0,
 	.event_map		= p6_pmu_event_map,
-	.raw_event		= p6_pmu_raw_event,
+	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
-- 
1.6.6


