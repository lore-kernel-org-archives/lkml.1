Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbYBMLmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbYBMLmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbYBMLma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:42:30 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:3116 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbYBMLm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:42:29 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: allow alternative hook script dir in .deb packages
Date: Wed, 13 Feb 2008 12:42:18 +0100
User-Agent: KMail/1.9.7
Cc: sam@ravnborg.org
References: <200802131118.11413.elendil@planet.nl>
In-Reply-To: <200802131118.11413.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1338797.ptBylXTUX6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802131242.27907.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 11:42:27.0974 (UTC) FILETIME=[82607260:01C86E35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1338797.ptBylXTUX6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom: Frans Pop <elendil@planet.nl>
   =20
Hook scripts in the default directory /etc/kernel are also
executed by packages created using make-kpkg (including official
Debian kernels). Allow to specify an alternative hook scripts
directory by exporting the environment variable KERNELDEBHOOKDIR
so that this can be avoided.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 2577dec..c76bbf1 100644
=2D-- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -55,14 +55,17 @@ if grep -q '^CONFIG_MODULES=3Dy' .config ; then
 fi
=20
 # Install the maintainer scripts
+# Note: hook scripts under /etc/kernel are also executed by kernel packages
+# built using make-kpkg (from the "kernelpackage" package)
+debhookdir=3D${KERNELDEBHOOKDIR:-/etc/kernel}
 for script in postinst postrm preinst prerm ; do
=2D	mkdir -p "$tmpdir/etc/kernel/$script.d"
+	mkdir -p "$tmpdir$debhookdir/$script.d"
 	cat <<EOF > "$tmpdir/DEBIAN/$script"
 #!/bin/sh
=20
 set -e
=20
=2Dtest -d /etc/kernel/$script.d && run-parts --arg=3D"$version" /etc/kerne=
l/$script.d
+test -d $debhookdir/$script.d && run-parts --arg=3D"$version" $debhookdir/=
$script.d
 exit 0
 EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"

--nextPart1338797.ptBylXTUX6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHstejgm/Kwh6ICoQRAnBCAJ9kyaCzFTKt682Svenw0Jc/RHqm7QCdEWIb
o+SZgfXVXFVDmoUXZdr3u2A=
=OThC
-----END PGP SIGNATURE-----

--nextPart1338797.ptBylXTUX6--
