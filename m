Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbZFRO3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbZFRO3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763637AbZFRO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:27:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51267 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763535AbZFRO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:27:11 -0400
Date: Thu, 18 Jun 2009 16:26:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jonsmirl@gmail.com
Subject: Re: [spi-devel-general] [PATCH v4] powerpc/5200: Add mpc5200-spi
	(non-PSC) device driver
Message-ID: <20090618142610.GC10629@pengutronix.de>
References: <20090618025030.12363.69402.stgit@localhost.localdomain> <20090618065814.GA12942@pengutronix.de> <fa686aa40906180635g45724119x99cd4d1e4ede59f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <fa686aa40906180635g45724119x99cd4d1e4ede59f9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

> The double spaces at the end of sentences are intentional.  It is
> perhaps a bit quaint and old fashioned, but it is my writing style.

Ah, okay.

> >> +
> >> + =A0 =A0 /* Statistics */
> >> + =A0 =A0 int msg_count;
> >> + =A0 =A0 int wcol_count;
> >> + =A0 =A0 int wcol_ticks;
> >> + =A0 =A0 u32 wcol_tx_timestamp;
> >> + =A0 =A0 int modf_count;
> >> + =A0 =A0 int byte_count;
> >
> > Hmm, there isn't even a debug-printout for those. Putting #ifdef DEBUG =
around
> > them will be ugly. Well, I can't make up if this is just overhead or us=
eful
> > debugging aid, so no real objection :)
>=20
> There used to be a sysfs interface for dumping these, but it was an
> ugly misuse.  I'd like to leave these in.  I still have the sysfs bits
> in a private patch and I'm going to rework them for debugfs.

Okay. Maybe a comment stating the future use will be nice.

>=20
> > But I wonder more about the usage of the SS pin and if this chipsel is =
needed
> > at all (sadly I cannot test as I don't have any board with SPI connecte=
d to
> > that device). You define the SS-pin as output, but do not set the SSOE-=
bit.
> > More, you use the MODF-feature, so the SS-pin should be defined as inpu=
t?
> > According to Table 17.3 in the PM, you have that pin defined as generic=
 purpose
> > output.
>=20
> That's right.  The SS handling by the SPI device is completely
> useless, so this driver uses it as a GPIO and asserts it manually.

That definately needs a comment :D (perhaps with some more details if you k=
now them).

> The MODF irq is probably irrelevant, but I'd like to leave it in for
> completeness.

But it won't work if the pin is set to output, no? Are you sure there are no
side-effects?


> >> + =A0 =A0 /* initialize the device */
> >> + =A0 =A0 out_8(regs+SPI_CTRL1, SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_C=
TRL1_MSTR);
> >
> > spaces around operator.
>=20
> Intentional to keep from spilling past column 80; but I'll move the
> missing spaces to around the | operators.  I think it is easier to
> read that way.

Ah, I remember, we had this topic a while ago :D

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko6ToIACgkQD27XaX1/VRvmxwCfbu92t03t5YK/9Ccx6Zp3UNmc
UTsAnAhRz7XWKfs5EMfHm14jvqeeGf3O
=ELdc
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
