Return-Path: <linux-kernel-owner+w=401wt.eu-S1751105AbXBVRJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbXBVRJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXBVRJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:09:13 -0500
Received: from tim.rpsys.net ([194.106.48.114]:53748 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXBVRJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:09:12 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070222163405.GF25887@khazad-dum.debian.net>
References: <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
	 <1172103159.5790.45.camel@localhost.localdomain>
	 <20070222005122.GA7928@khazad-dum.debian.net>
	 <20070222011017.GA8845@khazad-dum.debian.net>
	 <1172138450.5837.34.camel@localhost.localdomain>
	 <20070222145613.GD25887@khazad-dum.debian.net>
	 <1172157592.5837.89.camel@localhost.localdomain>
	 <20070222163405.GF25887@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 17:08:39 +0000
Message-Id: <1172164119.5837.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 14:34 -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 22 Feb 2007, Richard Purdie wrote:
> > If you really care, add a a call to backlight_update_status() after you
> > set the brightness attribute like some of the other drivers have. The
> 
> I will.  Do you ACK the patch, then?

Yes, it can have an Acked-by: Richard Purdie <rpurdie@rpsys.net>.

> > Have a look at what corgi_bl does. It can know what state it set the
> > hardware too as it keeps track itself, it just can't read that state
> 
> You are assuming nothing else is changing the hardware behind the driver's
> back. 

Which it can't in the corgi_bl case (excluding poking things
like /dev/mem). Its safe to assume it has exclusive access.

>  I am against such assumptions when they can be avoided, but that's a
> particular PoV and not much more than that.  IMHO, if you cannot query the
> hardware, you shouldn't provide a way to query the current brightness that
> will be right only if nobody else messed with the device.
> 
> Maybe for corgi, that doesn't hold much strength, but for stuff tied to
> ACPI, it does.  And in a ThinkPad's case, where even writes to /dev/nvram
> can change the brightness, well, if there weren't a way to ask the EC the
> current real brightness, there is NO way I'd be implementing it based on a
> memory cache.

Right, I'd be against such a driver. On the embedded hardware we can
safely assume there is nothing else playing with the brightness settings
though and such a driver is perfectly valid.

> > > Howerver, I *do* strongly wish for a way to combine various drivers into a
> > > single backlight device, where radeon/intelfb takes care of some stuff,
> > > ibm-acpi/asus-laptop/sony-laptop takes care of other stuff, etc.  Also, a
> > > standard naming for the builtin screen(s) would help, calling it "ibm",
> > > "asus", "sony" is not good IMHO.
> > 
> > I wasn't aware of this problem. If some devices need bits from both
> > raedon/whatever and acpi, the current implementations are just plain
> > wrong. Its not really a backlight class problem and more of an
> > implementation and interaction problem between acpi and the framebuffer
> > drivers. They should be presenting and registering *one* backlight class
> 
> I.e. we should add hooks to the framebuffer drivers?  It would work, that's
> for sure.

If the backlight controls would then power off the backlight properly
that would be desirable as we've have a more standard interface.

Richard

