Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXEFVmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXEFVmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXEFVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:42:49 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2603 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXEFVmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:42:49 -0400
Date: Mon, 7 May 2007 01:38:29 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, ian <spyro@f2s.com>,
       kernel-discuss@handhelds.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
	(was: battery class)
Message-ID: <20070506213829.GD10236@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <1178372786.3901.4.camel@wirenth> <1609424106.20070505170603@gmail.com> <20070506180604.GA31940@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070506180604.GA31940@khazad-dum.debian.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 03:06:04PM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 05 May 2007, Paul Sokolovsky wrote:
> > Saturday, May 5, 2007, 4:46:26 PM, you wrote:
> > > On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:
> > >> Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> > >> control signaling over the USB bus for power-control purposes),
> > 
> > > it might be dumb, but it is useful to know wether the PDA is charging
> > > from usb or mains power. and some devices allow one to switch on / off
> > > the ability to charge via usb
> > 
> >         And USB does have power budgetting requirements, etc. (like
> > was already pointed in own of initial review messages). So, USB
> > is definitely not the same thing as "dumb DC".
> 
> Everything does.  A dumb DC power source is a dumb DC power source.  USB is
> no different here, *unless* it is using USB signaling to control the power
> link, at which point it is not a dumb DC power source anymore.
> 
> There really is no difference beween an AC brick, a DC brick, an AC/DC
> brick, or an USB port supplying DC power in a dumb way in a laptop or
> handheld: they are all supposed-continous DC power supplies with a maximum
> power budget.
> 
> But the "GUI should show it differently" part does make sense.  I am not
> completely convinced a high number of top-level types is the best way to go
> about it, though.  I'd use subtypes, and a comprehensive enough set of
> standard types and sub-types, along with a description of exactly what they
> are to be used for.  This will make it MUCH easier on the userspace side for
> GUI authors, and it will be much better for people to not use the wrong
> types when converting to the new class...

Um... well, if we'll speak for easiness, then just "type" is more easy and
less error-prone than type + subtype. ;-) So, personally I see nothing
wrong with MAINS/USB/Battery/UPS power supply types. Though, as you may
noticed I'm easy to convince. ;-) So, if you'll elaborate it, I might
finally will see my wrongness.


Just in case I'll be convinced...

.type = POWER_SUPPLY_TYPE_MAINS,
.subtype = POWER_SUPPLY_SUBTYPE_USB,

Looks okay?

.type = POWER_SUPPLY_TYPE_MAINS,
.subtype = POWER_SUPPLY_SUBTYPE_AC,

And SUBTYPE_AC looks not good already, because we indeed tried to
avoid AC/DC meanings in type fields, because current_type attribute
will be better. So, what subtype name we should use?

.type = POWER_SUPPLY_TYPE_BATTERY,
.subtype = POWER_SUPPLY_SUBTYPE_????,

What should be in "????" for plain batteries? Should UPS be
subtype of battery type?

.type = POWER_SUPPLY_TYPE_MAINS,
.subtype = POWER_SUPPLY_SUBTYPE_UPS,

Just wrong.


So, notice that subtype brings complications, not solves them.

Thanks!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
