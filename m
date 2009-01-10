Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZAJADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZAJADo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZAJADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:03:35 -0500
Received: from b01.ext.isohunt.com ([208.71.112.51]:52641 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752255AbZAJADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:03:35 -0500
Date: Fri, 9 Jan 2009 16:01:06 -0800
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-ide@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Do ICH10+AHCI-driver support port-multiplying on a eSATA port?
Message-ID: <20090110000106.GD32364@curie-int.orbis-terrarum.net>
References: <1231513287.2631.68.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lWZ9pouYHbrmKLtT"
Content-Disposition: inline
In-Reply-To: <1231513287.2631.68.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lWZ9pouYHbrmKLtT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2009 at 04:01:27PM +0100, Soeren Sonnenburg wrote:
> I am trying to connect an external 2-disk case (eCube II  see
> http://www.one-tech.com/EN/htm_ecube.htm) to an ICH10 skyburg dp45sg
> board via eSATA. As the case requires a port-multiplying sata card, I am
> wondering if ich10+ahci support it?
Look at the portion of your dmesg where AHCI is loaded:
You'll see some lines like this:

[3675853.416077] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo p=
mp pio slum part ems=20
[3675855.666834] ahci 0000:04:00.0: flags: 64bit stag led slum part=20
Relevant lspci bits:
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI=
 Controller
04:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Contr=
oller (rev b1)

Notice the 'pmp' flag on the first one. From what I understand, the AHCI
BIOS portions can choose to enable or disable things like PMP support,
and that's why it's reflected in the inquiry data.

Another box:
[    4.396835] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
=20

And the lspci:
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AH=
CI Controller (rev 01)

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--lWZ9pouYHbrmKLtT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAkln5UIACgkQPpIsIjIzwiyi4gCfYv+mxA56INgq1c7lwrMVT6wh
2acAoO8XWpeRGA7kFQk7nyJ3Jdizd/Ly
=OrGY
-----END PGP SIGNATURE-----

--lWZ9pouYHbrmKLtT--
