Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYEZSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYEZSgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYEZSfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:35:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:47719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753807AbYEZSfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:35:53 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19hQWEn0m9hCVwQ+lreZ9M7yy50um0pfI6kCqHpPY
	lSNUvrfe/YmM0h
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: dwmw2@infradead.org
Subject: [PATCH] MTD: fix 2 "unused variable" warnings in cafe_nand.c
Date: Mon, 26 May 2008 20:35:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2184249.aAV14RtehQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805262035.49139.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2184249.aAV14RtehQ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

pointed out by Sebastian Siewior the original patch produces the compiler
warning "ISO C90 forbids mixed declarations and code" therefore here the 2nd
attempt to fix 2 compiler warnings about unused variables if
CONFIG_MTD_PARTITIONS is undefined.

BTW I'm wondering whether the devs prefer to live w/ the warning rather than
having the 2 additional #ifdef pragmas or not.


Signed-off-by: Toralf F=F6rster <toralf.foerster@gmx.de>
=2D--
 drivers/mtd/nand/cafe_nand.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index da6ceaa..5c29d36 100644
=2D-- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -626,10 +626,12 @@ static int __devinit cafe_nand_probe(struct pci_dev *=
pdev,
 {
        struct mtd_info *mtd;
        struct cafe_priv *cafe;
=2D       struct mtd_partition *parts;
        uint32_t ctrl;
=2D       int nr_parts;
        int err =3D 0;
+#ifdef CONFIG_MTD_PARTITIONS
+       struct mtd_partition *parts;
+       int nr_parts;
+#endif

        /* Very old versions shared the same PCI ident for all three
           functions on the chip. Verify the class too... */
=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2184249.aAV14RtehQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkg7AwUACgkQhyrlCH22naPG6ACeJ6VuHLnNx2TBdsBMFX1lrQjP
7boAnjbTYHjX8j/txkqBXI9tXI/fUT0l
=BKAO
-----END PGP SIGNATURE-----

--nextPart2184249.aAV14RtehQ--
