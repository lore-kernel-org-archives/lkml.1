Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXHVCPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXHVCPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXHVCPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:15:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60337 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbXHVCPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:15:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add some Blackfin specific checks to checkpatch.pl
Date: Tue, 21 Aug 2007 22:15:43 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, bryan.wu@analog.com, apw@shadowen.org
References: <200708211829.59975.vapier@gentoo.org>
In-Reply-To: <200708211829.59975.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2475241.bcoU3x9U9q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708212215.43929.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2475241.bcoU3x9U9q
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Check for a few common errors in Blackfin-specific code wrt MMR loading in
assembly and doing core/system syncs.  Restrict the Blackfin MMR checks to=
=20
actual Blackfin assembly files as pointed out by Joe Perches.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Bryan Wu <bryan.wu@analog.com>
CC: Andy Whitcroft <apw@shadowen.org>
=2D--
 scripts/checkpatch.pl |   22 ++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dae7d30..ead9675 100755
=2D-- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -486,9 +486,31 @@ sub process {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
=20
+# Blackfin: use hi/lo macros
+		if ($realfile =3D~ s@arch/blackfin/.*\.S$@) {
+			if ($line =3D~ /\.[lL][[:space:]]*=3D.*&[[:space:]]*0x[fF][fF][fF][fF]/=
) {
+				my $herevet =3D "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
+			}
+			if ($line =3D~ /\.[hH][[:space:]]*=3D.*>>[[:space:]]*16/) {
+				my $herevet =3D "$here\n" . cat_vet($line) . "\n";
+				ERROR("use the HI() macro, not (... >> 16)\n" . $herevet);
+			}
+		}
+
 # check we are in a valid source file *.[hc] if not then ignore this hunk
 		next if ($realfile !~ /\.[hc]$/);
=20
+# Blackfin: don't use __builtin_bfin_[cs]sync
+		if ($line =3D~ /__builtin_bfin_csync/) {
+			my $herevet =3D "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the CSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+		if ($line =3D~ /__builtin_bfin_ssync/) {
+			my $herevet =3D "$here\n" . cat_vet($line) . "\n";
+			ERROR("use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
+		}
+
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
 		if ($line=3D~/^\+\s* \t\s*\S/ or $line=3D~/^\+\s*        \s*/) {
=2D-=20
1.5.3.rc5

--nextPart2475241.bcoU3x9U9q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iQIVAwUARsucT0FjO5/oN/WBAQJ9+A/9FvARcXpaSiCP5k/lCekaxv8II9J+GIxn
Z8MuTBfPzrWyHYk0E5h3CSfHeWbf0mYXfjVOnphIygVTIZzLDMVlIHKI66S48NMh
yJFmn+usn+tiqZWgxpWyA3ECIaszFdN8oPB7H1PrGMipMz+kWhh4qB5Xzum36vwC
MZtl1YH4xjN3YPuVpeWKo11f62bSytQq+oa8D+5fUpQgor5JdYFg/sUrKuJZW5ou
5g2J2zyYqYL8el9vHDta3BDwe8QWJg5uZlzCb5Xv9IlNyTLyTDOuY0ZbU29QnQpw
PUfuA42lXpsGgUfyTJ3GFMWKTVObspEZaiAyCvWR4Hbph6MAemPTWNtnFro3JS2W
adE2qZw0ZFoGyDDqtNlbk8YJyeOf+kVwr5qADzMgYtXjlJVSJIGy11nktywb6jeV
ZmmX6K5UZYry8z5m+ZGHiuoEtyp2GSlrIwXrcecfpVkZDeDKkeeDypMHQF1PWPz5
f9TSMtuBNZsIHMBQL+3u6odv1LCQfLcQdNcpvCvrnGGysO5mDoB75SwLxBX0VjpZ
fM2wvoQDKjFS8c7WoTk64OaF02XCYG/PQcqQ4JWsOG0df5ls1dFjLYRSUIV3DxGP
VkEd0rqdvoJsEQmHVqMJmDOvaYa8Ggx0fsscmHe2Gl08pXr46a8ut1316hwY9/ms
Nch++JbksHQ=
=q4V/
-----END PGP SIGNATURE-----

--nextPart2475241.bcoU3x9U9q--
