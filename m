Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYFJPvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYFJPvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYFJPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:51:26 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:42156 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753745AbYFJPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:51:25 -0400
Date: Tue, 10 Jun 2008 21:20:55 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Question about task_struct::state
Message-ID: <20080610155055.GC4345@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Oleg,

sched.h has a comment in task_struct

        volatile long state;    /* -1 unrunnable, 0 runnable, >0 stopped */

After some searching, I've not been able to figure out how state can
become -1 (or unrunnable). Can you let me know how that happens?

If it cannot reach that state, then maybe this patch is needed.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2008-06-10 21:13:02.000000000 +0530
+++ linux-2.6/include/linux/sched.h	2008-06-10 21:14:44.000000000 +0530
@@ -1024,7 +1024,7 @@ struct sched_rt_entity {
 };
 
 struct task_struct {
-	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
+	volatile long state;	/* 0 runnable, >0 stopped */
 	void *stack;
 	atomic_t usage;
 	unsigned int flags;	/* per process flags, defined below */

-- 
regards,
Dhaval
