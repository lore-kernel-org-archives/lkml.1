Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXLHRHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXLHRHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXLHRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:06:58 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:23899 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbXLHRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:06:57 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <1197116185.31440.1.camel@twins>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 08:53:12 -0800
Message-Id: <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-08 at 13:16 +0100, Peter Zijlstra wrote:
> On Sat, 2007-12-08 at 00:02 +0100, Remy Bohmer wrote:
> > Hello Peter,
> > 
> > > > What specifically is wrong with dev->sem ?
> > >
> > > Nothing really, other than that they use semaphores to avoid lockdep :-/
> > >
> > > I think I know how to annotate this, after Alan Stern explained all the
> > > use cases, but I haven't come around to implementing it. Hope to do that
> > > soonish.
> > 
> > I was looking for an easy semaphore I could convert to a mutex, and I
> > ran into one that was widely spread and interesting, and which seemed
> > quite doable at first sight.
> > So, I started working on it, but was forgotten this discussion, (until
> > Daniel made me remember it this afternoon). So, I (stupid me ;-) )
> > tried to convert dev->sem...
> > 
> > After doing the monkey part of the conversion I can boot the kernel
> > completely on X86 and ARM, and everything works fine, except after
> > enabling lockdep, lockdep starts complaining...
> > 
> > Is this the problem you were pointing at?
> 
> Yeah, one of the interesting nestings :-)

It must be the locking in __driver_attach(), taking dev->parent->sem
then taking dev->sem .. Assuming those are different structures, why
does lockdep trigger?

Daniel

