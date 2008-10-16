Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYJPLvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYJPLvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbYJPLuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:50:54 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56141 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753906AbYJPLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:50:53 -0400
Date: Thu, 16 Oct 2008 17:20:45 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: [RFC PATCH 3/4] timers: identifying cpu-pinned hrtimer.
Message-ID: <20081016115045.GD7641@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch identifies the cpu-pinned hrtimer in kernel/sched.c


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.27/kernel/sched.c
===================================================================
--- linux-2.6.27.orig/kernel/sched.c
+++ linux-2.6.27/kernel/sched.c
@@ -1099,7 +1099,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	hrtimer_start_pinned(&rq->hrtick_timer, ns_to_ktime(delay),
+				HRTIMER_MODE_REL);
 }
 
 static void init_hrtick(void)
