Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYLPHsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYLPHsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYLPHrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:47:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:46933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYLPHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:47:52 -0500
Message-Id: <20081216074636.090411199@chello.nl>
References: <20081216074529.570706654@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 16 Dec 2008 08:45:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] sched: optimize update_curr()
Content-Disposition: inline; filename=sched-opt-update_curr_fair.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip the hard work when there is none.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_fair.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -492,6 +492,8 @@ static void update_curr(struct cfs_rq *c
 	 * overflow on 32 bits):
 	 */
 	delta_exec = (unsigned long)(now - curr->exec_start);
+	if (!delta_exec)
+		return;
 
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;

-- 

