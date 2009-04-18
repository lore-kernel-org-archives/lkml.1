Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZDRJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZDRJRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbZDRJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:17:00 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:54793 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbZDRJQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:16:59 -0400
Date: Sat, 18 Apr 2009 11:16:53 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Nico Schottelius <nico-linux-20090330@schottelius.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [Resend] [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090418091653.GB16933@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jiri Kosina <jkosina@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
References: <20090330122137.GA6918@denkbrett.schottelius.org> <20090407154437.GA31758@ikn.schottelius.org> <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de> <20090407174550.GB13089@uranus.ravnborg.org> <20090417213436.GA16933@ikn.schottelius.org> <20090417215802.GA16568@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <20090417215802.GA16568@uranus.ravnborg.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-wl-36123-g39fb448 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: multipart/mixed; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg [Fri, Apr 17, 2009 at 11:58:02PM +0200]:
> I thought I already applied a similar fix.
> Care to resend.

- git: git://git.schottelius.org/foreign/linux-2.6 (URL changed!):
  f43ba0be1204e7c26cc700a75bdb688a788fbf2fcommit
- Original patch attached (p1)
- Diff against your tree attached (p2)

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=p1
Content-Transfer-Encoding: quoted-printable

commit f43ba0be1204e7c26cc700a75bdb688a788fbf2f
Author: Nico Schottelius <nico@ikn.schottelius.org>
Date:   Tue Apr 7 17:27:18 2009 +0200

    [PATCH] Fix scripts/setlocalversion with git
   =20
    When using trees like wireless-testing, which have untagged tags,
    scripts/setlocalversion does not display any git indication for
    localversion.
   =20
    This patch fixes it: If git is available, but no usable tag is found,
    it uses -g${head}. It skips the detection of unanottated tags via
    git name-rev.
   =20
    Signed-off-by: Nico Schottelius <nico@ikn.schottelius.org>

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index f6946cf..296669a 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -10,13 +10,12 @@ cd "${1:-.}" || usage
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

--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=p2
Content-Transfer-Encoding: quoted-printable

--- kbuild-fixes/scripts/setlocalversion	2009-04-18 09:44:18.142135489 +0200
+++ linux-2.6/scripts/setlocalversion	2009-04-07 17:37:33.131483677 +0200
@@ -10,18 +10,17 @@
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
 	if git config --get svn-remote.svn.url >/dev/null; then
-	        printf -- '-svn%s' "`git svn find-rev $head`"
+	        printf -- '-svn%s' "`git-svn find-rev $head`"
 	fi
=20
 	# Are there uncommitted changes?

--NklN7DEeGtkPCoo3--

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknpmoUACgkQuL75KpiFGIxM0wCgooe8CTAilOOPljgLNaOKs98a
C2cAoJwKMum7LnXIBZN6HthRluiGq25B
=gSlx
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
