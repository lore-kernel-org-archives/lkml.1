Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZL1XEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZL1XEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZL1XEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:04:06 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:44474 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752069AbZL1XEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:04:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/sh_eth.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 18:04:07 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4C8@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/sh_eth.c: use %pM to shown MAC address
Thread-Index: AcqIEg6oPFVKeoCMQvW+GsLjhTIYuQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 23:04:01.0220 (UTC) FILETIME=[0B339840:01CA8812]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
index ca62850..ed52c00 100644
--- a/drivers/net/sh_eth.c
+++ b/drivers/net/sh_eth.c
@@ -1473,13 +1473,9 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_unregister;
 
-	/* pritnt device infomation */
-	pr_info("Base address at 0x%x, ",
-	       (u32)ndev->base_addr);
-
-	for (i = 0; i < 5; i++)
-		printk("%02X:", ndev->dev_addr[i]);
-	printk("%02X, IRQ %d.\n", ndev->dev_addr[i], ndev->irq);
+	/* print device infomation */
+	pr_info("Base address at 0x%x, %pM, IRQ %d.\n",
+	       (u32)ndev->base_addr, ndev->dev_addr, ndev->irq);
 
 	platform_set_drvdata(pdev, ndev);
  
