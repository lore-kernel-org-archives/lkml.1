Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0BXLrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:47:06 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:41454 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab0BXLrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:47:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Wed, 24 Feb 2010 12:46:29 +0100
From: Michael Thayer <Michael.Thayer@Sun.COM>
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
In-reply-to: <20100224100206.GA5598@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1267011989.2831.30.camel@michael-laptop>
Organization: Sun Microsystems GmbH
X-Mailer: Evolution 2.28.1
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
 <1266958533.3602.128.camel@michael-laptop>
 <20100224100206.GA5598@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 février 2010 à 02:02 -0800, Dmitry Torokhov a écrit :
> On Tue, Feb 23, 2010 at 09:55:33PM +0100, Michael Thayer wrote:
> > I'm not sure, if we ended up doing a completely new device, how different it
> > would end up being.  Emulating a touchscreen or a tablet makes sense for us as
> > these are both something known, which will work with existing systems without
> > too much tweaking
> > [snip]
> But the virtual mouse is not a touchscreen or a tablet, it behaves
> differently.
What would you suggest emulating that exists in the real world?  And might a
tablet not be better than a touchscreen, given that it doesn't just have a
binary concept of "touch or not", but a pressure axis as well?  We could report
"pen on but zero pressure".  I take your point (below) about not relying on
behaviour that doesn't correspond to real devices like being able to send
position data without BTN_TOUCH being held down.

> > The two devices also make sense for us on the one hand because xf86-input-evdev
> > currently only understands absolute devices without mouse buttons
> 
> Hmm, I scanned through it and I did not see anything specifically
> removing mouse buttons from absolute devices there... Is it still valid
> for the recent version of evdev driver?
Sorry, I have to correct myself there.  It assumes that an absolute device with
a "BTN_TOUCH" and mouse buttons and no pen is a touchpad and not a touchscreen.
Function "EvdevProbe()", search for "Found absolute touchpad".

> > (yes I know,
> > we could send them patches too if we had too, but we would rather not patch the
> > whole world :) ) and on the other because it makes it easy for us to switch
> > between absolute and relative event reporting, which is a big plus.
> 
> Why is this a big plus? Also, can't evdev handle devices reporting both
> relative and absolute events?
We sometimes want to switch to relative event reporting to e.g. let people play
games which are controlled using the mouse.  Don't ask :)  I can check again,
but I think that xf86-input-evdev ignores relative axes if a device supports
absolute ones.  I do feel that having two devices from it's point of view is
a safer bet here, rather than trying something fancier.

> You are relying on the fact that currently userspace components rely on
> drivers not sending coordinates data without touch; as soon as userspace
> (evdev) starts validating it and ignoring coordinate events without
> ABS_PRESSURE or BTN_TOUCH you'll be toast.
Point taken.  See above.

> > > I think it would be better if we had separate protocol module for that.
> [snip]
> First, create a separate protocol handler (module similar to
> lifebook.c), allocate protocol number, something like PSMOUSE_VBPS, and
> plumb it into psmouse-base.c in the same fashion othe protocol handlers
> do it.
Sure, I can copy lifebook.c and make the necessary modifications.  I will wait
for your answers/comments on the above though (particularly the first bit)
before starting.

Thanks again.

Regards,

Michael
-- 
Sun Microsystems GmbH        Michael Thayer
Werkstrasse 24               VirtualBox engineer
71384 Weinstadt, Germany     mailto:michael.thayer@sun.com

Sitz der Gesellschaft:
Sun Microsystems GmbH, Sonnenallee 1, 85551 Kirchheim-Heimstetten
Amtsgericht Muenchen: HRB 161028
Geschaeftsfuehrer: Thomas Schroeder, Wolfgang Engels
Vorsitzender des Aufsichtsrates: Martin Haering

