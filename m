Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0CATDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:03:34 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34414 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0CATDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:03:32 -0500
Date: Mon, 1 Mar 2010 11:03:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH RFC tip/core/rcu 0/2] rcu: make RCU lockdep handle early
	boot in organized manner
Message-ID: <20100301190329.GA26892@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch set makes RCU lockdep handle early boot in an organized
manner:

1.	Make rcu_read_lock_held(), rcu_read_lock_bh_held(),
	rcu_read_lock_sched_held(), and rcu_dereference_check()
	suppress complaints if !rcu_scheduler_active.  The rationale
	for this approach is that RCU grace periods are handled very
	differently during early boot, and rcu_scheduler_active marks
	the point that normal runtime RCU behavior starts.

2.	Remove the !rcu_scheduler_active check from calls to
	rcu_dereference_check(), because rcu_dereference_check() already
	does the check in question.

Testing in progress, but want to get these out for review.

							Thanx, Paul

------------------------------------------------------------------------

 cgroup.h   |    2 --
 rcupdate.h |   27 +++++++++++++++++----------
 2 files changed, 17 insertions(+), 12 deletions(-)
