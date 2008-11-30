Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYK3XCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYK3XCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 18:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYK3XCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 18:02:32 -0500
Received: from server.drzeus.cx ([85.8.24.28]:46577 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753432AbYK3XCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 18:02:31 -0500
Date: Mon, 1 Dec 2008 00:02:20 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.28-rc7
Message-ID: <20081201000220.6163a080@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-25156-1228086148-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-25156-1228086148-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/host/at91_mci.c   |    4 ++--
 drivers/mmc/host/sdricoh_cs.c |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

Nicolas Ferre (1):
      mmc: at91_mci: reorder timer setup and mmc_add_host() call

Sascha Sommer (1):
      sdricoh_cs: Add support for Bay Controller devices

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 1f8b5b3..e556d42 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1088,6 +1088,8 @@ static int __init at91_mci_probe(struct platform_devi=
ce *pdev)
 		goto fail0;
 	}
=20
+	setup_timer(&host->timer, at91_timeout_timer, (unsigned long)host);
+
 	platform_set_drvdata(pdev, mmc);
=20
 	/*
@@ -1101,8 +1103,6 @@ static int __init at91_mci_probe(struct platform_devi=
ce *pdev)
=20
 	mmc_add_host(mmc);
=20
-	setup_timer(&host->timer, at91_timeout_timer, (unsigned long)host);
-
 	/*
 	 * monitor card insertion/removal if we can
 	 */
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 1df44d9..4358633 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -82,6 +82,8 @@ static struct pcmcia_device_id pcmcia_ids[] =3D {
 	/* vendor and device strings followed by their crc32 hashes */
 	PCMCIA_DEVICE_PROD_ID12("RICOH", "Bay1Controller", 0xd9f522ed,
 				0xc3901202),
+	PCMCIA_DEVICE_PROD_ID12("RICOH", "Bay Controller", 0xd9f522ed,
+				0xace80909),
 	PCMCIA_DEVICE_NULL,
 };
=20


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-25156-1228086148-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkzG4UACgkQ7b8eESbyJLjBCwCgio63tW/OISQFFDUa4OM/b0a1
OfYAoKqEU2KkPPf70Fpm+Pl/gWlFGIeJ
=mL5P
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-25156-1228086148-0001-2--
