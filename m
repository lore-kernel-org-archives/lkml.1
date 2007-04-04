Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXDDRYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXDDRYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDDRYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:24:23 -0400
Received: from palrel10.hp.com ([156.153.255.245]:59772 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbXDDRYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:24:22 -0400
Date: Wed, 4 Apr 2007 12:24:20 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       coughlan@redhat.com, coldwell@redhat.com
Subject: [PATCH 1/1] cciss: add init of drv->cylinders back to cciss_geometry_inquiry
Message-ID: <20070404172420.GD5412@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1/1

This patch adds initialization of drv->cylinders back into the failing case in
cciss_geometry_inquiry. I inadvertently removed it in one my 2TB updates.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 072e18e..14d7806 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1915,6 +1915,7 @@ static void cciss_geometry_inquiry(int c
 			       "does not support reading geometry\n");
 			drv->heads = 255;
 			drv->sectors = 32;	// Sectors per track
+			drv->cylinders = total_size + 1;
 			drv->raid_level = RAID_UNKNOWN;
 		} else {
 			drv->heads = inq_buff->data_byte[6];
