Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbZDJBvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbZDJBvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZDJBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:51:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:20207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZDJBva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:51:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="asc'?scan'208";a="680373723"
Subject: Re: GCM benchmark
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090409082152.GA4099@gondor.apana.org.au>
References: <1239263421.6384.41.camel@yhuang-dev.sh.intel.com>
	 <20090409082152.GA4099@gondor.apana.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AE2TDQ5F4aSmGFi0ab+H"
Date: Fri, 10 Apr 2009 09:51:28 +0800
Message-Id: <1239328288.6384.69.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AE2TDQ5F4aSmGFi0ab+H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-09 at 16:21 +0800, Herbert Xu wrote:
> On Thu, Apr 09, 2009 at 03:50:21PM +0800, Huang Ying wrote:
> > Hi, Herbert,
> >=20
> > I am working on GCM acceleration with Intel new PCLMULQDQ instructions
> > now. Can you tell me how to do GCM benchmark?
>=20
> We need to add the infrastructure for testing AEAD speed.  It can
> be modelled after the cipher/hash speed testing code.

One issue here is that blkcipher testing infrastructure uses
local_bh_disable()/local_irq_disable() to get more accurate result. But
AEAD uses asynchronous interface, something like
wait_for_completion_interruptable() will be used in test path. How to
get more accurate result for testing asynchronous interface? Maybe it
can be: test many times, select the one with best performance. What's
your opinion?

> > BTW: Similar with AES-NI support, I use cryptd to defer requests in sof=
t
> > IRQ context. Now, cryptd uses crypto_hash instead of crypto_shash as
> > child. I think we should change that. If you have not done that, I will
> > do that.
>=20
> We need to complete the conversion of all hash algorithms to shash
> first.

Yes.

Best Regards,
Huang Ying


--=-AE2TDQ5F4aSmGFi0ab+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkneph4ACgkQKhFGF+eHlpjZdQCeN1YQbGWmiwSxOmYjfxIsN4RO
YTkAoJluLPcdm7+8b2kr0x/Hp03oXzwI
=f+Z1
-----END PGP SIGNATURE-----

--=-AE2TDQ5F4aSmGFi0ab+H--

