Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXISVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXISVtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXISVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:49:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXISVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:49:37 -0400
Date: Wed, 19 Sep 2007 23:49:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919214926.GA15158@elte.hu>
References: <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu> <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org> <20070919195633.GA23595@elte.hu> <alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org> <20070919214105.GA12245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919214105.GA12245@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Peter, what do you think?
> 
> Linus, if this would be acceptable for .23 then i'll push it out into 
> sched.git together with another fix that Hiroshi Shimamoto just posted 
> to lkml.

it's getting late here so i've pushed the current version of those two 
patches out to:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

I'll redo this git tree if we want some other solution for yield. (but i 
think this is the safest approach for 2.6.23 - some apps will complain 
about too strong yield, some apps will complain about too weak yield. So 
by providing the two extremes we at least cover the practical range of 
behavior.)

there's nothing else pending for 2.6.23 otherwise at the moment, 
scheduler-wise.

	Ingo

------------------>
Hiroshi Shimamoto (1):
      sched: fix invalid sched_class use

Ingo Molnar (1):
      sched: add /proc/sys/kernel/sched_compat_yield

 include/linux/sched.h |    1 
 kernel/sched.c        |   10 ++++---
 kernel/sched_fair.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |    8 ++++++
 4 files changed, 72 insertions(+), 10 deletions(-)
