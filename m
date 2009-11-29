Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZK2MFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZK2MFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 07:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZK2MFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 07:05:11 -0500
Received: from mail.klingt.org ([86.59.21.178]:52064 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZK2MFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 07:05:10 -0500
Message-ID: <4B1262AC.8000903@klingt.org>
Date: Sun, 29 Nov 2009 13:01:48 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091127 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sched: Optimize branch hint in context_switch()
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig922C6DE6A79F1E45007F0D6E"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Sun, 29 Nov 2009 13:01:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig922C6DE6A79F1E45007F0D6E
Content-Type: multipart/mixed;
 boundary="------------080608080806010705010001"

This is a multi-part message in MIME format.
--------------080608080806010705010001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Branch hint profiling on my nehalem machine showed 88%
incorrect branch hints:

42017484 326957902  88 context_switch                 sched.c            =
  3043
42038493 326953687  88 context_switch                 sched.c            =
  3050

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)



--------------080608080806010705010001
Content-Type: text/x-patch;
 name="0001-sched-Optimize-branch-hint-in-context_switch.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-sched-Optimize-branch-hint-in-context_switch.patch"

diff --git a/kernel/sched.c b/kernel/sched.c
index 2a78b38..c78dcfe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3040,14 +3040,14 @@ context_switch(struct rq *rq, struct task_struct =
*prev,
 	 */
 	arch_start_context_switch(prev);
=20
-	if (likely(!mm)) {
+	if (unlikely(!mm)) {
 		next->active_mm =3D oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
=20
-	if (likely(!prev->mm)) {
+	if (unlikely(!prev->mm)) {
 		prev->active_mm =3D NULL;
 		rq->prev_mm =3D oldmm;
 	}


--------------080608080806010705010001--

--------------enig922C6DE6A79F1E45007F0D6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSYqwACgkQdL+4qsZfVsvC4ACeLeg/5sWrq1P0CfCsuvowXyvD
J6IAn36YrDK7QnZmsXQB16Vu2rPplyEb
=9pAs
-----END PGP SIGNATURE-----

--------------enig922C6DE6A79F1E45007F0D6E--
