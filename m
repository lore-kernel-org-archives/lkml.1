Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZGBSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZGBSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZGBSWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:22:06 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60456 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZGBSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:22:05 -0400
Date: Thu, 2 Jul 2009 14:22:08 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Staging: vt6656 ?
Message-ID: <20090702182208.GD9422@alittletooquiet.net>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <200906281759.46152.bzolnier@gmail.com> <20090628164716.GC9143@alittletooquiet.net> <200907021945.49926.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <200907021945.49926.bzolnier@gmail.com>
X-PGP-Key: http://www.alittletooquiet.net/media/forest.pubkey.asc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 02, 2009 at 07:45:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 28 June 2009 18:47:16 Forest Bond wrote:
> > On Sun, Jun 28, 2009 at 05:59:45PM +0200, Bartlomiej Zolnierkiewicz wro=
te:
> > > [ I'll later setup vt665x branch of my misc.git tree, merge your patc=
hes,
> > >   merge all outstanding vt6655 patches from Alexander and investigate=
 a bit
> > >   more whether merge of vt665x drivers is feasible and what needs to =
be
> > >   done if so.. ]
> >=20
> > Good.
>=20
> The temporary tree is here:
>=20
> git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git vt665x
>=20
> and I'll happily apply patches to it till Greg digs out from under the
> overdue patch queues.. :)

Thanks for doing this, Bartlomiej.

> > FYI, there is a known issue with the drivers as I've submitted them tha=
t causes
> > lock-ups.  Please see the attached message for a suggested fix.
>=20
> I think that all netdev_priv() changes should be reverted for now:

I'm happy to defer to you on this.  I don't really understand the code, to =
be
frank.  However, if those changes are simply reverted, the driver will not
compile.  I assume that you mean those areas should be removed?

> --- a/drivers/staging/vt6655/wpactl.c
> +++ b/drivers/staging/vt6655/wpactl.c
> @@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
> =20
>  static int wpa_init_wpadev(PSDevice pDevice)
>  {
> +    PSDevice wpadev_priv;
>  	struct net_device *dev =3D pDevice->dev;
>           int ret=3D0;
> =20
> -	pDevice->wpadev =3D alloc_netdev(0, "vntwpa", wpadev_setup);
> +	pDevice->wpadev =3D alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_set=
up);
>  	if (pDevice->wpadev =3D=3D NULL)
>  		return -ENOMEM;
> =20
> -	pDevice->wpadev->priv =3D pDevice;
> +    wpadev_priv =3D netdev_priv(pDevice->wpadev);
> +    *wpadev_priv =3D *pDevice;
> +
>  	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
>           pDevice->wpadev->base_addr =3D dev->base_addr;
>  	pDevice->wpadev->irq =3D dev->irq;
>=20
> This will copy the current state of pDevice to newly allocated private pa=
rt
> of ->apdev but later modifications to the original pDevice won't be seen =
if
> we access it through netdev_priv(pDevice->apdev) instead of apdev->priv.
>=20
> [ I don't know whether this is a problem currently but it looks suspiciou=
s. ]

Agreed.  I gave this a best effort, but was not very confident about the re=
sult.

Feel free to aggressively rework my changes if it seems appropriate.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKTPrQRO4fQQdv5AwRAgdwAJ42fUODJjWYGPYyEhXfDR/dxJfM/wCbBQ7R
+2e9AOCLi5/VIdO1YTmgf5w=
=dhSg
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
