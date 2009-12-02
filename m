Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZLBUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZLBUJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZLBUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:09:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41388 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbZLBUJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:09:53 -0500
Date: Wed, 2 Dec 2009 12:09:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/4] rcu: preemptible expedited grace periods
	and cleanups
Message-ID: <20091202200955.GA12950@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes some cleanups, improved diagnostics, and an
implementation of expedited preemptible RCU grace periods that is
actually expedited:

1.	Rename the "quiet" functions.  The name rcu_quiet_cpu() was
	clear enough, but now that we have four flavors of quietness
	with more on the way, we need more meaningful names.

2.	Enable a fourth level of the rcu_node hierarchy.  No, we really
	don't need the ability to run on million-CPU SMP systems at the
	moment, but the additional level allows more vigorous
	stress-testing on 16-CPU systems.

3.	Add an implementation of synchronize_rcu_expedited() that
	actually expedites preemptible-RCU grace periods.

4.	Make RCU_CPU_STALL_DETECTOR be on by default.  If this works
	well, the #ifdefs will eventually be removed to reduce testing
	load.

This patchset is intended for 2.6.34, but has passed sufficient testing
that it could safely be included in 2.6.33, if desired.

 b/kernel/rcutorture.c     |   34 +++++--
 b/kernel/rcutree.c        |   66 ++++++++-------
 b/kernel/rcutree.h        |    3 
 b/kernel/rcutree_plugin.h |   13 +--
 b/kernel/rcutree_trace.c  |   11 +-
 b/lib/Kconfig.debug       |    3 
 kernel/rcutree.c          |   16 ++-
 kernel/rcutree.h          |   51 ++++++++++-
 kernel/rcutree_plugin.h   |  198 +++++++++++++++++++++++++++++++++++++++++++---
 9 files changed, 324 insertions(+), 71 deletions(-)
