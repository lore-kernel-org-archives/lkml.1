Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZKBGIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZKBGIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZKBGIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:08:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40424 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZKBGIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:08:18 -0500
Date: Mon, 2 Nov 2009 17:08:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hollis Blanchard <hollisb@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM: powerpc: Fix BUILD_BUG_ON condition
Message-Id: <20091102170815.86e2daf7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Nov_2009_17_08_15_+1100_ZDizPxQ9Oj5eMHLd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Nov_2009_17_08_15_+1100_ZDizPxQ9Oj5eMHLd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hollis, Avi,

This commit was added to the kvm tree recently:

> Author: Hollis Blanchard <hollisb@us.ibm.com>
> Date:   Fri Oct 23 00:35:30 2009 +0000
>=20
>     KVM: powerpc: Fix BUILD_BUG_ON condition
>    =20
>     The old BUILD_BUG_ON implementation didn't work with __builtin_consta=
nt_p().
>     Fixing that revealed this test had been inverted for a long time with=
out
>     anybody noticing...
>    =20
>     Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
>     Signed-off-by: Avi Kivity <avi@redhat.com>
>=20
> diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
> index bb13b1f..a550f0f 100644
> --- a/arch/powerpc/kvm/timing.h
> +++ b/arch/powerpc/kvm/timing.h
> @@ -48,7 +48,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu=
 *vcpu, int type) {}
>  static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int t=
ype)
>  {
>  	/* type has to be known at build time for optimization */
> -	BUILD_BUG_ON(__builtin_constant_p(type));
> +	BUILD_BUG_ON(!__builtin_constant_p(type));
>  	switch (type) {
>  	case EXT_INTR_EXITS:
>  		vcpu->stat.ext_intr_exits++;

It is OK as far as it goes.  It still does not build, though, due to the
new BUILD_BUG_ON macro.  So I have still commented out the BUILD_BUG_ON
in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Nov_2009_17_08_15_+1100_ZDizPxQ9Oj5eMHLd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrud08ACgkQjjKRsyhoI8wGeACeIJQh4cWxzOhIkvUao2zIs0zT
SlMAoKsairvsRmUMEpQy0PIaMofostn4
=VM+M
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Nov_2009_17_08_15_+1100_ZDizPxQ9Oj5eMHLd--
