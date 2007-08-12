Return-Path: <linux-kernel-owner+w=401wt.eu-S935304AbXHLQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935304AbXHLQcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762634AbXHLQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:32:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761929AbXHLQcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:32:33 -0400
Date: Sun, 12 Aug 2007 18:32:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070812163225.GA11996@elte.hu>
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

three bugfixes:

- a nice fix from eagle-eye Oleg for a subtle typo in the balancing
  code, the effect of this bug was more agressive idle balancing. This
  bug was introduced by one of the original CFS commits.

- a round of global->static fixes from Adrian Bunk - this change,
  besides the cleanup effect, chops 100 bytes off sched.o.

- Peter Zijlstra noticed a sleeper-bonus bug. I kept this patch under
  observation and testing this past week and saw no ill effects so far. 
  It could fix two suspected regressions. (It could improve Kasper
  Sandberg's workload and it could improve the sleeper/runner
  problem/bug Roman Zippel was seeing.)

test-built and test-booted on x86-32 and x86-64, and did a dozen of 
randconfig builds for good measure (which uncovered two new build errors 
in latest -git).

Thanks,

	Ingo

--------------->
Adrian Bunk (1):
      sched: make global code static

Ingo Molnar (1):
      sched: fix sleeper bonus

Oleg Nesterov (1):
      sched: run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/

 include/linux/cpu.h |    2 --
 kernel/sched.c      |   48 ++++++++++++++++++++++++------------------------
 kernel/sched_fair.c |   12 ++++++------
 3 files changed, 30 insertions(+), 32 deletions(-)
