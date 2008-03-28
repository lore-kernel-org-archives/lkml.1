Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYC1M6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYC1M6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758494AbYC1Mzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:39 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504AbYC1Mzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:35 -0400
Date: Fri, 28 Mar 2008 07:25:56 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 14/35] W1: w1_slave_read_id multiple short read bug
Message-ID: <20080328122556.GO3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96dIhm/ZjrNld+BP"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:56 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--96dIhm/ZjrNld+BP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is more to point out the bug in w1_slave_read_id, the next patch
rewrites the routine.

w1.c 1.15
Reading at an offset other than zero, ie reading less than 8 bytes at
a time would result in reading the first bytes over and over until 8
bytes were returned.  Added the offset to the buffer.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b18eedb..dbd9930 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -110,13 +110,13 @@ static ssize_t w1_slave_read_id(struct kobject *kobj,
 {
 	struct w1_slave *sl =3D kobj_to_w1_slave(kobj);
=20
-	if (off > 8) {
+	if (off >=3D 8) {
 		count =3D 0;
 	} else {
 		if (off + count > 8)
 			count =3D 8 - off;
=20
-		memcpy(buf, (u8 *)&sl->reg_num, count);
+		memcpy(buf, (u8 *)&sl->reg_num+off, count);
 	}
=20
 	return count;
--=20
1.4.4.4

--96dIhm/ZjrNld+BP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OPUAI852cse6PARAk93AKCuIvncuumjwIMaYGm9He82s13VJgCfTh6I
ldct+L9wrkwXXdkBqqLj9VA=
=xGOO
-----END PGP SIGNATURE-----

--96dIhm/ZjrNld+BP--
