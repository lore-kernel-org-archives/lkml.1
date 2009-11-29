Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZK2Lzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZK2Lzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZK2Lzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:55:54 -0500
Received: from mail.klingt.org ([86.59.21.178]:38618 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZK2Lzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:55:54 -0500
Message-ID: <4B126124.60902@klingt.org>
Date: Sun, 29 Nov 2009 12:55:16 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091127 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] sched, x86: Optimize branch hint in __switch_to()
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0ABA9069F674BBAC57147F1F"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Sun, 29 Nov 2009 12:55:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0ABA9069F674BBAC57147F1F
Content-Type: multipart/mixed;
 boundary="------------080205030302090701010401"

This is a multi-part message in MIME format.
--------------080205030302090701010401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Branch hint profiling on my nehalem machine showed 89%
incorrect branch hints:

31032542 270070841  89 __switch_to                    process_64.c       =
  440

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 arch/x86/kernel/process_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)



--------------080205030302090701010401
Content-Type: text/x-patch;
 name="0001-sched-x86-Optimize-branch-hint-in-__switch_to.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-sched-x86-Optimize-branch-hint-in-__switch_to.patch"

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c8d0ece..88068b3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -437,7 +437,7 @@ __switch_to(struct task_struct *prev_p, struct task_s=
truct *next_p)
 	 * reload when it has changed.  When prev process used 64bit
 	 * base always reload to avoid an information leak.
 	 */
-	if (unlikely(fsindex | next->fsindex | prev->fs)) {
+	if (fsindex | next->fsindex | prev->fs) {
 		loadsegment(fs, next->fsindex);
 		/*
 		 * Check if the user used a selector !=3D 0; if yes


--------------080205030302090701010401--

--------------enig0ABA9069F674BBAC57147F1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSYSkACgkQdL+4qsZfVst57QCaAlvTag49D0iQmQIfUHhWAUCL
SbAAnjmeLz9KxLdNs62bHqLXNv1z3RIe
=A+a4
-----END PGP SIGNATURE-----

--------------enig0ABA9069F674BBAC57147F1F--
