Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbXH1Ld2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbXH1Ld2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXH1LdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:33:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbXH1LdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:33:07 -0400
Date: Tue, 28 Aug 2007 13:32:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull request] scheduler updates
Message-ID: <20070828113259.GA7922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

no big changes - 5 small fixes and 1 small cleanup:

- the only bug with a human-noticeable effect is a bonus-limit oneliner
  bug found and fixed by Mike: Mike has done interactivity testing of
  -rc4 and found a relatively minor but noticeable Amarok
  song-switch-latency increase under high load. (This bug was a
  side-effect of the recent adaptive-latency patch - mea culpa.)

- there's a fix for a new_task_fair() bug found by Ting Yang: Ting has
  done a comprehensive review of the latest CFS code and found this
  problem which caused a random jitter of 1 jiffy of the key value for
  newly started up tasks. Saw no immediate effects from this fix (this
  amount of jitter is noise in most cases and the effect averages out
  over longer time), but it's worth having the fix in .23 nevertheless.

- then there's a converge-to-ideal-latency change that fixes a
  pre-existing property of CFS. This is not a bug per se but is still
  worth fixing for .23 - the before/after chew-max output in the
  changelog shows the clear benefits in consistency of scheduling.
  Affects the preemption slowpath only. Should be human-unnoticeable.
  [ We would not have this fix if it wasnt for the de-HZ-ification
    change of the tunables, so i'm glad we got rid of the HZ uglies in 
    one go - they just hid this real problem. ]

- Peter noticed a bug in the SCHED_FEAT_SKIP_INITIAL code - but this
  is off by default so it's a NOP on the default kernel.

- a small schedstat fix [NOP for defconfig]. This bug was there since
  the first CFS commit.

- a small task_new_fair() cleanup [NOP].

	Ingo

------------------>
Ingo Molnar (4):
      sched: make the scheduler converge to the ideal latency
      sched: fix wait_start_fair condition in update_stats_wait_end()
      sched: small schedstat fix
      sched: clean up task_new_fair()

Mike Galbraith (1):
      sched: fix sleeper bonus limit

Ting Yang (1):
      sched: call update_curr() in task_tick_fair()

 include/linux/sched.h |    1 +
 kernel/sched.c        |    1 +
 kernel/sched_fair.c   |   46 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 37 insertions(+), 11 deletions(-)

