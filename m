Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbYLYIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbYLYIFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 03:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYLYIFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 03:05:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYLYIE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 03:04:59 -0500
Date: Thu, 25 Dec 2008 09:04:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v5
Message-ID: <20081225080422.GA9430@elte.hu>
References: <20081223124058.GA11525@elte.hu> <20081225162242.50E8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225162242.50E8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> Currently, -tip tree can't build on my ia64 box.
> because..
> 
> >  create mode 100644 Documentation/perf-counters.txt
> >  delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
> >  create mode 100644 arch/x86/include/asm/perf_counter.h
> >  create mode 100644 arch/x86/kernel/cpu/perf_counter.c
> >  rename arch/x86/kernel/{signal_32.c => signal.c} (74%)
> >  delete mode 100644 arch/x86/kernel/signal_64.c
> >  create mode 100644 include/linux/perf_counter.h
> >  create mode 100644 kernel/perf_counter.c
> 
> 
> Only x86 has <asm/perf_counter.h>.

thanks - the fix below resolves it, right?

	Ingo

>From 26c6f31fe04454177513b8b8539e8197ff897703 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 25 Dec 2008 09:02:11 +0100
Subject: [PATCH] perfcounters: include asm/perf_counter.h only if CONFIG_PERF_COUNTERS=y

Impact: build fix on ia64

KOSAKI Motohiro reported that -tip doesnt build on ia64 because
asm/perf_counter.h only exists on x86 for now. Fix it.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_counter.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index ec77d16..cc3a75a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -14,7 +14,10 @@
 #define _LINUX_PERF_COUNTER_H
 
 #include <asm/atomic.h>
-#include <asm/perf_counter.h>
+
+#ifdef CONFIG_PERF_COUNTERS
+# include <asm/perf_counter.h>
+#endif
 
 #include <linux/list.h>
 #include <linux/mutex.h>
