Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZANHCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZANHCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZANHBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:01:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:64907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZANHBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:01:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,262,1231142400"; 
   d="asc'?scan'208";a="378290119"
Subject: Re: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090114065359.GA16044@gondor.apana.org.au>
References: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
	 <20090114065359.GA16044@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XZKUfC8tHQUIZ0vlIVmr"
Date: Wed, 14 Jan 2009 15:01:51 +0800
Message-Id: <1231916511.5937.151.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XZKUfC8tHQUIZ0vlIVmr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-14 at 14:53 +0800, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 02:44:08PM +0800, Huang Ying wrote:
> > Because:
> >=20
> > 1. if use %s, you can only request cryptd(<driver name>), not
> >    cryptd(<alg name>), because generated new algorithm instance has
> >    algorithm name: <alg name> and driver name cryptd(<driver name>).
>=20
> This is intentional.  For the purposes we talked about we should
> be requesting cryptd(<driver name>), as otherwise you may end up
> with someone else's AES algorithm as the base.

Current cryptd works well for AES-NI implementation. But how about
somebody want cryptd(cbc(aes)), and don't care about the driver.

> > 2. Generated cryptd-ed algorithm will have the same algorithm name and
> >    higher priority, but some user may not want to use cryptd-ed
> >    version.
>=20
> The priority shouldn't be an issue in our case since the AES-NI
> algorithm should register itself as an ablkcipher with an even
> higher priority.

Yes, not an issue for AES-NI case until now. But, for example there is
no aes-ni, if someone request cryptd(cbc(aes-asm)), other user will get
cryptd(cbc(aes-asm)) instead of cbc(aes-asm) when request cbc(aes), is
this a good behavior?

Best Regards,
Huang Ying


--=-XZKUfC8tHQUIZ0vlIVmr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkltjdwACgkQKhFGF+eHlpjGgQCWK3boOD9Ozpho3AhqUEfXYAll
4gCfRmF6aesJ1bIM/d0S5PNQRE32zeE=
=QGK7
-----END PGP SIGNATURE-----

--=-XZKUfC8tHQUIZ0vlIVmr--

