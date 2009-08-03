Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbZHCUJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbZHCUJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZHCUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:09:23 -0400
Received: from mx.ugf.br ([200.222.48.3]:53930 "EHLO mx.ugf.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZHCUJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:09:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 16:09:21 EDT
Subject: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
 device
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, hch@lst.de, mszeredi@novell.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VTFjpbaH1EVlaQBVvifE"
Date: Mon, 03 Aug 2009 17:03:28 -0300
Message-Id: <1249329808.7686.26.camel@logos>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VTFjpbaH1EVlaQBVvifE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The __xfs_get_blocks function does not check if the pointer to the target
device is valid before dereferencing it.

Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: stable <stable@kernel.org>
---
 fs/xfs/linux-2.6/xfs_aops.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index aecf251..bf482d5 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1419,7 +1419,11 @@ __xfs_get_blocks(
 	 * If this is a realtime file, data may be on a different device.
 	 * to that pointed to from the buffer_head b_bdev currently.
 	 */
-	bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
+	if (!iomap.iomap_target)
+		return -XFS_ERROR(EIO);
+
+	if (iomap.iomap_flags & IOMAP_REALTIME)
+		bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
=20
 	/*
 	 * If we previously allocated a block out beyond eof and we are now
--=20
1.5.6.3


--=-VTFjpbaH1EVlaQBVvifE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp3QowACgkQGIS0iEuhp4PoBgCg3SOUddJ1Glh94VrZs1wDlc64
YpEAn2JaNQZZQiiSpjDuFPivkiOy+7jl
=FB/W
-----END PGP SIGNATURE-----

--=-VTFjpbaH1EVlaQBVvifE--

