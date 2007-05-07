Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXEGQef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXEGQef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXEGQed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:34:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49202 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXEGQec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:34:32 -0400
Date: Mon, 7 May 2007 18:33:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: [patch] CFS scheduler, -v10
Message-ID: <20070507163342.GA3502@elte.hu>
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


i'm pleased to announce release -v10 of the CFS scheduler patchset.
(The main goal of CFS is to implement "desktop scheduling" with as
 high quality as technically possible.)

The CFS patch against v2.6.21.1 (or against v2.6.20.10) can be 
downloaded from the usual place:
 
    http://people.redhat.com/mingo/cfs-scheduler/

-v10 got a bit bigger than usual. One reason for that is that i couldnt 
resist the fine enhancements contributed by Peter Williams and Mike 
Galbraith. Peter fixed and improved nice level support and SMP 
load-balancing, while Mike applied his "no compromises" interactivity 
tuning skills to CFS:

    6 files changed, 247 insertions(+), 110 deletions(-)

the main user-visible change should be that CFS's 3D gaming performance 
and 'smoothness' should be significantly improved in -v10. This was the 
main remaining regression reported for -v9 (and for CFS in general).

Changes since -v9:

 - complete and finetune the 'smooth load calculation' mechanism
   (Mike Galbraith)

 - generalize and fix up nice level support (Peter Williams)

 - fix RT-task load-balancing (Peter Williams)

 - added Con Kolivas to the credits section of sched.c, crediting him 
   for the "fair scheduler" idea that CFS is following too.

 - made the key calculation 292-years wraparound safe (based on feedback
   from Esben Nielsen and Linus Torvalds)

 - cycle-precise statistics for "top"'s per-task CPU usage fields.

 - tune down negative reniced task scheduling granularity (should fix 
   the choppyness reported by Al Boldi)

 - re-normalize nice levels close to upstream's values and implement a 
   gentle +10%/-10% "relative nice levels step" when going a nice level 
   up or down. (based on the report from Al Boldi and also based on 
   Peter Williams's feedback)

 - improve the /proc/sched_debug output some more

 - bugfix for fair-clock update

 - other minor fixes

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
