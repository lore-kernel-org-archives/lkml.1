Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZADLbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZADLbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZADLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:31:23 -0500
Received: from b01.ext.isohunt.com ([208.71.112.51]:34496 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbZADLbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:31:22 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 06:31:22 EST
Date: Sun, 4 Jan 2009 03:24:36 -0800
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, robbat2@gentoo.org
Subject: reiserfs broken "unknown uniqueness" (commit
	c1eaa26b671299b3ec01d40c6c71ee19a4f81517)
Message-ID: <20090104112436.GT32364@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2pi4Gp0KyRJpQ5Nw"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2pi4Gp0KyRJpQ5Nw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Please CC, not on LKML).

Reiserfs broken recently, git bisect narrows it down to commit
c1eaa26b671299b3ec01d40c6c71ee19a4f81517.

[   52.365262] ReiserFS: warning: vs-500: unknown uniqueness -30719
=2E..
[27630.378732] ReiserFS: warning: vs-500: unknown uniqueness -30720
(and many more of the same with one of those two numbers on the end).

Manifests as various file creation operations failing, like:
(my /usr/src is on reiserfs with tail-packing enabled)
cd /usr/src && git clone --local file://`pwd`/linux linux.testcase

Git fails at creating the .config file in this example.

I had originally thought that my filesystem was corrupt, but fsck showed me=
 to
be clean, and a different kernel caused the problem to go away.

I don't know enough of inode internals to understand why it broke like this.
(Anybody looking to confirm the string, it's from the uniqueness2type funct=
ion
defined in "include/linux/reiserfs_fs.h").

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--2pi4Gp0KyRJpQ5Nw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAklgnHMACgkQPpIsIjIzwiwuVgCePC/VnQ+JpZnOnosF9AfaD32A
hw8AoK9Sbhzhg/xhmqgGrJeLzj2+zND8
=daNT
-----END PGP SIGNATURE-----

--2pi4Gp0KyRJpQ5Nw--
