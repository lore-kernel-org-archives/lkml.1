Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZINKlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZINKlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZINKk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:40:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZINKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:40:59 -0400
Date: Mon, 14 Sep 2009 12:41:01 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, broonie@opensource.wolfsonmicro.com
Subject: regulator: adding constraints to regulator_desc?
Message-ID: <20090914104101.GB3164@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a question regarding the constraints of the regulator-framework: If I
understood correctly, there is a struct in regulator_dev which is describing
the constraints on the power-domain-level. As we also have constraints on t=
he
regulator-level, all the regulator drivers do sanity checks in their
set_voltage()-functions. These checks differ and it is not always clear to =
me
if additional checks other drivers have were forgotten or intentionally omi=
tted
for a specific driver. I also wondered about code-duplication and if it was
maybe worthwhile to simply add 'min' and 'max' members to struct regulator_=
desc
and let the core do sanity checks (like it does for the constraints on the
power-domain-level). Has this been considered already?

One thing which also raised my attention was the beginning of
regulator_check_voltage(). It starts with

	BUG_ON(*min_uV > *max_uV);

Is it really necessary to halt the kernel? Wouldn't a big warning and -EINV=
AL
do like at the end of the function?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkquHb0ACgkQD27XaX1/VRt7RACeNHhbhLKJwy8gR8lQEhlCh1Ja
OsMAn3chy83ZMEBlj96k1zv3xyfN1Vmy
=tUO2
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
