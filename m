Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbZI2GAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbZI2GAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZI2GAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:00:17 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:57287 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbZI2GAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 02:00:16 -0400
Date: Tue, 29 Sep 2009 08:00:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: djwong@us.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/scsi/libsas: Use SAM_GOOD
Message-ID: <Pine.LNX.4.64.0909290759420.29620@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The field stat->stat should be compared to SAM_GOOD, not SAM_STAT_GOOD, as
done elsewhere in the same function.  Both constants have the same value.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/libsas/sas_ata.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e155011..c77b3f9 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -112,7 +112,7 @@ static void sas_ata_task_done(struct sas_task *task)
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-	} else if (stat->stat != SAM_STAT_GOOD) {
+	} else if (stat->stat != SAM_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
