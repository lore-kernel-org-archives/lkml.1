Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXEYIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXEYIlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXEYIlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:41:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53490 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbXEYIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:41:13 -0400
Date: Fri, 25 May 2007 10:41:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525084109.GI8094@one.firstfloor.org>
References: <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525083430.GB27236@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:34:31AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > > Hmm indeed. I actually had it correct at some point (i remember 
> > > > fixing 64bit compile errors in sched-clock ;-). I guess the 
> > > > Makefile hunk accidentially dropped out during some later merging 
> > > > and this didn't get noticed due to the weak attribute.
> > > 
> > > well the tsc.h bit was needed too.
> > 
> > It's not in defconfig at least. I just tried it.
> 
> what do you mean? The tsc.h bit is needed because 

Means i readded the Makefile hunk and it compiled for me in 64bit without
changing anything else.

> arch/i386/kernel/sched-clock.c (now built on x86_64 too with the patch i 
> sent) uses the tsc_disable global flag which is non-existent on x86_64. 
> So my tsc.h change adds that global flag, always-defined to 0.

My version of sched_clock.c doesn't have any reference to tsc_disable.

-andi
