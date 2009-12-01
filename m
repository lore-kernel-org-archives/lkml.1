Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZLAJbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZLAJbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZLAJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:31:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbZLAJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:31:42 -0500
Message-ID: <4B14E220.2050107@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 17:30:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event: initialize data.period in perf_swevent_hrtimer()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code in perf_swevent_hrtimer(), data.period is not initialized,
The result is obvious wrong:

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
-- 
1.6.1.2


