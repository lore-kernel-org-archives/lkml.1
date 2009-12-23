Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZLWMIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZLWMIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZLWMII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:08:08 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:57072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZLWMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:08:07 -0500
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
 issue and mac80211 suspend corner) case
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <20091222193010.GB30201@bombadil.infradead.org>
References: <20091222022355.GA32508@bombadil.infradead.org>
	 <20091222193010.GB30201@bombadil.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FEv9z7puJCo6c8GZp+WE"
Date: Wed, 23 Dec 2009 13:08:01 +0100
Message-ID: <1261570081.25008.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FEv9z7puJCo6c8GZp+WE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-22 at 14:30 -0500, Luis R. Rodriguez wrote:

> Johannes, any preferences how to handle this? The patch below avoids
> the Interrupt being turned off but its not enough given that we still
> could be associated according to userspace. If the hardware is
> unresponsive maybe it is best to just let the IRQ go disabled, not
> sure, but its likely not what happens in all cases.
>=20
> Trimming out the irrelevant parts below.

> http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless
> /irq-disabled.txt
> >=20
> > This can be fixed by something like the following:
> >=20
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index e6c08da..63d42fa 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1031,7 +1031,14 @@ int ieee80211_reconfig(struct ieee80211_local
> *local)
> > =20
> >  	/* restart hardware */
> >  	if (local->open_count) {
> > +		/*
> > +		 * Upon resume hardware can sometimes be goofy due to
> > +		 * various platform issues, so restarting the device may
> > +		 * at times not work immediately. Propagate the error.
> > +		 */
> >  		res =3D drv_start(local);
> > +		if (res)
> > +			return res;
> > =20
> >  		ieee80211_led_radio(local, true);
> >  	}
> >=20
> > But this isn't enough. And since we cannot exactly talk to hardware
> > we can't try to send a deassoc as harware would be unresponsive. I
> > also don't see us handling such cases before either on cfg80211 or
> > mac80211, so curious what we should do.

Well it seems to me that if the driver determines that the hardware is
unreachable or not responding, it would unregister it from mac80211,
which would clean up all user-visible state, obviously.

The patch above seems ok to me, but basically papers over the problem.
If the start there fails, the driver will have to unregister the hw
since any subsequent start will fail as well.

The way I see it, it's like a USB unplug while suspended/hibernated ...
the driver notices that and remo

johannes=20

--=-FEv9z7puJCo6c8GZp+WE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMggdAAoJEODzc/N7+QmaO3MP/2+7AXly+arQb2eaIT1oNuul
xUOAbS6QBOhpMmIUIy5IcHqDuxHOdDk69+BR6cJPjA+7U0FrAAGDnx8ynVCCc4gv
075gPswYj/CphdXBZAajGb57tGhtFqjndsXHfRD1mgDjH797cjR0Ra5uU4uTr8UY
ae9BHLhswq3uM+TY5lsOqx6sMAGMdmMjkbDrGxVMD30Sj/7E+FxYs9Mz4HRffZ2v
37hFDphbplusG18fIY6FqUrLv82Dm82tIzTyYCIokSiwWaOMx+LUQo0BDZZh9IgU
2bZ2QXXaLqt1Upxjr9oiks9u8hrOU+W2KTrbPItWPfUzH807m5edvqiFXGVE1kcL
oEGOr98Seuh4x90kTwKxxkg+pmjX/puH3pHq7yn92nidhYpOVzY5rS3nRcmM/5mk
oXrQLOfVUi7xK+Nerf/8F022+tWEM1Int4kIvZhAMnBuwjuQioEj74gOApeY57Tj
ga9Da2KAa7sDakUdIXOKiv3yaZuXhEoAfftp3twPu0p6XOMI4VbVBiIfIbfEPrcB
jW/l5DpbApnU5Lw3Gmfq220+qEEvCGyDlELOxq6NDcPDteH8Av7Fpqwe1IyM5soD
gm7XaTJGjrWc8G7N9o/AnlHxUBv/OOO4Fw7k0NJ14nQsZYaPawwGpuJtx7PkwQ7x
bMzFQiaPrQcsmk+0jRwI
=QczI
-----END PGP SIGNATURE-----

--=-FEv9z7puJCo6c8GZp+WE--

