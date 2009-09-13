Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZIMQOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZIMQOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZIMQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:14:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37470 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZIMQOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:14:40 -0400
Date: Sun, 13 Sep 2009 09:14:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: [PATCH tip/core/rcu 0/4] Review comments, cleanups, and
	preemptable synchronize_rcu() fixes
Message-ID: <20090913161438.GA32550@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides updates to TREE_PREEMPT_RCU as follows:

1.	Update the TREE_PREEMPT_RCU description to note that it is
	suitable for small machines.

2.	Add some WARN_ON_ONCE() calls to check for (incorrect)
	concurrent grace-period initialization.

3.	Simplify quiescent-state detection (which also speeds up
	TREE_PREEMPT_RCU grace periods slightly).

4.	Fix a thinko in TREE_PREEMPT_RCU's synchronize_rcu() that
	could result in premature grace periods.
