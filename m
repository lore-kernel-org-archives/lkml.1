Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYH0Qxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYH0Qxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYH0Qxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:53:30 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:51563 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYH0Qx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:53:29 -0400
Subject: Re: [PATCH] Export kmap_atomic_pfn for DRM-GEM.
From: Eric Anholt <eric@anholt.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Airlie <airlied@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808272336.05736.nickpiggin@yahoo.com.au>
References: <1219779789-8368-1-git-send-email-eric@anholt.net>
	 <1219779789-8368-2-git-send-email-eric@anholt.net>
	 <1219779789-8368-3-git-send-email-eric@anholt.net>
	 <200808272336.05736.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QfaZ7sTuY2ZQPz/Vwf7x"
Date: Wed, 27 Aug 2008 09:52:41 -0700
Message-Id: <1219855961.4994.6.camel@vonnegut.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QfaZ7sTuY2ZQPz/Vwf7x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-27 at 23:36 +1000, Nick Piggin wrote:
> On Wednesday 27 August 2008 05:43, Eric Anholt wrote:
> > The driver would like to map IO space directly for copying data in when
> > appropriate, to avoid CPU cache flushing for streaming writes.
> > kmap_atomic_pfn lets us avoid IPIs associated with ioremap for this
> > process.
> >
> > Signed-off-by: Eric Anholt <eric@anholt.net>
> > ---
> >  arch/x86/mm/highmem_32.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> > index 165c871..d52e91d 100644
> > --- a/arch/x86/mm/highmem_32.c
> > +++ b/arch/x86/mm/highmem_32.c
> > @@ -137,6 +137,7 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_ty=
pe
> > type)
> >
> >  	return (void*) vaddr;
> >  }
> > +EXPORT_SYMBOL(kmap_atomic_pfn);
> >
> >  struct page *kmap_atomic_to_page(void *ptr)
> >  {
>=20
>=20
> I wonder if you ever tested my vmap rework patches with this issue? It
> seems somewhat x86 specific and also not conceptually so clean to use
> kmap_atomic_pfn for this. vmap may not be used by all architectures but
> I think it might be able to cover some of them.
>=20
> As I said, there are some other possible improvements that can be made
> to my vmap rewrite if performance isn't good enough, but I simply have
> not seen numbers...

The consumer of this is a driver for Intel platforms, so being
x86-specific is not a worry this patch series.

However, when other DRM drivers get around to doing memory management,
I'm sure they'll also be interested in an ioremap_wc that doesn't eat
ipi costs.  For us, the ipis for flushing were eating over 10% of CPU
time.  If your patch series cuts that cost, we could drop this piece at
that point.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-QfaZ7sTuY2ZQPz/Vwf7x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAki1hlcACgkQHUdvYGzw6vds+QCgjGRitzsfjX29Pb0Aq3JTMRDM
7LoAnjjSYJpYt3+irZ6VvJsNf0Y1HKml
=vPZF
-----END PGP SIGNATURE-----

--=-QfaZ7sTuY2ZQPz/Vwf7x--
