Return-Path: <linux-kernel-owner+w=401wt.eu-S1423254AbXDYHYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423254AbXDYHYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423256AbXDYHYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:24:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3173 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423254AbXDYHYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:24:12 -0400
Date: Wed, 25 Apr 2007 07:23:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425072350.GA6866@ucw.cz>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is why there's a lot to be said for
> 
> 	echo mem > /sys/power/state
> 
> and being able to follow the path through _one_ object (the kernel) over 
> trying to figure out the interaction between many different parts with 
> different versions.

The 'promise' is 'if you can get echo disk > /sys/power/state working,
uswsusp will work. too'. IOW it should be ok to debug the in-kernel
parts, only.

Even I am running in-kernel swsusp, but my managers were pretty clear
they want graphical progress bar hiding all the 'ugly' swsusp
messages... and in the end the same uswsusp enables compression, too.

> I absolutely detest all suspend-to-disk crap. Quite frankly, I hate the 
> whole thing. I think they've _all_ caused problems for the "true" suspend 
> (suspend-to-ram), and the last thing I want to see is three or four 

Well, it is a bit more complex than that.

suspend-to-disk is a workaround for

	'suspend-to-ram eats too much power' (plus some details like
	being able to replace battery).

suspend-to-ram is a workaround for

	'idle machine takes way too much power' (plus some details
	like don't spin the disk so that machine is safe to carry).

I'm starting to think that we should fix the idle power consumption
problem. Cell phones do it right. They pretend to be ready/idle all
the time, yet they have _days_ of standby.

OLPC can do something like that, too: it is capable of entering
suspend-to-ram with screen on and input devices ready to wake the
system up.

And with right network card (and right userland) ... I think normal
PCs could enter suspend-to-ram during screensaver, too. When you are
about to turn off the screen, machine should enable WOL on any packet,
arm RTC wakeup for the next packet, and s2ram happily.

(Obviously we are far away from that on PC.)
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
