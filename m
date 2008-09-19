Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYISMRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYISMRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYISMRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:17:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYISMRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:17:04 -0400
Subject: [PATCH 2/2] hrtimer: Remove hrtimer_clock_base::reprogram()
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 13:13:48 +0100
Message-Id: <1221826428.20993.6.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_clock_base::reprogram() also appears to never
have been used, so remove it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 include/linux/hrtimer.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 1b079bd..68b0196 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -147,7 +147,6 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
- * @reprogram:		function to reprogram the timer event
  */
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
@@ -159,9 +158,6 @@ struct hrtimer_clock_base {
 	ktime_t			softirq_time;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t			offset;
-	int			(*reprogram)(struct hrtimer *t,
-					     struct hrtimer_clock_base *b,
-					     ktime_t n);
 #endif
 };
 
-- 
1.5.4.3

