Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbXGaSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbXGaSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765542AbXGaSZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:25:47 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1685 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbXGaSZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:25:45 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 44] drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 20:25:45 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       james.smart@emulex.com, linux-scsi@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312025.45603.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_debugfs.c | 13809 -> 13716 (-93 bytes)
 drivers/scsi/lpfc/lpfc_debugfs.o | 146124 -> 146124 (0 bytes)

 drivers/scsi/lpfc/lpfc_debugfs.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-31 14:11:24.000000000 +0200
@@ -432,14 +432,11 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	if (!lpfc_debugfs_start_time)
 		lpfc_debugfs_start_time = jiffies;

-	vport->disc_trc = kmalloc(
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc),
-		GFP_KERNEL);
+	vport->disc_trc = kcalloc(lpfc_debugfs_max_disc_trc,
+				  sizeof(struct lpfc_disc_trc),	GFP_KERNEL);

 	if (!vport->disc_trc)
 		goto debug_failed;
-	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc));

 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
