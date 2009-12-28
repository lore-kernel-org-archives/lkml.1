Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZL1WfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZL1WfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZL1WfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:35:01 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:34579 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253AbZL1WfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:35:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/igbvf/netdev.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 17:35:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4BE@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/igbvf/netdev.c: use %pM to shown MAC address
Thread-Index: AcqIDgADJmwYYClcSOuat37sXEDd5w==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 22:34:58.0858 (UTC) FILETIME=[FCAC40A0:01CA880D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index e9dd95f..1326232 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -2608,11 +2608,7 @@ static void igbvf_print_device_info(struct igbvf_adapter *adapter)
 	struct pci_dev *pdev = adapter->pdev;
 
 	dev_info(&pdev->dev, "Intel(R) 82576 Virtual Function\n");
-	dev_info(&pdev->dev, "Address: %02x:%02x:%02x:%02x:%02x:%02x\n",
-	         /* MAC address */
-	         netdev->dev_addr[0], netdev->dev_addr[1],
-	         netdev->dev_addr[2], netdev->dev_addr[3],
-	         netdev->dev_addr[4], netdev->dev_addr[5]);
+	dev_info(&pdev->dev, "Address: %pM\n", netdev->dev_addr);
 	dev_info(&pdev->dev, "MAC: %d\n", hw->mac.type);
 }
 
@@ -2777,11 +2773,8 @@ static int __devinit igbvf_probe(struct pci_dev *pdev,
 	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address: "
-		        "%02x:%02x:%02x:%02x:%02x:%02x\n",
-		        netdev->dev_addr[0], netdev->dev_addr[1],
-		        netdev->dev_addr[2], netdev->dev_addr[3],
-		        netdev->dev_addr[4], netdev->dev_addr[5]);
+		dev_err(&pdev->dev, "Invalid MAC Address: %pM\n",
+		        netdev->dev_addr);
 		err = -EIO;
 		goto err_hw_init;
 	} 
