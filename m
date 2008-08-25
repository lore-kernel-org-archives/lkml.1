Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYHYURr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYHYURr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYHYURh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:17:37 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36214
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750750AbYHYURg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:17:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/5] sched: misc rt fixes for tip/sched/devel
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Mon, 25 Aug 2008 16:15:18 -0400
Message-ID: <20080825200852.23217.13842.stgit@dev.haskins.net>
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

apply to tip/sched/devel to pick up the following fixes for the RT
scheduler. 

---

Gregory Haskins (5):
      sched: create "pushable_tasks" list to limit pushing to one attempt
      sched: add sched_class->needs_post_schedule() member
      sched: make double-lock-balance fair
      sched: pull only one task during NEWIDLE balancing to limit critical section
      sched: only try to push a task on wakeup if it is migratable


 include/linux/init_task.h |    1 
 include/linux/sched.h     |    2 +
 kernel/sched.c            |   37 +++++++-----
 kernel/sched_rt.c         |  139 ++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 143 insertions(+), 36 deletions(-)

-- 

These patches were developed in the interest of shorting latencies in
PREEMPT_RT, but they apply to the mainline scheduler as well, so I am
offering them here first.

This has been tested under both 26.3-rt3 and tip/sched/devel on x86_64 for
both CONFIG_SMP and !CONFIG_SMP.

Comments/bug-fixes welcome!

Regards,
-Greg
