Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZCCAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZCCAQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbZCCAQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:17 -0500
Received: from ozlabs.org ([203.10.76.45]:44542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbZCCAQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:16 -0500
Subject: Re: [PATCH 2/6] PCI MSI: Replace 'type' with 'is_msix'
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1235410082-5016-3-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
	 <1235410082-5016-3-git-send-email-matthew@wil.cx>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lxQDMsPfzH9CXOM21Ozk"
Date: Tue, 03 Mar 2009 11:16:11 +1100
Message-Id: <1236039371.8230.105.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lxQDMsPfzH9CXOM21Ozk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 12:27 -0500, Matthew Wilcox wrote:
> By changing from a 5-bit field to a 1-bit field, we free up some bits
> that can be used by a later patch.  Also rearrange the fields for better
> packing on 64-bit platforms (reducing the size of msi_desc from 72 bytes
> to 64 bytes).
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index dceea56..b3db438 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c

> @@ -393,7 +355,7 @@ static int msi_capability_init(struct pci_dev *dev)
>  	if (!entry)
>  		return -ENOMEM;
> =20
> -	entry->msi_attrib.type =3D PCI_CAP_ID_MSI;
> +	entry->msi_attrib.is_msix =3D 0;

This isn't strictly necessary given we kzalloc'ed the entry, but no
biggie.

Looks good otherwise.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-lxQDMsPfzH9CXOM21Ozk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmsdssACgkQdSjSd0sB4dLcsQCeOStGwGLtiYswkDxEJCuSJYsv
kmoAoIEEzidMF8CwB9jfmAMmhrmvRiK2
=TnEj
-----END PGP SIGNATURE-----

--=-lxQDMsPfzH9CXOM21Ozk--

