Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZC3MVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZC3MVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZC3MVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:21:42 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58869 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZC3MVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:21:41 -0400
Date: Mon, 30 Mar 2009 14:21:37 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org
Subject: [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090330122137.GA6918@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

When using trees like wireless-testing, which have untagged tags,
scripts/setlocalversion does not display any git indication for
localversion.

This patch fixes it: If git is available, but no usable tag is found,
it uses -g${head}. It skips the detection of unanottated tags via
git name-rev.

Please apply, otherwise testers like me always have '2.6.29' for trees
with unanottated tags, instead of 2.6.29-20318-g9aa4755, which helps
a lot if you've tons of kernels installed from different trees.

Sincerly,

Nico

ps: please cc on reply

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-localversion-2.6.29"
Content-Transfer-Encoding: quoted-printable

--- old/scripts/setlocalversion	2009-03-27 09:37:07.160938681 +0100
+++ new/scripts/setlocalversion	2009-03-30 14:14:21.187397016 +0200
@@ -10,13 +10,12 @@
=20
 # Check for git and a git repo.
 if head=3D`git rev-parse --verify --short HEAD 2>/dev/null`; then
-	# Do we have an untagged version?
-	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefi=
ned)$' > /dev/null; then
-		if tag=3D`git describe 2>/dev/null`; then
-			echo $tag | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
-		else
-			printf '%s%s' -g $head
-		fi
+	# Do we have an annotated tag?
+	if atag=3D`git describe 2>/dev/null`; then
+		echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+	# add -g${head}, if there is no usable tag
+	else
+		printf '%s%s' -g $head
 	fi
=20
 	# Is this git on svn?

--C7zPtVaVf+AK4Oqc--

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknQuVEACgkQuL75KpiFGIys8QCgv0DUsYvrAdeel812cvBoLDPH
SdsAniQTnU6wOK+ZfM1aAOoOi2hnrMpL
=OMwS
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
