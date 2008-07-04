Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYGDKvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYGDKvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYGDKva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:51:30 -0400
Received: from server.drzeus.cx ([85.8.24.28]:57115 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751630AbYGDKv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:51:29 -0400
Date: Fri, 4 Jul 2008 12:51:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable branch <stable@kernel.org>
Subject: [PATCH] mmc: don't use DMA on newer ENE controllers
Message-ID: <20080704125120.6ccaadf5@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-28411-1215168003-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-28411-1215168003-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

From: Pierre Ossman <drzeus@drzeus.cx>

Even the newer ENE controllers have bugs in their DMA engine that make
it too dangerous to use. Disable it until someone has figured out under
which conditions it corrupts data.

This has caused problems at least once, and can be found as bug report
10925 in the kernel bugzilla.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

--=20

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 07c2048..116abf2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -115,7 +115,8 @@ static const struct pci_device_id pci_ids[] __devinitda=
ta =3D {
 		.subvendor      =3D PCI_ANY_ID,
 		.subdevice      =3D PCI_ANY_ID,
 		.driver_data    =3D SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
+				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
+				  SDHCI_QUIRK_BROKEN_DMA,
 	},
=20
 	{
@@ -124,7 +125,8 @@ static const struct pci_device_id pci_ids[] __devinitda=
ta =3D {
 		.subvendor      =3D PCI_ANY_ID,
 		.subdevice      =3D PCI_ANY_ID,
 		.driver_data    =3D SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
+				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
+				  SDHCI_QUIRK_BROKEN_DMA,
 	},
=20
 	{

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-28411-1215168003-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuAK4ACgkQ7b8eESbyJLgRIwCfWJuuCWdLBUYl8m0gqAS+6akP
FlsAn2FZCI60Be09mRkf8XXfIKvL7cVL
=Aov5
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-28411-1215168003-0001-2--
