Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbYBMH3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbYBMH3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbYBMH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:29:39 -0500
Received: from ozlabs.org ([203.10.76.45]:55628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbYBMH3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:29:37 -0500
Subject: Re: [PATCH 09/18] ide: rework PowerMac media-bay support
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080208004523.17746.24578.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
	 <20080208004523.17746.24578.sendpatchset@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rcWHPrY1cbcdMlpZJp3I"
Date: Wed, 13 Feb 2008 18:29:36 +1100
Message-Id: <1202887776.7971.19.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rcWHPrY1cbcdMlpZJp3I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-02-08 at 01:45 +0100, Bartlomiej Zolnierkiewicz wrote:
> Rework PowerMac media-bay support in such way that instead of
> un/registering the IDE interface we un/register IDE devices:
>=20
> * Add ide_port_scan() helper for probing+registerering devices on a port.
>=20
> * Rename ide_port_unregister_devices() to __ide_port_unregister_devices()=
.
>=20
> * Add ide_port_unregister_devices() helper for unregistering devices on a=
 port.
>=20
> * Add 'ide_hwif_t *cd_port' to 'struct media_bay_info', pass 'hwif' inste=
ad
>   of hwif->index to media_bay_set_ide_infos() and use it to setup 'cd_por=
t'.
>=20
> * Use ide_port_unregister_devices() instead of ide_unregister()
>   and ide_port_scan() instead of ide_register_hw() in media_bay_step().
>=20
> * Unexport ide_register_hw() and make it static.
>=20
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-probe.c        |   18 ++++++++++++++++++
>  drivers/ide/ide.c              |   22 ++++++++++++++++------
>  drivers/ide/ppc/pmac.c         |    3 ++-
>  drivers/macintosh/mediabay.c   |   17 +++++++----------
>  include/asm-powerpc/mediabay.h |    4 +++-
>  include/linux/ide.h            |    6 ++----
>  6 files changed, 48 insertions(+), 22 deletions(-)

> Index: b/include/asm-powerpc/mediabay.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/include/asm-powerpc/mediabay.h
> +++ b/include/asm-powerpc/mediabay.h
> @@ -22,10 +22,12 @@ int check_media_bay(struct device_node *
>  /* Number of bays in the machine or 0 */
>  extern int media_bay_count;
> =20
> +#ifdef CONFIG_BLK_DEV_IDE_PMAC
>  int check_media_bay_by_base(unsigned long base, int what);
>  /* called by IDE PMAC host driver to register IDE controller for media b=
ay */
>  int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long=
 base,
> -			    int irq, int index);
> +			    int irq, ide_hwif_t *hwif);
> +#endif
> =20
>  #endif /* __KERNEL__ */
>  #endif /* _PPC_MEDIABAY_H */

This hunk breaks pmac32_defconfig for me.

include2/asm/mediabay.h:29: error: syntax error before 'ide_hwif_t'
make[3]: *** [arch/powerpc/platforms/powermac/setup.o] Error 1
make[2]: *** [arch/powerpc/platforms/powermac] Error 2
make[1]: *** [arch/powerpc/platforms] Error 2
make: *** [sub-make] Error 2

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-rcWHPrY1cbcdMlpZJp3I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHspxgdSjSd0sB4dIRAibPAJ0dcGD1H6r7zo8Pb8j3YsG+884OSgCeNItN
zwItoANm8Lo9B2HVBkp3mLg=
=FdoT
-----END PGP SIGNATURE-----

--=-rcWHPrY1cbcdMlpZJp3I--

