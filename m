Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0CDBuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:50:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46966 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0CDBuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:50:04 -0500
Date: Wed, 3 Mar 2010 17:50:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: fix !PREEMPT, __mpol_dup(), and
	ftrace_perf_buf_prepare() RCU lockdep splats
Message-ID: <20100304015001.GA32190@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch fixes three RCU lockdep issues:

1.	Makes rcu_read_lock_sched_held() correctly handle !PREEMPT
	kernels.

2.	Suppresses __mpol_dup() false positive.

3.	Converts a pair of rcu_dereference() calls in
	ftrace_perf_buf_prepare() to rcu_dereference_sched().

There are probably more where these came from.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcupdate.h           |   15 ++++++++++++++-
 include/trace/ftrace.h             |    4 ++--
 kernel/trace/trace_event_profile.c |    5 ++---
 mm/mempolicy.c                     |    3 ++-
 4 files changed, 20 insertions(+), 7 deletions(-)
