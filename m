Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZLBUtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZLBUtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZLBUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:49:09 -0500
Received: from smtp-out13.alice.it ([85.33.2.18]:1660 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbZLBUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:49:08 -0500
Date: Wed, 2 Dec 2009 21:48:53 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-Id: <20091202214853.d97b860c.ospite@studenti.unina.it>
In-Reply-To: <20091202204026.GA18311@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<20091202180658.GA12292@rakim.wolfsonmicro.main>
	<20091202212521.500f7a46.ospite@studenti.unina.it>
	<20091202204026.GA18311@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_21_48_53_+0100_lJTsaa1SG.Bc4z=D"
X-OriginalArrivalTime: 02 Dec 2009 20:49:12.0002 (UTC) FILETIME=[E6E96220:01CA7390]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_21_48_53_+0100_lJTsaa1SG.Bc4z=D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Dec 2009 20:40:26 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Dec 02, 2009 at 09:25:21PM +0100, Antonio Ospite wrote:
> > Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>=20
> > > There's no need to do this since the regulator API matches consumers
> > > based on struct device as well as name so you can have as many LEDs as
> > > you like all using the same supply name mapping to different regulato=
rs.
>=20
> > I need some more explanation here, I am currently using the driver with
> > this code:
>=20
> > +/* VVIB: Vibrator on A780, A1200, A910, E6, E2 */
> > +static struct regulator_consumer_supply pcap_regulator_VVIB_consumers
> > [] =3D {
> > +	{ .dev_name =3D "leds-regulator", .supply =3D "vibrator", },
>=20
> So you're instantiating the device with .id set to -1 (as your code
> below shows), meaning there's only one leds-regulator in the system and
> there's no need to number them.  If you had more than one of them then
> you'd number them and then have something like:
>=20
> 	{ .dev_name =3D "leds-regulator.0", supply =3D "vled" },
> 	{ .dev_name =3D "leds-regulator.1", supply =3D "vled" },
>=20
> when setting up the supplies.
>

Ok, the .id in .dev_name is what I was missing.

> > If I set the .supply value fixed, how can I assign different
> > regulators to different leds? Should I use the address to the platform
> > device (a780_vibrator in this case) for .dev when defining the
> > regulator in the first place?
>=20
> There is no need to use the .dev field, that is kept to avoid build
> breakage transitioning to dev_name.

Now everything is clear.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__2_Dec_2009_21_48_53_+0100_lJTsaa1SG.Bc4z=D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksW0rUACgkQ5xr2akVTsAFA8wCeM0lOZK+JVZwpNT8PaPdK/7Z6
M+QAn0elN2DC2xixTSCm4NlCQrEkIs71
=W0NG
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_21_48_53_+0100_lJTsaa1SG.Bc4z=D--
