Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZF3TCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZF3TCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZF3TCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:02:39 -0400
Received: from ru.mvista.com ([213.79.90.228]:21999 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752596AbZF3TCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:02:38 -0400
Date: Tue, 30 Jun 2009 23:02:39 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090630190239.GA21667@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021730.44f86185@mycelium.queued.net>
 <20090630113135.GD13961@sirena.org.uk>
 <20090630110430.6c7c5cdf@mycelium.queued.net>
 <20090630153719.GA13300@oksana.dev.rtsoft.ru>
 <20090630155713.GG13961@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090630155713.GG13961@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 04:57:14PM +0100, Mark Brown wrote:
> On Tue, Jun 30, 2009 at 07:37:19PM +0400, Anton Vorontsov wrote:
> > On Tue, Jun 30, 2009 at 11:04:30AM -0400, Andres Salomon wrote:
> 
> > > As far as the slow type, I don't see the need either, but I assumed
> > > Anton was aware of devices that differentiated between slow and
> > > trickle charging.
> 
> > Yep, there are two charging modes in Openmoko Neo FreeRunners:
> 
> > - 100 mA. It's "slow" mode -- used when the Neo couldn't negotiate
> >   with USB host, so it is permitted to only draw 100 mA from VBUS.
> 
> I strongly suspect you will find that the "slow" mode there is actually
> a trickle charge.  It's a lot more practical to trickle charge in mobile
> phone sized systems since the batteries are so much smaller than laptop
> batteries. 

Could be.

Anyway, I was curious what terminology is used in specs, and so
I took a look at pcf50633 spec.

"When a suitable adapter or USB supply is detected, the battery is
 charged with a constant precharge current (CC mode). The constant
 current is selected via the prechgcur bits
 ...
 For a Li-ion battery, the precharge current is typically 0.1C
 (C = charge rate = the charge current which will fully charge the
 battery in one hour)."

And then what is "fast" charge in pcf50633:

"Fast charging of a battery is only permitted within a certain
 temperature window (typically between 0 and 50 °C).
 ...
 If charging is via the adapter, the fast charge current is
 determined by the fstchgcur1 bit settings. If charging is via
 the USB connector, bits fstchgcur2 determine the fast charge
 current. For a Li-Ion battery, the fast-charge current is
 typically between 0.7 C and 1.0 C."

There is also precharge-wait and fastcharge-wait modes, FWIW.
But we don't expose this information to the userspace.

> > - 500/1000 mA. It's so-called "fast" mode, can be enabled after
> >   successful negotiation with the USB host.
> 
> Even if the 500mA is available you'll not always be able to do a fast
> charge from a USB supply - some systems draw enough current to require
> that the USB supply be suppliemented from battery when they're being
> heavily used.

True. Though, for these cases there is an AC charger that can
do 2A. ;-)

> > Well, this kind slow charging isn't official terminology, and
> > I'm not sure if we should use it. But I'm fine with it since we
> > can always remove "Slow" mode (i.e. report it as "Fast"), and
> > userspace won't break.
> 
> I guess my main question was if it was distinguishable from trickle
> charging.

Probably not, Fast/Slow/Trickle are quite vague terms anyway.
I'd prefer if we could measure this in some real units, but alas...


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
