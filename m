Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXKDMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXKDMJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXKDMJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:09:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42137 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXKDMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:09:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Nov 2007 13:08:36 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3 2.6.24-rc1-gitX] ieee1394: iso and async streams: s/g list
 fix
To: linux1394-devel@lists.sourceforge.net
cc: Jens Axboe <jens.axboe@oracle.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
Message-ID: <tkrat.e565b61745a1b175@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> 
 <472BA567.8040301@s5r6.in-berlin.de> 
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com> 
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk> 
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Sun, 4 Nov 2007 09:44:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>

Torsten Kaiser wrote:
> Looking that calltrace upwards, it seems replacing the
> memset(dma->sglist,...) with sg_init_table(...) would fix the BUG_ON()
> as that inits the SG_MAGIC.

Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.24-rc1/drivers/ieee1394/dma.c
===================================================================
--- linux-2.6.24-rc1.orig/drivers/ieee1394/dma.c
+++ linux-2.6.24-rc1/drivers/ieee1394/dma.c
@@ -103,8 +103,7 @@ int dma_region_alloc(struct dma_region *
 		goto err;
 	}
 
-	/* just to be safe - this will become unnecessary once sglist->address goes away */
-	memset(dma->sglist, 0, dma->n_pages * sizeof(*dma->sglist));
+	sg_init_table(dma->sglist, dma->n_pages);
 
 	/* fill scatter/gather list with pages */
 	for (i = 0; i < dma->n_pages; i++) {

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

