Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab0BZK0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:26:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:34412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab0BZK0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:26:18 -0500
Date: Fri, 26 Feb 2010 10:25:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Remove superflous MSR writes
Message-ID: <tip-6667661df4bc76083edf1e08831c20f64429709d@git.kernel.org>
Git-Commit-ID: 6667661df4bc76083edf1e08831c20f64429709d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:25:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6667661df4bc76083edf1e08831c20f64429709d
Gitweb:     http://git.kernel.org/tip/6667661df4bc76083edf1e08831c20f64429709d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Feb 2010 16:10:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 10:56:54 +0100

perf_events, x86: Remove superflous MSR writes

We re-program the event control register every time we reset the count,
this appears to be superflous, hence remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ad09656..dd09ccc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2009,9 +2009,6 @@ static int intel_pmu_save_and_restart(struct perf_event *event)
 	x86_perf_event_update(event, hwc, idx);
 	ret = x86_perf_event_set_period(event, hwc, idx);
 
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
-		intel_pmu_enable_event(hwc, idx);
-
 	return ret;
 }
 
