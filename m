Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbXEIXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbXEIXnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbXEIXlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:41:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:11769 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbXEIXlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="244003555"
Date: Wed, 9 May 2007 16:38:28 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 4/7] libata: expose AN to user space
Message-Id: <20070509163828.2c17128f.kristen.c.accardi@intel.com>
In-Reply-To: <20070510072247.063476979@intel.com>
References: <20070510072247.063476979@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If Asynchronous Notification of media change events is supported,
pass that information up to the SCSI layer.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/libata-scsi.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-scsi.c
+++ 2.6-git/drivers/ata/libata-scsi.c
@@ -899,6 +899,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 

-- 
