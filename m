Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852Ab0A2Jbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0A2Jbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807Ab0A2JaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:30:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:57492 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0A2JaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:30:00 -0500
Date: Fri, 29 Jan 2010 09:29:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Optimize x86_pmu_disable()
Message-ID: <tip-6c9687abeb24d5b7aae7db5be070c2139ad29e29@git.kernel.org>
Git-Commit-ID: 6c9687abeb24d5b7aae7db5be070c2139ad29e29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:29:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c9687abeb24d5b7aae7db5be070c2139ad29e29
Gitweb:     http://git.kernel.org/tip/6c9687abeb24d5b7aae7db5be070c2139ad29e29
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 Jan 2010 11:57:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:43 +0100

perf_event: x86: Optimize x86_pmu_disable()

x86_pmu_disable() removes the event from the cpuc->event_list[], however
since an event can only be on that list once, stop looking after we found
it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 33c889f..66de282 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1884,6 +1884,7 @@ static void x86_pmu_disable(struct perf_event *event)
 				cpuc->event_list[i-1] = cpuc->event_list[i];
 
 			--cpuc->n_events;
+			break;
 		}
 	}
 	perf_event_update_userpage(event);
