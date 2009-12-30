Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZL3UYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZL3UYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZL3UYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:24:44 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:50344 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752393AbZL3UYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:24:44 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/wimax/i2400m/driver.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:24:44 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F675@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/wimax/i2400m/driver.c: use %pM to show MAC address
Thread-Index: AcqJjh/3LigRXKrwQyCaaZ03w0A9qg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:24:42.0272 (UTC) FILETIME=[1E736200:01CA898E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 96a615f..6cead32 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -301,24 +301,15 @@ int i2400m_check_mac_addr(struct i2400m *i2400m)
 	/* Extract MAC addresss */
 	ddi = (void *) skb->data;
 	BUILD_BUG_ON(ETH_ALEN != sizeof(ddi->mac_address));
-	d_printf(2, dev, "GET DEVICE INFO: mac addr "
-		 "%02x:%02x:%02x:%02x:%02x:%02x\n",
-		 ddi->mac_address[0], ddi->mac_address[1],
-		 ddi->mac_address[2], ddi->mac_address[3],
-		 ddi->mac_address[4], ddi->mac_address[5]);
+	d_printf(2, dev, "GET DEVICE INFO: mac addr %pM\n",
+		 ddi->mac_address);
 	if (!memcmp(net_dev->perm_addr, ddi->mac_address,
 		   sizeof(ddi->mac_address)))
 		goto ok;
 	dev_warn(dev, "warning: device reports a different MAC address "
 		 "to that of boot mode's\n");
-	dev_warn(dev, "device reports     %02x:%02x:%02x:%02x:%02x:%02x\n",
-		 ddi->mac_address[0], ddi->mac_address[1],
-		 ddi->mac_address[2], ddi->mac_address[3],
-		 ddi->mac_address[4], ddi->mac_address[5]);
-	dev_warn(dev, "boot mode reported %02x:%02x:%02x:%02x:%02x:%02x\n",
-		 net_dev->perm_addr[0], net_dev->perm_addr[1],
-		 net_dev->perm_addr[2], net_dev->perm_addr[3],
-		 net_dev->perm_addr[4], net_dev->perm_addr[5]);
+	dev_warn(dev, "device reports     %pM\n", ddi->mac_address);
+	dev_warn(dev, "boot mode reported %pM\n", net_dev->perm_addr);
 	if (!memcmp(zeromac, ddi->mac_address, sizeof(zeromac)))
 		dev_err(dev, "device reports an invalid MAC address, "
 			"not updating\n"); 
