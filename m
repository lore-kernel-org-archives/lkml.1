Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbXGZMIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbXGZMIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXGZMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:08:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbXGZMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:08:17 -0400
Date: Thu, 26 Jul 2007 14:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] scheduler updates
Message-ID: <20070726120810.GA30565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

there's 8 commits in this tree - only one modifies scheduling behavior 
(and even that one only slightly so): a fix for a (minor) 
SMP-fairness-balancing problem.

There is one update/fix to the (upstream still unused) cpu_clock() API. 
[ which API will replace all the current (and buggy) in-tree uses of 
  sched_clock(). ]

There are also two small facilities added: preempt-notifiers (which is 
disabled and not selectable by the user and hence a NOP) needed by 
future KVM and other virtualization work and they'd like to see this 
offered by the upstream kernel. There's also the new 
above_background_load() inline function (unused at the moment). The 
presence of these two facilities causes no change at all to the kernel 
image:

    text    data     bss     dec     hex filename
 5573413  679332 3842048 10094793         9a08c9 vmlinux.before
 5573413  679332 3842048 10094793         9a08c9 vmlinux.after

so i thought this would be fine for a post-rc1 merge too.

There's also two small cleanup patches, a documentation update, and a 
debugging enhancement/helper: i've merged Nick's long-pending 
sysctl-domain-tree debug patch that has been in -mm for 3 years 
meanwhile. (It depends on CONFIG_SCHED_DEBUG and has no effect on 
scheduling by default even if enabled.)

passes allyesconfig, allnoconfig and distro build, boots and works fine 
on 32-bit and 64-bit x86 as well. (and is expected to work fine on every 
architecture)

	Ingo

-------------------->
Avi Kivity (1):
      sched: arch preempt notifier mechanism

Con Kolivas (1):
      sched: add above_background_load() function

Ingo Molnar (2):
      sched: increase SCHED_LOAD_SCALE_FUZZ
      sched: make cpu_clock() not use the rq clock

Joachim Deguara (1):
      sched: update Documentation/sched-stats.txt

Josh Triplett (1):
      sched: mark sysrq_sched_debug_show() static

Nick Piggin (1):
      sched: debug feature - make the sched-domains tree runtime-tweakable

Satoru Takeuchi (1):
      sched: remove unused rq->load_balance_class

 Documentation/sched-stats.txt |  195 ++++++++++++++++++++--------------------
 include/linux/preempt.h       |   44 +++++++++
 include/linux/sched.h         |   23 ++++
 kernel/Kconfig.preempt        |    3 
 kernel/sched.c                |  204 ++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_debug.c          |    2 
 6 files changed, 365 insertions(+), 106 deletions(-)
