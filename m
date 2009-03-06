Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZCFBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZCFBAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCFBAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:00:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:34449 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZCFBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:00:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,310,1233561600"; 
   d="asc'?scan'208";a="392114728"
Subject: Re: [PATCH 2/3] crypto: Add fpu template, a wrapper for blkcipher
	touching FPU
From: Huang Ying <ying.huang@intel.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305115402.GA4101@Chamillionaire.breakpoint.cc>
References: <1236219941.24215.38.camel@yhuang-dev.sh.intel.com>
	 <20090305115402.GA4101@Chamillionaire.breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vcNMvmQZZr1U5KxESahM"
Date: Fri, 06 Mar 2009 09:00:26 +0800
Message-Id: <1236301226.24215.59.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vcNMvmQZZr1U5KxESahM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-05 at 19:54 +0800, Sebastian Andrzej Siewior wrote:
> * Huang Ying | 2009-03-05 10:25:41 [+0800]:
>=20
> >Blkcipher touching FPU need to be enclosed by kernel_fpu_begin() and
> >kernel_fpu_end(). If they are invoked in cipher algorithm
> >implementation, they will be invoked for each block, so that
> >performance will be hurt, because they are "slow" operations. This
> >patch implements "fpu" template, which makes these operations to be
> >invoked for each request.
> >
> >Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> >---
> > crypto/Kconfig  |    7 ++
> > crypto/Makefile |    1=20
> > crypto/fpu.c    |  166 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> > 3 files changed, 174 insertions(+)
> >
> >--- a/crypto/Kconfig
> >+++ b/crypto/Kconfig
> >@@ -236,6 +236,13 @@ config CRYPTO_XTS
> > 	  key size 256, 384 or 512 bits. This implementation currently
> > 	  can't handle a sectorsize which is not a multiple of 16 bytes.
> >=20
> >+config CRYPTO_FPU
> >+	tristate "FPU wrapper"
> >+	select CRYPTO_BLKCIPHER
> >+	select CRYPTO_MANAGER
> >+	help
> >+	  FPU: Wrapper for blkcipher touching FPU.
> I as an end-user have to clue what this could be about. I suggest you
> don't make it visible since the explanation won't be helpfull either :)

Yes. That's better. I will change it.

Best Regards,
Huang Ying

--=-vcNMvmQZZr1U5KxESahM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmwdaIACgkQKhFGF+eHlpi8ZACfXUjSDw1jpkW+Z214Mvk3wQX6
4oUAnR1p0R8d58dnou1RqMCj6wKwuoRv
=Ko3t
-----END PGP SIGNATURE-----

--=-vcNMvmQZZr1U5KxESahM--

