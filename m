Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171Ab0AEREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0AEREU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611Ab0AEREQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:04:16 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932105Ab0AERDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:31 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/wimax/i2400m/driver.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 10:00:57 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051000.57496.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

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
