Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYJGG4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYJGG4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYJGG4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:56:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:42690 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYJGG4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:56:00 -0400
Date: Tue, 7 Oct 2008 09:57:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007065701.GA5012@localhost.localdomain>
References: <20081006132651.GG3180@one.firstfloor.org> <1223303879-5555-1-git-send-email-kirill@shutemov.name> <20081006192923.GJ3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20081006192923.GJ3180@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2008 at 09:29:23PM +0200, Andi Kleen wrote:
> On Mon, Oct 06, 2008 at 05:37:59PM +0300, Kirill A. Shutemov wrote:
> > It allows interpret attach address as a hint, not as exact address.
>=20
> First you should also do a patch for the manpage and send to=20
> the manpage maintainer.

I'll do it if the patch is ok.

> >  #define SHM_LOCK 	11
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index e77ec69..19462bb 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -819,7 +819,7 @@ long do_shmat(int shmid, char __user *shmaddr, int =
shmflg, ulong *raddr)
> >  	if (shmid < 0)
> >  		goto out;
> >  	else if ((addr =3D (ulong)shmaddr)) {
> > -		if (addr & (SHMLBA-1)) {
> > +		if (!(shmflg & SHM_MAP_HINT) && (addr & (SHMLBA-1))) {
> >  			if (shmflg & SHM_RND)
> >  				addr &=3D ~(SHMLBA-1);	   /* round down */
> >  			else
> > @@ -828,7 +828,7 @@ long do_shmat(int shmid, char __user *shmaddr, int =
shmflg, ulong *raddr)
> >  #endif
> >  					goto out;
> >  		}
> > -		flags =3D MAP_SHARED | MAP_FIXED;
> > +		flags =3D (shmflg & SHM_MAP_HINT ? 0 : MAP_FIXED) | MAP_SHARED;
>=20
>=20
> IMHO you need at least make the
>=20
>    if (find_vma_intersection(current->mm, addr, addr + size))
>                         goto invalid;
>=20
> test above conditional too.

Since it's a hint, we shouldn't call find_vma_intersection() at all.

I'll send fixed patch soon.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjrCD0ACgkQbWYnhzC5v6pSfwCdHXb4WrjRsItJl+QbsbhIGNiR
DZ0An1pDpowyCY1PXewWbVfTLVfKQod1
=QrNi
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
