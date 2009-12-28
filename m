Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZL1W7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZL1W7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZL1W7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:59:00 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:42494 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752049AbZL1W7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:59:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/r8169.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 17:59:03 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4C6@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/r8169.c: use %pM to shown MAC address
Thread-Index: AcqIEVnpwgURppdhRAKjHqCG2dkUMw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 22:58:58.0033 (UTC) FILETIME=[567CEE10:01CA8811]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 60f96c4..c403ce0 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3188,15 +3188,10 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (netif_msg_probe(tp)) {
 		u32 xid = RTL_R32(TxConfig) & 0x9cf0f8ff;
 
-		printk(KERN_INFO "%s: %s at 0x%lx, "
-		       "%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x, "
-		       "XID %08x IRQ %d\n",
+		printk(KERN_INFO "%s: %s at 0x%lx, %pM, XID %08x IRQ %d\n",
 		       dev->name,
 		       rtl_chip_info[tp->chipset].name,
-		       dev->base_addr,
-		       dev->dev_addr[0], dev->dev_addr[1],
-		       dev->dev_addr[2], dev->dev_addr[3],
-		       dev->dev_addr[4], dev->dev_addr[5], xid, dev->irq);
+		       dev->base_addr, dev->dev_addr, xid, dev->irq);
 	}
 
 	rtl8169_init_phy(dev, tp); 
