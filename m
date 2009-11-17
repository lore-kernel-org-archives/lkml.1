Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbZKQMo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbZKQMo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZKQMoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:44:55 -0500
Received: from ozlabs.org ([203.10.76.45]:40326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZKQMoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:44:55 -0500
Subject: Re: [PATCH 2/4] powerpc: Panic on platform ppc-xicp when
 CONFIG_XICS not set instead of build failure
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1258459659-11770-3-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258459659-11770-3-git-send-email-mel@csn.ul.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zwbNkCwuxkbKt0k2YRQj"
Date: Tue, 17 Nov 2009 23:45:00 +1100
Message-ID: <1258461900.24093.77.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zwbNkCwuxkbKt0k2YRQj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> If CONFIG_XICS is not set but CONFIG_PPC_PSERIES is, then the kernel
> fails to build with
>=20
> arch/powerpc/platforms/pseries/smp.c: In function =E2=80=98smp_init_pseri=
es_xics=E2=80=99:
> arch/powerpc/platforms/pseries/smp.c:202: error: =E2=80=98pSeries_xics_sm=
p_ops=E2=80=99 undeclared (first use in this function)
> arch/powerpc/platforms/pseries/smp.c:202: error: (Each undeclared identif=
ier is reported only once
> arch/powerpc/platforms/pseries/smp.c:202: error: for each function it app=
ears in.)
> make[2]: *** [arch/powerpc/platforms/pseries/smp.o] Error 1
>=20
> As CONFIG_XICS is not always necessary, this patch allows the kernel to
> build but the system will panic at runtime if it is found that XICS is
> required.
>=20
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  arch/powerpc/platforms/pseries/smp.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platform=
s/pseries/smp.c
> index 440000c..da78ea5 100644
> --- a/arch/powerpc/platforms/pseries/smp.c
> +++ b/arch/powerpc/platforms/pseries/smp.c
> @@ -199,7 +199,11 @@ void __init smp_init_pseries_mpic(void)
> =20
>  void __init smp_init_pseries_xics(void)
>  {
> +#ifdef CONFIG_XICS
>  	smp_ops =3D &pSeries_xics_smp_ops;
> +#else
> +	panic("Support for platform ppc-xicp not configured");
> +#endif
> =20
>  	smp_init_pseries();
>  }

I think it'd be neater to just ifdef the whole block in
pseries_discover_pic(), or move it out and ifdef that. That'd avoid
referencing pseries_xics_init_IRQ() and setup_kexec_cpu_down_xics()
also.

cheers

--=-zwbNkCwuxkbKt0k2YRQj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksCmssACgkQdSjSd0sB4dLFEQCfeVq096clKy9UBR/mXIRCSXxx
9rIAoLjyQBBwui0Cnb6/XShTgoKwcYZH
=aKPq
-----END PGP SIGNATURE-----

--=-zwbNkCwuxkbKt0k2YRQj--

