Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXGEFjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXGEFjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 01:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbXGEFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 01:38:52 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:15334 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbXGEFiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 01:38:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkchANogjEZKhRO4R2dsb2JhbACHJod6AQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: blink driver power saving
Date: Thu, 5 Jul 2007 01:38:48 -0400
User-Agent: KMail/1.9.3
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707030142.36252.dtor@insightbb.com> <20070704221122.GA1719@elf.ucw.cz>
In-Reply-To: <20070704221122.GA1719@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707050138.49789.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 18:11, Pavel Machek wrote:
> Hi!
> 
> > > > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > > > while crash dumping" problem. I'm waiting for your patches.
> > > > > >
> > > > > 
> > > > > I don't don't like it ;) Unfortunately too many people end up enabling
> > > > 
> > > > Yes that's pretty weird. I admit I hadn't expected
> > > > that problem. blink is equivalent to "annoy me" and it
> > > > is a mystery why so many people should willingly ask their computer to 
> > > > annoy them.
> > > 
> > > tristate "Keyboard blink driver"
> > > 
> > > ...drivers are not expected to act on their own. I was expecting to
> > > get nice /sys/class/led* interface to my keyboard leds.
> > > 
> > > BTW ... I still believe we should have /sys/class/led* interface to
> > > those leds. I'd like to make them blink with hdd activity on some
> > > machines... of course, that needs non-buggy KBC.
> > 
> > I'll take patches. Ofcourse we'll have to keep the current EV_LED interface
> > for compatibility.
> 
> Here's a working version. For some reason, it only works with capslock
> led. (But so does your code, is that thinkpad problem?)
>

My code does blink NumLock on my box (Dell) so I wonder why it does not
on your box...

Anyway, as far as the patch goes - I don't think we want to do it this
way for a couple of reasons:

1. It does not reflect the true device hierarchy - LEDs are not children
of input devices, they are children of whatever device that owns input
device. So in case of AT keyboard LEDs should grow from corresponding
serio port, not input device and so atkbd should register all of its leds.

2. LEDs will stop working if input device is grabbed via EVIOCSGRAB.
I think that grab should not cross subsystem boundaries.

-- 
Dmitry
