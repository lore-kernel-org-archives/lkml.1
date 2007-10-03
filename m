Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXJCAab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXJCAab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXJCAaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:30:21 -0400
Received: from ozlabs.org ([203.10.76.45]:44416 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXJCAaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:30:19 -0400
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linas Vepstas <linas@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071003002646.GD9814@bakeyournoodle.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <20070924123531.GC30855@shadowen.org>
	 <20071002232819.GN4338@austin.ibm.com>
	 <20071003002646.GD9814@bakeyournoodle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WYSzyGelrcydW7aGMI+8"
Date: Wed, 03 Oct 2007 10:30:16 +1000
Message-Id: <1191371416.8073.1.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WYSzyGelrcydW7aGMI+8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-03 at 10:26 +1000, Tony Breeds wrote:
> On Tue, Oct 02, 2007 at 06:28:19PM -0500, Linas Vepstas wrote:
> > On Mon, Sep 24, 2007 at 01:35:31PM +0100, Andy Whitcroft wrote:
> > > Seeing the following from an older power LPAR, pretty sure we had
> > > this in the previous -mm also:
> >=20
> > I haven't forgetten about this ... and am looking at it now.
> > Seems that whenever I go to reserve the machine pSeries-102,
> > someone else is using it :-)
>=20
> This panic is caused by "[POWERPC] pseries: Fix jumbled no_logging flag."
> (79c0108d1b9db4864ab77b2a95dfa04f2dcf264c), in the powerpc/for-2.6.24
> branch.  It looks to me that we have logging enabled too early now.
>=20
> I think the following is a reasonable fix?
>=20
> ---
> Explicitly enable RTAS error logging, when it should be ready.
>=20
>=20
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
>=20
> ---
>=20
>  arch/powerpc/platforms/pseries/rtasd.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platfo=
rms/pseries/rtasd.c
> index 30925d2..0df5d0d 100644
> --- a/arch/powerpc/platforms/pseries/rtasd.c
> +++ b/arch/powerpc/platforms/pseries/rtasd.c
> @@ -54,7 +54,10 @@ static unsigned int rtas_event_scan_rate;
>  static int full_rtas_msgs =3D 0;
> =20
>  /* Stop logging to nvram after first fatal error */
> -static int no_more_logging;
> +static int no_more_logging =3D 1; /* Until we initialize everything,
> +                                 * make sure we don't try logging
> +                                 * anything */
> +

I realise it'll make the patch bigger, but this doesn't seem like a
particularly good name for the variable anymore.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-WYSzyGelrcydW7aGMI+8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHAuKYdSjSd0sB4dIRAgQaAKChXpo6czn9QHG+RCiFCdSyecGl9ACdEDit
QUejGm5eJo/TxR+FsRWNoTw=
=kRrk
-----END PGP SIGNATURE-----

--=-WYSzyGelrcydW7aGMI+8--

