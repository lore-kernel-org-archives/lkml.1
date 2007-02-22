Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXBVQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXBVQeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXBVQeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:34:17 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47752 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbXBVQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:34:14 -0500
X-Sasl-enc: c2Zk+SzuCxLBFNaGHIyu3fiUR350/uD3ewoN2FnzDGoN 1172162140
Date: Thu, 22 Feb 2007 14:34:05 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222163405.GF25887@khazad-dum.debian.net>
References: <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net> <20070222011017.GA8845@khazad-dum.debian.net> <1172138450.5837.34.camel@localhost.localdomain> <20070222145613.GD25887@khazad-dum.debian.net> <1172157592.5837.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172157592.5837.89.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Richard Purdie wrote:
> If you really care, add a a call to backlight_update_status() after you
> set the brightness attribute like some of the other drivers have. The

I will.  Do you ACK the patch, then?

> Have a look at what corgi_bl does. It can know what state it set the
> hardware too as it keeps track itself, it just can't read that state

You are assuming nothing else is changing the hardware behind the driver's
back.  I am against such assumptions when they can be avoided, but that's a
particular PoV and not much more than that.  IMHO, if you cannot query the
hardware, you shouldn't provide a way to query the current brightness that
will be right only if nobody else messed with the device.

Maybe for corgi, that doesn't hold much strength, but for stuff tied to
ACPI, it does.  And in a ThinkPad's case, where even writes to /dev/nvram
can change the brightness, well, if there weren't a way to ask the EC the
current real brightness, there is NO way I'd be implementing it based on a
memory cache.

> from the hardware. Note how there is extra code in it to handle a power
> limit on the backlight under certain conditions and how this is fed back
> through the class through the get_brightness method.

I will read the corgi driver code, it looks interesting.

> Adding one line of code (admittedly slight more due to error handling),
> is hardly that much code duplication.

No, it really isn't much trouble.  Which is why I wrote a patch right away.

> > Howerver, I *do* strongly wish for a way to combine various drivers into a
> > single backlight device, where radeon/intelfb takes care of some stuff,
> > ibm-acpi/asus-laptop/sony-laptop takes care of other stuff, etc.  Also, a
> > standard naming for the builtin screen(s) would help, calling it "ibm",
> > "asus", "sony" is not good IMHO.
> 
> I wasn't aware of this problem. If some devices need bits from both
> raedon/whatever and acpi, the current implementations are just plain
> wrong. Its not really a backlight class problem and more of an
> implementation and interaction problem between acpi and the framebuffer
> drivers. They should be presenting and registering *one* backlight class

I.e. we should add hooks to the framebuffer drivers?  It would work, that's
for sure.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
