Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbYBMP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbYBMP67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbYBMP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:58:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbYBMP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:58:43 -0500
Date: Wed, 13 Feb 2008 16:58:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler updates
Message-ID: <20080213155829.GB19523@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Find the shortlog and diffstat below.

The main body of this tree is about resolving interactions between the 
group scheduler and the new rt_ratio API. This restructuring also fixes 
an -rc1 bug where tasks would try to gain RT privileges that were in an 
UID group by default which had no RT runtime assigned to them - 
resulting in those tasks not running at all.

Furthermore, Peter found that the "ratio" API was a bit unfortunate 
choice (which causes some arbitrary granularity to be chosen) so it's 
microseconds based now. Also, RT group scheduling is now selectable in 
the .config (off by default). These all got a bit intrusive [and had a 
bug that took some time to find] so i kept testing it for a while so it 
missed -rc1.

It's good IMO and most of the code is default-disabled - but if this 
looks too complex our other option would be to disable the new RT bits 
in .25 and do it in .26.

	Ingo

------------------>
Peter Zijlstra (8):
      hrtimer: more hrtimer_init_sleeper() fallout.
      sched: fair-group: separate tg->shares from task_group_lock
      sched: fix incorrect irq lock usage in normalize_rt_tasks()
      sched: rt-group: deal with PI
      sched: rt-group: interface
      sched: rt-group: make rt groups scheduling configurable
      sched: rt-group: clean up the ifdeffery
      sched: rt-group: refure unrunnable tasks

 Documentation/sched-rt-group.txt |   59 +++++
 include/linux/cgroup_subsys.h    |    2 +-
 include/linux/sched.h            |   18 +-
 init/Kconfig                     |   23 ++-
 kernel/rtmutex.c                 |    5 +-
 kernel/sched.c                   |  494 +++++++++++++++++++++++++++----------
 kernel/sched_rt.c                |  102 +++++---
 kernel/sysctl.c                  |   32 ++--
 kernel/user.c                    |   50 ++++-
 9 files changed, 576 insertions(+), 209 deletions(-)
 create mode 100644 Documentation/sched-rt-group.txt

