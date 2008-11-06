Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbYKFRit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbYKFRit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYKFRil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:38:41 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53037 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKFRil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:38:41 -0500
Date: Thu, 6 Nov 2008 23:00:34 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Inline double_unlock_balance()
Message-ID: <20081106173034.GA4341@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200811051857.14944.sripathik@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811051857.14944.sripathik@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs this to fix a warning as well


sched: fix double_unlock_balance compile warning

kernel/sched_rt.c:913: warning: ‘double_unlock_balance’ declared inline after being called
kernel/sched_rt.c:913: warning: previous declaration of ‘double_unlock_balance’ was here

Correct the declaration.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 kernel/sched_rt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c	2008-11-06 22:52:23.000000000 +0530
+++ linux-2.6-tip/kernel/sched_rt.c	2008-11-06 22:57:39.000000000 +0530
@@ -910,7 +910,8 @@ static void put_prev_task_rt(struct rq *
 #define RT_MAX_TRIES 3
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
-static void double_unlock_balance(struct rq *this_rq, struct rq *busiest);
+static inline void double_unlock_balance(struct rq *this_rq,
+						struct rq *busiest);
 
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
-- 
regards,
Dhaval
