Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZKVQxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZKVQxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZKVQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:53:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47913 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbZKVQxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:53:13 -0500
Date: Sun, 22 Nov 2009 08:53:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: resend of grace-period stall and
	cleanup patches
Message-ID: <20091122165321.GA19922@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series is a resend of the three RCU patches that are candidates
for the upcoming 2.6.33 merge window, but that are not yet in -tip.
These are:

1.	A fix for a grace-period-stall bug that occurs on large
	machines.  This was partially fixed by commit 237c80c5,
	and this patch completes the fix using a much cleaner
	method.  237c80c5 would request another quiescent state
	for a CPU that just went offline and that might have already
	gone through a quiescent state for the current grace period.
	In contrast, this patch pushes the quiescent-state reporting
	up the rcu_node tree straightaway.

2.	A cleanup removing function wrapping that has been unnecessary
	since commit e74f4c45 caused CPUs going offline to give up
	their own callbacks.

3.	A cleanup that gets rid of a few annoying #ifdefs by moving
	the code from kernel/rcupdate.c and include/linux/rcupdate.h
	to include/linux/rcutiny.h, include/linux/rcutree.h, and
	kernel/rcutree.c.

							Thanx, Paul
