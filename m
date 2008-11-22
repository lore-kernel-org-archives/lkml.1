Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYKVDlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYKVDlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbYKVDlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:41:12 -0500
Received: from ozlabs.org ([203.10.76.45]:54391 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbYKVDlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:41:10 -0500
Subject: Re: [PATCH] IB/ehca: Fix lockdep failures for shca_list_lock
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       OF-EWG <ewg@lists.openfabrics.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
In-Reply-To: <1227283347.3599.8.camel@johannes.berg>
References: <200806061835.43802.fenkes@de.ibm.com>
	 <48499C11.7030504@gmail.com>  <200811211637.15300.fenkes@de.ibm.com>
	 <1227283347.3599.8.camel@johannes.berg>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wGTLu2HDVlWeitLDaXUm"
Date: Sat, 22 Nov 2008 14:41:08 +1100
Message-Id: <1227325268.10134.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wGTLu2HDVlWeitLDaXUm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 17:02 +0100, Johannes Berg wrote:
> On Fri, 2008-11-21 at 16:37 +0100, Joachim Fenkes wrote:
>=20
> > +	u64 flags;
>=20
> > -	spin_lock(&shca_list_lock);
> > +	spin_lock_irqsave(&shca_list_lock, flags);
>=20
> That's wrong and I think will give a warning on all machines where
> u64 !=3D unsigned long. Might not particularly matter in this case.

Crud, sorry.

> Also, generally it seems wrong to say "fix lockdep failure" when the
> patch really fixes a bug that lockdep happened to find.

True. I guess it should be "fix locking error found with lockdep", to
make it clear no one has actually hit the bug.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-wGTLu2HDVlWeitLDaXUm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkknf1QACgkQdSjSd0sB4dLuegCfdD9QaCxGcfpr0dLLsdDw8aCy
znQAoKjg+uaMRKR7noZNuoq2/rhEX2Ed
=+IXW
-----END PGP SIGNATURE-----

--=-wGTLu2HDVlWeitLDaXUm--

