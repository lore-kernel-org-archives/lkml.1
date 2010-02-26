Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab0BZKfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:35:13 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:37457 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab0BZKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:35:10 -0500
Date: Fri, 26 Feb 2010 11:35:05 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl,
       linux-input@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd version)
Message-ID: <20100226103505.GB3992@const.homenet.telecomitalia.it>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100224012010.GA4062@const> <20100225013840.GA5519@const.homenet.telecomitalia.it> <20100225102056.GG10823@core.coreip.homeip.net> <20100225214403.GB9378@const.homenet.telecomitalia.it> <20100226035448.GA16797@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100226035448.GA16797@core.coreip.homeip.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Thu 25 Feb 2010 19:54:48 -0800, a écrit :
> Right now on .33, if you write LED event to one event device while
> legacy keyboard driver is inactive (in raw mode) then that write will
> only affect that particular event device, not the rest of them. Your
> patch changes that.

Errr, I don't think so.  My patch just puts a trigger layer between
keyboard and the loop over devices that keyboard used to do.  When the
legacy keyboard driver is inactive, it doesn't trigger anything any
more, and my patch becomes actually inactive, and other sources of LED
events can send them to various input event devices independently.  I've
just tried it with Xorg (telling it to use only one keyboard) and it
works.

> Whether LED state should be shared between all input devices or should
> be kept separate is a matter of policy and we try to keep policy in
> userspace.

Sure.

> >  On the contrary,
> > it fixes the problem of proper caps lock with led feedback.
> 
> I am unaware of such issue, any pointers?

In the very changelog of my patch :) #7063
And also please see the thread “make CapsLock work as expected even
for non-ASCII” on lkml.

> > Being able to assign only some of the devices to the linux console
> > would indeed probably be good, but to me it's just a refinement. Users
> > a priori assume all keyboards get their leds updated, so my patch
> > makes sense.  And it won't prevent a further patch that, in addition
> > to input::<led> leds, adds per-device leds, which the user could use
> > instead of input::<led>.
> 
> I think that if we want to go LED route we shoudl start with adding led
> devices to individual keyboard drivers first

Mmm, thinking again, I think my patch could be rather easily converted
into creating led instances for each device, with proper trigger
defaults.  Something like input-devicename::numlock? (devicename::numlock
might get conflicts with non-input devices I guess?)

That being said, usermode tools which want to set up the modifiers and
connect the input LEDs to them need an easy and proper way to do so.
Having central input::numlock and such still seems a good thing.

> and then convert legacy
> keyboard to use trigger instead of talking to input devices directly.

This part is already done by my patch.

Samuel
