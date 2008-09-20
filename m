Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYITV7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYITV7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYITV7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:59:46 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:60548 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbYITV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:59:45 -0400
Date: Sat, 20 Sep 2008 23:59:42 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: apw@shadowen.org
Subject: [PATCH] [CHECKPATCH] Check for p0-patches
Message-ID: <20080920215942.GA26888@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Check if the patch is most likely a p0-patch and give a warning if so.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 scripts/checkpatch.pl |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: playground/scripts/checkpatch.pl
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- playground.orig/scripts/checkpatch.pl
+++ playground/scripts/checkpatch.pl
@@ -986,6 +986,7 @@
 	my $in_comment =3D 0;
 	my $comment_edge =3D 0;
 	my $first_line =3D 0;
+	my $p1_prefix =3D '';
=20
 	my $prev_values =3D 'E';
=20
@@ -1123,7 +1124,12 @@
 		# extract the filename as it passes
 		if ($line=3D~/^\+\+\+\s+(\S+)/) {
 			$realfile =3D $1;
-			$realfile =3D~ s@^[^/]*/@@;
+			$realfile =3D~ s@^([^/]*)/@@;
+
+			$p1_prefix =3D $1;
+			if ($tree && -e "$root/$p1_prefix") {
+				WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
+			}
=20
 			if ($realfile =3D~ m@include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specifi=
c files in include/asm-<architecture>\n" . "$here$rawline\n");
--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjVck4ACgkQD27XaX1/VRv8tgCfSpeBUyaU6Wf7QApomlwpU15V
YIoAn0CE9i+PZ1HsF+BlpU2SgyypWB07
=fV28
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
