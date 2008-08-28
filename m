Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYH1PuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYH1PuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYH1PuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:50:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYH1PuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:50:06 -0400
Date: Thu, 28 Aug 2008 11:50:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <200808290134.35093.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Aug 2008, Nick Piggin wrote:

> On Friday 29 August 2008 01:12, Steven Rostedt wrote:
> > On Fri, 29 Aug 2008, Nick Piggin wrote:
> > > On Friday 29 August 2008 00:30, Ingo Molnar wrote:
> > > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > For this, if this time limit does kick in, we should at the very
> > > > > least print something out to let the user know this happened. After
> > > > > all, this is more of a safety net anyway, and if we are hitting the
> > > > > limit, the user should be notified. Perhaps even tell the user that
> > > > > if this behaviour is expected, to up the sysctl <var> by more.
> > > >
> > > > yeah, agreed, this is a reasonable suggestion. Peter, do you agree?
> > >
> > > Seems reasonable. But I still think it should be disabled by default
> > > (it might not get caught in testing for example).
> >
> > Perhaps we should default it to 1sec, that way it would be hit more often,
> > and educate the users of this now feature.
> 
> There only one sane default, as far as I can see.
> 
> Before anybody attacks me again because I haven't got my brain together or
> am an annoying standards nitpicker:
> 
> I'm very well aware of the consequences of unlimited hogging of the CPU.
> And I know exactly why people might want rt throttling. But just think for
> a minute the _negative_ consequences of changing the API and remember that
> is close to the #1 rule of Linux development to not break user API.
> 
> And put it this way: the sysctl is right there. Any distro that cares about
> this problem will probably find this thread as #1 hit and work out how to
> enable the sysctl and break the API if they are happy to do that. On the
> flip side, not every application development or deployment is even going to
> know about this, and it may not be trivial to catch in testing, so it could
> cause failures in the field.
> 

The issue here is where to place the policy of protecting the user. Is it 
in the kernel, or is it up to the distro.

I've always thought that the policy settings belong in the distro, and the 
kernel should never enforce a policy (by setting this as default, it is 
enforcing a policy, even though an RT user can change it).

I've recently been told that the kernel has of recent, has indeed been 
starting to set policies. With protection of memory and such. If this is 
the case, that the kernel is the place to implement policy, then the 
"sane" default belongs there. If the distro is the place to instill 
policy, then that is the place to put the "sane" default.

Basically, I'm not in a position to say where Linux should place the 
default policies (distro or kernel). I've always thought the kernel should 
be bare bones, allowing the distros to do all the policy settings, and 
those that compile and build their own kernels/distros do so at their own 
risks.  But if this is no longer the case, then who am I to argue.

I guess this decision belongs to those above (Linus, Andrew)?

-- Steve

