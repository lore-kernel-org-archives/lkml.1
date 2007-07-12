Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbXGLUja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbXGLUja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763973AbXGLUjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:39:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36649 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757326AbXGLUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:39:07 -0400
Date: Thu, 12 Jul 2007 11:10:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
Message-ID: <20070712091043.GB1866@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707030142.36252.dtor@insightbb.com> <20070704221122.GA1719@elf.ucw.cz> <200707050138.49789.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707050138.49789.dtor@insightbb.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'll take patches. Ofcourse we'll have to keep the current EV_LED interface
> > > for compatibility.
> > 
> > Here's a working version. For some reason, it only works with capslock
> > led. (But so does your code, is that thinkpad problem?)
> 
> My code does blink NumLock on my box (Dell) so I wonder why it does not
> on your box...

setleds does not work here, either, so...

> Anyway, as far as the patch goes - I don't think we want to do it this
> way for a couple of reasons:
> 
> 1. It does not reflect the true device hierarchy - LEDs are not children
> of input devices, they are children of whatever device that owns input
> device. So in case of AT keyboard LEDs should grow from corresponding
> serio port, not input device and so atkbd should register all of its
> leds.

I'm not sure what you mean here. Should the code be moved to atkbd.c?
...and then duplicated to usbkbd.c?

> 2. LEDs will stop working if input device is grabbed via EVIOCSGRAB.
> I think that grab should not cross subsystem boundaries.

Well, if userspace grabbed a LED, it would make sense to stop blinking
it from heartbeat, no?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
