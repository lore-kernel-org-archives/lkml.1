Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYG3VTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYG3VTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759686AbYG3VSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:18:45 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5907 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665AbYG3VSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:18:43 -0400
Date: Wed, 30 Jul 2008 16:18:42 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-ID: <20080730211842.GF1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 6 of 6

Bug fix. If SCSI tape support is turned off we get an implicit declaration
of cciss_unregister_scsi error in cciss_remove_one.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ae663db..262148b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3616,7 +3616,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		}
 	}
 
+#ifdef CONFIG_CISS_SCSI_TAPE
 	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
+#endif
 
 	cciss_shutdown(pdev);
 
