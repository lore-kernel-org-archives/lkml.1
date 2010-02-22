Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0BVVYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:24:01 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59178 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab0BVVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:23:59 -0500
X-Sasl-enc: pc3ajSYhZaoTrp6+XMZUQwezVeH64DfwnJcOFuaXsTKj 1266873838
Message-ID: <4B82F5A4.1010901@imap.cc>
Date: Mon, 22 Feb 2010 22:22:44 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 02/11] drivers: isdn: use new hex_to_bin() method
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com> <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com> <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF340A785094DF792C6EAAB7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF340A785094DF792C6EAAB7C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 22.02.2010 19:09 schrieb Andy Shevchenko:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>=20
> Get rid of own implementation of hex_to_bin().
>=20
> Please note it requires to have hex_to_bin() introduced by one of previ=
ous
> patch [1] which is not applied yet.
>=20
> [1] http://patchwork.kernel.org/patch/80404/
>=20
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Tilman Schmidt <tilman@imap.cc>

Acked-by: Tilman Schmidt <tilman@imap.cc>

> ---
>  drivers/isdn/gigaset/capi.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index 3f5cd06..532ca33 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -183,17 +183,6 @@ static inline int ishexdigit(char c)
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
> @@ -204,7 +193,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)=

>  	while (*in) {
>  		if (!ishexdigit(in[0]) || !ishexdigit(in[1]) || l >=3D maxlen)
>  			return -1;
> -		out[++l] =3D (hex2bin(in[0]) << 4) + hex2bin(in[1]);
> +		out[++l] =3D (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
>  		in +=3D 2;
>  	}
>  	out[0] =3D l;

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF340A785094DF792C6EAAB7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuC9bIACgkQQ3+did9BuFvBdQCcCOItgWXKsbPamQ+a6j1T5Cc4
dKgAnRJIfJusgosvI6g0NPRXo2diS1I1
=nfD4
-----END PGP SIGNATURE-----

--------------enigF340A785094DF792C6EAAB7C--
