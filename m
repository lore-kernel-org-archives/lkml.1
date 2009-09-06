Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZIFW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZIFW6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbZIFW6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 18:58:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35122 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758125AbZIFW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 18:58:39 -0400
X-Sasl-enc: pPFKD7ef04JserPRDwaPlbY/+W8zfpyGme5UkJyjejcD 1252277919
Message-ID: <4AA43E92.8080708@imap.cc>
Date: Mon, 07 Sep 2009 00:58:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/48] 2.6.27.32-stable review
References: <20090904201112.GA8274@kroah.com>
In-Reply-To: <20090904201112.GA8274@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA41CCB3D2BB6B6C5F1026E4D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA41CCB3D2BB6B6C5F1026E4D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Greg,

if at all possible, could you please include the patch below, with an

Acked-by: Tilman Schmidt <tilman@imap.cc>

tacked on? It applies fine to 2.6.27.31.

Thanks a lot in advance,
Tilman

---- original message follows ----
Message-ID: <4A9524BE.3060508@canonical.com>
Date: Wed, 26 Aug 2009 14:04:14 +0200
From: Stefan Bader <stefan.bader@canonical.com>
To: stable@kernel.org
CC: Tilman Schmidt <tilman@imap.cc>,=20
 "David S. Miller" <davem@davemloft.net>,
 Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Fix incorrect stable backport to bas_gigaset patch

This seems to affect 2.6.27.y and (discontinued) 2.6.28.y. Some code went=
 into=20
gigaset_probe instead of gigaset_initcshw causing an oops when the hardwa=
re is=20
probed.
[I added one pr_err statement from upstream, too)

-Stefan

=46rom 944fd2dab4173cea4fdcd50732529639ec00cf5d Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 25 Aug 2009 17:35:56 +0200
Subject: [PATCH] UBUNTU: SAUCE: Fix incorrect stable backport to bas_giga=
set

BugLink: http://bugs.launchpad.net/bugs/417732

commit 56f7efe48d57dda9e59e23ab161c118271cce815
Author: Tilman Schmidt <tilman@imap.cc>
Date:   Wed Apr 15 03:25:43 2009 -0700

    bas_gigaset: correctly allocate USB interrupt transfer buffer

    [ Upstream commit 170ebf85160dd128e1c4206cc197cce7d1424705 ]

This incorrect backport to 2.6.28.10 placed some code into the probe func=
tion
which used a pointer before it was initialized. Moving this to the correc=
t
place (as it is in upstream).

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/ba=
s-gigaset.c
index fcec2df..3990eae 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2140,8 +2140,16 @@ static int gigaset_initcshw(struct cardstate *cs)
 	struct bas_cardstate *ucs;
=20
 	cs->hw.bas =3D ucs =3D kmalloc(sizeof *ucs, GFP_KERNEL);
-	if (!ucs)
+	if (!ucs) {
+		pr_err("out of memory\n");
+		return 0;
+	}
+	ucs->int_in_buf =3D kmalloc(IP_MSGSIZE, GFP_KERNEL);
+	if (!ucs->int_in_buf) {
+		kfree(ucs);
+		pr_err("out of memory\n");
 		return 0;
+	}
=20
 	ucs->urb_cmd_in =3D NULL;
 	ucs->urb_cmd_out =3D NULL;
@@ -2236,12 +2244,6 @@ static int gigaset_probe(struct usb_interface *int=
erface,
 		}
 		hostif =3D interface->cur_altsetting;
 	}
-	ucs->int_in_buf =3D kmalloc(IP_MSGSIZE, GFP_KERNEL);
-	if (!ucs->int_in_buf) {
-		kfree(ucs);
-		pr_err("out of memory\n");
-		return 0;
-	}
=20
 	/* Reject application specific interfaces
 	 */
--=20
1.5.4.3

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigA41CCB3D2BB6B6C5F1026E4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKpD6cQ3+did9BuFsRAqlVAJ9UVMc9Ke0T+gWy3yFUPgGUUU9C1wCfW1+r
8p/mqKPklnh6UB61oB/r684=
=hL7s
-----END PGP SIGNATURE-----

--------------enigA41CCB3D2BB6B6C5F1026E4D--
