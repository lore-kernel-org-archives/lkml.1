Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXJBRWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXJBRWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbXJBRVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:21:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47320 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXJBRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:21:52 -0400
Date: Tue, 2 Oct 2007 13:21:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] SCSI aic94xx fix
Message-ID: <20071002172151.GA28579@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI maintainer wants to wait until 2.6.25 for this obvious data
corruption fix.

I vehemently disagree.



Please pull from 'sas-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git sas-fixes

to receive the following updates:

 drivers/scsi/aic94xx/aic94xx_task.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Jeff Garzik (1):
      aic94xx: fix DMA data direction for SMP requests

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d5d8cab..ab13824 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -451,7 +451,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	struct scb *scb;
 
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_req, 1,
-		   PCI_DMA_FROMDEVICE);
+		   PCI_DMA_TODEVICE);
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_resp, 1,
 		   PCI_DMA_FROMDEVICE);
 
@@ -486,7 +486,7 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
 
 	BUG_ON(!task);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_req, 1,
-		     PCI_DMA_FROMDEVICE);
+		     PCI_DMA_TODEVICE);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_resp, 1,
 		     PCI_DMA_FROMDEVICE);
 }
