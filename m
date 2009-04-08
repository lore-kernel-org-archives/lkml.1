Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbZDHAza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbZDHAza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZDHAzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:55:16 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZDHAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:55:14 -0400
Subject: Re: [Bug #12490] ath5k related kernel panic in 2.6.29-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Sergey S. Kostyliov" <rathamahata@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20090408004644.GB28096@hash.localnet>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.GaD.UJn2JB@chimera> <20090407024021.GA26739@hash.localnet>
	 <1239098625.22453.6.camel@johannes.local>
	 <20090408004644.GB28096@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NLHk8h7izYX30T5hLc7z"
Date: Wed, 08 Apr 2009 02:54:32 +0200
Message-Id: <1239152072.8456.39.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NLHk8h7izYX30T5hLc7z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 20:46 -0400, Bob Copeland wrote:
> On Tue, Apr 07, 2009 at 12:03:45PM +0200, Johannes Berg wrote:
> >=20
> > > Anyway here's a patch to buy some time.  Johannes, would this be
> > > an acceptable band-aid for now?
> >=20
> > This is going to make it print two warnings for one occurrence of the
> > problem though. I'd much prefer to put something into minstrel.c to
> > catch when _it_ returns bogus values and in that case return 0, that wa=
y
> > at least the bandaid is restricted to the code it patches up.
>=20
> Ok, then maybe something like this?
>=20
> I think this covers most of the bases: if the driver is returning crap or
> the ->cb gets corrupted, it'll get caught in tx_status.  If minstrel
> stuffs a -1 in the first slot for any other reason we'll get a warning
> before get_tx_rate and a hopefully valid index gets substituted.

Yeah, that looks nicer, thanks.

> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minst=
rel.c
> index 3824990..1cf7152 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -181,6 +181,11 @@ minstrel_tx_status(void *priv, struct ieee80211_supp=
orted_band *sband,
>  		if (ar[i].idx < 0)
>  			break;
> =20
> +		if (WARN(ar[i].idx >=3D mi->n_rates,
> +		    "minstrel: invalid rate report %d (n=3D%d)\n",
> +		    ar[i].idx, mi->n_rates))
> +			break;

It might be easier to print this in hex -- that way things like 0x6b are
more apparent?

johannes

--=-NLHk8h7izYX30T5hLc7z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2/XFAAoJEKVg1VMiehFYk64P/3cmAf3w0CrNkhKeTs4HDLQz
kBpw84EzpHbeMpAOj0UyUzVKOBvjnmpF1nEXlU4rKJjHV3KI/UaFh+OpyAMpeaaI
utePrXvVKwX727YtXE2VgJtB9zhObjqlNSlYcVD9J876CCbGhPOZOzDCnRDKLNzs
aOTMWJHzGDAozHp1LvMieOqtF0qOwIWRlmGELuzv1Ws0g9cSjcXvmlH3a+qTDrco
QgZgeiu032dTrCaYyRsWcqNHsWDqf+0V1zDfCrXrvI3Ug6WbheCdF34ARNfOEYEY
tP+kbcGO0IxamRiwtF0AY1d/kwq7CwNuJaEu+Hbjg12ygp9MXylRCSjx7xZvzzBE
SIvp55znT8qELS4qpL3UnBAdNQxxrx92y91h342lfWEyMpUVzOkrkqSqOClGKc++
WmrxtWlPRjzx9rzijLTDqlVg+wqfNnnY1RlQgBG5p9LPi1lwtGMReeiJk70c+Siw
bvb60/6wgVM2MU2e4DC7FcEE7QVGUjLrqxPulihrSBBGP6ffI81uX9vJN0l8Kp3t
fTzkoBrUodhhHG+shYOclY7c5jH1DswhlrkMHXclslbp9Tx5GRXEQllBL3jRnx0+
gH35eN9HDhgJTD/zGsN7aqBnW54b1JrloaVUeCDVSP5gBuf2gtAodx8Cj9SorBgV
xTd6o2XH7Kt4BzBgkrge
=3lxA
-----END PGP SIGNATURE-----

--=-NLHk8h7izYX30T5hLc7z--

