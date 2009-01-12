Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZALGz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZALGz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZALGzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:55:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:43530 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZALGzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:55:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,251,1231142400"; 
   d="asc'?scan'208";a="98888053"
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090109070144.GA7358@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pgGYok33G0B8RvoQt4kN"
Date: Mon, 12 Jan 2009 14:55:10 +0800
Message-Id: <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pgGYok33G0B8RvoQt4kN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 15:01 +0800, Herbert Xu wrote:
> Actually I was thinking of something as simple as just using
> cryptd as is.  That is, register a blkcipher algorithm for your
> version of cbc-aes, but don't register under the name cbc(aes),
> e.g., register it under the name of __cbc-aes-aesni for both alg
> name and driver name.  You can register it under cbc(aes) too
> if you add the fallback in there.
>=20
> Then for the real thing, just allocate the blkcipher __cbc_*,
> plus the ablkcipher cryptd(__cbc_*), and invoke the right one
> depending on caller context.

One more question:

I use a "shell" cbc(aes) algorithm which chooses between
cryptd(__cbc-aes-aesni) and __cbc-aes-aesni according to context. But
the struct ablkcipher_request passed in can not be used for cryptd(*).
This can be resolved by allocating another struct ablkcipher_request for
cryptd(*) for each incoming struct ablkcipher_request. But is there any
better solution?

Best Regards,
Huang Ying

--=-pgGYok33G0B8RvoQt4kN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklq6UsACgkQKhFGF+eHlph79gCfaq/sf1JlBB8zTb2HLVGTiqmU
JHoAmgNCiJdMqjwZCoOBKmWyM4GvqLjI
=EgKi
-----END PGP SIGNATURE-----

--=-pgGYok33G0B8RvoQt4kN--

