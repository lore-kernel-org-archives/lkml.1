Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZBBGnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZBBGnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZBBGm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:42:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:3985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZBBGm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,363,1231142400"; 
   d="asc'?scan'208";a="661907421"
Subject: [PATCH 3/3] crypto: Uses kcrypto_wq instead of keventd_wq in
	chainiv
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5jknn2iMu47QG1rC39T/"
Date: Mon, 02 Feb 2009 14:42:25 +0800
Message-Id: <1233556945.19806.59.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5jknn2iMu47QG1rC39T/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

keventd_wq has potential starvation problem, so use dedicated
kcrypto_wq instead.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig   |    1 +
 crypto/chainiv.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -56,6 +56,7 @@ config CRYPTO_BLKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_RNG2
+	select CRYPTO_WORKQUEUE
=20
 config CRYPTO_HASH
 	tristate
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -15,6 +15,7 @@
=20
 #include <crypto/internal/skcipher.h>
 #include <crypto/rng.h>
+#include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -133,7 +134,7 @@ static int async_chainiv_schedule_work(s
 			goto out;
 	}
=20
-	queued =3D schedule_work(&ctx->postponed);
+	queued =3D queue_work(kcrypto_wq, &ctx->postponed);
 	BUG_ON(!queued);
=20
 out:


--=-5jknn2iMu47QG1rC39T/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmGlc4ACgkQKhFGF+eHlpgLEwCfYz0CsElqZ2j9/3CYqHdc/yYX
rpAAnAmlQbUUdSwb57+YjfiJVZKGLg8e
=ZfF2
-----END PGP SIGNATURE-----

--=-5jknn2iMu47QG1rC39T/--

