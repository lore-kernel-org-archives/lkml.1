Return-Path: <linux-kernel-owner+w=401wt.eu-S1031519AbXEDSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031519AbXEDSTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031518AbXEDSTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:19:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:21835 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161358AbXEDSTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:19:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,493,1170662400"; 
   d="scan'208";a="83835218"
Date: Fri, 4 May 2007 11:16:30 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       akpm@linux-foundation.org
Subject: [patch 4/7] libata: expose AN to user space - resend
Message-Id: <20070504111630.f8330bf0.kristen.c.accardi@intel.com>
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
