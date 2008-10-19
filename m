Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbYJSINx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbYJSINx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 04:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYJSINk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 04:13:40 -0400
Received: from mx38.mail.ru ([194.67.23.16]:54168 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYJSINj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 04:13:39 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cpqarry: fix return value of cpqarray_init
Date: Sun, 19 Oct 2008 12:13:34 +0400
User-Agent: KMail/1.9.10
Cc: Dick Gevers <dvgevers@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1696121.M67j86kgNP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810191213.35676.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1696121.M67j86kgNP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] cpqarry: fix return value of cpqarray_init
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

As reported by Dick Gevers on Compaq ProLiant:

Oct 13 18:06:51 dvgcpl kernel: Compaq SMART2 Driver (v 2.6.0)
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: 'cpqarray'->init
suspiciously returned 1, it should follow 0/-E convention
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: loading module anyway...
Oct 13 18:06:51 dvgcpl kernel: Pid: 315, comm: modprobe Not tainted
2.6.27-desktop-0.rc8.2mnb #1
Oct 13 18:06:51 dvgcpl kernel:  [<c0380612>] ? printk+0x18/0x1e
Oct 13 18:06:51 dvgcpl kernel:  [<c0158f85>] sys_init_module+0x155/0x1c0
Oct 13 18:06:51 dvgcpl kernel:  [<c0103f06>] syscall_call+0x7/0xb
Oct 13 18:06:51 dvgcpl kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D


Make it return 0 on success and -ENODEV if no array was found.

Reported-by: Dick Gevers <dvgevers@xs4all.nl>
Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

Compile tested by Dick. I do not have hardware.

 drivers/block/cpqarray.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 09c1434..f5d2e54 100644
=2D-- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -567,7 +567,12 @@ static int __init cpqarray_init(void)
 			num_cntlrs_reg++;
 	}
=20
=2D	return(num_cntlrs_reg);
+	if (num_cntlrs_reg)
+		return 0;
+	else {
+		pci_unregister_driver(&cpqarray_pci_driver);
+		return -ENODEV;
+	}
 }
=20
 /* Function to find the first free pointer into our hba[] array */

--nextPart1696121.M67j86kgNP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj67C8ACgkQR6LMutpd94ypUgCgiHg4ZWuAokecAxAeGhPd12rA
cdoAn0NrNPS13nl6Wr3D5xzQdjiYqXWm
=Icul
-----END PGP SIGNATURE-----

--nextPart1696121.M67j86kgNP--
