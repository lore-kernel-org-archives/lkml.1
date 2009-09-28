Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZI1Opw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZI1Opw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZI1Opw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:45:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46933 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZI1Opv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:45:51 -0400
Date: Mon, 28 Sep 2009 07:45:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] rcu: v2: more review feedback
Message-ID: <20090928144551.GA20704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090927064753.GA9394@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927064753.GA9394@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies the last of the review comments:

o	Whitespace fixes, updated comments, and code movement.

o	Improve an existing abstraction and introduce two additional
	abstractions for traversing the rcu_node tree.

Change since v1 (http://lkml.org/lkml/2009/9/27/17):

o	Update second patch's changelog

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


 b/include/linux/rcupdate.h |   14 +++++------
 b/kernel/rcutree.c         |   11 ++++-----
 b/kernel/rcutree.h         |   12 ++++++++++
 b/kernel/rcutree_plugin.h  |    5 ----
 kernel/rcutree.c           |   53 +++++++++++++++++++++++----------------------
 5 files changed, 52 insertions(+), 43 deletions(-)
