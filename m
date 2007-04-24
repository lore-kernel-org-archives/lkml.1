Return-Path: <linux-kernel-owner+w=401wt.eu-S1030945AbXDXADB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030945AbXDXADB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030894AbXDXACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:02:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:24856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030879AbXDXACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:02:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,443,1170662400"; 
   d="scan'208"; a="232725026:sNHT85388688"
Date: Mon, 23 Apr 2007 17:00:04 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 4/7] libata: expose AN to user space
Message-Id: <20070423170004.d29c786f.kristen.c.accardi@intel.com>
In-Reply-To: <20070424074856.005152262@intel.com>
References: <20070424074856.005152262@intel.com>
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
