Return-Path: <linux-kernel-owner+w=401wt.eu-S933828AbYBHSft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbYBHSft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbYBHSfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:35:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:47360 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757170AbYBHSfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:35:40 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19b0IIOoZBbtCATcHCiMq8fvCzWz5xVQh+ZArZcG1
	sQSC2XSam9jivw
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 43/45] x86: replace LOCK_PREFIX in futex.h
Date: Fri, 8 Feb 2008 19:35:33 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
References: <20080207204118.202098927@mini.kroah.org> <20080207204821.GR16389@suse.de>
In-Reply-To: <20080207204821.GR16389@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5520212.f7gcxnirR1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802081935.34666.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5520212.f7gcxnirR1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 7. Februar 2008, Greg KH wrote:
> 2.6.24-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
> From: Thomas Gleixner <tglx@linutronix.de>
>=20
> The exception fixup for the futex macros __futex_atomic_op1/2 and
> futex_atomic_cmpxchg_inatomic() is missing an entry when the lock
> prefix is replaced by a NOP via SMP alternatives.
>=20
> Chuck Ebert tracked this down from the information provided in:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D429412
>=20
> A possible solution would be to add another fixup after the
> LOCK_PREFIX, so both the LOCK and NOP case have their own entry in the
> exception table, but it's not really worth the trouble.
>=20
> Simply replace LOCK_PREFIX with lock and keep those untouched by SMP
> alternatives.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  include/asm-x86/futex_32.h |    6 +++---
>  include/asm-x86/futex_64.h |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

This patch seems to break compilation on x86_64 (i386 builds fine).

[...]
  CC      kernel/time/tick-sched.o
  LD      kernel/time/built-in.o
  CC      kernel/futex.o
In file included from include/asm/futex.h:4,
                 from kernel/futex.c:59:
include/asm/futex_64.h: In function =E2=80=98futex_atomic_op_inuser=E2=80=
=99:
include/asm/futex_64.h:69: error: expected =E2=80=98:=E2=80=99 or =E2=80=98=
)=E2=80=99 before =E2=80=98lock=E2=80=99
include/asm/futex_64.h:69: error: stray =E2=80=98\=E2=80=99 in program
In file included from include/asm/futex.h:4,
                 from kernel/futex.c:59:
include/asm/futex_64.h:69:61: error: invalid suffix "b" on integer constant
include/asm/futex_64.h:69: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:69: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:72: error: expected =E2=80=98:=E2=80=99 or =E2=80=98=
)=E2=80=99 before =E2=80=98lock=E2=80=99
include/asm/futex_64.h:72: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:72:63: error: invalid suffix "b" on integer constant
include/asm/futex_64.h:72: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:72: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:75: error: expected =E2=80=98:=E2=80=99 or =E2=80=98=
)=E2=80=99 before =E2=80=98lock=E2=80=99
include/asm/futex_64.h:75: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:75:62: error: invalid suffix "b" on integer constant
include/asm/futex_64.h:75: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:75: error: stray =E2=80=98\=E2=80=99 in program
include/asm/futex_64.h:51: warning: unused variable =E2=80=98tem=E2=80=99
make[1]: *** [kernel/futex.o] Fehler 1
make: *** [kernel] Fehler 2

Tested on current debian-amd64/ unstable.
ii  binutils                                           2.18.1~cvs20080103-1=
       The GNU assembler, linker and binary utiliti
ii  gcc-4.2                                            4.2.3-1             =
       The GNU C compiler
ii  gcc-4.2-base                                       4.2.3-1             =
       The GNU Compiler Collection (base package)

[...]
> --- a/include/asm-x86/futex_64.h
> +++ b/include/asm-x86/futex_64.h
> @@ -27,7 +27,7 @@
>  "1:	movl	%2, %0\n\
>  	movl	%0, %3\n"					\
>  	insn "\n"						\
> -"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
> +"2:	"lock cmpxchgl %3, %2\n\
>  	jnz	1b\n\
>  3:	.section .fixup,\"ax\"\n\
>  4:	mov	%5, %1\n\
> @@ -62,7 +62,7 @@ futex_atomic_op_inuser (int encoded_op,=20
>  		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
>  		break;
>  	case FUTEX_OP_ADD:
> -		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
> +		__futex_atomic_op1("lock xaddl %0, %2", ret, oldval,
>  				   uaddr, oparg);
>  		break;
>  	case FUTEX_OP_OR:
> @@ -101,7 +101,7 @@ futex_atomic_cmpxchg_inatomic(int __user
>  		return -EFAULT;
> =20
>  	__asm__ __volatile__(
> -		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
> +		"1:	lock cmpxchgl %3, %1			\n"
> =20
>  		"2:	.section .fixup, \"ax\"			\n"
>  		"3:	mov     %2, %0				\n"

Regards
	Stefan Lippers-Hollmann

--nextPart5520212.f7gcxnirR1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHrKD2ORbEMfgJlPYRAkZkAJ9XI6CT6YSmVzVcesvWTnkNAW3Y/gCfeeg+
xmbH6SmmC395qR2/ae+XEU4=
=HLB8
-----END PGP SIGNATURE-----

--nextPart5520212.f7gcxnirR1--
