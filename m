Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbXEUMLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbXEUMLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXEUMK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:10:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42642 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755751AbXEUMK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:10:58 -0400
Date: Mon, 21 May 2007 14:10:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: trenn@suse.de, Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070521121048.GA8332@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <1179604609.16465.83.camel@sublime.suse.de> <200705202350.45145.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705202350.45145.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > No, writing trip-points is neither a fix, nor it is reasonable.
> > > It is a workaround at best, and it is a dangerous and mis-leading hack.
> > Yes it is a workaround for critical ACPI bugs like that or similar:
> > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/22336
> 
> Thanks for pointing that out -- it is a great example
> of how powerful mis-information can be.
> 
> The fact that the trip-points are writable has obscured,
> rather than clarified, the actual causes of the failures.
> No less than 4 people in that bug report declared that
> cleaning the dust out of their fan fixed the root cause.
> A bunch more said that the issues went away when they 
> stopped using ubuntu's user-space power save daemon.
> 
> There are a couple more with broken active fan control --
> which also gets obscured rather than clarified by
> over-riding trip points.
> 
> And finally, there are probably some with clean fans
> that are working properly, but are thermally challenged
> systems.  I'll venture that Windows is NOT modifying or disabling
> the critical trip point to work around this issue.
> I'll venture that their thermal throttling is working
> and ours may not be.
> 
> perhaps it was the recently fixed mod_timer() bug in thermal.c,
> or perhaps it is one that we don't know about yet...
> 
> > It's also convenient to e.g. lower passive trip point to avoid fan
> > noise.
> 
> nope, the OS can't reliably override the processor passive trip point.
> That is what _SCP and cooling_mode are for.

Yes, it is reliable if you turn on thermal polling.

> The reason is that the BIOS can send us a trip-point changed event at any time,
> the kernel will evaluate _PSV, and wipe out the modified OS version.
> 
> if you want to change the state of the fans,
> then poke /proc/acpi/fan/ directly.

Heh, you suggest this? It is even less functional than current
solution -- which works okay as long as you keep thermal polling
working.

> > It's there for a long time, why is this "a dangerous and mis-leading
> > hack." now?
> 
> It has been dangerous and misleading since the day it went in.
> If the user doesn't enable polling, then they are effectively
> writing random numbers that have absolutely no effect on
> the operation of the system, and hiding the numbers that
> do control the operation of the system.

You are misstating the situation. With thermal polling, it is pretty
much okay, and it is certainly better than "ride fans manually" hack
you suggested.

> For folks with the reverse problem -- active cooling where the
> fans kick in early than they'd like, they should just turn off
> the fans via /proc/acpi/fan and not mess with the trip points at
> all.

No. Manually turning off fans is even worse hack.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
