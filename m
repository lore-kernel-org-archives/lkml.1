Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXJKXbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXJKXbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXJKXbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:31:15 -0400
Received: from ozlabs.org ([203.10.76.45]:42025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbXJKXbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:31:14 -0400
Subject: Re: [patch 1/2] Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE
	#define
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kumar Gala <galak@kernel.crashing.org>
Cc: markn@au1.ibm.com, PowerPC dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <DFC6881D-E917-4EC5-B19C-8CE04E040B06@kernel.crashing.org>
References: <20071011071558.676463639@au1.ibm.com>
	 <20071011072208.075979098@au1.ibm.com>
	 <DFC6881D-E917-4EC5-B19C-8CE04E040B06@kernel.crashing.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZbF/pTGSW0O73+6a+MeH"
Date: Fri, 12 Oct 2007 09:31:12 +1000
Message-Id: <1192145472.6274.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZbF/pTGSW0O73+6a+MeH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-11 at 08:04 -0500, Kumar Gala wrote:
> On Oct 11, 2007, at 2:15 AM, markn@au1.ibm.com wrote:
>=20
> > Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE in the coredump code =20
> > which
> > allows for more flexibility in the note type for the state of =20
> > 'extended
> > floating point' implementations in coredumps. New note types can =20
> > now be
> > added with an appropriate #define.
> >
> > #define ELF_CORE_XFPREG_TYPE to be NT_PRXFPREG in all current users so
> > there's are no change in behaviour.
>=20
> Can we make this ELF_CORE_VECREG_TYPE or something that is so coupled =20
> to the x86 specific name?
>=20
> >
> > Signed-off-by: Mark Nelson <markn@au1.ibm.com>
> > ---
> >  arch/ia64/ia32/elfcore32.h     |    1 +
> >  arch/x86_64/ia32/ia32_binfmt.c |    1 +
> >  fs/binfmt_elf.c                |    4 ++--
> >  include/asm-i386/elf.h         |    1 +
> >  4 files changed, 5 insertions(+), 2 deletions(-)
> >
> > Index: linux/arch/ia64/ia32/elfcore32.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux.orig/arch/ia64/ia32/elfcore32.h
> > +++ linux/arch/ia64/ia32/elfcore32.h
> > @@ -117,6 +117,7 @@ elf_core_copy_task_fpregs(struct task_st
> >  }
> >
> >  #define ELF_CORE_COPY_XFPREGS 1
> > +#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
> >  static inline int
> >  elf_core_copy_task_xfpregs(struct task_struct *tsk, =20
> > elf_fpxregset_t *xfpu)
> >  {
> > Index: linux/arch/x86_64/ia32/ia32_binfmt.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
> > +++ linux/arch/x86_64/ia32/ia32_binfmt.c
> > @@ -188,6 +188,7 @@ elf_core_copy_task_fpregs(struct task_st
> >  }
> >
> >  #define ELF_CORE_COPY_XFPREGS 1
> > +#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
> >  static inline int
> >  elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t =20
> > *xfpu)
> >  {
> > Index: linux/fs/binfmt_elf.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux.orig/fs/binfmt_elf.c
> > +++ linux/fs/binfmt_elf.c
> > @@ -1446,8 +1446,8 @@ static int elf_dump_thread_status(long s
> >
> >  #ifdef ELF_CORE_COPY_XFPREGS
> >  	if (elf_core_copy_task_xfpregs(p, &t->xfpu)) {
> > -		fill_note(&t->notes[2], "LINUX", NT_PRXFPREG, sizeof(t->xfpu),
> > -			  &t->xfpu);
> > +		fill_note(&t->notes[2], "LINUX", ELF_CORE_XFPREG_TYPE,
> > +			  sizeof(t->xfpu), &t->xfpu);
> >  		t->num_notes++;
> >  		sz +=3D notesize(&t->notes[2]);
> >  	}
>=20
> You've only fixed up one of 4 NT_PRXFPREG uses in the kernel.
>=20
> Also, I'm not a fan of your proposed mechanism to "overload" the =20
> elf_fpxregset_t.  I'd rather see us introduce a new elf_vecregset_t =20
> and have it typedef'd to be elf_fpxregset_t on i386, x86_64, ia64

He's not overloading it, there is no such thing as an elf_fpxregset_t,
unless it's typedef'd to something else by the arch code, eg:

include/asm-i386/elf.h:typedef struct user_fxsr_struct elf_fpxregset_t;
include/asm-ia64/elf.h:typedef unsigned long elf_fpxregset_t;

Introducing another typedef would just be another layer of obfuscation
IMO, and the elf code doesn't need any more of that.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-ZbF/pTGSW0O73+6a+MeH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHDrJAdSjSd0sB4dIRAjLxAJ4mzBvuCsD43PszkIoCDxrhXK04SACgpjSC
cIMJvUxlwPO4hqc9dMpHbLA=
=8e3U
-----END PGP SIGNATURE-----

--=-ZbF/pTGSW0O73+6a+MeH--

