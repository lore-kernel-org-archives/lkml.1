Return-Path: <linux-kernel-owner+w=401wt.eu-S935389AbXHHTMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935389AbXHHTMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964957AbXHHTLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:11:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:5332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803AbXHHTLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,237,1183359600"; 
   d="scan'208";a="278433539"
Date: Wed, 8 Aug 2007 12:08:29 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/4] libata: expose AN to user space
Message-Id: <20070808120829.97022745.kristen.c.accardi@intel.com>
In-Reply-To: <20070808190613.616085010@localhost.localdomain>
References: <20070808190613.616085010@localhost.localdomain>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
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
@@ -771,6 +771,9 @@ static void ata_scsi_dev_config(struct s
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		sdev->media_change_notify = 1;
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 

-- 
