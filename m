Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbYBMRhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbYBMRhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765719AbYBMRhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:37:36 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45391 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764103AbYBMRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:37:32 -0500
Date: Wed, 13 Feb 2008 18:37:01 +0100
From: Christian Krafft <krafft@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: parabelboi@bopserverein.de, linuxppc-dev@ozlabs.org
Subject: Re: [Patch 2/2] powerpc: i2c-isa: add access check to legacy
 ioports
Message-ID: <20080213183701.254391cc@de.ibm.com>
In-Reply-To: <20080213182800.5c6940a8@de.ibm.com>
References: <20080213182800.5c6940a8@de.ibm.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/x82tJ18quo/VNEsVC.yFIHh";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x82tJ18quo/VNEsVC.yFIHh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

when probing i2c-pca-isa writes to legacy ioports, which crashes the kernel
if there is no device at that port.
This patch adds a check_legacy_ioport call, so probe failes gracefully
and thus prevents the oops.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>

Index: linux.git/drivers/i2c/busses/i2c-pca-isa.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.git.orig/drivers/i2c/busses/i2c-pca-isa.c
+++ linux.git/drivers/i2c/busses/i2c-pca-isa.c
@@ -125,6 +125,13 @@ static int __devinit pca_isa_probe(struc
=20
 	dev_info(dev, "i/o base %#08lx. irq %d\n", base, irq);
=20
+#ifdef CONFIG_PPC_MERGE
+	if (check_legacy_ioport(base)) {
+		dev_err(dev, "I/O address %#08lx is not available\n", base);
+		goto out;
+	}
+#endif
+
 	if (!request_region(base, IO_SIZE, "i2c-pca-isa")) {
 		dev_err(dev, "I/O address %#08lx is in use\n", base);
 		goto out;


--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294

--Sig_/x82tJ18quo/VNEsVC.yFIHh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHsyq/6rqK4qDx+dcRAqGjAKCAH0JTGXPrVDXCrvdKzhrhyEAb/QCfc3s/
v52DW2XZKyxbLJ4+ATJir8o=
=kR/U
-----END PGP SIGNATURE-----

--Sig_/x82tJ18quo/VNEsVC.yFIHh--
