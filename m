Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZCHRNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZCHRNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZCHRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:13:45 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56234 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZCHRNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:13:45 -0400
Date: Sun, 8 Mar 2009 18:13:38 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fix for 2.6.29-rc8
Message-ID: <20090308181338.427cdbd7@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-25664-1236532420-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-25664-1236532420-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive a fix for a regression that broke MMC cards:

 drivers/mmc/core/mmc_ops.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

Adrian Hunter (1):
      mmc: fix data timeout for SEND_EXT_CSD

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 9c50e6f..34ce270 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -248,12 +248,15 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_h=
ost *host,
=20
 	sg_init_one(&sg, data_buf, len);
=20
-	/*
-	 * The spec states that CSR and CID accesses have a timeout
-	 * of 64 clock cycles.
-	 */
-	data.timeout_ns =3D 0;
-	data.timeout_clks =3D 64;
+	if (opcode =3D=3D MMC_SEND_CSD || opcode =3D=3D MMC_SEND_CID) {
+		/*
+		 * The spec states that CSR and CID accesses have a timeout
+		 * of 64 clock cycles.
+		 */
+		data.timeout_ns =3D 0;
+		data.timeout_clks =3D 64;
+	} else
+		mmc_set_data_timeout(&data, card);
=20
 	mmc_wait_for_req(host, &mrq);
=20


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-25664-1236532420-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz/MQACgkQ7b8eESbyJLgMWgCfeZJrRRMeyGJRVy4m+nKtqTYd
ExgAn30vr9CILe67f/on8sr+pt0luWD5
=mWLA
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-25664-1236532420-0001-2--
