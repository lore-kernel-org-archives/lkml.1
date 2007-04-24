Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXDXUnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXDXUnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXDXUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:43:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbXDXUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:43:02 -0400
Date: Tue, 24 Apr 2007 13:41:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070424202336.GC16503@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de>
 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
 <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Apr 2007, Pavel Machek wrote:
> 
> Well, current uswsusp code can do most of stuff suspend2 can do, with
> 20% (or so) of kernel code. 

Btw, this is a totally inane argument.

If the code just moved somewhere else, it's not "less code".

You compare complete subsystems against complete subsystems, OR YOU DON'T 
COMPARE THEM AT ALL!

This whole notion that "kernel lines of code" is somehow different is a 
stupid and idiotic _disease_ that is spread by microkernel people and 
people who have been brainwashed by them.

Code is code, and sometimes it's better in the kernel, sometimes it's 
better in user space, and you cannot say "we only have 10 lines of kernel 
code", if that is then combined with a million lines of user space code 
that actually is the only reason for the 10 lines of code in the first 
place.

Separation of code often makes things *harder* to understand and debug. A 
few prime examples of this f*cking idiotic stupid disease of discounting 
user level code because it somehow "doesn't matter" is:

 - the old 16-bit pcmcia layer that did all the "policy" in user space, 
   and only the "device access" in kernel space, and as a result _neither_ 
   actually knew what the hell they were actually doing, and debugging was 
   a nightmare.

   We've become a *lot* better off with a device layer that actually knows 
   and understands what it is doing, and having the code in one place, 
   rather than having two broken pieces.

   And we became better exactly by doing *more* in the kernel, and havign 
   a *higher* level of abstraction. This is a BIG ISSUE. Abstraction is 
   good, but abstraction is good only if it is at a high enough level to 
   make sense and matter, and give the abstraction level a choice in how 
   to implement the lower layers.

 - the old module loader was also split into user/kernel space, and yes, 
   we made the kernel part "larger" by moving some parts into the kernel, 
   but in doing so, we actually made the *combined* code smaller, and a 
   hell of a lot more maintainable.

   It also automatically (again, because of a higher level of abstraction) 
   meant that the new module loader infrastructure was not only more 
   maintainable, but could actually *do* more. Suddenly you can do things
   like check for cryptographic signatures etc, because you know what 
   you're actually doing, as opposed to getting a ready-made "binary blob" 
   that you don't know anything about, that has been pre-linked etc.

So stop blathering about "less kernel code". That's the *least* of any 
worries. The only thing that matters is the end result, and trying to say 
that magically only one part counts is just dishonest and stupid.

In general, the kernel should be self-sufficient and *understand* what it 
is doing. If the kernel cannot understand the bigger picture, nobody can 
ever maintain the kernel, because the kernel is just a broken piece 
bobbing around in a mindless churning sea during a thunderstorm. You 
cannot have purpose, and you cannot improve yourself if you don't actyally 
understand your lot in life. That's as true of kernels as it is of people.

User-space should set high-level policy, but if the kernel doesn't know 
what it's all about, the kernel can never do anything smarter and can 
never *fix* itself. That was the case in both PCMCIA and in kernel module 
loaders.

I have not a frigging clue whether that is the case in suspend2 vs 
uswsusp, but I object to this idiotic argument of counting "kernel code". 
That's simply not a valid argument. It never was.

			Linus
