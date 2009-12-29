Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZL2IrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZL2IrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 03:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZL2IrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 03:47:09 -0500
Received: from vps2.mechanicalrealm.com ([66.216.20.21]:51225 "EHLO
	zinan.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZL2IrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 03:47:08 -0500
From: "Luke-Jr" <luke@dashjr.org>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
Date: Tue, 29 Dec 2009 02:46:50 -0600
User-Agent: KMail/1.12.3 (Linux/2.6.32-gentoo; KDE/4.3.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
References: <200912290152.16357.luke@dashjr.org> <87d41yxjx9.fsf@purkki.valot.fi>
In-Reply-To: <87d41yxjx9.fsf@purkki.valot.fi>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912290246.57663.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009 02:29:22 am Kalle Valo wrote:
> "Luke-Jr" <luke@dashjr.org> writes:
> > Tested on Nokia N810 in Linux-OMAP tree. Mainline is not bootable yet.
> 
> What's the problem in mainline? I haven't tested n8x0 for months :(

Lack of platform support, as far as I know.
Until we have cbus, there's no way to get the LCD powered...

> > --- a/arch/arm/mach-omap2/Kconfig
> > +++ b/arch/arm/mach-omap2/Kconfig
> > @@ -117,6 +117,11 @@ config MACH_NOKIA_N8X0
> >  	select MACH_NOKIA_N810
> >  	select MACH_NOKIA_N810_WIMAX
> >
> > +config MACH_NOKIA_N8X0_USB
> > +	bool
> > +	depends on MACH_NOKIA_N8X0 && MACH_OMAP2_TUSB6010
> > +	default y
> > +
> 
> Is is really needed to add new kconfig variable? Can't we just use
> MACH_OMAP2_TUSB6010 in code?
> 
> I think a separate file is not needed, it's not that much code. I
> recommend to just adding it directly to board-n8x0.c. It's simple and
> easier for everyone.

Seemed simpler to manage in a separate file, though not as necessary as the 
LCD stuff (which I also have a patch against mainline for, but it needs 
tahvo...)

> > --- a/arch/arm/mach-omap2/board-n8x0.c
> > +++ b/arch/arm/mach-omap2/board-n8x0.c
> > @@ -109,8 +109,16 @@ static void __init n8x0_init_irq(void)
> >  	omap_gpio_init();
> >  }
> >
> > +#ifdef CONFIG_MACH_NOKIA_N8X0_LCD
> > +extern void n8x0_usb_init(void);
> > +#else
> > +static inline void n8x0_usb_init (void) {}
> > +#endif
> 
> CONFIG_MACH_NOKIA_N8X0_LCD does not look right here.

Heh, looks like my isolate-and-merge-to-mainline got messed up there.
Of course it should be CONFIG_MACH_NOKIA_N8X0_USB :)

Also, scripts/checkpatch.pl gave me a warning about the extern in a .c file, 
but I couldn't figure out where else it could reasonably go. Any ideas? :/

Luke
