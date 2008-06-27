Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYF0MJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYF0MJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYF0L6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:32 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3174 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754495AbYF0L5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:53 -0400
Message-Id: <20080627115211.751732577@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 16/30] sched: fix sched_balance_self() smp group balancing
Content-Disposition: inline; filename=sched-fix-sched_balance_self.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finding the least idle cpu is more accurate when done with updated shares.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2171,6 +2171,9 @@ static int sched_balance_self(int cpu, i
 			sd = tmp;
 	}
 
+	if (sd)
+		update_shares(sd);
+
 	while (sd) {
 		cpumask_t span, tmpmask;
 		struct sched_group *group;

-- 

