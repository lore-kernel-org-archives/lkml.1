Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0BLOB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:01:29 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39592 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab0BLOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:01:16 -0500
Date: Fri, 12 Feb 2010 11:55:36 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Simon Raffeiner <sturmflut@lieberbiber.de>,
       Andrey Yurovsky <andrey@cozybit.com>,
       Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] nl80211: does not allow NEW_STATION and DEL_STATION
 for mesh
Message-ID: <20100212135535.GA1123@holoscopio.com>
References: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
 <1265978993.15701.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1265978993.15701.0.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 12, 2010 at 01:49:53PM +0100, Johannes Berg wrote:
> On Fri, 2010-02-12 at 10:37 -0200, Thadeu Lima de Souza Cascardo wrote:
> > As discussed in linux-wireless mailint list, adding and removing
> > stations for mesh topologies is not necessary. Since doing it triggers
> > bugs, the sugestion was to simply disable it.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Simon Raffeiner <sturmflut@lieberbiber.de>
> > Cc: Andrey Yurovsky <andrey@cozybit.com>
> > Cc: Javier Cardona <javier@cozybit.com>
> > ---
> >  net/wireless/nl80211.c |   47
> > +++++++++++------------------------------------
> >  1 files changed, 11 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index 5b79ecf..176b8fe 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -2001,6 +2001,10 @@ static int nl80211_new_station(struct sk_buff
> > *skb, struct genl_info *info)
> > =20
> >  	memset(&params, 0, sizeof(params));
> > =20
> > +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP &&
> > +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN)
> > +		return -EINVAL;
> > +
> >  	if (!info->attrs[NL80211_ATTR_MAC])
> >  		return -EINVAL;
>=20
> You clearly didn't ever try this code.
>=20
> johannes

Sorry. This code has obviously given me an oops. I did it in a hurry and
thought that was a good optimization to get out as early as possible in
the case the device was not in AP mode.

I have fixed it, but I would like to do a more thorough test now to make
up for my mistake.

So, is there any test tool around? I am playing with iw code to do
these tests. Any recommendations for the values of listen interval and
the acceptable values for supported rates and aid?

Regards,
Cascardo.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt1XdcACgkQyTpryRcqtS3MZgCgh2U6J+8r7ZzPBR0Y1+d6lpAg
JJYAn3S8wpVAqkYZNLnOA0Xs2cp7sIoW
=9QTc
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
