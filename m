Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYJGKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYJGKI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYJGKH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:07:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:61595 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbYJGKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:07:56 -0400
Date: Tue, 7 Oct 2008 13:09:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC, v2] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007100854.GA5039@localhost.localdomain>
References: <20081006192923.GJ3180@one.firstfloor.org> <1223362670-5187-1-git-send-email-kirill@shutemov.name> <20081007082030.GD20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20081007082030.GD20740@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2008 at 10:20:30AM +0200, Andi Kleen wrote:
> On Tue, Oct 07, 2008 at 09:57:50AM +0300, Kirill A. Shutemov wrote:
> > It allows interpret attach address as a hint, not as exact address.
>=20
> Please expand the description a bit. Rationale. etc.
>=20
> > @@ -55,6 +55,7 @@ struct shmid_ds {
> >  #define	SHM_RND		020000	/* round attach address to SHMLBA boundary */
> >  #define	SHM_REMAP	040000	/* take-over region on attach */
> >  #define	SHM_EXEC	0100000	/* execution access */
> > +#define	SHM_MAP_HINT	0200000	/* interpret attach address as a hint */
>=20
> search hint

Ok.

> > @@ -892,7 +892,7 @@ long do_shmat(int shmid, char __user *shmaddr, int =
shmflg, ulong *raddr)
> >  	sfd->vm_ops =3D NULL;
> > =20
> >  	down_write(&current->mm->mmap_sem);
> > -	if (addr && !(shmflg & SHM_REMAP)) {
> > +	if (addr && !(shmflg & (SHM_REMAP|SHM_MAP_HINT))) {
>=20
> I think you were right earlier that it can be just deleted, so why don't
> you just do that?

I want say that we shouldn't do this check if shmaddr is a search hint.
I'm not sure that check is unneeded if shmadd is the exact address.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjrNTYACgkQbWYnhzC5v6r75QCeJ+U4G2XEohKAT+a2U48TwnBn
oOwAn127G3sfy14CewOOtjqnlyUHJ+HX
=kT7t
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
