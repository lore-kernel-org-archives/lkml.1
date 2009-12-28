Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZL1WnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZL1WnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZL1WnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:43:15 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:33869 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751088AbZL1WnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:43:14 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/lib82596.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 17:43:17 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4C1@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/lib82596.c: use %pM to shown MAC address
Thread-Index: AcqIDyX16g2IQYRwQsuSQV9Y9igTTw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 22:43:11.0962 (UTC) FILETIME=[2295F3A0:01CA880F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation instead of
space-separated.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index b117f7f..b60efd4 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -1094,11 +1094,9 @@ static int __devinit i82596_probe(struct net_device *dev)
 		return i;
 	};
 
-	DEB(DEB_PROBE, printk(KERN_INFO "%s: 82596 at %#3lx,",
-			      dev->name, dev->base_addr));
-	for (i = 0; i < 6; i++)
-		DEB(DEB_PROBE, printk(" %2.2X", dev->dev_addr[i]));
-	DEB(DEB_PROBE, printk(" IRQ %d.\n", dev->irq));
+	DEB(DEB_PROBE, printk(KERN_INFO "%s: 82596 at %#3lx, %pM IRQ %d.\n",
+			      dev->name, dev->base_addr, dev->dev_addr,
+			      dev->irq));
 	DEB(DEB_INIT, printk(KERN_INFO
 			     "%s: dma at 0x%p (%d bytes), lp->scb at 0x%p\n",
 			     dev->name, dma, (int)sizeof(struct i596_dma), 
