Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYDIHEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYDIHEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYDIHEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:04:23 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47122 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYDIHEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:04:22 -0400
Date: Wed, 9 Apr 2008 03:04:21 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080409070421.GA26759@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_sil680.c |    2 +-
 drivers/ata/sata_fsl.c    |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

Benjamin Herrenschmidt (1):
      pata_sil680: Fix build on arch/ppc

Johann Felix Soden (1):
      ata/sata_fsl: Remove unused variable in sata_fsl_probe

diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 3988e44..7c5b2dd 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -270,7 +270,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 		tmpbyte & 1, tmpbyte & 0x30);
 
 	*try_mmio = 0;
-#ifdef CONFIG_PPC
+#ifdef CONFIG_PPC_MERGE
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 4c19855..9d1e3ca 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1256,7 +1256,6 @@ static int sata_fsl_probe(struct of_device *ofdev,
 	void __iomem *ssr_base = NULL;
 	void __iomem *csr_base = NULL;
 	struct sata_fsl_host_priv *host_priv = NULL;
-	struct resource *r;
 	int irq;
 	struct ata_host *host;
 
@@ -1266,8 +1265,6 @@ static int sata_fsl_probe(struct of_device *ofdev,
 	dev_printk(KERN_INFO, &ofdev->dev,
 		   "Sata FSL Platform/CSB Driver init\n");
 
-	r = kmalloc(sizeof(struct resource), GFP_KERNEL);
-
 	hcr_base = of_iomap(ofdev->node, 0);
 	if (!hcr_base)
 		goto error_exit_with_cleanup;
