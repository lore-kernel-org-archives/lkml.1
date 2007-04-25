Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXDYXaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXDYXaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXDYXaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:30:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbXDYXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:30:16 -0400
Date: Wed, 25 Apr 2007 16:29:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425231319.GK17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251621530.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <1177540027.5025.87.camel@nigel.suspend2.net>
 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
 <20070425231319.GK17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> Current design is:

Broken. Yes. I've tried to tell you.

> Twice. Once during snapshot (then we spin it up when the snapshot is
> done), and once during shutdown.

And nobody can possibly say that is "sane". But it's a direct result of 
the incorrect thinking that "suspend()" and "snapshot()" have anything 
what-so-ever to do with each other.

> Yep, we optimize away spindown, because it takes too long, so SCSI
> disks are actually very bad example.

No. SCSI disks are a *good* example. It's an example of how you 
(incorrectly) call the same function for two totally different things, and 
then that function is smart enough that it *understands* that they are 
totally different.

But the *confusion* remains. It remains in your head, and you've poisoned 
people like Alan too, that usually are not confused. And THAT is the main 
problem (although there are also indirect problems like "fixing one may 
break the other", but I actually think that the fundamental problem is the 
confusion it creates, which in turn causes bugs to happen because people 
are confused and think that they should do the same thing for suspend and 
for snapshot).

> No, I'd like you to understand that we actually CAN tell the disks to
> spin down, because we'll call resume and spin them back again before
> writing the image. We used to do it. We still can do it, but it is
> slow.
> 
> Yes, it is quite confusing.

It's worse than just confusing, it's *idiotic*.

It _can_ work in practice, but
 - we have pretty damn solid evidence that it doesn't work all that often 
   in practice
 - the fact that something *can* be done the stupid way is in no way an 
   argument that it *should* be done the stupid way.

I claim that the current STD is *stupid*. Yes, it can work. But that 
doesn't make it less stupid.

What's your argument? Your argument seems to be that it's not stupid, 
because it can work. Can't you see that that simply isn't an argument at 
all? "stupid and wrong" doesn't mean "cannot work in theory". But it 
*does* mean that people get confused, and it *does* mean that there are 
likely more bugs, because confused people do not tend to write very good 
code.

I'm not claiming that the current code cannot work. It clearly *does* 
work for a lot of people. But I'm claiming that it's STUPID.

So don't argue that "it works". Windows works, kind of. That doesn't make 
it less stupid and badly designed!

		Linus
