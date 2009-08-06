Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZHFQG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZHFQG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZHFQGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:06:55 -0400
Received: from gold.linx.net ([195.66.232.40]:53425 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966AbZHFQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:06:53 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 12:06:53 EDT
Subject: RE: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: Chetan.Loke@Emulex.Com
Cc: hancockrwd@gmail.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com>
References: <20090805192055.8F2DE1007C@gold.linx.net>
	 <4A7A16C9.6030500@gmail.com>
	 <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SaVPfAckteLCTwu9i4oZ"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 06 Aug 2009 16:59:23 +0100
Message-Id: <1249574363.4530.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SaVPfAckteLCTwu9i4oZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> disable_msi() is missing right?

I didn't add that as none of the other drivers have it:
chainsaw@amalthea /cvs/linux-2.6/drivers/ata $ grep _msi * | grep pci
ahci.c:		pci_enable_msi(pdev);
sata_mv.c:	if (msi && pci_enable_msi(pdev) =3D=3D 0)
sata_vsc.c:	if (pci_enable_msi(pdev) =3D=3D 0)

(This is a tree without the sata_nv change I submitted)

I do believe it is safe to shut the interrupt down and unload the
handler whilst it is still in MSI mode. At least, I don't see the libata
core special-casing it in any way.

> Chetan

Regards,
Tony V.

--=-SaVPfAckteLCTwu9i4oZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkp6/dsACgkQp5vW4rUFj5rw5ACfbwhVHi/w2RbFLQEqag7zspa5
P4EAoL5lqbtFa5E1iB7156AJGTJcn5aS
=IZxt
-----END PGP SIGNATURE-----

--=-SaVPfAckteLCTwu9i4oZ--

