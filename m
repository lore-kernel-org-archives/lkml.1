Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbZBMUPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbZBMUPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBMUPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:15:08 -0500
Received: from mail49.e.nsc.no ([193.213.115.49]:65263 "EHLO mail49.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZBMUPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:15:07 -0500
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 15:15:06 EST
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Henrik Austad <henrik@austad.us>
Subject: [PATCH] idle_at_tick is only used when CONFIG_SMP is set
Date: Fri, 13 Feb 2009 17:17:37 +0100
Message-Id: <1234541857-8274-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_at_tick in struct rq is only used in SMP settings
and it does not make sense to have this in the rq in an UP setup.

This will also increase packing of rq.

Signed-off-by: Henrik Austad <henrik@austad.us>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c1d0ed3..4404e47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -549,7 +549,6 @@ struct rq {
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
-	unsigned char idle_at_tick;
 #ifdef CONFIG_NO_HZ
 	unsigned long last_tick_seen;
 	unsigned char in_nohz_recently;
@@ -590,6 +589,7 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned char idle_at_tick;
 	/* For active balancing */
 	int active_balance;
 	int push_cpu;
-- 
1.6.1.rc2

