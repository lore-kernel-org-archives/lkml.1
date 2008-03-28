Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYC1Mus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYC1Mus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYC1Mua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:50:30 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56310 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbYC1Mu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:50:29 -0400
Date: Fri, 28 Mar 2008 07:24:00 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 2/35] W1: abort search early on on exit
Message-ID: <20080328122400.GC3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:24:01 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.5
Early abort if the master driver or the hardware goes away in the
middle of a bus search operation.  The alternative is to spam the
print buffer up to 64*64 times with read errors in the case of USB.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 2d11fe7..6fb4110 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -771,6 +771,11 @@ void w1_search(struct w1_master *dev, u8 search_type, =
w1_slave_found_callback cb
 			/* extract the direction taken & update the device number */
 			tmp64 =3D (triplet_ret >> 2);
 			rn |=3D (tmp64 << i);
+
+			if(test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				return;
+			}
 		}
=20
 		if ( (triplet_ret & 0x03) !=3D 0x03 ) {
--=20
1.4.4.4

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ONgAI852cse6PARAuHpAKDE+08loaztkwld3gd/kiLuOTYyIQCfQAwE
SC7zd8RfG3oResmc8BU/cqA=
=pPJj
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
