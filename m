Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbYHZRho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbYHZRho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYHZRhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:37:13 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:54141
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756971AbYHZRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:37:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 0/6] Series short description
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Tue, 26 Aug 2008 13:34:44 -0400
Message-ID: <20080826173131.16413.17862.stgit@dev.haskins.net>
In-Reply-To: <20080825200852.23217.13842.stgit@dev.haskins.net>
References: <20080825200852.23217.13842.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following repositories

     git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git tip/sched/devel/rtbalance 

     ftp://ftp.novell.com/dev/ghaskins/tip-rt-fixes.tar.bz2

apply to tip/sched/devel to pick up fixes for the RT scheduler. 

[
	Changelog:
	
	v2: 
	    *) predicated newidle and double_lock changes on
	       CONFIG_PREEMPT to address a concern by Nick Piggin

	    *) fixed a build issue when DEBUG_PI_LIST is defined 

	v1:
	    *) initial release
]

These patches were developed in the interest of shorting latencies in
PREEMPT_RT, but they apply to the mainline scheduler as well, so I am
offering them here first.

This has been tested under both 26.3-rt3 and tip/sched/devel on x86_64 for
both CONFIG_SMP and !CONFIG_SMP.

Comments/bug-fixes welcome!

Regards,
-Greg


---

Gregory Haskins (6):
      sched: create "pushable_tasks" list to limit pushing to one attempt
      plist: fix PLIST_NODE_INIT to work with debug enabled
      sched: add sched_class->needs_post_schedule() member
      sched: make double-lock-balance fair
      sched: pull only one task during NEWIDLE balancing to limit critical section
      sched: only try to push a task on wakeup if it is migratable


 include/linux/init_task.h |    1 
 include/linux/plist.h     |    9 ++-
 include/linux/sched.h     |    2 +
 kernel/sched.c            |   84 ++++++++++++++++++++++++---
 kernel/sched_rt.c         |  139 ++++++++++++++++++++++++++++++++++++++-------
 5 files changed, 202 insertions(+), 33 deletions(-)


