Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXDQIBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXDQIBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXDQIBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:01:54 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43819
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752463AbXDQIBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:01:53 -0400
Date: Tue, 17 Apr 2007 09:58:36 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-driver@qlogic.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] qla1280: use DMA_64BIT_MASK instead of ~ 0ULL
Message-ID: <20070417075836.GA22931@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-driver@qlogic.com, James.Bottomley@SteelEye.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

QLA1280: call pci_set_dma_mask with DMA_64BIT_MASK instead of  ~ 0ULL

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

---

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6777e8a..54d8bdf 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4293,7 +4293,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no); 
-- 
              Comunicar bichos a <bug-coreutils@gnu.org>
                     (LANG=es_ES uname --help)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
                                                                  `-
