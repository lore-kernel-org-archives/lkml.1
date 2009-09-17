Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZIQSrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZIQSrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZIQSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:47:32 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46604 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZIQSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:47:26 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/20] cciss: Silence noisy per-disk messages output by
	cciss_read_capacity
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:55 -0500
Message-ID: <20090917184755.15105.46098.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence noisy per-disk messages output by cciss_read_capacity

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a4cb041..239c4f5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2601,8 +2601,6 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 	} else {		/* Get geometry failed */
 		printk(KERN_WARNING "cciss: reading geometry failed\n");
 	}
-	printk(KERN_INFO "      heads=%d, sectors=%d, cylinders=%d\n\n",
-	       drv->heads, drv->sectors, drv->cylinders);
 }
 
 static void
@@ -2636,9 +2634,6 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	if (*total_size != 0)
-		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
-		(unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 }
 

