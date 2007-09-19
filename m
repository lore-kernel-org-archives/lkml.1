Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXISKya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXISKya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXISKyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:54:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXISKyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:54:02 -0400
Message-Id: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 0/6] using lockdep to validate rcu usage
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set uses lockdep to validate rcu usage.

It annotates rcu_read_{,un}lock{,_bh}() to catch imbalances. And further uses
that information to establish a proper context for rcu_dereference().

It also separates implicit from explicit preempt_disable() usage, in order to
separate rcu_dereference() from the locking model.

A kernel (2.6.23-rc4-mm1) with these patches boots but does have some funnies -
I suspect it calls printf from places it doesn't like.

The first patch should be safe to apply, the rest is RFC.

If people want to see the very noisy bootlog this generates:
  http://programming.kicks-ass.net/kernel-patches/lockdep_rcu/lockdep_rcu.log


