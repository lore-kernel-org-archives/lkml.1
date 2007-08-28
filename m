Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXH1FGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXH1FGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXH1FGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:06:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbXH1FGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:06:03 -0400
Date: Mon, 27 Aug 2007 22:05:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <200708280737.53439.a1426z@gawab.com>
Message-ID: <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com>
 <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Aug 2007, Al Boldi wrote:
> 
> No need for framebuffer.  All you need is X using the X.org vesa-driver.  
> Then start gears like this:
> 
>   # gears & gears & gears &
> 
> Then lay them out side by side to see the periodic stallings for ~10sec.

I don't think this is a good test.

Why?

If you're not using direct rendering, what you have is the X server doing 
all the rendering, which in turn means that what you are testing is quite 
possibly not so much about the *kernel* scheduling, but about *X-server* 
scheduling!

I'm sure the kernel scheduler has an impact, but what's more likely to be 
going on is that you're seeing effects that are indirect, and not 
necessarily at all even "good".

For example, if the X server is the scheduling point, it's entirely 
possible that it ends up showing effects that are more due to the queueing 
of the X command stream than due to the scheduler - and that those 
stalls are simply due to *that*.

One thing to try is to run the X connection in synchronous mode, which 
minimizes queueing issues. I don't know if gears has a flag to turn on 
synchronous X messaging, though. Many X programs take the "[+-]sync" flag 
to turn on synchronous mode, iirc.

		Linus
