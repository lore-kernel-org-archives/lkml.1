Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0CDQvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:51:40 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28102 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab0CDQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:33 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i87h2a8h6bh43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO26-02-MPC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/9] perf, x86: use new perfctr reservation functions in perf code
Date: Thu, 4 Mar 2010 16:22:07 +0100
Message-ID: <1267716131-17908-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0254 (UTC) FILETIME=[9F3062E0:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_perfctr()/release_perfctr() in perf code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 62a1a5e..16ae7b4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -244,7 +244,7 @@ static bool reserve_pmc_hardware(void)
 		disable_lapic_nmi_watchdog();
 
 	for (i = 0; i < x86_pmu.num_events; i++) {
-		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
+		if (!reserve_perfctr(i))
 			goto perfctr_fail;
 	}
 
@@ -252,7 +252,7 @@ static bool reserve_pmc_hardware(void)
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
-		release_perfctr_nmi(x86_pmu.perfctr + i);
+		release_perfctr(i);
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
@@ -265,7 +265,7 @@ static void release_pmc_hardware(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.num_events; i++)
-		release_perfctr_nmi(x86_pmu.perfctr + i);
+		release_perfctr(i);
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
-- 
1.7.0


