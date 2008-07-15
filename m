Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYGOOYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYGOOYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760517AbYGOOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:23:58 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5597 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757906AbYGOOX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:23:56 -0400
Date: Tue, 15 Jul 2008 18:23:54 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080715142354.GA3296@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080715123822.GA10893@polina.dev.rtsoft.ru> <20080715124013.GA13086@polina.dev.rtsoft.ru> <1216126470.5345.55.camel@dax.rpnet.com> <20080715132438.GA26648@polina.dev.rtsoft.ru> <1216128687.5345.61.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1216128687.5345.61.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:31:27PM +0100, Richard Purdie wrote:
> On Tue, 2008-07-15 at 17:24 +0400, Anton Vorontsov wrote:
> > On Tue, Jul 15, 2008 at 01:54:30PM +0100, Richard Purdie wrote:
> > > I don't have any issue with the driver itself, just the name which is
> > > going to confuse people no end.
> > > 
> > > Can we come up with a better name for this driver please?
> [...]
> > > "openfirmware-led"?
> > 
> > And this would be wrong, since this driver is for GPIO LEDs only, not
> > for all LEDs that OF can describe. In future there could be OF PWM LEDs
> > or something like this.
> 
> Ok, will these be a separate driver or combined into the gpio driver?

I believe this must be a separate driver. The two drivers would have
nothing in common except prologue registration stuff.

> > > I'm mainly concerned with the more user visible bits like the name of
> > > the .c file, the wording of the Kconfig option and the module
> > > description. We need to play down the GPIO bit and play up the
> > > openfirmware bindings bit.
> > 
> > Hm... file name is leds-of-gpio.c, how could I play up the "of" bit more
> > than this? ;-)
> 
> Spell out openfirmware :). I initially had no idea "of == openfirmware"
> and I suspect others won't either...

This would be unusually long name, that is

$ find . -iname '*openfirmware*' | wc -l
0

And in contrast:

drivers/video/offb.c
drivers/video/nvidia/nv_of.c
drivers/usb/host/ohci-ppc-of.c
drivers/usb/host/ehci-ppc-of.c
drivers/serial/of_serial.c
drivers/mtd/maps/physmap_of.c
...

So, I think we should stick with the "of" for consistency, while
confused users may consult with Kconfig for disambiguation.

But if you really want the expanded name.. just repeat it, and I'll
change the name.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
