Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXHDGvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXHDGvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 02:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXHDGuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 02:50:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbXHDGux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 02:50:53 -0400
Date: Sat, 4 Aug 2007 08:50:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070804065037.GA30816@elte.hu>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu> <20070803001447.GA14775@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803001447.GA14775@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Oh good. Thanks for getting to the bottom of it. We have normally 
> disliked too much runtime tunables in the scheduler, so I assume these 
> are mostly going away or under a CONFIG option for 2.6.23? Or...?

yeah, they are all already under CONFIG_SCHED_DEBUG. (it's just that the 
add-on optimization is not upstream yet - the tunings are still being 
tested) Btw., with SCHED_DEBUG we now also have your domain-tree sysctl 
patch upstream, which has been in -mm for a near eternity.

> What CPU did you get these numbers on? Do the indirect calls hurt much 
> on those without an indirect predictor? (I'll try running some tests).

it was on an older Athlon64 X2. I never saw indirect calls really 
hurting on modern x86 CPUs - dont both CPU makers optimize them pretty 
efficiently? (as long as the target function is always the same - which 
it is here.)

> I must say that I don't really like the indirect calls a great deal, 
> and they could be eliminated just with a couple of branches and direct 
> calls.

yeah - i'll try that too. We can make the indirect call the uncommon 
case and a NULL pointer be the common case, combined with a 'default', 
direct function call. But i doubt it makes a big (or even measurable) 
difference.

	Ingo
