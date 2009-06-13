Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbZFMOuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbZFMOuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZFMOtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:49:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:49023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758914AbZFMOtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:49:31 -0400
Date: Sat, 13 Jun 2009 14:48:57 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18995.20490.979429.244883@cargo.ozlabs.ibm.com>
References: <18995.20490.979429.244883@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Fix atomic_set vs. atomic64_t type mismatch
Message-ID: <tip-87847b8f26cc7176ec9b239898dc7ce47a94e1a6@git.kernel.org>
Git-Commit-ID: 87847b8f26cc7176ec9b239898dc7ce47a94e1a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:48:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87847b8f26cc7176ec9b239898dc7ce47a94e1a6
Gitweb:     http://git.kernel.org/tip/87847b8f26cc7176ec9b239898dc7ce47a94e1a6
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Sat, 13 Jun 2009 17:06:50 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 12:58:24 +0200

perf_counter: Fix atomic_set vs. atomic64_t type mismatch

Using atomic_set on an atomic64_t variable gives a compiler
warning on powerpc, and won't give the desired result at runtime.
This fixes an instance of this error in the perf_counter code.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18995.20490.979429.244883@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 29b685f..8d14a73 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1283,7 +1283,7 @@ static void perf_ctx_adjust_freq(struct perf_counter_context *ctx)
 		if (!interrupts) {
 			perf_disable();
 			counter->pmu->disable(counter);
-			atomic_set(&hwc->period_left, 0);
+			atomic64_set(&hwc->period_left, 0);
 			counter->pmu->enable(counter);
 			perf_enable();
 		}
