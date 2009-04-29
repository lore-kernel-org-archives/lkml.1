Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZD2Kyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZD2Kyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZD2KvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:19 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10123 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZD2KvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:08 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KIUZGW-04-0XF-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 28/29] x86/perfcounters: remove unused function argument in intel_pmu_get_status()
Date: Wed, 29 Apr 2009 12:47:25 +0200
Message-ID: <1241002046-8832-29-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0664 (UTC) FILETIME=[5BCF9C00:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mask argument is unused and thus can be removed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d1c8036..856b0b8 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -393,7 +393,7 @@ void hw_perf_restore(u64 ctrl)
  */
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
-static inline u64 intel_pmu_get_status(u64 mask)
+static inline u64 intel_pmu_get_status(void)
 {
 	u64 status;
 
@@ -728,7 +728,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 
 	cpuc->throttle_ctrl = intel_pmu_save_disable_all();
 
-	status = intel_pmu_get_status(cpuc->throttle_ctrl);
+	status = intel_pmu_get_status();
 	if (!status)
 		goto out;
 
@@ -753,7 +753,7 @@ again:
 	/*
 	 * Repeat if there is more work to be done:
 	 */
-	status = intel_pmu_get_status(cpuc->throttle_ctrl);
+	status = intel_pmu_get_status();
 	if (status)
 		goto again;
 out:
-- 
1.6.1.3


