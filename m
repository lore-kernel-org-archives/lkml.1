Return-Path: <linux-kernel-owner+w=401wt.eu-S1423668AbXEAVXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423668AbXEAVXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423661AbXEAVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:23:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423668AbXEAVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:23:04 -0400
Date: Tue, 1 May 2007 23:22:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>, Balbir Singh <balbir@in.ibm.com>
Subject: [patch] CFS scheduler, -v8
Message-ID: <20070501212223.GA29867@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v8 of the CFS scheduler patchset. (The 
main goal of CFS is to implement "desktop scheduling" with as high 
quality as technically possible.)

The CFS patch against v2.6.21.1 (or against v2.6.20.10) can be 
downloaded from the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

-v7 resolved a couple of important regresisons while not introducing new 
regressions, so i felt it was time to step forward: -v8 tries to address 
one of the last (known) frontiers: 3D/OpenGL games^H^H^H applications 
'smoothness'.

To achieve more scheduling smoothness, -v8 introduces a new 'precise 
load calculation and smoothing' feature. (A variant of this was 
suggested by Peter Williams in earlier CFS discussions - thanks Peter!)

i was able to reuse the rq->cpu_load[] load average calculation from 
Peter Williams's smpnice code, and it's thus now utilized on UP too. As 
a nice side-effect of CFS using a smoothed load metric, apps should also 
start up faster under load. CFS now utilizes the full range of smpnice 
metrics.

No other fundamental portion of CFS was touched, so the rate of change 
is moderate:

   7 files changed, 140 insertions(+), 79 deletions(-)

Changes since -v7:

 - powerpc debug output and build warning fixes (Balbir Singh)

 - documentation fixes (Zach Carter)

 - interactivity: precise load calculation and load smoothing

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
