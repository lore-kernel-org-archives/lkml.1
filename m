Return-Path: <linux-kernel-owner+w=401wt.eu-S934197AbXGUCAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbXGUCAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 22:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXGUCA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 22:00:29 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:61176 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbXGUCA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 22:00:28 -0400
Date: Fri, 20 Jul 2007 21:59:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <200707210155.42814.arnd@arndb.de>
Message-ID: <Pine.LNX.4.58.0707202120060.21951@gandalf.stny.rr.com>
References: <1184970779.4012.38.camel@chaos> <200707210155.42814.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Arnd Bergmann wrote:

> On Saturday 21 July 2007, Thomas Gleixner wrote:

>
> In my experience, it's very helpful to have a single set of header
> files, and merging the two versions of one header usually exposes
> bugs that have been fixed in only one of the two, so you get
> to fix actual bugs in the process.

This can still be done after the merge tglx did.

>
> In the s390 merge, I also started out in an attempt to guarantee
> unchanged object files, much like what you describe. However, it
> turned out that fixing it in the process is actually easier.
> Either way, 'diff -D __x86_64__' is a great tool for a start, you
> should try it out to see how easy it is to merge a lot of files.
>
> To put it into perspective, I think the s390 merge was a lot easier
> than the x86 merge, because there is only a very limited set of
> hardware configurations for s390 compared to others. We ended up
> doing the full merge with three people within less than a week
> and no separate files at all.

This is the big reason they wanted to keep it binary identical. Since
there are just way too many different configs out there in the x86
world

>
> OTOH, the powerpc merge is now going into its third year, mostly
> because it was started with the intention to remove all cruft
> in the process and to only allow sane code into the new architecture.

I'd expect x86 to move much faster, just because there are more developers
and users of x86 PCs than there are for powerpc.

>
> The steps that I'd suggest instead are:
>
> * merge all exported header files of the two architectures. This
>   alone is a worthy goal, because it allows us to get rid of
>   the ugly code for deciding which version to use in installed
>   headers and elsewhere.

I don't see why this can't be done after the first "Big" merge.

>
> * Create an arch/x86/Makefile that descends into ../i386/* and
>   ../x86_64/* instead of its subdirectories.

The thing that Thomas pointed out, is that physical location of the source
actually does matter. Having two files side by side with the same name
except for a _32.c and _64.c, makes a developer want to merge them.

A perfect example is looking at both
  arch/x86/kernel/module_{32,64}.c
One would be encouraged to make that into a single file. But having
a arch/i386/kernel/module.c and a arch/x86_64/kernel/module.c would
take some time before anyone would care.

>
> * Merge the arch/x86/* subdirectories, one at a time, starting with
>   the low-hanging fruit like oprofile or pci, and do the hard
>   ones like mm and kernel last.

Your looking at a 10year plus merge with that approach. I think that is
exactly what Ingo and Thomas _dont_ want.  Doing it as the big bang way as
is posted in this patch is the fastest way to get where we want to go.

>
> Unfortunately, I don't think I'll spend much time on this, so I
> don't get to decide on it, but you asked for feedback ;-)
>

I'm actually looking forward to helping out here ;-)

-- Steve

