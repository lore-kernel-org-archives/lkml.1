Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXJXQ4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXJXQ4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763298AbXJXQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:39:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763295AbXJXQjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:39:35 -0400
Date: Wed, 24 Oct 2007 18:39:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler updates
Message-ID: <20071024163913.GA27422@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it includes 11 commits: 3 (low-key) fixlets, 6 low-impact cleanups, the 
marking of CONFIG_FAIR_GROUP_SCHED as !EXPERIMENTAL and a debug-printout 
improvement.

The "reduce balance-tasks overhead" commit is admittedly borderline for 
a post-rc1 pull because it is primarily a speedup and only secondarily a 
cleanup - but it's been in my queue for some time with no problems and a 
followup cleanup depended on it too so i included it.

build and boot tested on x86 32-bit and 64-bit.

	Ingo

------------------>
Adrian Bunk (1):
      sched: make cpu_shares_{show,store}() static

Ingo Molnar (3):
      sched: fix fastcall mismatch in completion APIs
      sched: clean up sched_domain_debug()
      sched: mark CONFIG_FAIR_GROUP_SCHED as !EXPERIMENTAL

Joe Perches (1):
      sched: constify sched.h

Mel Gorman (1):
      sched: document profile=sleep requiring CONFIG_SCHEDSTATS

Milton Miller (1):
      sched: fix sched_domain sysctl registration again

Paul Menage (1):
      sched: clean up some control group code

Peter Williams (2):
      sched: reduce balance-tasks overhead
      sched: isolate SMP balancing code a bit more

Satyam Sharma (1):
      sched: use show_regs() to improve __schedule_bug() output

 Documentation/kernel-parameters.txt |    3 
 include/linux/completion.h          |   18 -
 include/linux/sched.h               |   37 ++--
 init/Kconfig                        |    1 
 kernel/profile.c                    |    5 
 kernel/sched.c                      |  330 +++++++++++++++++++-----------------
 kernel/sched_fair.c                 |   48 ++++-
 kernel/sched_idletask.c             |   18 +
 kernel/sched_rt.c                   |   32 ++-
 kernel/user.c                       |    5 
 10 files changed, 292 insertions(+), 205 deletions(-)
