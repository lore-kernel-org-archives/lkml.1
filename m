Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXJLOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXJLOPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJLOOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:14:52 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48535 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbXJLOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:14:51 -0400
Date: Fri, 12 Oct 2007 16:14:46 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: [PATCH] ps3disk: Remove superfluous cast
Message-ID: <Pine.LNX.4.62.0710121613560.5600@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1121713909-1192198486=:5600"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1121713909-1192198486=:5600
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

ps3disk: Remove a superfluous cast

As ps3disk is a ppc64-only driver, sector_t equals to unsigned long.
Future {re,ab}use is protected by the safety net called `compiler warning'.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3disk.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -102,8 +102,7 @@ static void ps3disk_scatter_gather(struc
 		dev_dbg(&dev->sbd.core,
 			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
 			__func__, __LINE__, i, bio_segments(iter.bio),
-			bio_sectors(iter.bio),
-			(unsigned long)iter.bio->bi_sector);
+			bio_sectors(iter.bio), iter.bio->bi_sector);
 
 		size = bvec->bv_len;
 		buf = bvec_kmap_irq(bvec, &flags);

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1121713909-1192198486=:5600--
