Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZAOJbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZAOJbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZAOJbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:31:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:51480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZAOJbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,268,1231142400"; 
   d="asc'?scan'208";a="657314578"
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090115092314.GA32559@gondor.apana.org.au>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
	 <20090115084750.GA32239@gondor.apana.org.au>
	 <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
	 <20090115092314.GA32559@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bdjU8KK2Xk0NS5L5KzmE"
Date: Thu, 15 Jan 2009 17:30:51 +0800
Message-Id: <1232011851.5937.208.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bdjU8KK2Xk0NS5L5KzmE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 17:23 +0800, Herbert Xu wrote:
> On Thu, Jan 15, 2009 at 05:21:47PM +0800, Huang Ying wrote:
> > On Thu, 2009-01-15 at 16:47 +0800, Herbert Xu wrote:
> > > On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
> > > >
> > > > +	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> > > > +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D
> > > > +	       THIS_MODULE);
> > >=20
> > > You need to check whether tfm is an error before dereferencing it.
> > > Also it's probably better to free the tfm and return an error rather
> > > than invoking BUG.
> >=20
> > Why do we need this check? Someone else may register cryptd template?
> > Which error number should be return? -EINVAL?
>=20
> -ENOMEM for example.

You mean something as follow:

if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D THIS_MODULE)
        return ERR_PTR(-ENOMEM);

I think -ENOMEM is not appropriate for this check.

Sorry for ask you same question twice. Why do we need this check? Some
other module may register cryptd template?

Best Regards,
Huang Ying

--=-bdjU8KK2Xk0NS5L5KzmE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklvAkgACgkQKhFGF+eHlpjFzwCgpZz+1f3W8NAr5hQgERfVFZEF
cpYAn1pkME/ny+oNoD19rVpoFxsfLUPQ
=Ekuo
-----END PGP SIGNATURE-----

--=-bdjU8KK2Xk0NS5L5KzmE--

