Return-Path: <linux-kernel-owner+w=401wt.eu-S1161962AbXECOJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161962AbXECOJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161960AbXECOJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:09:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161962AbXECOJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:09:48 -0400
Date: Thu, 3 May 2007 16:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: [patch] CFS scheduler, -v9
Message-ID: <20070503140911.GA21916@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v9 of the CFS scheduler patchset. (The 
main goal of CFS is to implement "desktop scheduling" with as high 
quality as technically possible.)

The CFS patch against v2.6.21.1 (or against v2.6.20.10) can be 
downloaded from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

-v9 is a small fixes-only release:

    6 files changed, 34 insertions(+), 29 deletions(-)

it includes small fixlets, the most notable of which is the 64-bit SMP 
balancing fix from Balbir Singh. Things are clearly calming down and 
there's been no report of interactivity regression against -v8 so far, 
which is certainly promising. So please try to break -v9 :-)

Changes since -v8:

 - SMP balancing fix for powerpc/64-bit. (Balbir Singh)

 - build warning fix and microoptimization: sched_find_first_bit() only
   needs to cover 100 priority levels. (Mike Galbraith)

 - fix long initial delay in tasks reniced in a positive direction.
   (reported by Al Boldi)

 - fix missing syscall_table.S entry for sys_sched_yield_to.
   (noticed by Vegard Nossum)

 - small tweaks to the /proc/sched_debug output

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
