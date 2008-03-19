Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYCSTYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYCSTYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYCSTYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:24:16 -0400
Received: from systemlinux.org ([83.151.29.59]:60717 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYCSTYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:14 -0400
Date: Wed, 19 Mar 2008 12:51:35 +0100
From: Andre Noll <maan@systemlinux.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Fix permissions of /proc/net
Message-ID: <20080319115135.GM32242@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxlYARId5dseejUu"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxlYARId5dseejUu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commit f205a545ee62e0f0f797c1e2b0bd2062d96414b3
Author: Andre Noll <maan@congo.fml.local>
Date:   Wed Mar 19 11:39:55 2008 +0100

=46rom: Andre Noll <maan@systemlinux.org>

commit e9720ac ([NET]: Make /proc/net a symlink on /proc/self/net (v3))
broke ganglia and probably other applications that read /proc/net/dev.

This is due to the change of permissions of /proc/net that was
introduced in that commit.

Before: dr-xr-xr-x 5 root root 0 Mar 19 11:30 /proc/net
After: dr-xr--r-- 5 root root 0 Mar 19 11:29 /proc/self/net

This patch restores the permissions to the old value which makes ganglia
happy again.

Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8a10f6f..81d7d14 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2290,7 +2290,7 @@ static const struct pid_entry tgid_base_stuff[] =3D {
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
 #ifdef CONFIG_NET
-	DIR("net",        S_IRUGO|S_IXUSR, net),
+	DIR("net",        S_IRUGO|S_IXUGO, net),
 #endif
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--FxlYARId5dseejUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH4P5HWto1QDEAkw8RAj9/AJ96RrhHhDUWF3vbhzfb+3p/HhtmMwCfQl/S
fYc57b8+nZLgXllXdmg7VzE=
=r6Ja
-----END PGP SIGNATURE-----

--FxlYARId5dseejUu--
