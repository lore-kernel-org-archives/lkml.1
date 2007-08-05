Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXHEFOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXHEFOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXHEFOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:14:00 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:58350 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXHEFN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:13:59 -0400
Subject: [BUG RT] WARNING: at kernel/sched.c:5071 2.6.23-rc1-rt7
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 01:13:36 -0400
Message-Id: <1186290816.636.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The below ifndef, shouldn't that be ifndef CONFIG_PREEMPT_SOFTIRQS ?
I hit that warning while I was running !PREEMPT_RT but with both hard
and softiqs as threads.


int __sched cond_resched_softirq(void)
{
#ifndef CONFIG_PREEMPT_RT
	WARN_ON_ONCE(!in_softirq());
#endif
	if (need_resched() && system_state == SYSTEM_RUNNING) {
		local_bh_enable();
		__cond_resched();
		local_bh_disable();
		return 1;
	}
	return 0;
}


-- Steve

P.S. I really found out that the system becomes VERY non-responsive when
you run with both hard and softirqs as threads, but with
PREEMPT_NONE ;-)



