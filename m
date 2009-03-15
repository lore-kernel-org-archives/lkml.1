Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZCOLo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZCOLo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZCOLor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:44:47 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49186 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZCOLoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:44:46 -0400
Date: Sun, 15 Mar 2009 12:44:39 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/7] mmc_spi: documentation enhancement
Message-ID: <20090315124439.65ba16ff@mjolnir.ossman.eu>
In-Reply-To: <200903121106.37557.wolfgang.mues@auerswald.de>
References: <200903121106.37557.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26925-1237117480-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26925-1237117480-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 11:06:37 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o Document the various pitfalls of SD cards in SPI mode.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> ---
> diff -uprN 2_6_29_rc7_patch7_unaligned_responses/drivers/mmc/host/mmc_spi=
.c 2_6_29_rc7_patch8_documentation/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch7_unaligned_responses/drivers/mmc/host/mmc_spi.c	2009=
-03-11 13:51:25.000000000 +0100
> +++ 2_6_29_rc7_patch8_documentation/drivers/mmc/host/mmc_spi.c	2009-03-12=
 10:54:24.000000000 +0100
> @@ -68,6 +68,20 @@
>   *   during that time ... at least on unshared bus segments.
>   */
> =20
> +/* PITFALLS:
> + *
> + * - SD card benchmarking is done in 4 bit SD mode. Nobody care about
> + *   speed in SPI mode. So expect less throughput and longer timeouts
> + *   as in SD mode. (See core.c:mmc_set_data_timeout()).
> + * - SPI imposes a byte-aligned protocol. Expect that SD cards violate
> + *   this requirement for ALL responses:
> + *   - response after command
> + *   - data token up to CRC for read blocks
> + *   - token response after a write block

Perhaps you should elaborate on why this is (not everyone knows that
the native protocol isn't byte aligned).

> + * - Expect that the delay (in bits) will vary according to the
> + *   buffer fill grade in the SD card controller.
> + * - Expect that CRC16 is only working for full 512 byte data blocks.

This is a bit premature as so far it's only the CSD and CID that have
been found to violate the CRC requirement. And that's somewhat expected
as those are probably precomputed and stored on the card (and someone
forgot to update them).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26925-1237117480-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm86ioACgkQ7b8eESbyJLhIuwCgvQfVsy1yrM1Oeaxk1kh+xNp9
+xwAoMe7Wa9UPXuFlRzLtwF0lybRJ0YG
=Hxr6
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26925-1237117480-0001-2--
