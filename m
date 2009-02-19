Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZBSJpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZBSJpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZBSJpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:45:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZBSJpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:45:40 -0500
Message-ID: <499D2A9B.3080805@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 17:47:07 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCHv2 07/11]Replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
References: <499CFDC8.1070600@cn.fujitsu.com> <499D0221.9090407@cn.fujitsu.com> <20090219081403.GA5400@elte.hu> <499D1ED9.4040005@cn.fujitsu.com> <499D2728.1080208@cn.fujitsu.com>
In-Reply-To: <499D2728.1080208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 drivers/scsi/aacraid/commsup.c |    4 ++--
 drivers/scsi/aacraid/linit.c   |    4 ++--
 drivers/usb/host/ehci-pci.c    |    2 +-
 sound/pci/ali5451/ali5451.c    |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 3b69c2d..956261f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1206,8 +1206,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
 	if (quirks & AAC_QUIRK_31BIT) {
-		if (((retval = pci_set_dma_mask(aac->pdev, DMA_31BIT_MASK))) ||
-		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_31BIT_MASK))))
+		if (((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(31)))) ||
+		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_BIT_MASK(31)))))
 			goto out;
 	} else {
 		if (((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32)))) ||
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 40c27ae..11414c1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1097,8 +1097,8 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 	 * to driver communication memory to be allocated below 2gig
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_31BIT_MASK) ||
-				pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(31)) ||
+				pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(31)))
 			goto out_disable_pdev;
 
 	pci_set_master(pdev);
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index abb9a77..5aa8bce 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -108,7 +108,7 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 		case 0x00d8:	/* CK8 */
 		case 0x00e8:	/* CK8S */
 			if (pci_set_consistent_dma_mask(pdev,
-						DMA_31BIT_MASK) < 0)
+						DMA_BIT_MASK(31)) < 0)
 				ehci_warn(ehci, "can't enable NVidia "
 					"workaround for >2GB RAM\n");
 			break;
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 1a0fd65..654d4d6 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2186,8 +2186,8 @@ static int __devinit snd_ali_create(struct snd_card *card,
 	if (err < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 31 bits */
-	if (pci_set_dma_mask(pci, DMA_31BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_31BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(31)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(31)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support "
 			   "31bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
-- 
1.6.0.3

-- 
Regards
Yang Hongyang
