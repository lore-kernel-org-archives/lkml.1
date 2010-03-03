Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0CCPrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45487 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0CCPrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:13 -0500
Date: Wed, 3 Mar 2010 07:46:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/4] rcu: suppress RCU lockdep early-boot
	warnings and fixes
Message-ID: <20100303154638.GA8576@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series suppresses early-boot RCU-lockdep warnings and fixes
a couple of other RCU lockdep issues:

1.	Use a wrapper function to query lockdep about tasklist_lock
	instead of (re-)exporting tasklist_lock to modules.

2.	Suppress early-boot RCU-lockdep warnings.

3.	Revert an earlier lockdep-RCU patch that manually checked for
	early boot.

4.	Add a couple of variables to the lockdep_rcu_dereference()
	output.

Testing identified a couple of lockdep splats that I thought were due
to early boot issues, but which turned out to be not -quite- that early.
These will be dealt with by a pair of later patches.

							Thanx, Paul

 include/linux/cgroup.h   |    2 --
 include/linux/cred.h     |    2 +-
 include/linux/rcupdate.h |   35 ++++++++++++++++++++++++++---------
 include/linux/sched.h    |    4 ++++
 kernel/exit.c            |    2 +-
 kernel/fork.c            |    9 ++++++++-
 kernel/lockdep.c         |    2 +-
 kernel/pid.c             |    5 +++--
 lib/locking-selftest.c   |    6 +++++-
 9 files changed, 49 insertions(+), 18 deletions(-)
