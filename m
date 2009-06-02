Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZFBURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZFBURa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZFBURE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:17:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:59489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZFBURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:01 -0400
Date: Tue, 2 Jun 2009 20:16:27 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Remove the last nmi/irq bits
Message-ID: <tip-8a016db386195b193e2a8aeddff9fe937dcb7a40@git.kernel.org>
Git-Commit-ID: 8a016db386195b193e2a8aeddff9fe937dcb7a40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:16:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a016db386195b193e2a8aeddff9fe937dcb7a40
Gitweb:     http://git.kernel.org/tip/8a016db386195b193e2a8aeddff9fe937dcb7a40
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 15:27:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:31 +0200

perf_counter: Remove the last nmi/irq bits

IRQ (non-NMI) sampling is not used anymore - remove the last few bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    6 ------
 include/linux/perf_counter.h       |    4 +---
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index ec06aa5..9e144fb 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -284,12 +284,6 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (!hw_event->exclude_kernel)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	/*
-	 * Use NMI events all the time:
-	 */
-	hwc->nmi	= 1;
-	hw_event->nmi	= 1;
-
 	if (!hwc->sample_period)
 		hwc->sample_period = x86_pmu.max_period;
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 1fcd3cc..cef9931 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -140,7 +140,6 @@ struct perf_counter_hw_event {
 	__u64			read_format;
 
 	__u64			disabled       :  1, /* off by default        */
-				nmi	       :  1, /* NMI sampling          */
 				inherit	       :  1, /* children inherit it   */
 				pinned	       :  1, /* must always be on PMU */
 				exclusive      :  1, /* only group on PMU     */
@@ -153,7 +152,7 @@ struct perf_counter_hw_event {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 
-				__reserved_1   : 51;
+				__reserved_1   : 52;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -354,7 +353,6 @@ struct hw_perf_counter {
 			u64				config;
 			unsigned long			config_base;
 			unsigned long			counter_base;
-			int				nmi;
 			int				idx;
 		};
 		union { /* software */
