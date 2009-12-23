Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZLWTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZLWTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZLWTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:01:58 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:51815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZLWTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:01:57 -0500
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
 issue and mac80211 suspend corner) case
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <20091223162813.GB2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
	 <20091222193010.GB30201@bombadil.infradead.org>
	 <1261570081.25008.1.camel@johannes.local>  <20091223162813.GB2609@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lYhv/jeqb8p3t5dteYCW"
Date: Wed, 23 Dec 2009 17:47:08 +0100
Message-ID: <1261586828.7304.13.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lYhv/jeqb8p3t5dteYCW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 08:28 -0800, Luis R. Rodriguez wrote:

> > Well it seems to me that if the driver determines that the hardware
> is
> > unreachable or not responding, it would unregister it from mac80211,
> > which would clean up all user-visible state, obviously.
>=20
> The drivers would not know this until it fails on the first call
> from mac80211 which would be start().

Which is why this patch may be a good way to solve that particular
problem.

> > The patch above seems ok to me, but basically papers over the
> problem.
> > If the start there fails, the driver will have to unregister the hw
> > since any subsequent start will fail as well.
>=20
> How about just having mac80211 do that for drivers where the start()
> fails and we are resuming? I can give that a shot.

No way, the driver will invariably assume things are still going and
might later unregister etc. Too much magic.

johannes

--=-lYhv/jeqb8p3t5dteYCW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMkmIAAoJEODzc/N7+QmatxUP/2EHkMmAm9omk8AOwVjX2rNj
7SSKyHsrZUNToQJSVNuY0rf2nI6/rLwbJVw4EjxOQT1DZWYfaSGjpgBcDl7l49So
O/ZjFXIY+p52zVBb4AWVJ3WQpqa9xx3dzCPrVnpGjSP0DDwF+3h5Wexe9uojVpo0
QROLaaDNvUw5DGNOaHfdDoZcg68wcfF3rWZInvA3S5oHsBy8H26O7GS7B6SHehA+
mQIflkuA8zEAylOXXUS1bdJa1hYyLadD7p1HhLJllltCMn6fuLeXQY3fEQnUsDGi
mA7okApjV2oNHjGuexvazmQR5GMFqx+y5wzQu68ley80T1b71choEgx80+m4J2zx
h32EqQ+0JzyjwJ4kTLbYbkNDELcTI38kBaaNcMgJV9AcuJcwUzUYWQp0n/f4rId3
glmIRkgZ8JOlolPh2D4aEArafOMYppvmiKxsCXJ23dnFM9LAPwraUVJvOO5rwNQw
eJg4kisVSmCrL20dy0gqJ24Ot9ChNJXHVj7IJKSfpi+KdZZxPsshqAK3vNSMgwrl
k8EleRx2vgR1QGDkpv2zjjLQSfsqvOefz26av2e6SwuGchFtSCXFlxICLQs4doKb
8zWzzvQqzzb4YLVmXjSOpuozabYs7ZRIBxt+dH3DdVDraf5Ww3sBTVTLeaO+ZpoQ
4w3nQx28HQpTOHt6oZ1/
=bMkg
-----END PGP SIGNATURE-----

--=-lYhv/jeqb8p3t5dteYCW--

