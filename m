Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbXH1FYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbXH1FYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbXH1FYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:24:32 -0400
Received: from [212.12.190.25] ([212.12.190.25]:32877 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750716AbXH1FYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:24:31 -0400
From: Al Boldi <a1426z@gawab.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CFS review
Date: Tue, 28 Aug 2007 08:23:53 +0300
User-Agent: KMail/1.5
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708280737.53439.a1426z@gawab.com> <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280823.53663.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 28 Aug 2007, Al Boldi wrote:
> > No need for framebuffer.  All you need is X using the X.org vesa-driver.
> > Then start gears like this:
> >
> >   # gears & gears & gears &
> >
> > Then lay them out side by side to see the periodic stallings for ~10sec.
>
> I don't think this is a good test.
>
> Why?
>
> If you're not using direct rendering, what you have is the X server doing
> all the rendering, which in turn means that what you are testing is quite
> possibly not so much about the *kernel* scheduling, but about *X-server*
> scheduling!
>
> I'm sure the kernel scheduler has an impact, but what's more likely to be
> going on is that you're seeing effects that are indirect, and not
> necessarily at all even "good".
>
> For example, if the X server is the scheduling point, it's entirely
> possible that it ends up showing effects that are more due to the queueing
> of the X command stream than due to the scheduler - and that those
> stalls are simply due to *that*.
>
> One thing to try is to run the X connection in synchronous mode, which
> minimizes queueing issues. I don't know if gears has a flag to turn on
> synchronous X messaging, though. Many X programs take the "[+-]sync" flag
> to turn on synchronous mode, iirc.

I like your analysis, but how do you explain that these stalls vanish when 
__update_curr is disabled?


Thanks!

--
Al

