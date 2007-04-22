Return-Path: <linux-kernel-owner+w=401wt.eu-S965554AbXDVI6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbXDVI6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXDVI6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:58:13 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:35012 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965554AbXDVI6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:58:11 -0400
X-Greylist: delayed 1107 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 04:58:11 EDT
Date: Sun, 22 Apr 2007 10:58:09 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow reading tainted flag as user
Message-ID: <20070422085809.GA9078@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org
References: <20070422083941.GA7945@wavehammer.waldi.eu.org> <20070422015045.f39d6ff7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20070422015045.f39d6ff7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 22, 2007 at 01:50:45AM -0700, Andrew Morton wrote:
> On Sun, 22 Apr 2007 10:39:41 +0200 Bastian Blank <bastian@waldi.eu.org> w=
rote:
>=20
> > The commit 34f5a39899f3f3e815da64f48ddb72942d86c366 restricted reading
> > of the tainted value. The attached patch changes this back to a
> > write-only check and restores the read behaviour of older versions.
> >=20
> > Signed-off-by: Bastian Blank <bastian@waldi.eu.org>
>=20
> there's no patch here.

Ups.

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1b255df..c904748 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1676,7 +1676,7 @@ static int proc_dointvec_taint(ctl_table *table, int =
write, struct file *filp,
 {
 	int op;
=20
-	if (!capable(CAP_SYS_ADMIN))
+	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
=20
 	op =3D OP_OR;

--=20
Captain's Log, star date 21:34.5...

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkYrI6EACgkQnw66O/MvCNFVbgCfXSciry2+3nvGzdLVK1uq6c4e
XZAAnirDrSwXh+Jj9+/17iaK91ARuOvu
=pLHK
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
