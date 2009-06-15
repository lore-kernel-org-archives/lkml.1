Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZFOCRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZFOCRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZFOCR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:17:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFOCR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:17:27 -0400
Date: Mon, 15 Jun 2009 12:17:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: scsi tree build failure
Message-Id: <20090615121716.c5bc0655.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_12_17_16_+1000_qYKp9MXQBIxa8VQ3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_12_17_16_+1000_qYKp9MXQBIxa8VQ3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/scsi/ps3rom.c: In function 'ps3rom_interrupt':
drivers/scsi/ps3rom.c:302: error: implicit declaration of function 'ps3_sys=
tem_bus_get_drvdata'
drivers/scsi/ps3rom.c:302: warning: assignment makes pointer from integer w=
ithout a cast
drivers/scsi/ps3rom.c: In function 'ps3rom_probe':
drivers/scsi/ps3rom.c:390: error: implicit declaration of function 'ps3_sys=
tem_bus_set_drvdata'
drivers/scsi/ps3rom.c: In function 'ps3rom_remove':
drivers/scsi/ps3rom.c:421: warning: initialization makes pointer from integ=
er without a cast

Caused by commit 4381bd58427116cd7689831998771ddd58078af9 ("[SCSI]
ps3rom: Use ps3_system_bus_[gs]et_drvdata() instead of direct access").
This is number 21 in a series and depends on number 19 which is not yet
merged.  If you instead Ack this patch, Ben will merge it through the
powerpc tree.

For today, I have used the scsi tree from next-20090612.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_12_17_16_+1000_qYKp9MXQBIxa8VQ3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1rywACgkQjjKRsyhoI8yeNQCfTRc8RQwArnlJIBFdZdA9ean+
1NMAnR/G1/sdLNKDFvjGKfhZRScPakgH
=BHZl
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_12_17_16_+1000_qYKp9MXQBIxa8VQ3--
