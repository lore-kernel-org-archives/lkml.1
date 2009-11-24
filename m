Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbZKXLKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbZKXLKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZKXLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:10:51 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZKXLKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:50 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBBA8.2090604@klingt.org>
Date: Tue, 24 Nov 2009 11:55:36 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] slab.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org>
In-Reply-To: <cover.1259059549.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig142AEE78C2F68D4549DBB251"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:01:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig142AEE78C2F68D4549DBB251
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

branch profiling on my nehalem machine showed 99% incorrect branch hints:=


   28459  7678524  99 __cache_alloc_node             slab.c
  3551

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index f70b326..4125fcd 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
gfp_t flags, int nodeid,
 	slab_irq_save(save_flags, this_cpu);
  	this_node =3D cpu_to_node(this_cpu);
-	if (unlikely(nodeid =3D=3D -1))
+	if (nodeid =3D=3D -1)
 		nodeid =3D this_node;
  	if (unlikely(!cachep->nodelists[nodeid])) {
--=20
1.6.4.2



--------------enig142AEE78C2F68D4549DBB251
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu6gACgkQdL+4qsZfVsudMwCePruS/Nf3kvQlAszj6xpDZWOV
/ooAn0N6R+Kk3AeFQz+NDDBYtODK+/lI
=ccf9
-----END PGP SIGNATURE-----

--------------enig142AEE78C2F68D4549DBB251--
