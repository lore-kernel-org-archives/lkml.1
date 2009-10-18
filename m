Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZJRXuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZJRXuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZJRXuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:50:05 -0400
Received: from ozlabs.org ([203.10.76.45]:48354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbZJRXuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:50:04 -0400
Subject: Re: [PATCH 3/3] powerpc perf_event: Add alignment-faults and
 emulation-faults software events
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Anton Blanchard <anton@samba.org>
Cc: benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091018111300.GM4808@kryten>
References: <20091018110929.GK4808@kryten> <20091018111126.GL4808@kryten>
	 <20091018111300.GM4808@kryten>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZZtt9XYGfs4yRBQtKZhE"
Date: Mon, 19 Oct 2009 10:50:05 +1100
Message-Id: <1255909805.4192.5.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZZtt9XYGfs4yRBQtKZhE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-18 at 22:13 +1100, Anton Blanchard wrote:
> Hook up the alignment-faults and emulation-faults events for powerpc.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>=20
> Index: linux.trees.git/arch/powerpc/include/asm/emulated_ops.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.trees.git.orig/arch/powerpc/include/asm/emulated_ops.h	2009-09-=
22 13:45:07.000000000 +1000
> +++ linux.trees.git/arch/powerpc/include/asm/emulated_ops.h	2009-09-22 13=
:45:27.000000000 +1000
> @@ -19,6 +19,7 @@
>  #define _ASM_POWERPC_EMULATED_OPS_H
> =20
>  #include <asm/atomic.h>
> +#include <linux/perf_event.h>
> =20
>=20
>  #ifdef CONFIG_PPC_EMULATED_STATS
> @@ -71,7 +72,18 @@ extern void ppc_warn_emulated_print(cons
> =20
>  #endif /* !CONFIG_PPC_EMULATED_STATS */
> =20
> -#define PPC_WARN_EMULATED(type, regs)	__PPC_WARN_EMULATED(type)
> -#define PPC_WARN_ALIGNMENT(type, regs)	__PPC_WARN_EMULATED(type)
> +#define PPC_WARN_EMULATED(type, regs)					\
> +	do {								\
> +		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,		\
> +			1, 0, regs, 0);					\
> +		__PPC_WARN_EMULATED(type);				\
> +	} while (0)
> +
> +#define PPC_WARN_ALIGNMENT(type, regs)					\
> +	do {								\
> +		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS,		\
> +			1, 0, regs, regs->dar);				\
> +		__PPC_WARN_EMULATED(type);				\
> +	} while (0)

Does that work with perfxxx configured off?

cheers

--=-ZZtt9XYGfs4yRBQtKZhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrbqakACgkQdSjSd0sB4dKPQQCeItH0ghULWUJ4WmGRMpUgG79k
RFoAn3RBua1T2wFfb2ey9eL5jDw4M3oZ
=8rqU
-----END PGP SIGNATURE-----

--=-ZZtt9XYGfs4yRBQtKZhE--

