Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZCOLhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZCOLhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZCOLhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:37:23 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60749 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbZCOLhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:37:22 -0400
Date: Sun, 15 Mar 2009 12:37:15 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] mmc_spi: convert timeout handling to jiffies and
 avoid busy waiting
Message-ID: <20090315123715.70490281@mjolnir.ossman.eu>
In-Reply-To: <200903111435.03196.wolfgang.mues@auerswald.de>
References: <200903111435.03196.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26888-1237117036-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26888-1237117036-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Mar 2009 14:35:03 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> @@ -816,8 +819,11 @@ mmc_spi_data_do(struct mmc_spi_host *hos
>  	else
>  		clock_rate =3D spi->max_speed_hz;
> =20
> -	timeout =3D ktime_add_ns(ktime_set(0, 0), data->timeout_ns +
> -			data->timeout_clks * 1000000 / clock_rate);
> +	timeout =3D data->timeout_ns +
> +		  data->timeout_clks * 1000000 / clock_rate;
> +	timeout =3D usecs_to_jiffies((unsigned int)(timeout / 1000));
> +	if (!timeout)
> +		timeout =3D 1;
> =20

Does this round properly upwards? Having a timeout 6 ms shorter than it
should be can be a real problem (although the huge timeout your other
patch introduces means we probably won't be affected by it).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26888-1237117036-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm86G0ACgkQ7b8eESbyJLgoWACdEnp97moMJ1Dt8gdLueurqpD4
4SsAoKHqKE4OJuyezwZasZ97pzeCaznX
=yZ5N
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26888-1237117036-0001-2--
