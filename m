Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZDGPo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZDGPo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZDGPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:44:47 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53777 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZDGPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:44:47 -0400
Date: Tue, 7 Apr 2009 17:44:37 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [Resend] [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090407154437.GA31758@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
References: <20090330122137.GA6918@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <20090330122137.GA6918@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: multipart/mixed; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again!

I just saw that this patch did not go anywhere and did not have
any replies, so I repost it.

I also created a git-repo at
 =20
  git://git.schottelius.org/linux/linux-2.6
  gitweb:
  http://git.schottelius.org/?p=3Dlinux/linux-2.6;a=3Dsummary

if you want the patch (f43ba0be1204e7c26cc700a75bdb688a788fbf2f)
via git.

Sincerly,

Nico

Nico Schottelius [Mon, Mar 30, 2009 at 02:21:37PM +0200]:
> Hello!
>=20
> When using trees like wireless-testing, which have untagged tags,
> scripts/setlocalversion does not display any git indication for
> localversion.
>=20
> This patch fixes it: If git is available, but no usable tag is found,
> it uses -g${head}. It skips the detection of unanottated tags via
> git name-rev.
>=20
> Please apply, otherwise testers like me always have '2.6.29' for trees
> with unanottated tags, instead of 2.6.29-20318-g9aa4755, which helps
> a lot if you've tons of kernels installed from different trees.
>=20
> Sincerly,
>=20
> Nico
>=20
> ps: please cc on reply

--KFztAG8eRSV9hGtP
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

--KFztAG8eRSV9hGtP--

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknbdOUACgkQuL75KpiFGIwNEQCgr8xjo0J8a4a9aa0iWc5Hx/PP
kl0AoJxEvGVfYDjPHTfrcCUOfTgssVcu
=HbnH
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
