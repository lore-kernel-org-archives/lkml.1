Return-Path: <linux-kernel-owner+w=401wt.eu-S1764799AbXGUF7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799AbXGUF7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXGUF7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:59:06 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:37100 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbXGUF7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:59:04 -0400
Date: Sat, 21 Jul 2007 01:58:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@suse.de>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <200707210737.59552.ak@suse.de>
Message-ID: <Pine.LNX.4.58.0707210151020.29129@gandalf.stny.rr.com>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Jul 2007, Andi Kleen wrote:

> On Saturday 21 July 2007 00:32, Thomas Gleixner wrote:
> > We are pleased to announce a project we've been working on for some
> > time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> > to solicit feedback about it.
>
> Well you know my position on this. I think it's a bad idea because
> it means we can never get rid of any old junk. IMNSHO arch/x86_64
> is significantly cleaner and simpler in many ways than arch/i386 and I would
> like to preserve that. Also in general arch/x86_64 is much easier to hack
> than arch/i386 because it's easier to regression test and in general
> has to care about much less junk. And I don't
> know of any way to ever fix that for i386 besides splitting the old
> stuff off completely.

I have to say honestly that it is much easier to work in the i386 arch
directories than the x86_64. But that may be my own feelings.  You seem to
have a nice style that you like and think that it is cleaner. But it
doesn't really seem much cleaner to me. Somethings I like better with the
x86_64 code, and there's somethings I like better with the i386 code. But
from a comfort level, I have to go with worknig with the i386 code.


>
> Besides radical file movements like this are bad anyways. They cause
> a big break in patchkits and forward/backwards porting that doesn't
> really help anybody.

I think it helps a lot of people. Especially those that are trying to add
things to _both_ i386 and x86_64.

>
> > This causes double maintenance
> > even for functionality that is conceptually the same for the 32-bit and
> > the 64-bit tree. (such as support for standard PC platform architecture
> > devices)

Not sure what you mean here?  I would think that we have this "double
maintence" anyway.  Fixes that are done in x86_64 probably should also be
done in i386.  Why have it in two places?

>
> It's not really the same platform: one is PC hardware going back forever
> with zillions of bugs, the other is modern PC platforms which much less
> bugs and quirks

hehe, I'm seeing a bunch of bugs and quirks appear.  It's just that
x86_64 isn't as old as i386 to have as many of them. But give it time.

>
> To see it otherwise it's more a junkification of arch/x86_64 than
> a cleanup of arch/i386 -- in fact you didn't really clean up arch/i386
> at all.

That was not the point of this patch. This patch was to unify the two so
that we can get started on the unification.

>
> > How did we do it?
> > -----------------
> >
> > As an initial matter, we made it painstakingly sure that the resulting
> > .o files in a 32-bit build are bit for bit equal.
>
> You got not a single line less code duplication then, so i don't really
> see the point of this.
>

Did you read what tglx wrote?  The point of this patch was to keep
everything the _same_.  The fact that not a single line less code
duplication is a feature.  A great starting point where we can easily
trace things back to the current arch separation, as well as move forward
in merging the two.

-- Steve

