Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZDWEXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZDWEXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZDWEX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:23:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59441 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZDWEX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:23:28 -0400
Subject: Re: [PATCH][BUILD FAILURE 03/12] Re: Next April 21 : PPC64
 randconfig [arch/powerpc/kernel/of_platform.o]
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <49EFDD66.3060407@oracle.com>
References: <20090422161648.9231.76057.sendpatchset@subratamodak.linux.ibm.com>
	 <1240447420.6689.13.camel@localhost>  <49EFDD66.3060407@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V9pFvoiHkxB3zTZOxmLf"
Date: Thu, 23 Apr 2009 14:23:26 +1000
Message-Id: <1240460606.6689.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V9pFvoiHkxB3zTZOxmLf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 20:15 -0700, Randy Dunlap wrote:
> Michael Ellerman wrote:
> > On Wed, 2009-04-22 at 21:46 +0530, Subrata Modak wrote:
> >> On Wed, 2009-04-22 at 00:20 +0530, Subrata Modak wrote:
> >>> Reported this earlier on 14th April 2009:
> >>> http://lkml.org/lkml/2009/4/14/480,
> >>>
> >>> Michael,
> >>>
> >>> Any fix in sight ?
> >>> http://lkml.org/lkml/2009/4/14/676,
> >>>
> >>> CC      arch/powerpc/kernel/of_platform.o
> >>> arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
> >>> arch/powerpc/kernel/of_platform.c:270: error: implicit declaration of
> >>> function 'pci_devs_phb_init_dynamic'
> >>> arch/powerpc/kernel/of_platform.c:279: error: implicit declaration of
> >>> function 'scan_phb'
> >>> arch/powerpc/kernel/of_platform.c:295: error: implicit declaration of
> >>> function 'pci_bus_add_devices'
> >>> make[1]: *** [arch/powerpc/kernel/of_platform.o] Error 1
> >>> make: *** [arch/powerpc/kernel] Error 2
> >>> ---
> >=20
> > The problem above is as I said before, that the Cell Kconfig forces on
> > PPC_OF_PLATFORM_PCI even if PCI is disabled. I think the proper fix is
> > just to have CELL_NATIVE force on PCI.
> >=20
> > I don't know how you got the other errors, both pci_dn.c and pci_dlpar.=
c
> > are only built if CONFIG_PCI is enabled, see the Makefiles.
>=20
>=20
> The Kconfig could be more like this:
> config PPC_CELL_NATIVE
> 	bool
> 	select PPC_CELL_COMMON
> -	select PPC_OF_PLATFORM_PCI
> +	select PPC_OF_PLATFORM_PCI if PCI

That might be better. Although I think in truth the Cell code won't
build without PCI, but we could fix that. As I said in my patch I think
we do want PCI on Cell native, so we should just select it too.

http://patchwork.ozlabs.org/patch/26338/

cheers

--=-V9pFvoiHkxB3zTZOxmLf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknv7T4ACgkQdSjSd0sB4dKkTgCeINJlWGZ+mo4jOcjn66aeJFDf
YrcAnRZ34fZ9jlFE262qS9ngWUNn9fxy
=SqMe
-----END PGP SIGNATURE-----

--=-V9pFvoiHkxB3zTZOxmLf--

