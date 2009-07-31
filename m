Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZGaK0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZGaK0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZGaK0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:26:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35137 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZGaK02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:26:28 -0400
Date: Fri, 31 Jul 2009 12:26:23 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090731122623.254fd0f1@mjolnir.ossman.eu>
In-Reply-To: <20090728222334.0c543c47@mjolnir.ossman.eu>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<20090728222334.0c543c47@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-2171-1249035986-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-2171-1249035986-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This things are currently lingering in my inbox:

[PATCH 1/1] MMC: SDIO card reset support for Intel Moorestown  platform
http://lkml.org/lkml/2009/6/16/269

SDIO cards have a global reset that in theory might be useful. I'm not
sure it is in practice though as it is a very blunt instrument and it
has created some problems in the past.

A PCI equivalent to this reset would be resetting an entire PCI card,
making it and every subfunction fall off the bus and come back again.
The complexity of handling this can be high since every subfunction
needs to be involved.

The patch above adds new callbacks to handle this, but I think it can
proabably be handled as a normal removal/insertion. This reset should
only be used as a last resort anyway.

Lastly, using this reset method might not even be useful. The libertas
guys tried using it to get back a wedged card, but they did not have
much success.

I recommend holding off on this functionality until someone can show
that the added functionality is worth the complexity.

[PATCH 1/2] MMC Agressive clocking framework
http://marc.info/?l=3Dlinux-arm-kernel&m=3D124394660502578&w=3D2
(and several subsequent versions)

I like this idea and it should be merged. What I didn't like about the
initial versions were that the MMC core was too involved with low level
decisions in drivers. IMO (and the PM guys from what I can tell) the
drivers should automatically do relevant PM stuff, only restricted by
what the MMC core has told the driver should be going on on the bus.

The missing piece here was that the core needed to tell the drivers
when they could turn off the clock on the bus. This can be difficult as
some cards need the clock to drive their internal logic for writes
(although this is in violation of the specs). This means the clock
needs to be left running some time after a request.

There are also a bunch of drivers that tries to do this themselves, and
often without the delay. These should be fixed to leave such decisions
to the core.

[PATCH] mmc: prevent dangling block device from accessing stale queues
http://marc.info/?l=3Dlinux-kernel&m=3D124413857119112

This one is more fun as it requires digging into the block layer. :/

The thread above describes the problem so I'm not going to reiterate it
here. The short summary of why I don't want the patch though is that I
believe it papers over the problem and doesn't solve it. I've been
meaning to look further into the issue, but if someone else has the
time then please go digging.

[PATCH 1/2] atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)
http://marc.info/?l=3Dlinux-arm-kernel&m=3D124577578729455

This is nice work and it's really up to Nicolas when he wants it merged.

[PATCH] DaVinci: MMC: V5: MMC/SD controller driver for DaVinci family.
(couldn't find an archive)

This driver has undergone some reviews and should be more or less done.
Please check the previous review comments to confirm that everything
has been fixed.

[PATCH] mmc_spi: fail gracefully if host or card do not support the switch =
command
http://marc.info/?l=3Dlinux-kernel&m=3D124473347118158

This is to work around buggy cards. I'm not convinced the problem is
fully understood yet though so I need to look more at this.

MMC driver for HTC Dream
http://marc.info/?t=3D124631240200002&r=3D1&w=3D2

This is a new driver that needs a review. It seems to make the
classical mistakes, so have a look at my earlier driver reviews to see
what to look for.

[PATCH] MMC Core: Drop initialization frequency floor to 50kHz
http://lkml.org/lkml/2009/7/1/529

The initial patch wasn't very good, but lowering the
speed to 350 kHz should be okay. A new patch is needed and probably
some testing in -next.

[PATCH] MMCI: use AMBA bus accessors
http://marc.info/?t=3D124689780400003&r=3D1&w=3D2
http://marc.info/?t=3D124689978900001&r=3D1&w=3D2
http://marc.info/?t=3D124689956700005&r=3D1&w=3D2
http://marc.info/?t=3D124689959900002&r=3D1&w=3D2

Should probably all be merged.

[PATCH] Add support for debugging MMC channel individually.
http://list.drzeus.cx/pipermail/sdhci-devel/2009-July/002713.html

I agree with Marcel. This kind of fine grained control belongs in
debugfs.

[PATCH] sdio: do not ignore MMC_VDD_165_195
http://marc.info/?t=3D124764000300001&r=3D1&w=3D2

There has already been some discussions around this, and quite
correctly the bit this patch wants to use is undefined.

Restoring back the system state from MMC after a successful hibernation
http://marc.info/?t=3D124818534700003&r=3D1&w=3D2

I don't agree with this approach. The point of the workqueue is so that
the kernel can do things in parallel, so this patch is a step back. The
problem is really with how the kernel doesn't properly cope with
asynchronous disk scanning during bootup. The root_delay parameter was
added for this for the "normal" case, but it seems more work is needed.

move mmci-omap-hs's probe function to .devinit.text
http://marc.info/?t=3D124734613000001&r=3D1&w=3D2

Second patch is probably okay, but the maintainers need to respond.

[PATCH 0/32] mmc and omap_hsmmc patches
http://marc.info/?t=3D124722953900010&r=3D1&w=3D2

I haven't looked through these at all. The ones affecting the core
probably need some thorough reviews.

I did notice the patch to say which cards a controller supports though,
and I'm very sceptical about that one. The scanning process should work
anyway, and the performance impact should be negligible as it is only
on init. So that patch only adds complexity and confusion IMO.


I think that's it, but don't be afraid to search the archives for
anything else that doesn't seem to have been getting any attention.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-2171-1249035986-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpyxtMACgkQ7b8eESbyJLhCjgCgo49LNSsFERnoZOgD3WUmEyzK
/3oAn230LPx7NNWWwupZu7rZa9/fcJNj
=1MkV
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-2171-1249035986-0001-2--
