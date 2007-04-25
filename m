Return-Path: <linux-kernel-owner+w=401wt.eu-S1423251AbXDYHbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423251AbXDYHbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423269AbXDYHbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:31:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2570 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423251AbXDYHbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:31:46 -0400
Date: Wed, 25 Apr 2007 07:29:05 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425072904.GB6866@ucw.cz>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425064137.GA25247@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425064137.GA25247@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate 
> > the whole thing. I think they've _all_ caused problems for the "true" 
> > suspend (suspend-to-ram), and the last thing I want to see is three or 
> > four different suspend-to-disk implementations.  So unlike Ingo, I 
> > don't think "let's just integrate them all side-by-side and maintain 
> > them and look who wins" is really a good idea.
> >
> > How many different magic ioctl's does the thing introduce? Is it 
> > really just *two* entry-points (and how simple are they, 
> > interface-wise), and nothing else?
> 
> userspace-driven-suspend is already in the kernel, today. So it's not 
> really "two versions side by side doing the same thing", but more of:
> 
>            A B C + D E F G H
> 
> where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used by 
> suspend2. So any "suspend2 merge" would largely be about adding "DEFGH". 

Actually, we have 'D H' in kernel, today. It is called swsusp...
(Encryption, swapFile support and Graphical progress are missing from
today's kernel.)

> My original mail was about the following thing: i tried the suspend2 
> patch (which just makes "echo disk > /sys/power/state" work as expected, 
> as long as you give the booting up kernel image an idea about where the 

..and it means that 'echo disk > ...' should work w/o suspend2 patch,
too. (Just try it). You'll miss compression part, but that provides
only small speedup.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
