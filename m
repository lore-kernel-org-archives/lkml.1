Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZCOL2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZCOL2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZCOL2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:28:09 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:52430 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbZCOL2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:28:07 -0400
Date: Sun, 15 Mar 2009 12:27:59 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Message-ID: <20090315122759.3f48ba80@mjolnir.ossman.eu>
In-Reply-To: <200903111428.39831.wolfgang.mues@auerswald.de>
References: <200903111428.39831.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26535-1237116480-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26535-1237116480-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Mar 2009 14:28:39 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o Some SD cards have very high timeouts in SPI mode.
>   So adjust the timeouts from theory to practice.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> ---
> This is one of a line of patches to enhance the usability of
> the mmc spi host port driver from "don't work with most SD cards"
> to "work with nearly all SD cards" (including those ugly cards
> with non-byte-aligned responses).
>=20
> diff -uprN 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c 2_=
6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c
> --- 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c	2009-03-0=
4 02:05:22.000000000 +0100
> +++ 2_6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c	2009-03-=
10 12:06:16.000000000 +0100
> @@ -297,6 +297,21 @@ void mmc_set_data_timeout(struct mmc_dat
>  			data->timeout_clks =3D 0;
>  		}
>  	}
> +	/*
> +	 * Some cards need very high timeouts if driven in SPI mode.
> +	 * The worst observed timeout was 900ms after writing a
> +	 * continuous stream of data until the internal logic
> +	 * overflowed.
> +	 */
> +	if (mmc_host_is_spi(card->host)) {
> +		if (data->flags & MMC_DATA_WRITE) {
> +			if (data->timeout_ns < 1000000000)
> +				data->timeout_ns =3D 1000000000;	/* 1s */
> +		} else {
> +			if (data->timeout_ns < 100000000)
> +				data->timeout_ns =3D  100000000;	/* 100ms */
> +		}
> +	}
>  }
>  EXPORT_SYMBOL(mmc_set_data_timeout);
>=20

In the future, there are macros called NSEC_PER_SEC and similar that
can be used to increase readability instead of the comments.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26535-1237116480-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm85kEACgkQ7b8eESbyJLhWIwCfRa+FF3RH9zD81dp//ccu/LtM
Y8AAoOan4zMRPXHNxBhyA4mW4cjEK5MO
=Ei8q
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26535-1237116480-0001-2--
