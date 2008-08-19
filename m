Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbYHSKqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbYHSKqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYHSKo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYHSKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:28 -0400
Message-Id: <20080819103844.065473084@chello.nl>
References: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] sched: rt-bandwidth for user grouping interface
Content-Disposition: inline; filename=sched-rt-bw-user-print.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rt_runtime is a signed value

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -169,7 +169,7 @@ static ssize_t cpu_rt_runtime_show(struc
 {
 	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
 
-	return sprintf(buf, "%lu\n", sched_group_rt_runtime(up->tg));
+	return sprintf(buf, "%ld\n", sched_group_rt_runtime(up->tg));
 }
 
 static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
@@ -180,7 +180,7 @@ static ssize_t cpu_rt_runtime_store(stru
 	unsigned long rt_runtime;
 	int rc;
 
-	sscanf(buf, "%lu", &rt_runtime);
+	sscanf(buf, "%ld", &rt_runtime);
 
 	rc = sched_group_set_rt_runtime(up->tg, rt_runtime);
 

-- 

