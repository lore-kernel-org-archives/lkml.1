Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYC1MvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYC1MvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYC1Muj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:50:39 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56312 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYC1Mui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:50:38 -0400
Date: Fri, 28 Mar 2008 07:25:10 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 8/35] W1: feature, w1_therm.c use strong pullup
Message-ID: <20080328122510.GI3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:10 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_therm.c 1.3 1.4 1.10
Use the strong pullup not the sleep.  Note that the pullup goes before
W1_CONVERT_TEMP not after.
+w1_next_pullup(dev, tm);
 w1_write_8(dev, W1_CONVERT_TEMP);
-msleep(tm);

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/slaves/w1_therm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index fb28aca..dd26db2 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -192,10 +192,10 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
 			int count =3D 0;
 			unsigned int tm =3D 750;
=20
+			/* 750ms strong pullup (or delay) after the convert */
+			w1_next_pullup(dev, tm);
 			w1_write_8(dev, W1_CONVERT_TEMP);
=20
-			msleep(tm);
-
 			if (!w1_reset_select_slave(sl)) {
=20
 				w1_write_8(dev, W1_READ_SCRATCHPAD);
--=20
1.4.4.4

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OOlAI852cse6PARAv18AKCv62B0+2MaP40CsKvqO8jc1nMtXwCghzCJ
wNP5JcRFHuRk+BMVdGYPE3U=
=xccb
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--
