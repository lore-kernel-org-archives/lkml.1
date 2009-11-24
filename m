Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbZKXLML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbZKXLML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932811AbZKXLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:12:09 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797AbZKXLKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:55 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBB9F.6080304@klingt.org>
Date: Tue, 24 Nov 2009 11:55:27 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] sched.c: change branch hint
References: <cover.1259059549.git.tim@klingt.org>
In-Reply-To: <cover.1259059549.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig01E7B493E2DFA2A8B8BA051D"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:00:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig01E7B493E2DFA2A8B8BA051D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

branch hint profiling of my nehalem machine, showed over 90% incorrect
branch hints:

10420275 170645395  94 context_switch                 sched.c
   3043
10408421 171098521  94 context_switch                 sched.c
   3050

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c78dcfe..2a78b38 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3040,14 +3040,14 @@ context_switch(struct rq *rq, struct task_struct
*prev,
 	 */
 	arch_start_context_switch(prev);
 -	if (unlikely(!mm)) {
+	if (likely(!mm)) {
 		next->active_mm =3D oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 -	if (unlikely(!prev->mm)) {
+	if (likely(!prev->mm)) {
 		prev->active_mm =3D NULL;
 		rq->prev_mm =3D oldmm;
 	}
--=20
1.6.4.2



--------------enig01E7B493E2DFA2A8B8BA051D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu58ACgkQdL+4qsZfVssGFQCdHaS41OZxGBvUw08/zV5qHinu
YC4AmwZAi0kTT2bWjPBV6uSorlbzh2Iv
=lEIR
-----END PGP SIGNATURE-----

--------------enig01E7B493E2DFA2A8B8BA051D--
