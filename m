Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbXGCDvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbXGCDvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 23:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbXGCDuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 23:50:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19405 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXGCDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 23:50:53 -0400
X-IronPort-AV: i="4.16,490,1175497200"; 
   d="scan'208"; a="175866734:sNHT42970329"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 02 Jul 2007 20:50:52 -0700
Message-ID: <adaodiu6t7n.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jul 2007 03:50:52.0832 (UTC) FILETIME=[5A36AA00:01C7BD25]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fix for a crash in IPoIB and new device IDs for mlx4:

Jack Morgenstein (1):
      mlx4_core: Add new Mellanox device IDs

Ralph Campbell (1):
      IPoIB/cm: Partial error clean up unmaps wrong address

 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    4 ++--
 drivers/net/mlx4/main.c                 |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 5ffc464..ea74d1e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -148,8 +148,8 @@ partial_error:
 
 	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
 
-	for (; i >= 0; --i)
-		ib_dma_unmap_single(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
+	for (; i > 0; --i)
+		ib_dma_unmap_single(priv->ca, mapping[i], PAGE_SIZE, DMA_FROM_DEVICE);
 
 	dev_kfree_skb_any(skb);
 	return NULL;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 41eafeb..c3da2a2 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -911,6 +911,8 @@ static struct pci_device_id mlx4_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x6340) }, /* MT25408 "Hermon" SDR */
 	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25408 "Hermon" DDR */
 	{ PCI_VDEVICE(MELLANOX, 0x6354) }, /* MT25408 "Hermon" QDR */
+	{ PCI_VDEVICE(MELLANOX, 0x6732) }, /* MT25408 "Hermon" DDR PCIe gen2 */
+	{ PCI_VDEVICE(MELLANOX, 0x673c) }, /* MT25408 "Hermon" QDR PCIe gen2 */
 	{ 0, }
 };
 
