Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZE1GfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZE1GfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZE1Gez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:34:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41684 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZE1Gey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:34:54 -0400
Date: Thu, 28 May 2009 08:34:45 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528063445.GA12004@pengutronix.de>
References: <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com> <20090527235704.GQ6805@pengutronix.de> <fa686aa40905272021w18a148caqd2b73c4448da2b28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <fa686aa40905272021w18a148caqd2b73c4448da2b28@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> It is inherent in the value "atmel,24c08".  Because the exact device
> model is specified, the kernel can know what the page size and flags
> are for that device.

I am afraid this is not the case. I remember that we once had two revisions=
 of
the same eeprom, and the vendor decided to increase the page size without
changing the naming of the eeprom. (Can't point to any documentation yet, w=
ould
have to dig this up.) Those eeproms can be really weird.

Also, there are _a lot_ of eeprom manufacturers out there, so the match tab=
le
will be enormous....

> OTOH, if it is appropriate for the device, then the binding can be define=
d to
> include things like page size and flags encoded explicitly in additional
> properties.

=2E.., so I think a property like "page-size" could really be argumented fo=
r.
Actually, I am quite optimistic that there could be agreement on it. Maybe =
we
could also reuse the "read-only" property which is used for partitions. Sti=
ll,
this discussion has to be done, and that is additional work for mainlining.

Also, this would be _another_ wrapper to collect data from the device tree =
and
pass it into platform_data. I think it is difficult to maintain. If somebody
extends at24 and forgets about the of-wrapper, it may easily get broken. Pl=
us,
at least for me, coding always very similar stuff, feels like bloating the
kernel. I did it a few times now, and that made me really wonder if we can't
have a more generic solution to that problem. Sadly, I could neither come up
with anything useful :(

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoeMIUACgkQD27XaX1/VRtnZwCfQe5nSJ/mRhg/8mS2Yj842Ifa
BacAoMh6k4ifzgmxTJGAMbfbdATew2kD
=4PH1
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
