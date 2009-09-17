Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZIQSqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZIQSqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbZIQSqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:46:44 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27032 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbZIQSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:46:40 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/20] cciss: Remove some unused code in rebuild_lun_table()
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:08 -0500
Message-ID: <20090917184708.15105.61462.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unused code in rebuild_lun_table()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 763535e..1d2d614 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1707,7 +1707,6 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	unsigned long flags = 0;
 	int ret = 0;
 	drive_info_struct *drvinfo;
-	int was_only_controller_node;
 
 	/* Get information about the disk and modify the driver structure */
 	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
@@ -1715,13 +1714,6 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	if (inq_buff == NULL || drvinfo == NULL)
 		goto mem_msg;
 
-	/* See if we're trying to update the "controller node"
-	 * this will happen the when the first logical drive gets
-	 * created by ACU.
-	 */
-	was_only_controller_node = (drv_index == 0 &&
-				h->drv[0].raid_level == -1);
-
 	/* testing to see if 16-byte CDBs are already being used */
 	if (h->cciss_read == CCISS_READ_16) {
 		cciss_read_capacity_16(h->ctlr, drv_index, 1,

