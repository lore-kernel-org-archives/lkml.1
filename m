Return-Path: <linux-kernel-owner+w=401wt.eu-S965683AbXAYJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683AbXAYJjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965740AbXAYJjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:39:16 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:44314 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965683AbXAYJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:39:15 -0500
Message-ID: <45B87932.1070803@freedesktop.org>
Date: Thu, 25 Jan 2007 01:32:34 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
CC: Andrew Morton <akpm@osdl.org>, usb-hacking@psas.pdx.edu
Subject: [PATCH] USB: In init_endpoint_class, use PTR_ERR to obtain an errno
 value, not IS_ERR
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF59DAD349237819D149144E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF59DAD349237819D149144E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

init_endpoint_class calls class_create, and checks the result for an erro=
r
with IS_ERR; however, if true, it then returns the result of IS_ERR (a
boolean) rather than PTR_ERR (the actual errno).

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 drivers/usb/core/endpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Resent with correct address for linux-usb-devel; for others, sorry for th=
e
duplicate.

diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 5e628ae..e0ec704 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -229,7 +229,7 @@ static int init_endpoint_class(void)
 	kref_init(&ep_class->kref);
 	ep_class->class =3D class_create(THIS_MODULE, "usb_endpoint");
 	if (IS_ERR(ep_class->class)) {
-		result =3D IS_ERR(ep_class->class);
+		result =3D PTR_ERR(ep_class->class);
 		goto class_create_error;
 	}
=20




--------------enigBF59DAD349237819D149144E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFuHkyGJuZRtD+evsRAtTLAKCJRrVsLeM1aFhvEHfopXEIKZMkGwCfSiQN
2p973+5PwmoQ5mbakttd8AA=
=v4ma
-----END PGP SIGNATURE-----

--------------enigBF59DAD349237819D149144E--
