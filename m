Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZK3R7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZK3R7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZK3R7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:59:43 -0500
Received: from mail.klingt.org ([86.59.21.178]:55774 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbZK3R7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:59:42 -0500
Message-ID: <4B140806.9000308@klingt.org>
Date: Mon, 30 Nov 2009 18:59:34 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091129 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] branch profiling on my nehalem machine showed 99% incorrect
 branch hints:
References: <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com>
In-Reply-To: <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF5C399A04A8EB255D3E485F"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Mon, 30 Nov 2009 18:59:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF5C399A04A8EB255D3E485F
Content-Type: multipart/mixed;
 boundary="------------060500020600030306000905"

This is a multi-part message in MIME format.
--------------060500020600030306000905
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

i have regenerated the patch for tip/tip ...

--
   28459  7678524  99 __cache_alloc_node             slab.c              =
 3551

Discussion on lkml [1] led to the solution to remove this hint.

[1] http://patchwork.kernel.org/patch/63517/

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)



--------------060500020600030306000905
Content-Type: text/x-patch;
 name="0001-branch-profiling-on-my-nehalem-machine-showed-99-inc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-branch-profiling-on-my-nehalem-machine-showed-99-inc.pa";
 filename*1="tch"

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..0d4b731 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3306,7 +3306,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t=
 flags, int nodeid,
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
=20
-	if (unlikely(nodeid =3D=3D -1))
+	if (nodeid =3D=3D -1)
 		nodeid =3D numa_node_id();
=20
 	if (unlikely(!cachep->nodelists[nodeid])) {


--------------060500020600030306000905--

--------------enigBF5C399A04A8EB255D3E485F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksUCAYACgkQdL+4qsZfVsvM5QCglM/5fQ7/XwWfi4qFcwWju1aQ
MBUAmwcL7hQ19rnPJDfW8tYKpziJN0wo
=mv5W
-----END PGP SIGNATURE-----

--------------enigBF5C399A04A8EB255D3E485F--
