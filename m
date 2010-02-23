Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0BWUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:55:55 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:45270 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab0BWUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:55:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Tue, 23 Feb 2010 21:55:33 +0100
From: Michael Thayer <Michael.Thayer@Sun.COM>
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
In-reply-to: <20100223175852.GA11301@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1266958533.3602.128.camel@michael-laptop>
Organization: Sun Microsystems GmbH
X-Mailer: Evolution 2.28.1
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Thanks for your comments!

Le mardi 23 février 2010 à 09:58 -0800, Dmitry Torokhov a écrit :
> On Tue, Feb 23, 2010 at 12:13:35PM +0100, Michael Thayer wrote:
> > This patch adds support for VirtualBox touchscreen emulation to the Lifebook
> >  input driver.
[snip]
> I am wondering if it is a good idea to piggy-back on Lifebook. The
> devices are sufficiently different with Lifebook really having 2
> separate devices (touchscreen and either regular external mouse or a
> touchpad) and VirtualBox having asingle device that looks like a pointer
> (not a touchscreen since pointer moves constantly, not while "touching")
> with absolute coordinates reporting.
I'm not sure, if we ended up doing a completely new device, how different it
would end up being.  Emulating a touchscreen or a tablet makes sense for us as
these are both something known, which will work with existing systems without
too much tweaking (I could imagine us adding Solaris support at a later point,
and it would be nice to see "little" OSes picking up support independently).

The two devices also make sense for us on the one hand because xf86-input-evdev
currently only understands absolute devices without mouse buttons (yes I know,
we could send them patches too if we had too, but we would rather not patch the
whole world :) ) and on the other because it makes it easy for us to switch
between absolute and relative event reporting, which is a big plus.  Of course,
as you point out, we have the unused touch bit, but the device works nicely
sending co-ordinates without "touching", and having at least nominal touch
functionality is rather a prerequisite for emulating a touch screen.

> I think it would be better if we had separate protocol module for that.
> [snip]
Separate module as in separate driver, or changes to the actual (PS/2 extension)
protocol?  If the second, then what did you have in mind?  One protocol change
I could think of, other than the thing with the buttons, would be a magic knock
rather than DMI matching, as that would let others piggy-back on us.  Not a big
advantage for us of course, but it might be one for you.

> This issue should be fixed in the recent kernels.
Ah, I failed to see that (I was working against the Ubuntu Lucid kernel
after checking that there were no more recent changes to lifebook.c).
Is the fix in psmouse-base.c?

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

