Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZL3UJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZL3UJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZL3UJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:09:06 -0500
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:54140 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753252AbZL3UJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:09:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/atl1e/atl1e_main.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:09:05 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F66E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/atl1e/atl1e_main.c: use %pM to show MAC address
Thread-Index: AcqJi/A9AGWbaMHJSA2NhAwtRupHUQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:09:03.0775 (UTC) FILETIME=[EF101AF0:01CA898B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index 08f8c09..2080d44 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2378,10 +2378,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac_addr, netdev->addr_len);
-	dev_dbg(&pdev->dev, "mac address : %02x-%02x-%02x-%02x-%02x-%02x\n",
-			adapter->hw.mac_addr[0], adapter->hw.mac_addr[1],
-			adapter->hw.mac_addr[2], adapter->hw.mac_addr[3],
-			adapter->hw.mac_addr[4], adapter->hw.mac_addr[5]);
+	dev_dbg(&pdev->dev, "mac address : %pM\n", adapter->hw.mac_addr);
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task); 
