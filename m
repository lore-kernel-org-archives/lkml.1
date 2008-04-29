Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYD2EsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYD2EsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYD2Erw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:47:52 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:63740
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbYD2Erw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:47:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsBANZFFkh8qMj2/2dsb2JhbAAIrCY
X-IronPort-AV: E=Sophos;i="4.25,720,1199631600"; 
   d="scan'208";a="321700143"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804282044.00706.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <200804281744.11564.david-b@pacbell.net>
	 <1209434284.14631.71.camel@moss.renham>
	 <200804282044.00706.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 29 Apr 2008 14:47:44 +1000
Message-Id: <1209444464.311.25.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 20:44 -0700, David Brownell wrote:
> On Monday 28 April 2008, Ben Nizette wrote:
> >
> > Ah well we're backwards there, though now I think of it I can't think of
> > a great many valid use-cases on my side.  Just for funzies I'll post on
> > the avrfreaks AVR32 support forum and see how many I can actually dig
> > up.
> 
> Use cases would always help clarify things.  I've seen just
> enough to make me understand this is a useful feature, and
> for more reasons than just "feature equality" letting us
> obsolete three drivers/i2c/chips/*.c drivers and help vanish
> half a dozen (at least!) out-of-tree drivers doing that.

Oh yeah, nearly every vendor of small not-a-simple-PC Linux boards would
have their own solution to this problem.  About time they were put to
the knackers.

> 
> The Gumstix user forums and wiki may help too.  ISTR they
> have such a GPIO widget (maybe that's the one I saw which
> supports polling?) and have shipped it for ages ... so they
> will surely have some (PXA-specific) examples lurking.

At a glance there's a bunch of how-to but very little why-to.  Bugger.
In fact their driver looks to be mostly obsoleted by gpio-keys anyway so
not only can't a see a specific use-case of their driver, I can't see
the point of it's existence at all :-/

> 
> 
> > > Trent pointed out that dynamic range assignment can make trouble,
> > > so I can see some help might be needed here.  Were you suggesting
> > > something like a /sys/class/gpio/chips file with contents like
> > > 
> > > 	0-15	gpio
> > > 	16-31	gpio
> > > 	32-47	gpio
> > > 	48-63	gpio
> > > 	192-207	mpuio
> > > 	208-213	tps65010
> > > 
> > > (Matching a stock OMAP 5912 OSK board, for what it's worth.)
> > 
> > Yeah that's the kind of a thing.  Would be well worth having that info
> > especially for dynamically allocated chip bases.
> 
> I'd have no problem with that.  Some people surely would though;
> it has more than one value in that file!  OMG, it's readable! We
> can't have any of that!!  The Earth will turn in its grave!  And
> Slashdot will be decorated in Pink!  Teh End Daze arrive!  :)

xD

Where would the doom mongers prefer it live?  /proc? ;-)

> 
>  
> > > > > The D-space footprint is negligible, except for the sysfs resources
> > > > > associated with each exported GPIO.  The additional I-space footprint
> > > > > is about half of the current size of gpiolib.  No /dev node creation
> > > > > involved, and no "udev" support is needed.
> > > > 
> > > > Which is good for simplicity but makes async notification kinda tricky.
> > > 
> > > Sysfs attributes are supposed to be pollable.  I've not done it,
> > > but fs/sysfs/file.c::sysfs_notify() looks relevant ...
> > 
> > Right, that'll work.
> 
> OK.  In that case, I think I should plan to rename the "direction"
> attribute as "configuration" or something a bit broader ... so that
> writing "irq" (or maybe "rising", "falling", "bothedges", "poll")
> would eventually configure it as an input with an IRQ handler.

Good plan, unless you'd prefer to see "direction" and "interrupt" config
separate.  I have no real preference but IMO
echo "falling" > interrupt
makes more immediate sense than
echo "falling" > configuration

> 
> Whenever someone contributes such an async notification scheme,
> that is.  ;)

;)

--Ben.

> 
> - Dave
