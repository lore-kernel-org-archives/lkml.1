Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXLHRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXLHRoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLHRos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:44:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXLHRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:44:48 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 18:11:50 +0100
Message-Id: <1197133910.6353.33.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 08:53 -0800, Daniel Walker wrote:
> On Sat, 2007-12-08 at 13:16 +0100, Peter Zijlstra wrote:
> > On Sat, 2007-12-08 at 00:02 +0100, Remy Bohmer wrote:
> > > Hello Peter,
> > > 
> > > > > What specifically is wrong with dev->sem ?
> > > >
> > > > Nothing really, other than that they use semaphores to avoid lockdep :-/
> > > >
> > > > I think I know how to annotate this, after Alan Stern explained all the
> > > > use cases, but I haven't come around to implementing it. Hope to do that
> > > > soonish.
> > > 
> > > I was looking for an easy semaphore I could convert to a mutex, and I
> > > ran into one that was widely spread and interesting, and which seemed
> > > quite doable at first sight.
> > > So, I started working on it, but was forgotten this discussion, (until
> > > Daniel made me remember it this afternoon). So, I (stupid me ;-) )
> > > tried to convert dev->sem...
> > > 
> > > After doing the monkey part of the conversion I can boot the kernel
> > > completely on X86 and ARM, and everything works fine, except after
> > > enabling lockdep, lockdep starts complaining...
> > > 
> > > Is this the problem you were pointing at?
> > 
> > Yeah, one of the interesting nestings :-)
> 
> It must be the locking in __driver_attach(), taking dev->parent->sem
> then taking dev->sem .. Assuming those are different structures, why
> does lockdep trigger?

They aren't different, parent is a struct device again.

