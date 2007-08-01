Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXHAQ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXHAQ3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXHAQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:28:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbXHAQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:28:56 -0400
Date: Wed, 1 Aug 2007 09:27:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <p73ps27npu0.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu>
 <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu>
 <p73ps27npu0.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2007, Andi Kleen wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > thanks. Just to make sure, while you said that your TSC was off on that 
> > laptop, the bootup log of yours suggests a working TSC:
> > 
> >   Time: tsc clocksource has been installed.
> 
> Standard kernels often disable the TSC later after running a bit 
> with it (e.g. on any cpufreq change without p state invariant TSC) 

I assume that what Roman hit was that he had explicitly disabled the TSC 
because of TSC instability with the "notsc" kernel command line. Which 
disabled is *entirely*.

That *used* to be the right thing to do, since the gettimeofday() logic 
originally didn't know about TSC instability, and it just resulted in 
somewhat flaky timekeeping.

These days, of course, we should notice it on our own, and just switch 
away from the TSC as a reliable clock-source, but still allow it to be 
used for the cases where absolute accuracy is not a big issue.

So I suspect that Roman - by virtue of being an old-timer - ends up having 
a workaround for an old problem that isn't needed, and that in turn ends 
up meaning that his scheduler clock also ends up using the really not very 
good timer tick..

			Linus
