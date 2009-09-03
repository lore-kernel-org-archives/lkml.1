Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZICVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZICVMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338AbZICVMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:12:24 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:52858 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbZICVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:12:22 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make sure the value in abs() does not get truncated if it is greater than 2^32
Date: Thu, 3 Sep 2009 23:12:01 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc6-git; KDE/4.3.1; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1352288.7Cedh2St8A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909032312.10418.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1352288.7Cedh2St8A
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I was just digging a bit around in linux/kernel.h and stumbled over the abs=
()=20
makro. For me it looks as it would return wrong results on 64 bit platforms=
=20
if the input value is greater than 2^32.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
=2D--
 include/linux/kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..1e6eb66 100644
=2D-- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -145,7 +145,7 @@ extern int _cond_resched(void);
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
=20
 #define abs(x) ({				\
=2D		int __x =3D (x);			\
+		long __x =3D (x);			\
 		(__x < 0) ? -__x : __x;		\
 	})
=20
=2D-=20
1.6.0.2


--nextPart1352288.7Cedh2St8A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqgMSoACgkQXKSJPmm5/E539gCdGaS8L/5rrtbWuBZ40AFLGajY
3uYAmwTI2YpJSPym8R+uUmZ5dmIrtCml
=4KtI
-----END PGP SIGNATURE-----

--nextPart1352288.7Cedh2St8A--
