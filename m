Return-Path: <linux-kernel-owner+w=401wt.eu-S936785AbXGUIQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936785AbXGUIQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbXGUIPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:15:55 -0400
Received: from www.osadl.org ([213.239.205.134]:41457 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932173AbXGUIPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:15:53 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200707210737.59552.ak@suse.de>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 10:15:50 +0200
Message-Id: <1185005750.4012.100.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 07:37 +0200, Andi Kleen wrote: 
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

I disagree of course. 

I worked on both trees quite intensive over the last years and I broke
x86_64 more than once when hacking on i386 and vice versa. 

Your "junk" argument is nothing else than a strawman which you beat on
every time when this discussion comes up.

> Besides radical file movements like this are bad anyways. They cause
> a big break in patchkits and forward/backwards porting that doesn't 
> really help anybody.

Interestingly enough the folks with the big patch kits (Virtualization)
would be quite happy about that move.

> > This causes double maintenance
> > even for functionality that is conceptually the same for the 32-bit and
> > the 64-bit tree. (such as support for standard PC platform architecture
> > devices)
> 
> It's not really the same platform: one is PC hardware going back forever
> with zillions of bugs, the other is modern PC platforms which much less
> bugs and quirks

It _IS_ the same platform. x86_64 is PC hardware with zillions of bugs
as well. And it is not modern at all. It is nothing else than a 64 bit
version of the legacy x86.

> To see it otherwise it's more a junkification of arch/x86_64 than
> a cleanup of arch/i386 -- in fact you didn't really clean up arch/i386 
> at all.

We went for a 1 : 1 replacement without merging anything which is not
obvious in the first place (identical files and files, which are just
including some other file). That way we were able to do a binary
compatible migration.

The clean up is the next step and there are enough folks out there
willing to help on this.

> > As an initial matter, we made it painstakingly sure that the resulting
> > .o files in a 32-bit build are bit for bit equal.
> 
> You got not a single line less code duplication then, so i don't really
> see the point of this.

Really ? 

The script detected 15 identical files with a simple cmp.

It also unified another 10 by simply looking at the only line in there
"include <the other arch/file>"

And there is more of that, when you take the time and look closely at
the _32.[ch] _64.[ch] files which are created by the merge.

	tglx


