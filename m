Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZL3S2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZL3S2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZL3S2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:28:41 -0500
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:46288 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751575AbZL3S2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:28:40 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/defxx.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 13:28:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F63E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/defxx.c: use %pM to show MAC address
Thread-Index: AcqJfefGotWgHt+dS0a4qVmGxvRDmA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 18:28:37.0660 (UTC) FILETIME=[E737EDC0:01CA897D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index 6a6ea03..d27b716 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -1052,12 +1052,9 @@ static int __devinit dfx_driver_init(struct net_device *dev,
 		board_name = "DEFEA";
 	if (dfx_bus_pci)
 		board_name = "DEFPA";
-	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, "
-		"Hardware addr = %02X-%02X-%02X-%02X-%02X-%02X\n",
+	pr_info("%s: %s at %saddr = 0x%llx, IRQ = %d, Hardware addr = %pM\n",
 		print_name, board_name, dfx_use_mmio ? "" : "I/O ",
-		(long long)bar_start, dev->irq,
-		dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
-		dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
+		(long long)bar_start, dev->irq, dev->dev_addr);
 
 	/*
 	 * Get memory for descriptor block, consumer block, and other buffers 
