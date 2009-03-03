Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZCCAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZCCAQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbZCCAQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:19 -0500
Received: from ozlabs.org ([203.10.76.45]:44555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759604AbZCCAQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:16 -0500
Subject: Re: [PATCH 6/6] PCI MSI: Add support for multiple MSI
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1235410082-5016-7-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
	 <1235410082-5016-7-git-send-email-matthew@wil.cx>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AtkYLtc8Yiigr8dhf++s"
Date: Tue, 03 Mar 2009 11:16:13 +1100
Message-Id: <1236039373.8230.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AtkYLtc8Yiigr8dhf++s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 12:28 -0500, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
>=20
> Add the new API pci_enable_msi_block() to allow drivers to
> request multiple MSI and reimplement pci_enable_msi in terms of
> pci_enable_msi_block.  Ensure that the architecture back ends don't
> have to know about multiple MSI.
>=20

> diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
> index 3bb7d3d..0c16e2a 100644
> --- a/arch/powerpc/kernel/msi.c
> +++ b/arch/powerpc/kernel/msi.c
> @@ -19,6 +19,10 @@ int arch_msi_check_device(struct pci_dev* dev, int nve=
c, int type)
>  		return -ENOSYS;
>  	}
> =20
> +	/* PowerPC doesn't support multiple MSI yet */
> +	if (type =3D=3D PCI_CAP_ID_MSI && nvec > 1)
> +		return 1;
> +
>  	if (ppc_md.msi_check_device) {
>  		pr_debug("msi: Using platform check routine.\n");
>  		return ppc_md.msi_check_device(dev, nvec, type);

That bit:

Acked-by: Michael Ellerman <michael@ellerman.id.au>

I'll tell benh to expect this hunk to show up sometime via Jesse's tree.

Looks good otherwise, not sure if we'll ever implement it, but good to
have. Is AHCI the only driver you're planning on using it for ATM?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-AtkYLtc8Yiigr8dhf++s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmsds0ACgkQdSjSd0sB4dK8RwCgiIOGS8/PWetMLxaDVs1GLlK8
sysAnRva8lCKkO7AndCwwe2hKNmfbNXU
=a8SY
-----END PGP SIGNATURE-----

--=-AtkYLtc8Yiigr8dhf++s--

