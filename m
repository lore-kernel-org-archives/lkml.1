Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbZLQEwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbZLQEwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbZLQEwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:52:14 -0500
Received: from kroah.org ([198.145.64.141]:55236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761784AbZLQEDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.143280063@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [009/151] perf_event: Initialize data.period in perf_swevent_hrtimer()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit 59d069eb5ae9b033ed1c124c92e1532c4a958991 upstream.

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
LKML-Reference: <4B14E220.2050107@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3949,6 +3949,7 @@ static enum hrtimer_restart perf_swevent
 	event->pmu->read(event);
 
 	data.addr = 0;
+	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
 	 * In case we exclude kernel IPs or are somehow not in interrupt


