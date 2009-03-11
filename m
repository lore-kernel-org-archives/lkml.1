Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZCKNN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZCKNN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZCKNNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:13:48 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2122 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754697AbZCKNNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:13:47 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 1/7] mmc_spi: allow setting of spi mode 3
Date: Wed, 11 Mar 2009 14:13:15 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903111413.15981.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o allow the platform data structures to specify spi mode 3
  (if there is a pullup on the clock line or the spi hardware
   is not able to serve spi mode 0).

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
This is one of a line of patches to enhance the usability of
the mmc spi host port driver from "don't work with most SD cards"
to "work with nearly all SD cards" (including those ugly cards
with non-byte-aligned responses). 
  
diff -uprN 2_6_29_rc7_backported/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_backported/drivers/mmc/host/mmc_spi.c	2009-03-04 02:05:22.000000000 +0100
+++ 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c	2009-03-11 12:58:47.000000000 +0100
@@ -1204,10 +1204,12 @@ static int mmc_spi_probe(struct spi_devi
 
 	/* MMC and SD specs only seem to care that sampling is on the
 	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
-	 * should be legit.  We'll use mode 0 since it seems to be a
-	 * bit less troublesome on some hardware ... unclear why.
+	 * should be legit.  We'll use mode 0 since the steady state is 0,
+	 * which is appropriate for hotplugging, unless the platform data
+	 * specify mode 3 (if hardware is not compatible to mode 0).
 	 */
-	spi->mode = SPI_MODE_0;
+	if (spi->mode != SPI_MODE_3)
+		spi->mode = SPI_MODE_0;
 	spi->bits_per_word = 8;
 
 	status = spi_setup(spi);

---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
