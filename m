Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZIQSqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZIQSqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbZIQSqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:46:30 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31135 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbZIQSqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:46:24 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/20] cciss: Remove sysfs entries for logical drives on
	driver cleanup.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:46:53 -0500
Message-ID: <20090917184653.15105.99513.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Patterson <andrew.patterson@hp.com>

Sysfs entries for logical drives need to be removed when a drive is
deleted during driver cleanup.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
---

 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a52cc7f..970c896 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1977,7 +1977,6 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1);
-			cciss_destroy_ld_sysfs_entry(&h->drv[i]);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -2118,6 +2117,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
+	cciss_destroy_ld_sysfs_entry(drv);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4141,6 +4141,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			if (q)
 				blk_cleanup_queue(q);
 		}
+		if (hba[i]->drv[j].raid_level != -1)
+			cciss_destroy_ld_sysfs_entry(&hba[i]->drv[j]);
+
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE

