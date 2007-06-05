Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXFEVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXFEVvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXFEVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:50:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54677 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933640AbXFEVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:50:53 -0400
Date: Tue, 5 Jun 2007 23:50:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/sched{,_fair}.c: make code static
Message-ID: <20070605215056.GJ5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: Please don't #include C files in sched.c

 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc3-mm1/kernel/sched_fair.c.old	2007-06-05 22:18:18.000000000 +0200
+++ linux-2.6.22-rc3-mm1/kernel/sched_fair.c	2007-06-05 22:29:00.000000000 +0200
@@ -134,7 +134,7 @@
 	return curr->load_weight * (s64)(granularity / NICE_0_LOAD);
 }
 
-unsigned long get_rq_load(struct rq *rq)
+static unsigned long get_rq_load(struct rq *rq)
 {
 	unsigned long load = rq->cpu_load[CPU_LOAD_IDX_MAX-1] + 1;
 
@@ -384,7 +384,7 @@
 	p->exec_start = 0;
 }
 
-long div64_s(s64 divident, unsigned long divisor)
+static long div64_s(s64 divident, unsigned long divisor)
 {
 	u64 tmp;
 
--- linux-2.6.22-rc3-mm1/kernel/sched.c.old	2007-06-05 22:29:19.000000000 +0200
+++ linux-2.6.22-rc3-mm1/kernel/sched.c	2007-06-05 22:29:38.000000000 +0200
@@ -564,7 +564,7 @@
  * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
  * it's +10% CPU usage.
  */
-const int prio_to_weight[40] = {
+static const int prio_to_weight[40] = {
 /* -20 */ 88818, 71054, 56843, 45475, 36380, 29104, 23283, 18626, 14901, 11921,
 /* -10 */  9537,  7629,  6103,  4883,  3906,  3125,  2500,  2000,  1600,  1280,
 /*   0 */  NICE_0_LOAD /* 1024 */,

