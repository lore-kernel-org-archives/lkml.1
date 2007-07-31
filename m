Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXGaSTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXGaSTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbXGaSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:18:57 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1539 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233AbXGaSS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:18:56 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 40] drivers/atm/iphase.c: mostly kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:18:55 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       chas@cmf.nrl.navy.mil, pwang@iphase.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312018.55797.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/atm/iphase.c | 111508 -> 111431 (-77 bytes)
 drivers/atm/iphase.o | 254740 -> 254260 (-480 bytes)

 drivers/atm/iphase.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/atm/iphase.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/atm/iphase.c	2007-07-31 11:55:17.000000000 +0200
@@ -1601,14 +1601,14 @@ static int rx_init(struct atm_dev *dev)

 	skb_queue_head_init(&iadev->rx_dma_q);
 	iadev->rx_free_desc_qhead = NULL;
-	iadev->rx_open = kmalloc(4*iadev->num_vc,GFP_KERNEL);
-	if (!iadev->rx_open)
-	{
+
+	iadev->rx_open = kzalloc(4 * iadev->num_vc, GFP_KERNEL);
+	if (!iadev->rx_open) {
 		printk(KERN_ERR DEV_LABEL "itf %d couldn't get free page\n",
 		dev->number);
 		goto err_free_dle;
 	}
-	memset(iadev->rx_open, 0, 4*iadev->num_vc);
+
         iadev->rxing = 1;
         iadev->rx_pkt_cnt = 0;
 	/* Mode Register */
@@ -3171,12 +3171,12 @@ static int __devinit ia_init_one(struct
         unsigned long flags;
 	int ret;

-	iadev = kmalloc(sizeof(*iadev), GFP_KERNEL);
+	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
 	if (!iadev) {
 		ret = -ENOMEM;
 		goto err_out;
 	}
-	memset(iadev, 0, sizeof(*iadev));
+
 	iadev->pci = pdev;

 	IF_INIT(printk("ia detected at bus:%d dev: %d function:%d\n",
