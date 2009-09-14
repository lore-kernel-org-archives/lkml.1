Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZINPgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZINPgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZINPgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:36:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38052 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZINPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:36:19 -0400
Date: Mon, 14 Sep 2009 17:36:16 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marek Vasut <marek.vasut@gmail.com>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090914153616.GD3164@pengutronix.de>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <200909132328.47079.marek.vasut@gmail.com> <20090913230008.GC30169@n2100.arm.linux.org.uk> <20090914002100.GD30621@shareable.org> <20090914081001.GB14519@n2100.arm.linux.org.uk> <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com> <20090914140059.GC21580@n2100.arm.linux.org.uk> <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com> <20090914144028.GG21580@n2100.arm.linux.org.uk> <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2009 at 06:14:08PM +0300, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 5:40 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Sep 14, 2009 at 05:38:32PM +0300, Felipe Contreras wrote:
> >> On Mon, Sep 14, 2009 at 5:00 PM, Russell King - ARM Linux
> >> <linux@arm.linux.org.uk> wrote:
> >> > On Mon, Sep 14, 2009 at 03:58:24PM +0300, Felipe Contreras wrote:
> >> >> On Mon, Sep 14, 2009 at 11:10 AM, Russell King - ARM Linux
> >> >> <linux@arm.linux.org.uk> wrote:
> >> >> > On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
> >> >> >> Russell King - ARM Linux wrote:
> >> >> >> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> >> >> >> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bhi =A0 =A0 __delay
> >> >> >> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =A0 =A0 pc, lr
> >> >> >> > > > =A0ENDPROC(__udelay)
> >> >> >> > > >
> >> >> >> > > Hi
> >> >> >> > >
> >> >> >> > > why was this code there in the first place ?
> >> >> >> >
> >> >> >> > To make the delay loop more stable and predictable on older CP=
Us.
> >> >> >>
> >> >> >> So why has it been commented out, if it's needed for that?
> >> >> >
> >> >> > We moved on and it penalises later CPUs, leading to udelay provid=
ing
> >> >> > shorter delays than requested.
> >> >> >
> >> >> > So the choice was either stable and predictable on older CPUs but
> >> >> > buggy on newer CPUs, or correct on all CPUs but gives unnecessari=
ly
> >> >> > longer delays on older CPUs.
> >> >>
> >> >> Why not add an #ifdef CPU_V4 or whatever?
> >> >
> >> > Because then you get it whenever you configure for V4 as the lowest
> >> > denominator CPU, which leads to the buggy behaviour on better CPUs.
> >> > It's far better to leave it as is and just accept that the old CPUs
> >> > will have longer than necessary delays. =A0If people really really
> >> > care (and there's likely to only be a small minority of them now)
> >> > changing the '0' to a '1' is a very simple change for them to carry
> >> > in their local tree. =A0Unlike getting the right unrolling etc.
> >>
> >> Well, they can also 'git revert' this patch. If somebody really cares
> >> I think they should shout now and provide a better patch, otherwise
> >> this one should be merged.
> >
> > On the other hand, having the code there as it currently stands is not
> > harmful in any way, so leaving it there is just as easy.
>=20
> It makes the code less understandable. I'm not sure about linux's
> practices, but an #if 0 generally means somebody is being lazy.

And what about a comment like "Try including the following code if ..."? I
think I saw this somewhere else in the kernel and I'd be fine with that. So,
while I generally agree that "#if 0" looks suspicious, there are a few cases
for it, though they need documentation IMHO.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkquYvAACgkQD27XaX1/VRvjZgCfW6OZb9hQDga/XCEcMIwskXrs
ebgAoLmtpTZ7t/Sz89D3WoESDCOenff6
=YPuS
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
