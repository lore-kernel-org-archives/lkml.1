Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYIPNCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYIPNCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYIPNB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:01:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:20578 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIPNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:01:57 -0400
Date: Tue, 16 Sep 2008 16:02:36 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080916130234.GA17082@localhost.localdomain>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20080916125802.GA15951@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2008 at 03:58:02PM +0300, Adrian Bunk wrote:
> On Tue, Sep 16, 2008 at 03:22:43PM +0300, Kirill A. Shutemov wrote:
> > <linux/fcntl.h> conflicts with glibc's <fcntl.h>.
> >=20
> > It breaks building kdelibs, kdepim and pinot.
>=20
> We should rather fix the actual bug.
>=20
> What is the error message?

/usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
flock'
/usr/include/bits/fcntl.h:142: error: previous definition of 'struct
flock'
/usr/include/asm-generic/fcntl.h:140: error: redefinition of 'struct
flock64'
/usr/include/bits/fcntl.h:157: error: previous definition of 'struct
flock64'

>=20
> >...
> > --- a/include/linux/inotify.h
> > +++ b/include/linux/inotify.h
> > @@ -7,8 +7,10 @@
> >  #ifndef _LINUX_INOTIFY_H
> >  #define _LINUX_INOTIFY_H
> > =20
> > +#ifdef __KERNEL__
> >  /* For O_CLOEXEC and O_NONBLOCK */
> >  #include <linux/fcntl.h>
> > +#endif
> >... =20
>=20
> This breaks the header for users of IN_CLOEXEC/IN_NONBLOCK.
>=20
> cu
> Adrian
>=20
> --=20
>=20
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>=20

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjPrmoACgkQbWYnhzC5v6o5SwCfZUjiM2Zs+ZP33Dz8c2UYES4y
Q2sAn12wEHdrCtli41HbTyeAoEbQ9DZ5
=TTOZ
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
