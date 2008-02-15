Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbYBOXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbYBOXV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763068AbYBOXVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:21:44 -0500
Received: from mail.southpole.se ([193.12.106.18]:55060 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763003AbYBOXVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:21:43 -0500
Subject: pci_device_id definition cleanups
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HBx+e5REx5vEp65xuQ2y"
Organization: South Pole Consulting AB
Date: Sat, 16 Feb 2008 00:21:40 +0100
Message-Id: <1203117700.16761.9.camel@satguru>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HBx+e5REx5vEp65xuQ2y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I've done some work on cleaning up the definitions of pci_device_id to
make them "static const" (where possible) and to make sure they go into
__devinitconst.  There are about 350 changes of the type shown in the
diff at the end of this mail.

=EF=BB=BFAll these changes are in my public GIT tree at:

git://www.southpole.se/~jonas/git/linux.git

(Based on 2.6.25-rc2)

In addition to these pci_device_id changes, there are a few changesets
that move "const" data from __devinitdata to __devinitconst.

The tree above builds with both allmodconfig and allyesconfig.

=EF=BB=BF/Jonas

------

Representative example change:

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d59ae8..90c7820 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4967,7 +4967,7 @@ megaraid_shutdown(struct pci_dev *pdev)
 	__megaraid_shutdown(adapter);
 }
=20
-static struct pci_device_id megaraid_pci_tbl[] =3D {
+static const struct pci_device_id megaraid_pci_tbl[] __devinitconst =3D {
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,



--=-HBx+e5REx5vEp65xuQ2y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHth6E70gcjN2673MRAsPwAJ4ilRYSXAUiOGSwm/Mh5lDYDx3awwCgnp6I
9i1cxV+ARH69Yyt2xM5AxgQ=
=ViQF
-----END PGP SIGNATURE-----

--=-HBx+e5REx5vEp65xuQ2y--

