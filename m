Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0BRX4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:56:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46182 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab0BRX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:56:03 -0500
X-Sasl-enc: oZFMcPT4Z1bMShb7y5wxWaLe7ssgRlQDlcsak1HxA+Je 1266537362
Message-ID: <4B7DD363.4050402@imap.cc>
Date: Fri, 19 Feb 2010 00:55:15 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 11/12] drivers: isdn: use new hex_to_bin() method
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-10-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-11-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-12-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1266519351-3218-12-git-send-email-andy.shevchenko@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4B236CC9EA051866F6287B3E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4B236CC9EA051866F6287B3E
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 18.02.2010 19:55 schrieb Andy Shevchenko:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>=20
> Get rid of own implementation of hex_to_bin(). It requires to have hex_=
to_bin()
> introduced by one of previous path in series.
>=20
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/isdn/gigaset/capi.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index 83c4e2f..72adcfb 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -13,6 +13,7 @@
> =20
>  #include "gigaset.h"
>  #include <linux/ctype.h>
> +#include <linux/kernel.h>
>  #include <linux/isdn/capilli.h>
>  #include <linux/isdn/capicmd.h>
>  #include <linux/isdn/capiutil.h>

You don't need to include kernel.h here, it's already included
from gigaset.h.

> @@ -169,17 +170,6 @@ static inline void ignore_cstruct_param(struct car=
dstate *cs, _cstruct param,
>  }
> =20
>  /*
> - * convert hex to binary
> - */
> -static inline u8 hex2bin(char c)
> -{
> -	int result =3D c & 0x0f;
> -	if (c & 0x40)
> -		result +=3D 9;
> -	return result;
> -}
> -
> -/*
>   * convert an IE from Gigaset hex string to ETSI binary representation=

>   * including length byte
>   * return value: result length, -1 on error
> @@ -190,7 +180,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)=

>  	while (*in) {
>  		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >=3D maxlen)
>  			return -1;
> -		out[++l] =3D (hex2bin(in[0]) << 4) + hex2bin(in[1]);
> +		out[++l] =3D (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
>  		in +=3D 2;
>  	}
>  	out[0] =3D l;

Otherwise, fine with me.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4B236CC9EA051866F6287B3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkt902MACgkQQ3+did9BuFtcqQCdEfn4K7OyXJXIK0rm4qFePy3M
JoQAn3TfsypSls5WVPRgrDUR01VAHVLs
=LFJG
-----END PGP SIGNATURE-----

--------------enig4B236CC9EA051866F6287B3E--
