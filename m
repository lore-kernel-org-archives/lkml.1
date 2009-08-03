Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZHCKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZHCKei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZHCKeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:34:37 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55380 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZHCKeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:34:36 -0400
Date: Mon, 3 Aug 2009 12:34:29 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090803123429.390a636f@mjolnir.ossman.eu>
In-Reply-To: <20090731105407.GA31900@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<20090728222334.0c543c47@mjolnir.ossman.eu>
	<20090731122623.254fd0f1@mjolnir.ossman.eu>
	<20090731105407.GA31900@console-pimps.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-16264-1249295673-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-16264-1249295673-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2009 11:54:07 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Fri, Jul 31, 2009 at 12:26:23PM +0200, Pierre Ossman wrote:
> >=20
> > [PATCH 0/32] mmc and omap_hsmmc patches
> > http://marc.info/?t=3D124722953900010&r=3D1&w=3D2
> >=20
> > I haven't looked through these at all. The ones affecting the core
> > probably need some thorough reviews.
> >=20
> > I did notice the patch to say which cards a controller supports though,
> > and I'm very sceptical about that one. The scanning process should work
> > anyway, and the performance impact should be negligible as it is only
> > on init. So that patch only adds complexity and confusion IMO.
> >=20
>=20
> How much complexity does it really add? Surely it's better to give the
> host controller driver writers the ability to not entertain supporting
> some cards if they cannot be used? If they want to avoid the scanning
> process for certain cards, why not let them?
>=20

Let's look at the pros and cons of this:

Con:

 - The scanning code gets less clear as you increase the number of
   possible paths through it.

 - Different systems will have different init sequences, possibly
   provoking bugs in the cards.

 - Host driver writers now have more capability bits they have to
   consider. And these might be less than obvious since SD/MMC/SDIO are
   normally compatible so these bits seem useless.

 - With the current logic (which was better in the first version),
   "normal" drivers will have to explicitly state that they work as
   intended by setting all bits.

Pro:

 - A slightly reduced scanning time.


I simply don't see it as being worth it. Linux patches generally need
to provide the answer to "Why?", not just be able to avoid "Why not?".

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-16264-1249295673-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkp2vTkACgkQ7b8eESbyJLj3MwCgqr4opv7W7elnHGfgXQC5YEkz
G9oAn2Up6CCouEIGRtZ8x92CJmCnSPcK
=544B
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-16264-1249295673-0001-2--
