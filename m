Return-Path: <linux-kernel-owner+w=401wt.eu-S938013AbZDJWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938013AbZDJWKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934834AbZDJWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:10:37 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45674 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZDJWKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:10:36 -0400
Date: Sat, 11 Apr 2009 00:10:30 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
Message-ID: <20090411001030.56e247c4@mjolnir.ossman.eu>
In-Reply-To: <200904081155.53173.wolfgang.mues@auerswald.de>
References: <200904081155.53173.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-20312-1239401431-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-20312-1239401431-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2009 10:55:53 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o This patch adds a propper retry managment for reading
>   and writing data blocks for mmc and mmc_spi. Blocks are
>   retransmitted 2 times in case of a transmission failure.
>   This patch was tested with induced transmission errors
>   by ESD pulses (and survived).
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

NAK. Writes cannot be retried safely as upper layers rely on the fact
that writes fail in a linear manner (a stupid assumption IMO, but
that's the way things are).

> +		/* Invalid response. This is most likely a transmission
> +		 * error from card to host.
> +		 */
> +		case -EINVAL:

EINVAL is actually "host controller driver/hardware does not support
this type of request".

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-20312-1239401431-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknfw9kACgkQ7b8eESbyJLgTpwCgg/79/kMozW2fTEaRwiAvJjdM
WQQAoKiwnDkjr2A5wBHozYa9GlifA+zf
=X1+I
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-20312-1239401431-0001-2--
