Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXEYIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXEYIey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXEYIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:34:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbXEYIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:34:46 -0400
Date: Fri, 25 May 2007 10:34:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525083430.GB27236@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525082018.GF8094@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > > Hmm indeed. I actually had it correct at some point (i remember 
> > > fixing 64bit compile errors in sched-clock ;-). I guess the 
> > > Makefile hunk accidentially dropped out during some later merging 
> > > and this didn't get noticed due to the weak attribute.
> > 
> > well the tsc.h bit was needed too.
> 
> It's not in defconfig at least. I just tried it.

what do you mean? The tsc.h bit is needed because 
arch/i386/kernel/sched-clock.c (now built on x86_64 too with the patch i 
sent) uses the tsc_disable global flag which is non-existent on x86_64. 
So my tsc.h change adds that global flag, always-defined to 0.

	Ingo
