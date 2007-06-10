Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbXFJLYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbXFJLYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 07:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXFJLYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 07:24:08 -0400
Received: from ozlabs.org ([203.10.76.45]:47185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbXFJLYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 07:24:06 -0400
Subject: Re: [PATCH] PCI: also read revision ID for sparc64, ppc, read
	class at the same time
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de, grundler@parisc-linux.org, davem@davemloft.net,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070609201221.5868.31948.stgit@localhost.localdomain>
References: <20070609201221.5868.31948.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3keEE1/wuSeeIYLRlYup"
Date: Sun, 10 Jun 2007 21:24:03 +1000
Message-Id: <1181474643.8351.1.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3keEE1/wuSeeIYLRlYup
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 at 13:12 -0700, Auke Kok wrote:
> Since the PCI bus class and revision are in the same dword, we
> can fill in both in the same read.
>=20
> Other non-x86 arches use different methods to fill in these values,
> make sure to adjust those too.
>=20
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> ---
>=20
>  arch/powerpc/kernel/pci_64.c |    2 ++
>  arch/sparc64/kernel/pci.c    |    1 +
>  drivers/pci/probe.c          |    4 +---
>  3 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index 249cca2..b2c55ca 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -367,8 +367,10 @@ struct pci_dev *of_create_pci_dev(struct device_node=
 *node,
>  	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
>  		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
>  	dev->class =3D get_int_prop(node, "class-code", 0);
> +	dev->revision =3D get_int_prop(node, "revision-id", 0);

It's not clear to me in the spec if nodes are required to have the
"revision-id" property. I guess 0 is a safe default though.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-3keEE1/wuSeeIYLRlYup
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGa99TdSjSd0sB4dIRAhQwAKC5GIDi7X8ZSgzTejgTZ2dNWxzz5ACeM2Eo
QCn8vy0lyNQ0B/ext7BuYwk=
=D4cW
-----END PGP SIGNATURE-----

--=-3keEE1/wuSeeIYLRlYup--

