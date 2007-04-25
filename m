Return-Path: <linux-kernel-owner+w=401wt.eu-S1031117AbXDYTkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031117AbXDYTkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031114AbXDYTkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:40:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030998AbXDYTk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:40:29 -0400
Date: Wed, 25 Apr 2007 12:38:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425192512.GZ3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
 <20070425192512.GZ3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Adrian Bunk wrote:
> > 
> > .. but if the alternative is a feature that just isn't worth it, and 
> > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > I believe STD is both of those. There's a reason it's called "STD". Go 
> > to google and type "STD" and press "I'm feeling lucky". Google is God).
> 
> Is there really no use case for STD?

People seem to have reading comprehension problems.

The STD code is buggy, and has introduced bugs in STR too, largely thanks 
to bad design. Some of them have happily gotten fixed. Others did not, and 
now we have three totally different versions (two of which share some 
infrastructure), all of which are broken (ie the "suspend2" people will 
swear up-and-down that swsusp doesn't work for them, but anybody who 
thinks that "suspend2" will work for everybody is just being a total 
idiot, and I have a bridge to sell to them).

I'd actually be happier *removing* STD support in the sense it is now: 
it's way too closely integrated with STR, even though it has absolutely 
nothing in common with it. When you STD, you'e actually much closer to a 
*shutdown* than to STR, yet the STD code continually seems to want to be 
in the "suspend" path, as shown even by its name.

So my objections to STD have nothing to do with saving state and shutting 
down. They have everything to do with the fact that it is not - and will 
never be - a "suspend", and it shouldn't affect suspend.

And that's a *fundamental* problem. If the STD people cannot even realize 
that they have less to do with "suspend" than to "reboot", how do you ever 
expect them to get anything to work, and not affect other things 
negatively?

Yeah, I'm down on it. I'm down on it because every person involved with 
the whole STD thing seems to have basically zero taste, and a total 
inability to work with anybody else. 

		Linus
