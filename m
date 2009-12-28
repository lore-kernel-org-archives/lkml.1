Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZL1XOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZL1XOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZL1XOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:14:32 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:57213 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751741AbZL1XOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:14:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/sunvnet.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 18:14:35 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4CA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/sunvnet.c: use %pM to shown MAC address
Thread-Index: AcqIE4V+1Y1HSkxiSIiLt+twNG1lhw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 23:14:30.0150 (UTC) FILETIME=[8212B260:01CA8813]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index bc74db0..d65764e 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1062,10 +1062,7 @@ static struct vnet * __devinit vnet_new(const u64 *local_mac)
 		goto err_out_free_dev;
 	}
 
-	printk(KERN_INFO "%s: Sun LDOM vnet ", dev->name);
-
-	for (i = 0; i < 6; i++)
-		printk("%2.2x%c", dev->dev_addr[i], i == 5 ? '\n' : ':');
+	printk(KERN_INFO "%s: Sun LDOM vnet %pM\n", dev->name, dev->dev_addr);
 
 	list_add(&vp->list, &vnet_list);
  
