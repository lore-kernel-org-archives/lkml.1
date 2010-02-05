Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0BENet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:34:49 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57982 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932410Ab0BENer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:34:47 -0500
Date: Fri, 5 Feb 2010 14:35:00 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org,
       James.Bottomley@suse.de, u.kleine-koenig@pengutronix.de,
       jkosina@suse.cz, dc395x@twibble.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Message-ID: <20100205133500.GC6874@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	This is another example of a block of code, here since ever
and never compiled in modern history. Couldn't find out much more
about it but as it can't be set for ages it might be wise to just
remove it right now?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 5cb8acd3f6939c617d6f28bd3eabb276c443c34e Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:39:33 +0100
Subject: [PATCH] Remove config SCSI_DC395x_TRMS1040_TRADMAP

There's exactly one in source-check for SCSI_DC395x_TRMS1040_TRADMAP
imported with the first git revision and no corresponding KConfig Item
ever. Removing this single left-over block from the kernel config.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/dc395x.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6c59c02..7b3d0d3 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1160,29 +1160,7 @@ complete:
 static int dc395x_bios_param(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *info)
 {
-#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
-	int heads, sectors, cylinders;
-	struct AdapterCtlBlk *acb;
-	int size = capacity;
-
-	dprintkdbg(DBG_0, "dc395x_bios_param..............\n");
-	acb = (struct AdapterCtlBlk *)sdev->host->hostdata;
-	heads = 64;
-	sectors = 32;
-	cylinders = size / (heads * sectors);
-
-	if ((acb->gmode2 & NAC_GREATER_1G) && (cylinders > 1024)) {
-		heads = 255;
-		sectors = 63;
-		cylinders = size / (heads * sectors);
-	}
-	geom[0] = heads;
-	geom[1] = sectors;
-	geom[2] = cylinders;
-	return 0;
-#else
 	return scsicam_bios_param(bdev, capacity, info);
-#endif
 }
 
 
-- 
1.6.3.3



