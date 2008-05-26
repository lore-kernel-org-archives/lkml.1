Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYEZLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYEZLsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYEZLsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:48:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:34109 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754341AbYEZLr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:47:59 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+2yAwh8L+2FJ8iJP34Yae3FiG2uAOPb4J8BG8zUD
	uLAoAiKgwAgRZ5
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  MTD: fix 2 "unused variables" warnings  in drivers/mtd/nand/cafe_nand.c
Date: Mon, 26 May 2008 13:47:51 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1998067.s3DBDQlSAj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805261347.55492.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1998067.s3DBDQlSAj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

this patch should fix 2 compiler warnings about unused variables
if CONFIG_MTD_PARTITIONS is undefined.

Signed-off-by: Toralf F=F6rster <toralf.foerster@gmx.de>
=2D--
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index da6ceaa..f1443f0 100644
=2D-- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -626,9 +626,7 @@ static int __devinit cafe_nand_probe(struct pci_dev *pd=
ev,
 {
        struct mtd_info *mtd;
        struct cafe_priv *cafe;
=2D       struct mtd_partition *parts;
        uint32_t ctrl;
=2D       int nr_parts;
        int err =3D 0;

        /* Very old versions shared the same PCI ident for all three
@@ -800,6 +798,9 @@ static int __devinit cafe_nand_probe(struct pci_dev *pd=
ev,
        add_mtd_device(mtd);

 #ifdef CONFIG_MTD_PARTITIONS
+       struct mtd_partition *parts;
+       int nr_parts;
+
        nr_parts =3D parse_mtd_partitions(mtd, part_probes, &parts, 0);
        if (nr_parts > 0) {
                cafe->parts =3D parts;
=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1998067.s3DBDQlSAj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkg6o2sACgkQhyrlCH22naPtLwCfadQFx+X83zkKmWOSwszJtc+l
inoAn2lhMVIeRIkhjkT8cvJ7Q97WBwWt
=WWj/
-----END PGP SIGNATURE-----

--nextPart1998067.s3DBDQlSAj--
