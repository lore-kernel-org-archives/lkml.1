Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZCBVFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZCBVFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZCBVFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:05:01 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56184 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZCBVFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:05:00 -0500
Date: Mon, 2 Mar 2009 22:04:47 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.29-rc7
Message-ID: <20090302220447.789f6c3d@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-1283-1236027896-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-1283-1236027896-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive a fix for a regression on Marvell's CAFE controller.

 drivers/mmc/host/sdhci-pci.c |    1 +
 drivers/mmc/host/sdhci.c     |    5 ++++-
 drivers/mmc/host/sdhci.h     |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

Andres Salomon (1):
      sdhci: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip

Ben Dooks (1):
      sdhci: Add quirk for controllers with no end-of-busy IRQ

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 8cff5f5..406da9a 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -107,6 +107,7 @@ static const struct sdhci_pci_fixes sdhci_ene_714 =3D {
=20
 static const struct sdhci_pci_fixes sdhci_cafe =3D {
 	.quirks		=3D SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+			  SDHCI_QUIRK_NO_BUSY_IRQ |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
=20
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index f52f305..accb592 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1291,8 +1291,11 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u=
32 intmask)
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
+
+		/* The controller does not support the end-of-busy IRQ,
+		 * fall through and take the SDHCI_INT_RESPONSE */
 	}
=20
 	if (intmask & SDHCI_INT_RESPONSE)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index ebb8365..43c37c6 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -208,6 +208,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_TIMEOUT_VAL			(1<<12)
 /* Controller has an issue with buffer bits for small transfers */
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
+/* Controller does not provide transfer-complete interrupt when not busy */
+#define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<14)
=20
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-1283-1236027896-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmsSfgACgkQ7b8eESbyJLjECwCfSEP/fth9QcgcbV6JBqIDOeUh
E+UAoLoeTprAUObskT5zkiNap/JOF8yi
=DGiT
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-1283-1236027896-0001-2--
