Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbZD2NOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbZD2NOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbZD2NJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:09:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397AbZD2NJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:09:03 -0400
Date: Wed, 29 Apr 2009 13:08:24 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: remove vendor check in fixed_mode_idx()
Message-ID: <tip-ef7b3e09ffdcd5200aea9523f6b56d331d1c4fc0@git.kernel.org>
Git-Commit-ID: ef7b3e09ffdcd5200aea9523f6b56d331d1c4fc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:08:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef7b3e09ffdcd5200aea9523f6b56d331d1c4fc0
Gitweb:     http://git.kernel.org/tip/ef7b3e09ffdcd5200aea9523f6b56d331d1c4fc0
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:14 +0200

perf_counter, x86: remove vendor check in fixed_mode_idx()

The function fixed_mode_idx() is used generically. Now it checks the
num_counters_fixed value instead of the vendor to decide if fixed
counters are present.

[ Impact: generalize code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-28-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
