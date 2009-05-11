Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZEKOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZEKOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZEKOaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:30:13 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46839 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZEKOaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:30:12 -0400
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090510.223645.193708481.davem@davemloft.net>
References: <20090508131333.GV8112@parisc-linux.org>
	 <1242004911.7767.26.camel@concordia>
	 <20090510.223645.193708481.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+z82HoL7OYrdwANGKmtD"
Date: Tue, 12 May 2009 00:30:11 +1000
Message-Id: <1242052211.7011.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+z82HoL7OYrdwANGKmtD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-10 at 22:36 -0700, David Miller wrote:
> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Mon, 11 May 2009 11:21:51 +1000
>=20
> > So I guess this device is just silently ignoring that write?
>=20
> No, it signals a fault on the PCI bus, which is how we noticed
> this problem in the first place.

But the patch doesn't change that? It just removes the readl AFAICS:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..3627732 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -455,8 +455,6 @@ static int msix_capability_init(struct pci_dev *dev,
                entry->msi_attrib.default_irq =3D dev->irq;
                entry->msi_attrib.pos =3D pos;
                entry->mask_base =3D base;
-               entry->masked =3D readl(base + j * PCI_MSIX_ENTRY_SIZE +
-                                       PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
                msix_mask_irq(entry, 1);
=20

Or has msix_mask_irq() changed since 413f81eba?

cheers

--=-+z82HoL7OYrdwANGKmtD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoINm4ACgkQdSjSd0sB4dLdwQCfZhPeciogvLdZSOm5UADGYWAn
MjIAoMGLpNmE3CTixUIjzbaJ+AXFevhI
=GsFo
-----END PGP SIGNATURE-----

--=-+z82HoL7OYrdwANGKmtD--

