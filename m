Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZCCUNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZCCUNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCCUNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:13:12 -0500
Received: from naru.obs2.net ([84.20.150.76]:60112 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZCCUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:13:11 -0500
Date: Tue, 3 Mar 2009 22:13:06 +0200
From: Riku Voipio <riku.voipio@iki.fi>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, rpurdie@rpsys.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] leds: Fix &&/|| confusion
Message-ID: <20090303201306.GA1119@kos.to>
References: <498863FC.1090008@gmail.com> <adaiqnnxwxm.fsf@cisco.com> <498C86A1.8030404@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <498C86A1.8030404@gmail.com>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 06, 2009 at 07:51:13PM +0100, Roel Kluin wrote:
> Roland Dreier wrote:
> >  > -	if (type !=3D EV_SND && (code !=3D SND_BELL || code !=3D SND_TONE))
> >  > +	if (type !=3D EV_SND && (code !=3D SND_BELL && code !=3D SND_TONE))
> >=20
> > Actually more likely seems to be
> >=20
> > 	if (type !=3D EV_SND || (code !=3D SND_BELL && code !=3D SND_TONE))
>=20
> Thanks for your review,

I think what I want is:

	if (!(type=3D=3DEV_SND && (code =3D=3D SND_BELL || code =3D=3D SND_TONE)))

Not that I think anyone would send SND_* without EV_SND.

=46rom 725c752a53a83319042dcdaccf072908b29d1c40 Mon Sep 17 00:00:00 2001
=46rom: Riku Voipio <riku.voipio@iki.fi>
Date: Tue, 3 Mar 2009 22:06:51 +0200
Subject: [PATCH 19/19] [PATCH v2] leds: Fix &&/|| confusion

Thanks to Roel Kluin <roel.kluin@gmail.com> for noticing.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
---
 drivers/leds/leds-pca9532.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index a46d208..dba8921 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_dev *dev, unsigne=
d int type,
 {
 	struct pca9532_data *data =3D input_get_drvdata(dev);
=20
-	if (type !=3D EV_SND && (code !=3D SND_BELL || code !=3D SND_TONE))
+	if (!(type =3D=3D EV_SND && (code =3D=3D SND_BELL || code =3D=3D SND_TONE=
)))
 		return -1;
=20
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
--=20
1.6.1.3


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJrY9SibPvMsrqrwMRArZmAJ0Q76oK0Lnz7JmiVQwmnGXX5JpU4gCgpcNK
6srgk2vQAoTKQLjzKWgDfIw=
=PvFQ
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
