Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZANGo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZANGo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZANGoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:44:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:33539 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZANGoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:44:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,262,1231142400"; 
   d="asc'?scan'208";a="656962357"
Subject: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8cegAMkWd/GWRuciTo1o"
Date: Wed, 14 Jan 2009 14:44:08 +0800
Message-Id: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8cegAMkWd/GWRuciTo1o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Because:

1. if use %s, you can only request cryptd(<driver name>), not
   cryptd(<alg name>), because generated new algorithm instance has
   algorithm name: <alg name> and driver name cryptd(<driver name>).

2. Generated cryptd-ed algorithm will have the same algorithm name and
   higher priority, but some user may not want to use cryptd-ed
   version.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -215,7 +215,9 @@ static struct crypto_instance *cryptd_al
=20
 	ctx->state =3D state;
=20
-	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg->cra_name) >=3D CRYPTO_MAX_ALG_NAME)
+		goto out_free_inst;
=20
 	inst->alg.cra_priority =3D alg->cra_priority + 50;
 	inst->alg.cra_blocksize =3D alg->cra_blocksize;


--=-8cegAMkWd/GWRuciTo1o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkltibMACgkQKhFGF+eHlpiFDgCfRrxNsesjmM39mzQxWVN8gwF9
uQcAn1ToKNBajnqvmD38hZe4qHqd/aqo
=8QGZ
-----END PGP SIGNATURE-----

--=-8cegAMkWd/GWRuciTo1o--

