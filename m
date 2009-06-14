Return-Path: <linux-kernel-owner+w=401wt.eu-S1764472AbZFNWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764472AbZFNWAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 18:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764306AbZFNWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 18:00:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764303AbZFNWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 18:00:25 -0400
Date: Mon, 15 Jun 2009 00:00:22 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614220022.GB24323@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de> <20090614192359.GG3639@local> <4A355155.4020500@grandegger.com> <20090614203444.GH3639@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20090614203444.GH3639@local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > For x86 it's not defined at all. But as this code is for the PowerPC,
>=20
> No, it isn't. What makes you say that? The Kconfig entry doesn't depend
> on PowerPC. I compiled it on x86...

It depends on OF. You could compile on x86? Have to check that...

> > where using NO_IRQ seems still to be OK.
>=20
> No. uio_pdrv_genirq can be used on all platforms, and not all platforms h=
ave
> NO_IRQ. NO_IRQ can be used in platform specific code only.

Well, the wrapper uses irq_of_parse_and_map(). So far, it returns NO_IRQ if=
 an
IRQ was not specified (or not found). I could check if there was an
interrupt-property at all, so I can distinguish between 'not specified' and
'not found'. Then, UIO_IRQ_NONE would only be used, if there was none
specified. Otherwise it will always be the result from irq_of_parse_and_map=
(),
whatever that is (even NO_IRQ). Is this what you have in mind?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1cvYACgkQD27XaX1/VRv7gwCguug8XM1SKP/XqWjndkHhPw9E
fK0AnjaB2ULdSE6SMC5A1mAWL+zoc2xS
=ASBc
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
