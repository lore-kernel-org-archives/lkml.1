Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYDWMAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYDWMAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYDWMAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:00:41 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44848 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751787AbYDWMAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:00:38 -0400
Date: Wed, 23 Apr 2008 14:00:34 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: [PATCH] ps3disk: Remove superfluous cast
Message-ID: <Pine.LNX.4.64.0804231357170.13313@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-481070356-1208952034=:13313"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-481070356-1208952034=:13313
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

As ps3disk is a ppc64-only driver, sector_t equals to unsigned long, and the
cast is not needed.

Reuse in another (possibly 32-bit) driver is protected by the safety net called
`compiler warning' (with the cast, it may silently truncate to 32-bit).
If sector_t ever changes, we will get a compiler warning as well (with the
cast, we won't).

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
Please apply, thx!

 drivers/block/ps3disk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
Fortis Bank Zaventem · BIC GEBABEBB08A · IBAN BE39001382358619
---584349381-481070356-1208952034=:13313--
