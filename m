Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXJ3Sfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXJ3Sfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXJ3Sfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:35:34 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:44539 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751997AbXJ3Sfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:35:34 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 14:35:33 EDT
Date: Tue, 30 Oct 2007 19:28:32 +0100
From: Kristof Provost <Kristof@provost-engineering.be>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] several returns before unlocking in lmc_ioctl
Message-ID: <20071030182832.GI32270@berith>
References: <471D4763.60604@tiscali.nl> <471D52C4.1050701@tiscali.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <471D52C4.1050701@tiscali.nl>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Scanned: 2.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2007-10-23 03:47:48 (+0200), Roel Kluin <12o3l@tiscali.nl> wrote:
> I think we should keep the lmc_tracing. Use this patch instead.
>=20
> --
>     Several returns before unlocking in lmc_ioctl
>    =20
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_mai=
n.c
> index 5ea8772..64eb578 100644
<snip>
> @@ -229,9 +234,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq =
*ifr, int cmd) /*fold00*/
>          sc->lmc_xinfo.Magic1 =3D 0xDEADBEEF;
> =20
>          if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
> -                         sizeof (struct lmc_xinfo)))
> -            return -EFAULT;
> -        ret =3D 0;
> +					sizeof(struct lmc_xinfo))) {
> +		ret =3D -EFAULT;
> +	else
> +		ret =3D 0;
I think you have an extra curly brace there. It breaks compile on my
system.

Kristof
=20

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHJ3fQUEZ9DhGwDugRAmcnAJ9q1J7ivdo3UtaurjIaEfjAs9tVTACfdjMO
dPPFUfU2vHRM9JqK6bR07Lk=
=QOpv
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
