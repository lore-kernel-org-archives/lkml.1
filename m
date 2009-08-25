Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZHYJr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZHYJr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZHYJr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:47:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57520 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZHYJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:47:27 -0400
Date: Tue, 25 Aug 2009 15:17:29 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v1 PATCH 0/7] CFS Hard limits - v1
Message-ID: <20090825094729.GP3663@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

RFC on Hard limits feature for CFS group scheduler was posted earlier at
http://lkml.org/lkml/2009/6/4/24. This is the next RFC post with patches.

During the previous post, the need for hard limits feature was acknowledged.
Also it was mentioned that guarantees would also be desirable. This post
just addresses the limits part and there is no intention to address the
guarantees problem with this patchset.

This patchset has seen some very light testing and I believe that there will
be bugs in it. However if you feel brave enough, this patchset could be tried
on 2.6.31-rc7!

Features TODO
-------------
- Runtime borrowing isn't implemented yet, plan to add it in subsequent posts.
- Bandwidth inheritence support (long term, not under consideration currently)
- This implementation doesn't work for user group scheduler. Since user group
  scheduler will eventually go away, I don't plan to work on this.

Implementation TODO
-------------------
- This patchset has seen very minimal testing. I need to test this under
  more test scenarios.
- I have been testing this on a 8 CPU box. Need to see how this behaves
  on a bigger box.
- Need to run performance tests and regression tests for benchmarks on bigger
  machines.
- It is possible to share some of the bandwidth handling code with RT, but
  the intention of this post is to show the changes associated with hard limits.
  Hence the sharing/cleanup will be done down the line when this patchset
  itself becomes more accepatable.
- When a dequeued entity is enqueued back, I don't change its vruntime. The
  entity might get undue advantage due to its old (lower) vruntime. Need to
  address this.

This set has the following patches:

1/7 sched: Rename sched_rt_period_mask() and use it in CFS also
2/7 sched: Maintain aggregated tasks count in cfs_rq at each hierarchy level
3/7 sched: Bandwidth initialization for fair task groups
4/7 sched: Enforce hard limits by throttling
5/7 sched: Unthrottle the throttled tasks
6/7 sched: Add throttle time statistics to /proc/sched_debug
7/7 sched: Hard limits documentation

 Documentation/scheduler/sched-cfs-hard-limits.txt   |   52 +++
 include/linux/sched.h                               |    7 
 init/Kconfig                                        |   13 
 kernel/sched.c                                      |  346 +++++++++++++++++++-
 kernel/sched_debug.c                                |   21 +
 kernel/sched_fair.c                                 |  268 +++++++++++++++
 kernel/sched_rt.c                                   |   19 -
 7 files changed, 703 insertions(+), 23 deletions(-)

Regards,
Bharata.
