Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZI0GtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZI0GtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 02:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZI0GtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 02:49:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41289 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZI0GtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 02:49:10 -0400
Date: Sat, 26 Sep 2009 23:47:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] rcu: more review feedback
Message-ID: <20090927064753.GA9394@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies the last of the review comments:

o	Whitespace fixes, updated comments, and code movement.

o	Improve an existing abstraction and introduce two additional
	abstractions for traversing the rcu_node tree.

Issues remaining:

o	I can force hangs given sufficient rcutorture testing in
	conjunction with random CPU-hotplug operations.  I am working
	on a simpler interface between RCU and CPU hotplug that I
	believe will clear this up.

o	TREE_PREEMPT_RCU currently uses the TREE_RCU variant of
	synchronize_rcu_expedited, which is wrong.  I am working on
	an expedited variant for TREE_PREEMPT_RCU, but will fall
	back on synchronize_rcu() for the short term if it gives me
	much trouble.

o	The IPI hyperactivity from call_rcu() noted by Nick Piggin.
	I believe I have identified a clean design for a fix for this.

o	Make RCU less dependent on IPIs for forcing grace periods
	(but this might be best deferred to 2.6.33).

o	RCU priority boosting (2.6.33!).

o	TINY_PREEMPT_RCU (2.6.33!).

o	Squeeze another 400 bytes or so out of TINY_RCU (2.6.33!).
