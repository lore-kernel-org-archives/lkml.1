Return-Path: <linux-kernel-owner+w=401wt.eu-S1765034AbXIKVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765034AbXIKVWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763704AbXIKVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:22:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763094AbXIKVWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:22:18 -0400
Date: Tue, 11 Sep 2007 14:21:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
In-Reply-To: <20070911201219.GA9674@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.999.0709111414410.16478@woody.linux-foundation.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Sep 2007, Sam Ravnborg wrote:
> 
> From the mails and discussions I expected it be be obvious what was i386 
> only, what was shared and what was x86_64 only.

The problem right now is the *reverse* - even though they are in different 
subdirectories (and thus *look* like they are all separate), they aren't.

So the merged end result is much better: at a first approximation 
everything is shared (largely true), and the ones that aren't shared can 
be made more obvious.

> But see following table
> 
> Filename		i386	x86_64
> acpi.c		X	X
> common.c		X	X
> direct.c		X	X
> early.c		X	X
> fixup.c		X	X
> i386.c		X	X
> init.c		X	X
> legacy.c		X	X
> mmconfig-shared.c	X	X

So sharing is the default, as it should be.

> irq.c			X
> k8-bus.c			X
> numa.c			X
> pcbios.c		X

And these are examples of things that likely *should* be shared, and have 
nothing what-so-ever to do with 32- vs 64-bit issues. For example, neither 
NUMA nor k8 is in *any* way a 32-bit vs 64-bit issue, they are issues with 
chips that can be used as either.

> mmconfig_32.c		X
> mmconfig_64.c			X

And this is obvious, and correct.

> visws.c			X

Now, arguably this should be entirely elsewhere (ie in the "mach-visw" 
directory).

> In the filename there is NOTHING for most of
> the non-shared code that tell that this file is
> used by only i386 or x86_64.

.. and that's because of historical issues, and has nothing to do with the 
merge, and everything to do with all the problems that the merge is 
supposed to eventually help us FIX!

> The exception is mmconfig that is prefixed with _32 versus _64.
> But as I have understood the mails floating around using _32,_64
> is a way to say here are a potential candidate for futher merging.

Yes. But so are others.

> If legacy.c numa.c, pcibios.c and visws.c placed in a directory named i386
> then it would be obvious that this is i386 only.

But none of it is "i386 only" and putting it in a directory of its own 
would be stupid and wrong. The visws.c thing is platform-specific thing, 
and the fact that the platform happens to be 32-bit is totally secondary 
to the much bigger issue of the *platform*, so again, it would be totally 
wrong to split it up by wordsize.

> I dunno if this will address the concern of Andi about mixing i386 and x86_64
> but to me at least things would be so much more obvious if the original
> relationship are spelled out.

I obviously disagree violently. We should absolutely *not* make any of 
this depend on word-size. Quite the reverse!

		Linus
