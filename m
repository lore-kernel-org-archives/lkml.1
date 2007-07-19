Return-Path: <linux-kernel-owner+w=401wt.eu-S940175AbXGSQvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940175AbXGSQvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938443AbXGSQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:50:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938157AbXGSQux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:50:53 -0400
Date: Thu, 19 Jul 2007 18:50:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] scheduler updates
Message-ID: <20070719165046.GA16539@elte.hu>
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

4 small changes only. It includes an cleanup: Ralf Baechle noticed that 
sched_cacheflush() is now unused, a new kernel-internal API for future 
use (cpu_clock(cpu)), and two SMP balancer fixes from Suresh Siddha. The 
balancer fixes are the only functional bits. Tested on x86-32bit and 
x86-64bit, build-tested on allyesconfig and allnoconfig. I re-checked a 
few SMP balancing scenarios due to the balancer fixes and kept those 
changes in my tree for a few days, and they are working fine here.

Thanks,

	Ingo

--------------->
Ingo Molnar (1):
      sched: implement cpu_clock(cpu) high-speed time source

Ralf Baechle (1):
      sched: sched_cacheflush is now unused

Suresh Siddha (2):
      sched: fix newly idle load balance in case of SMT
      sched: fix the all pinned logic in load_balance_newidle()

 arch/ia64/kernel/setup.c     |    9 ---------
 include/asm-alpha/system.h   |   10 ----------
 include/asm-arm/system.h     |   10 ----------
 include/asm-arm26/system.h   |   10 ----------
 include/asm-i386/system.h    |    9 ---------
 include/asm-ia64/system.h    |    1 -
 include/asm-m32r/system.h    |   10 ----------
 include/asm-mips/system.h    |   10 ----------
 include/asm-parisc/system.h  |   11 -----------
 include/asm-powerpc/system.h |   10 ----------
 include/asm-ppc/system.h     |   10 ----------
 include/asm-s390/system.h    |   10 ----------
 include/asm-sh/system.h      |   10 ----------
 include/asm-sparc/system.h   |   10 ----------
 include/asm-sparc64/system.h |   10 ----------
 include/asm-x86_64/system.h  |    9 ---------
 include/linux/sched.h        |    7 +++++++
 kernel/sched.c               |   31 ++++++++++++++++++++++++++-----
 18 files changed, 33 insertions(+), 154 deletions(-)
