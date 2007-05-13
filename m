Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXEMTPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXEMTPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXEMTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:15:31 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56411 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbXEMTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:15:31 -0400
From: muli@il.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 3/3] OSS trident: replace deprecated pci_find_device with pci_get_device
Date: Sun, 13 May 2007 22:15:28 +0300
Message-Id: <1179083728758-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <1179083728411-git-send-email-muli@il.ibm.com>
References: <11790837281608-git-send-email-muli@il.ibm.com> <11790837282758-git-send-email-muli@il.ibm.com> <1179083728411-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 sound/oss/trident.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 2e3e78e..96adc47 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -4454,9 +4454,9 @@ trident_probe(struct pci_dev *pci_dev, c
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl = 0;
-		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL,
-						PCI_DEVICE_ID_AL_M1533,
-						pci_dev_m1533);
+		pci_dev_m1533 = pci_get_device(PCI_VENDOR_ID_AL,
+					       PCI_DEVICE_ID_AL_M1533,
+					       pci_dev_m1533);
 		rc = -ENODEV;
 		if (pci_dev_m1533 == NULL)
 			goto out_proc_fs;
@@ -4470,6 +4470,8 @@ trident_probe(struct pci_dev *pci_dev, c
 			bits &= 0xbf;	/*clear bit 6 */
 			pci_write_config_byte(pci_dev_m1533, 0x7b, bits);
 		}
+		pci_dev_put(pci_dev_m1533);
+
 	} else if (card->pci_id == PCI_DEVICE_ID_INTERG_5050) {
 		card->alloc_pcm_channel = cyber_alloc_pcm_channel;
 		card->alloc_rec_pcm_channel = cyber_alloc_pcm_channel;
-- 
1.4.4

