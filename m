Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbZKXLLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbZKXLLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZKXLK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:10:59 -0500
Received: from mail.klingt.org ([86.59.21.178]:33175 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791AbZKXLK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:10:58 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 06:10:50 EST
Message-ID: <4B0BBB93.3080307@klingt.org>
Date: Tue, 24 Nov 2009 11:55:15 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] process_64: remove branch hint
References: <cover.1259059549.git.tim@klingt.org>
In-Reply-To: <cover.1259059549.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig76977C1A07226100CB50C18A"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:00:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig76977C1A07226100CB50C18A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

branch hint profiling of my nehalem machine, showed 96% incorrect branch
hints:

 6548732 174664120  96 __switch_to                    process_64.c
   406
 6548745 174565593  96 __switch_to                    process_64.c
   410

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 arch/x86/kernel/process_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c8d0ece..1e2e1fe 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -403,11 +403,11 @@ __switch_to(struct task_struct *prev_p, struct
task_struct *next_p)
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
+	if (next->es | prev->es)
 		loadsegment(es, next->es);
  	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
+	if (next->ds | prev->ds)
 		loadsegment(ds, next->ds);
  -- 1.6.4.2



--------------enig76977C1A07226100CB50C18A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLu5MACgkQdL+4qsZfVsvEiwCeOzA4vWzjmWPZJnPIAFDVIAxO
j6sAn2qvDEQQtbgNiwfog+4lOpp6kPq/
=g3YD
-----END PGP SIGNATURE-----

--------------enig76977C1A07226100CB50C18A--
