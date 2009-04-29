Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZD2NPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZD2NPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbZD2NJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:09:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510AbZD2NJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:09:15 -0400
Date: Wed, 29 Apr 2009 13:08:35 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-29-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-29-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: remove unused function argument in intel_pmu_get_status()
Message-ID: <tip-19d84dab55a383d75c885b5c1a618f5ead96f2f6@git.kernel.org>
Git-Commit-ID: 19d84dab55a383d75c885b5c1a618f5ead96f2f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:08:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19d84dab55a383d75c885b5c1a618f5ead96f2f6
Gitweb:     http://git.kernel.org/tip/19d84dab55a383d75c885b5c1a618f5ead96f2f6
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:14 +0200

perf_counter, x86: remove unused function argument in intel_pmu_get_status()

The mask argument is unused and thus can be removed.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-29-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
