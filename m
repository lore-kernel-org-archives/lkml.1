Return-Path: <linux-kernel-owner+w=401wt.eu-S936428AbXJPWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936428AbXJPWHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935451AbXJPWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:07:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:52269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082AbXJPWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:07:34 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: arcmsr changelog differs from diffs
Date: Wed, 17 Oct 2007 00:07:19 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170007.20454.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX189ItIJvDK3AUO0RJBEJhAvPL0z85oVhHxR+ZN
 xvvg29m4WSoV35sNCEKx+gpEn0/yojoytLLUrlNRk3yfkd/De7
 gMVEFys3k/eYFE7VjSrjA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

while browsing through Linus' current check ins, I stumbled upon:

[SCSI] arcmsr: irq handler fixes, cleanups, micro-opts:

--8<--
488a5c8a9a3b67ae117784cd0d73bef53a73d57d
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c 
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 7832a10..f4d2d52 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -422,7 +422,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
 		goto out_release_regions;
 
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-				IRQF_SHARED, "arcmsr", acb);
+			    IRQF_SHARED, "arcmsr", acb);
 	if (error)
 		goto out_free_ccb_pool;
 
-->8--

and: [SCSI] arcmsr: Fix hardware wait loops

--8<--
24430458bb924e371ff894e26bfa9f73707f53fb
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c 
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 50e1310..7832a10 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2092,8 +2092,10 @@ static void arcmsr_iop_reset(struct 
AdapterControlBlock *acb)
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
 		/* talk to iop 331 outstanding command aborted */
 		arcmsr_abort_allcmd(acb);
+
 		/* wait for 3 sec for all command aborted*/
 		ssleep(3);
+
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
 		/* clear all outbound posted Q */
-->8--

where both changelogs differ significantly from the actual diffs, which both 
are simple WS fixups and nothing else. Does qgit fools me here, or is 
anything else wrong on my side?

Pete
