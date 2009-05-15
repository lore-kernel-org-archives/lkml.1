Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbZEOOps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbZEOOps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762440AbZEOOoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:44:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762589AbZEOOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:44:28 -0400
Date: Fri, 15 May 2009 14:43:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1242394667.6642.1887.camel@laptop>
References: <1242394667.6642.1887.camel@laptop>
Subject: [tip:perfcounters/core] perf_counter: frequency based adaptive irq_period, 32-bit fix
Message-ID: <tip-2e569d36729c8105ae066a9b105068305442cc77@git.kernel.org>
Git-Commit-ID: 2e569d36729c8105ae066a9b105068305442cc77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:43:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e569d36729c8105ae066a9b105068305442cc77
Gitweb:     http://git.kernel.org/tip/2e569d36729c8105ae066a9b105068305442cc77
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 May 2009 15:37:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 15:40:25 +0200

perf_counter: frequency based adaptive irq_period, 32-bit fix

fix:

  kernel/built-in.o: In function `perf_counter_alloc':
  perf_counter.c:(.text+0x7ddc7): undefined reference to `__udivdi3'

[ Impact: build fix on 32-bit systems ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1242394667.6642.1887.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0ad1db4..728a595 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2942,7 +2942,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 
 	hwc = &counter->hw;
 	if (hw_event->freq && hw_event->irq_freq)
-		hwc->irq_period = TICK_NSEC / hw_event->irq_freq;
+		hwc->irq_period = div64_u64(TICK_NSEC, hw_event->irq_freq);
 	else
 		hwc->irq_period = hw_event->irq_period;
 
