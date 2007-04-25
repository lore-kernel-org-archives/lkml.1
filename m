Return-Path: <linux-kernel-owner+w=401wt.eu-S1031022AbXDYPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031022AbXDYPSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031038AbXDYPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:18:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33915 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031022AbXDYPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:18:15 -0400
Date: Wed, 25 Apr 2007 17:18:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
Message-ID: <20070425151825.GW3468@stusta.de>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425072350.GA6866@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 07:23:50AM +0000, Pavel Machek wrote:
> Hi!
> 
> > This is why there's a lot to be said for
> > 
> > 	echo mem > /sys/power/state
> > 
> > and being able to follow the path through _one_ object (the kernel) over 
> > trying to figure out the interaction between many different parts with 
> > different versions.
> 
> The 'promise' is 'if you can get echo disk > /sys/power/state working,
> uswsusp will work. too'. IOW it should be ok to debug the in-kernel
> parts, only.
> 
> Even I am running in-kernel swsusp, but my managers were pretty clear
> they want graphical progress bar hiding all the 'ugly' swsusp
> messages... and in the end the same uswsusp enables compression, too.
> 
> > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate the 
> > whole thing. I think they've _all_ caused problems for the "true" suspend 
> > (suspend-to-ram), and the last thing I want to see is three or four 
> 
> Well, it is a bit more complex than that.
> 
> suspend-to-disk is a workaround for
> 
> 	'suspend-to-ram eats too much power' (plus some details like
> 	being able to replace battery).
>...

Why does everyone think suspend-to-disk was a laptop-only thing?

My personal usage of suspend-to-disk is for turning the computer off in 
the evening and getting the complete FVWM with all programs running, 
open browser tabs,... back the next morning.

All I need for suspending is:
- echo "disk" > /sys/power/state

All I need for getting a running and usable system back is:
- turn on the power at the socket my computer is connected at
- swapoff -a; swapon -a       [1]
- wait a bit until the above commands finished

That's much more convenient than a cold boot.

And it's working with a plain 2.6.16 kernel and zero userspace support.

> 							Pavel

cu
Adrian

[1] required step: working with 1 or 2 GB swapped out is horrible

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

