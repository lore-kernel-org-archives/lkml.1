Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865Ab0A2Jbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0A2Jbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817Ab0A2Jbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:31:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:57594 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab0A2Jbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:31:37 -0500
Date: Fri, 29 Jan 2010 09:30:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100127221122.261477183@chello.nl>
References: <20100127221122.261477183@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Remove spurious counter reset from x86_pmu_enable()
Message-ID: <tip-18c01f8abff51e4910cc5ffb4b710e8c6eea60c9@git.kernel.org>
Git-Commit-ID: 18c01f8abff51e4910cc5ffb4b710e8c6eea60c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:30:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18c01f8abff51e4910cc5ffb4b710e8c6eea60c9
Gitweb:     http://git.kernel.org/tip/18c01f8abff51e4910cc5ffb4b710e8c6eea60c9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 Jan 2010 23:07:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:49 +0100

perf_events, x86: Remove spurious counter reset from x86_pmu_enable()

At enable time the counter might still have a ->idx pointing to
a previously occupied location that might now be taken by
another event. Resetting the counter at that location with data
from this event will destroy the other counter's count.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100127221122.261477183@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3fac0bf..518eb3e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1762,9 +1762,6 @@ static int x86_pmu_enable(struct perf_event *event)
 	cpuc->n_events = n;
 	cpuc->n_added  = n - n0;
 
-	if (hwc->idx != -1)
-		x86_perf_event_set_period(event, hwc, hwc->idx);
-
 	return 0;
 }
 
