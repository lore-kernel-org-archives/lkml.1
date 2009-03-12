Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZCLOuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZCLOuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZCLOtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:49:50 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2318 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756026AbZCLOtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:49:49 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 10/7] mmc_spi: fix bug introduced in patch 3/7
Date: Thu, 12 Mar 2009 15:49:37 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121549.37620.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Fix bug introduced in patch 3/7.
  The first 3 bits of the data response may be undefined;
  assuming that these bits are always 1 lead to unreliable
  transmission.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -uprN 2_6_29_rc7_patch9_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch10_bugfix_of_patch3/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch9_speedup/drivers/mmc/host/mmc_spi.c	2009-03-12 14:35:27.000000000 +0100
+++ 2_6_29_rc7_patch10_bugfix_of_patch3/drivers/mmc/host/mmc_spi.c	2009-03-12 14:40:03.000000000 +0100
@@ -725,6 +725,9 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	pattern |= scratch->status[2] << 8;
 	pattern |= scratch->status[3];
 
+	/* First 3 bit of pattern are undefined */
+	pattern |= 0xE0000000;
+
 	/* left-adjust to leading 0 bit */
 	while (pattern & 0x80000000)
 		pattern <<= 1;

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
