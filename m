Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZCLKG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZCLKG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZCLKGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:06:50 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:3169 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271AbZCLKGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:06:49 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 8/7] mmc_spi: documentation enhancement
Date: Thu, 12 Mar 2009 11:06:37 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121106.37557.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Document the various pitfalls of SD cards in SPI mode.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch7_unaligned_responses/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch8_documentation/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch7_unaligned_responses/drivers/mmc/host/mmc_spi.c	2009-03-11 13:51:25.000000000 +0100
+++ 2_6_29_rc7_patch8_documentation/drivers/mmc/host/mmc_spi.c	2009-03-12 10:54:24.000000000 +0100
@@ -68,6 +68,20 @@
  *   during that time ... at least on unshared bus segments.
  */
 
+/* PITFALLS:
+ *
+ * - SD card benchmarking is done in 4 bit SD mode. Nobody care about
+ *   speed in SPI mode. So expect less throughput and longer timeouts
+ *   as in SD mode. (See core.c:mmc_set_data_timeout()).
+ * - SPI imposes a byte-aligned protocol. Expect that SD cards violate
+ *   this requirement for ALL responses:
+ *   - response after command
+ *   - data token up to CRC for read blocks
+ *   - token response after a write block
+ * - Expect that the delay (in bits) will vary according to the
+ *   buffer fill grade in the SD card controller.
+ * - Expect that CRC16 is only working for full 512 byte data blocks.
+ */
 
 /*
  * Local protocol constants, internal to data block protocols.
@@ -695,8 +709,8 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	 * writes succeeded; see the standard.
 	 *
 	 * In practice, there are (even modern SDHC-)Cards which need
-	 * some bits to send the response, so we have to cope with this
-	 * situation and check the response bit-by-bit. Arggh!!!
+	 * some clock bits to send the response, so we have to cope with
+	 * this situation and check the response bit-by-bit. Arggh!!!
 	 */
 	pattern  = scratch->status[0] << 24;
 	pattern |= scratch->status[1] << 16;


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
