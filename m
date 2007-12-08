Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXLHMR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXLHMR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXLHMRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:17:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbXLHMRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:17:17 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Peter Zijlstra <peterz@infradead.org>
To: Remy Bohmer <linux@bohmer.net>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 13:16:25 +0100
Message-Id: <1197116185.31440.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 00:02 +0100, Remy Bohmer wrote:
> Hello Peter,
> 
> > > What specifically is wrong with dev->sem ?
> >
> > Nothing really, other than that they use semaphores to avoid lockdep :-/
> >
> > I think I know how to annotate this, after Alan Stern explained all the
> > use cases, but I haven't come around to implementing it. Hope to do that
> > soonish.
> 
> I was looking for an easy semaphore I could convert to a mutex, and I
> ran into one that was widely spread and interesting, and which seemed
> quite doable at first sight.
> So, I started working on it, but was forgotten this discussion, (until
> Daniel made me remember it this afternoon). So, I (stupid me ;-) )
> tried to convert dev->sem...
> 
> After doing the monkey part of the conversion I can boot the kernel
> completely on X86 and ARM, and everything works fine, except after
> enabling lockdep, lockdep starts complaining...
> 
> Is this the problem you were pointing at?

Yeah, one of the interesting nestings :-)

> I tried debugging it, and I have not found a recursive mutex locking
> so far, only locking of 2 different mutexes in a row prior to this
> warning, which IMO should be valid.
> 
> What is your opinion?

Yeah, the locking is all valid afaics, its just that it needs some
interesting annotations to make lockdep see it that way.

> BTW: I attached my patch for dev->sem as I have it now, that generates
> this lockdep warning ( for if you want to look at it yourself also, so
> you do not have to do the monkey part yourself anymore ;-)

I have a similar patch floating around, but thanks anyway :-)

