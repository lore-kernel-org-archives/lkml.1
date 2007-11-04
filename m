Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbXKDNl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbXKDNl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXKDNlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:41:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45091 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbXKDNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:41:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Nov 2007 14:41:39 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire update
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.acb17d7c55769fbb@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394 subsystem update.
This fixes "2.6.24-rc1-54866.. fails to boot: kernel BUG at
include/linux/scatterlist.h:49!", bug# 9296.

 drivers/ieee1394/dma.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Jens Axboe (1):
      ieee1394: iso and async streams: s/g list fix


Full log and diff:

commit 9e66269d40229cd9823024120910a43af57a9d72
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Sun Nov 4 09:44:56 2007 +0100

    ieee1394: iso and async streams: s/g list fix
    
    Torsten Kaiser wrote:
    > Looking that calltrace upwards, it seems replacing the
    > memset(dma->sglist,...) with sg_init_table(...) would fix the BUG_ON()
    > as that inits the SG_MAGIC.
    
    Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index f5f4983..7c4eb39 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -103,8 +103,7 @@ int dma_region_alloc(struct dma_region *dma, unsigned long n_bytes,
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

