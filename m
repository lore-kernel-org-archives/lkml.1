Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLAKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLAKWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZLAKWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:22:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:44909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZLAKWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:22:17 -0500
Date: Tue, 1 Dec 2009 10:21:37 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B14E220.2050107@cn.fujitsu.com>
References: <4B14E220.2050107@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Initialize data.period in perf_swevent_hrtimer()
Message-ID: <tip-59d069eb5ae9b033ed1c124c92e1532c4a958991@git.kernel.org>
Git-Commit-ID: 59d069eb5ae9b033ed1c124c92e1532c4a958991
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d069eb5ae9b033ed1c124c92e1532c4a958991
Gitweb:     http://git.kernel.org/tip/59d069eb5ae9b033ed1c124c92e1532c4a958991
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 17:30:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 11:19:07 +0100

perf_event: Initialize data.period in perf_swevent_hrtimer()

In current code in perf_swevent_hrtimer(), data.period is not
initialized, The result is obvious wrong:

 # ./perf record -f -e cpu-clock make
 # ./perf report
 # Samples: 1740
 #
 # Overhead   Command                                   ......
 # ........  ........  ..........................................
 #
   1025422183050275328.00%        sh  libc-2.9.90.so ...
   1025422183050275328.00%      perl  libperl.so     ...
   1025422168240043264.00%      perl  [kernel]       ...
   1025422030011210752.00%      perl  [kernel]       ...

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <4B14E220.2050107@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b9ca2d..040ee51 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4010,6 +4010,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	event->pmu->read(event);
 
 	data.addr = 0;
+	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
 	 * In case we exclude kernel IPs or are somehow not in interrupt
