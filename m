Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0BLMt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:49:59 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0BLMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:49:57 -0500
Subject: Re: [PATCH] nl80211: does not allow NEW_STATION and DEL_STATION
 for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Simon Raffeiner <sturmflut@lieberbiber.de>,
       Andrey Yurovsky <andrey@cozybit.com>,
       Javier Cardona <javier@cozybit.com>
In-Reply-To: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
References: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3wVqaaHbXD/05HssIm7p"
Date: Fri, 12 Feb 2010 13:49:53 +0100
Message-ID: <1265978993.15701.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3wVqaaHbXD/05HssIm7p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-12 at 10:37 -0200, Thadeu Lima de Souza Cascardo wrote:
> As discussed in linux-wireless mailint list, adding and removing
> stations for mesh topologies is not necessary. Since doing it triggers
> bugs, the sugestion was to simply disable it.
>=20
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Simon Raffeiner <sturmflut@lieberbiber.de>
> Cc: Andrey Yurovsky <andrey@cozybit.com>
> Cc: Javier Cardona <javier@cozybit.com>
> ---
>  net/wireless/nl80211.c |   47
> +++++++++++------------------------------------
>  1 files changed, 11 insertions(+), 36 deletions(-)
>=20
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 5b79ecf..176b8fe 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2001,6 +2001,10 @@ static int nl80211_new_station(struct sk_buff
> *skb, struct genl_info *info)
> =20
>  	memset(&params, 0, sizeof(params));
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP &&
> +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN)
> +		return -EINVAL;
> +
>  	if (!info->attrs[NL80211_ATTR_MAC])
>  		return -EINVAL;

You clearly didn't ever try this code.

johannes

--=-3wVqaaHbXD/05HssIm7p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLdU5tAAoJEODzc/N7+QmaqgEP/Am0ArPMTyGOmH8vEv5n/p2S
eXFyHL389BgbiLvfgrmdBiY6lqTU8vaMlUD0gCJlPurPOMTgPMdQeRPD004KDjj4
0mmf7zHMZh+4cVTY+Uip5DBhUlzIIXGTZSTmB5nSxbU9I452LFcp59Szc9L/rIk6
ilWzhvtJf/bgzGngal3DM21RtU/CBZtRoa97Smw+8tGBRLWeIJ9Rm4uie73DD2Nn
rUk9+8gvZN7WSjzSDv0lVbw+6WjovsBPeUvlMiaMaVh9XUIN0isiq+q6wthAdBEe
m/1M0izbyyc5vQLXrfrj5mXO4huz206J3tDMHFfcEuSPaeRL9xFr8tJhTMduVIBs
yrsLXtKjBNOWiknO5372l771AGdj4+yRRFlfjOyR6Spum/tVI9iF/k6puFX5xBaB
0MCCcQMBntfCOWEi7mRKoUdcoguZiSykNbsSx5Vf+VgIqWhpCjbiTFQ1ym2xsmzh
01G7JBjXR7gz4qyguK+lLCihfzpWcEA05XTTJ7DQggQ7plBv5YunjL9SSP06tAMh
zupnl3FwXvnYzhz+uyL+wmXuiGfb7jGgLEKziredg8YK+fQPlnca52ewFLDvPqr+
9N7iD8V0tfsFRpH5/bZ5VY6rSjvnCXpsg62bwv5RewWcKG8axZ1nM5RIibtXOHCV
8+g4O9H9ILHwH1YfSfr4
=0dmA
-----END PGP SIGNATURE-----

--=-3wVqaaHbXD/05HssIm7p--

