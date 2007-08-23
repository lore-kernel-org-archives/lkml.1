Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbXHWQIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbXHWQIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764252AbXHWQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:08:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764109AbXHWQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:08:14 -0400
Date: Thu, 23 Aug 2007 18:07:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070823160759.GA2728@elte.hu>
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

It includes six fixes: an s390 task-accounting fix from Christian 
Borntraeger, sysctl directory permission fixes from Eric W. Biederman, 
an SMT/MC balancing fix from Suresh Siddha (we under-balanced) and 
another fix from Suresh for debugging tweak side-effect. Plus there's a 
sched_clock() quality fix for CPUs that stop the TSC in idle (acked by 
Len Brown) and a reniced-tasks fixlet.

the SMT/MC blancing fix has the highest risk - but since it causes 
slightly more balancing (instead of less balancing, which is the more 
risky action) it should be pretty safe. Key workloads still seem fine. 
Tested on 32-bit and 64-bit x86 and it has passed 200+ make randconfig 
build tests.

	Ingo

---------------->
Christian Borntraeger (1):
      sched: accounting regression since rc1

Eric W. Biederman (1):
      sched: fix sysctl directory permissions

Ingo Molnar (2):
      sched: sched_clock_idle_[sleep|wakeup]_event()
      sched: tweak the sched_runtime_limit tunable

Suresh Siddha (2):
      sched: fix broken SMT/MC optimizations
      sched: skip updating rq's next_balance under null SD

 arch/i386/kernel/tsc.c        |    1 
 drivers/acpi/processor_idle.c |   32 +++++++++++++++----
 fs/proc/array.c               |   44 +++++++++++++++++----------
 include/linux/sched.h         |    5 +--
 kernel/sched.c                |   68 +++++++++++++++++++++++++++++++-----------
 kernel/sched_debug.c          |    3 +
 6 files changed, 110 insertions(+), 43 deletions(-)
