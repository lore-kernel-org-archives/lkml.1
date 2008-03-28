Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYC1Mv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYC1Mv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYC1Muu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:50:50 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56314 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbYC1Mut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:50:49 -0400
Date: Fri, 28 Mar 2008 07:27:05 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 23/35] W1: ds2490.c correct print message
Message-ID: <20080328122705.GX3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dZJOqldIUwtPuZvk"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:06 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dZJOqldIUwtPuZvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.2
Corrected print message, it was writing not reading, this also prints
the endpoint used for the write instead of hardcoding it.
        Failed to write 1-wire data to ep0x%x: err=3D%d.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index b63b5e0..67a7f42 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -341,7 +341,8 @@ static int ds_send_data(struct ds_device *dev, unsigned=
 char *buf, int len)
 	count =3D 0;
 	err =3D usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, dev->ep[EP_DAT=
A_OUT]), buf, len, &count, 1000);
 	if (err < 0) {
-		printk(KERN_ERR "Failed to read 1-wire data from 0x02: err=3D%d.\n", err=
);
+		printk(KERN_ERR "Failed to write 1-wire data to ep0x%x: err=3D%d.\n",
+			dev->ep[EP_DATA_OUT], err);
 		return err;
 	}
=20
--=20
1.4.4.4

--dZJOqldIUwtPuZvk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQZAI852cse6PARAndVAJ95XAglDw/oAz/clE/B3ru51IefPACgxVpE
OwE+x2lDV5kh34q+6kh/Aao=
=tzZW
-----END PGP SIGNATURE-----

--dZJOqldIUwtPuZvk--
