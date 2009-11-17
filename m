Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZKQMwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZKQMwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZKQMwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:52:34 -0500
Received: from ozlabs.org ([203.10.76.45]:46803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZKQMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:52:33 -0500
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
 without CONFIG_XICS set
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <1258461544.24093.72.camel@concordia>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258461544.24093.72.camel@concordia>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BMaeNH7yeliJffYihnrk"
Date: Tue, 17 Nov 2009 23:52:38 +1100
Message-ID: <1258462358.24093.83.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BMaeNH7yeliJffYihnrk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 23:39 +1100, Michael Ellerman wrote:
> On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> > KConfig doesn't require CONFIG_XICS to be set with CONFIG_PSERIES but i=
f
> > it's not set, there are numerous small build errors. This is a small se=
ries
> > of patches to allow CONFIG_XICS to be unset in the config.
> >=20
> > XICS appears to be some sort of interrupt controller but I'm not sure h=
ow
> > common it is on systems that require CONFIG_PSERIES. If CONFIG_PSERIES
> > universally requires CONFIG_XICS, the better path might be to force it =
to
> > be set.
>=20
> It is indeed 'some sort of interrupt controller' :)
>=20
> All the virtualised PSERIES systems have, or appear to have, a XICS. So
> it's pretty common.
>=20
> I think the only time you see an MPIC is on older machines, and even
> then maybe only if you're running bare metal.
>=20
> So it is pretty much required for a PSERIES kernel, but perhaps there
> are cases where the BML guys want to be able to turn it off.

In fact this series makes me wonder whether we can drop support for a
single kernel image with pseries XICS & MPIC support.

If we could drop that requirement we could have a single set of names,
ie. API, for the irq routines and build either the XICS or MPIC
versions.

That would avoid all the code that needs a setup_foo_xics() and
setup_foo_mpic() - it'd just be setup_foo(), implemented by either the
XICS or MPIC code.

cheers



--=-BMaeNH7yeliJffYihnrk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksCnJYACgkQdSjSd0sB4dLlTACgyOQzAgYGj6l+DZblroA00YGi
ARkAn33WbyMtc8NO2zv1V/blPTosRG2U
=T2C3
-----END PGP SIGNATURE-----

--=-BMaeNH7yeliJffYihnrk--

