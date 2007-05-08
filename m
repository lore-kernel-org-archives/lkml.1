Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXEHGco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXEHGco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbXEHGcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:32:39 -0400
Received: from smtp-ext.int-evry.fr ([157.159.11.17]:37681 "EHLO
	smtp-ext.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934088AbXEHGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:32:39 -0400
X-Greylist: delayed 1760 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 02:32:38 EDT
From: Florian Fainelli <florian.fainelli@int-evry.fr>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] time locale in gen_initramfs_list.sh
Date: Tue, 8 May 2007 07:55:26 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2809982.g483iABZr5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705080755.31157.florian.fainelli@int-evry.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2809982.g483iABZr5
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ODBQGEa8cAAnGUE"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ODBQGEa8cAAnGUE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I noticed that some zsh users who forced their ls formatting to something n=
on=20
standard could not generate the initramfs file list. Forcing the locale to =
C=20
while generating seems not to be enough. Adding --time-style=3Dlocale will =
use=20
C locale ls output and will let them generate the initramfs list. It has no=
=20
side effects for other users.

Signed-off-by: Florian Fainelli <florian.fainelli@int-evry.fr>
=2D-

--Boundary-01=_ODBQGEa8cAAnGUE
Content-Type: text/plain;
  charset="us-ascii";
  name="time_locale.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="time_locale.patch"

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 683eb12..1f96b9b 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -125,7 +125,7 @@ parse() {
 			str="${ftype} ${name} ${location} ${str}"
 			;;
 		"nod")
-			local dev=`LC_ALL=C ls -l "${location}"`
+			local dev=`LC_ALL=C ls --time-style=locale -l "${location}"`
 			local maj=`field 5 ${dev}`
 			local min=`field 6 ${dev}`
 			maj=${maj%,}
@@ -135,7 +135,7 @@ parse() {
 			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
 			;;
 		"slink")
-			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
+			local target=`field 11 $(LC_ALL=C ls --time-style=locale -l "${location}")`
 			str="${ftype} ${name} ${target} ${str}"
 			;;
 		*)

--Boundary-01=_ODBQGEa8cAAnGUE--

--nextPart2809982.g483iABZr5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD4DBQBGQBDTkwOXMtq9F3IRAv3HAJMG3hnV4WJE3CuJ9D1lGtVz7zdsAJ9ZNQbU
frrYG5BbP8lLhXN7t+j1ow==
=7X1z
-----END PGP SIGNATURE-----

--nextPart2809982.g483iABZr5--
