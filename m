Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZBUOQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZBUOQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 09:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZBUOQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 09:16:33 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:39838 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbZBUOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 09:16:32 -0500
Date: Sat, 21 Feb 2009 15:16:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver - revised
Message-ID: <20090221151621.34125c6a@mjolnir.ossman.eu>
In-Reply-To: <200902091253.57594.wolfgang.mues@auerswald.de>
References: <20090113015904.606e3548.akpm@linux-foundation.org>
	<200901261418.19681.wolfgang.mues@auerswald.de>
	<20090208204452.0ecdb18e@mjolnir.drzeus.cx>
	<200902091253.57594.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-14192-1235225789-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-14192-1235225789-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Feb 2009 12:53:57 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

>=20
> Hmmm. Inside the core, this timeout value will be calculated as:
>=20
> timeout =3D 250ms;
> if (driver =3D=3D SPI)
>    timeout =3D 1s;
>=20
> I agree that it is confusing to have the timeout value set on two places.
> Do you prefer to have it set in the mmc core, different for SPI and non-S=
PI?
>=20

Yes please. With a comment though.

> > > -	if (host->mmc->use_spi_crc) {
> > > +	/*
> > > +	 * Omit the CRC check for CID and CSD reads. There are some SDHC
>=20
> > Hmmm... I think this also better handled in the core. Reorder things in
> > the init to not turn CRC checks on until after those registers have
> > been read.
>=20
> No! CRC checks are ONLY disabled for CID and CSD reads, NOT for the readi=
ng of=20
> data blocks. And I don't want to set use_spi_scc =3D=3D 0 because I don't=
 want to=20
> disable the safety of CRC for data blocks.
>=20

I said reorder, not remove. :)

I.e. move the call to mmc_spi_set_crc() to after the CID and CSD have
been read. Again with a comment explaining the issue.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-14192-1235225789-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgDLoACgkQ7b8eESbyJLgDWwCg3bj5u225/9g9MHTVjKcMuGCV
RIMAn2HDo4OM3dmO/6vDl3GIwUNr5k7a
=qcSe
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-14192-1235225789-0001-2--
