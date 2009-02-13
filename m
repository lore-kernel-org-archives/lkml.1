Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbZBMTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbZBMTuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZBMTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:49:59 -0500
Received: from lutt.itea.ntnu.no ([129.241.18.234]:50370 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZBMTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:49:58 -0500
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 14:49:58 EST
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterez@infradead.org>,
       Henrik Austad <henrik@austad.us>
Subject: [PATCH] idle_at_tick is only used when CONFIG_SMP is set
Date: Fri, 13 Feb 2009 20:35:45 +0100
Message-Id: <1234553745-21640-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_at_tick in struct rq is only used in SMP settings
and it does not make sense to have this in the rq in an UP setup.

Signed-off-by: Henrik Austad <henrik@austad.us>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8ee437a..a8a4abc 100644
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
1.6.1

