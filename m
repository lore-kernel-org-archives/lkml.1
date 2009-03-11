Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZCKNSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZCKNSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZCKNSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:18:21 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2133 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbZCKNSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:18:20 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 2/7] mmc_spi: wait more bytes for card response
Date: Wed, 11 Mar 2009 14:17:43 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111417.43821.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o some cards are slower than the standard allows and need more
  time to respond to a command. Max. observed number of bytes
  was 12.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
This is one of a line of patches to enhance the usability of
the mmc spi host port driver from "don't work with most SD cards"
to "work with nearly all SD cards" (including those ugly cards
with non-byte-aligned responses).

diff -uprN 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch2_wait_16bytes_response/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch1_spi_mode_3/drivers/mmc/host/mmc_spi.c	2009-03-11 12:58:47.000000000 +0100
+++ 2_6_29_rc7_patch2_wait_16bytes_response/drivers/mmc/host/mmc_spi.c	2009-03-11 13:00:06.000000000 +0100
@@ -279,8 +279,11 @@ static int mmc_spi_response_get(struct m
 		 * so it can always DMA directly into the target buffer.
 		 * It'd probably be better to memcpy() the first chunk and
 		 * avoid extra i/o calls...
+		 *
+		 * Note we check for more than 8 bytes, because in practice,
+		 * some SD cards are slow...
 		 */
-		for (i = 2; i < 9; i++) {
+		for (i = 2; i < 16; i++) {
 			value = mmc_spi_readbytes(host, 1);
 			if (value < 0)
 				goto done;

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
