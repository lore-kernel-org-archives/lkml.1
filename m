Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXKZPsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXKZPsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXKZPsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:48:23 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbXKZPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:48:22 -0500
Subject: Re: [RFC] Documentation about unaligned memory access
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YpCO1EmPixG11+GBGIp6"
Date: Mon, 26 Nov 2007 15:51:43 +0100
Message-Id: <1196088703.4149.266.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YpCO1EmPixG11+GBGIp6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Going back to an earlier example:
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		*((u16 *) data) =3D cpu_to_le32(value);
> 		[...]

typo? should it be a u32 cast?

> To avoid the unaligned memory access, you could rewrite it as follows:
>=20
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		value =3D cpu_to_le32(value);
> 		memcpy(data, value, sizeof(value));
> 		[...]
> 	}

I think you should use put_unaligned here as well. Or maybe just reorder
this vs. the section below where you use get/put_unaligned.

johannes

--=-YpCO1EmPixG11+GBGIp6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rdfKVg1VMiehFYAQIMHw/+NHqAcirhzfhcRP3qIzLRFCUcgbCKLoRb
lfvi3uWi7RLrw2388okzWmLPWJknNUJnIrNkEISunI6RqALUnO9jQnQ0ogSLCSth
OwkTOZ6Bo0EyfO9yJufBLEhhOWTZ7SjAjLESrEA4cI9MxPSkr9grVm3Bix/boBYU
cF5zWiokE4GeymW3Dnh5ce2vgsop7AE6Tn0PfUJiMTQMKEQDCBUa5AB2MTj0FPmS
SLf0f3iKESJqBRheVsf5Jytz+3H8ehJP4zI2alr6JT7KvtoiVrQrRe2gEonNFyLB
YYuO8FulQz7qjHVufyIGqeKEz8i9LKL65q/dpT3nlOI0/YnRKFujdsykRPTgNYIv
yFIAM3ZhusBG2a//fGNKvSfViuRatWgR9T+KxAXYWSHW1/V1MCiZ1yhiQEpw0OFq
1WetdOx+C1AkA8Vqrpb+6bCaz3MO3sa+b+9po54ZM6hAnTJlHpWcdMd0ZjsUBhEP
eCqUXHdTXAwYrsFJ6kxSeSQiaESu1Q+zw9v6s4Co6kpJUkIezggjAU7PnvFX8oWI
oOFihYUmW5g8EugPSuuqZ3WmTXqiG5ggBL4Mzk0AiSZib/UV5F8O0PAA0KFRH0Rb
CjPTAtggrkFeyk1pInXhg2TfkbHcfq5QBQhY9Q3vX7+UJ03Ofopav8zmkpGXZMVa
HunuxZ/LoXs=
=/asZ
-----END PGP SIGNATURE-----

--=-YpCO1EmPixG11+GBGIp6--

