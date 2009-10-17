Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZJQQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZJQQJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZJQQJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 12:09:00 -0400
Received: from mail.klingt.org ([86.59.21.178]:34374 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZJQQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 12:09:00 -0400
Message-ID: <4AD9EBFD.106@klingt.org>
Date: Sat, 17 Oct 2009 18:08:29 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5pre) Gecko/20091014 Lightning/1.0pre Shredder/3.0pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: delay_secs safety
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD199486F2EBD79809FF6CCD0"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2b1 (klingt.org [127.0.0.1]); Sat, 17 Oct 2009 18:08:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD199486F2EBD79809FF6CCD0
Content-Type: multipart/mixed;
 boundary="------------030809070709060108040900"

This is a multi-part message in MIME format.
--------------030809070709060108040900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


add delay_secs sanity check to handle_keypress, fixes a division by
zero crash.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 tools/perf/builtin-top.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


--------------030809070709060108040900
Content-Type: text/x-patch;
 name="0001-perf-tools-delay_secs-safety.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-perf-tools-delay_secs-safety.patch"

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2d8806b..cc66286 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -663,6 +663,8 @@ static void handle_keypress(int c)
 	switch (c) {
 		case 'd':
 			prompt_integer(&delay_secs, "Enter display delay");
+			if (delay_secs < 1)
+				delay_secs =3D 1;
 			break;
 		case 'e':
 			prompt_integer(&print_entries, "Enter display entries (lines)");


--------------030809070709060108040900--

--------------enigD199486F2EBD79809FF6CCD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrZ7AEACgkQdL+4qsZfVsvYAACfWCDc2MuJwYWsuO5XHWvL9Fnb
Bo4An0R3uJZ3NdbMaewMGw+p0JwOJ1SZ
=9OOm
-----END PGP SIGNATURE-----

--------------enigD199486F2EBD79809FF6CCD0--
