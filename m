Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZBJGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZBJGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 01:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZBJGOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 01:14:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:56550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBJGOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:14:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,184,1233561600"; 
   d="asc'?scan'208";a="488716467"
Subject: [PATCH -v2 3/3] crypto: Uses kcrypto_wq instead of keventd_wq in
	chainiv
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xJJ/yNjf7cwkOyM2RhAu"
Date: Tue, 10 Feb 2009 14:14:03 +0800
Message-Id: <1234246443.20270.77.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xJJ/yNjf7cwkOyM2RhAu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Uses kcrypto_wq instead of keventd_wq in chainiv

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


--=-xJJ/yNjf7cwkOyM2RhAu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmRGygACgkQKhFGF+eHlpge6QCgnAgXhoEMUXmim/cBf9SSI+/G
Pn4AmgMafVabhvgO+aln++QEKfB2nkHQ
=ZYnO
-----END PGP SIGNATURE-----

--=-xJJ/yNjf7cwkOyM2RhAu--

