Return-Path: <linux-kernel-owner+w=401wt.eu-S1763613AbXLNKcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763613AbXLNKcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXLNKcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:32:43 -0500
Received: from [222.73.24.84] ([222.73.24.84]:55990 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXLNKcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:32:42 -0500
Message-ID: <47625B94.50105@cn.fujitsu.com>
Date: Fri, 14 Dec 2007 18:31:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] time: add an offline-cpu check in add_timer_on()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
   I think we need a check in the function add_timer_on() to avoid adding a
timer into the timer list of an offline cpu.

This patch fixes this problem in add_timer_on().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
  kernel/timer.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..6189561 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -451,6 +451,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
  	timer_stats_timer_set_start_info(timer);
  	BUG_ON(timer_pending(timer) || !timer->function);
  	spin_lock_irqsave(&base->lock, flags);
+	BUG_ON(cpu_is_offline(cpu));
  	timer_set_base(timer, base);
  	internal_add_timer(base, timer);
  	spin_unlock_irqrestore(&base->lock, flags);
-- 
1.5.3.7


