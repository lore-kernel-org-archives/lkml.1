Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZL1WYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZL1WYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZL1WYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:24:36 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:52533 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751760AbZL1WYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:24:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] simeth.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 17:24:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4B7@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] simeth.c: use %pM to shown MAC address
Thread-Index: AcqIDIsDzgG3eFPvSg2XPg7b+y6/WQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 22:24:33.0854 (UTC) FILETIME=[882435E0:01CA880C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the HwAddr.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation instead of
space-separated.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index 7e81966..3489b0d 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -193,7 +193,7 @@ simeth_probe1(void)
 	unsigned char mac_addr[ETH_ALEN];
 	struct simeth_local *local;
 	struct net_device *dev;
-	int fd, i, err, rc;
+	int fd, err, rc;
 
 	/*
 	 * XXX Fix me
@@ -236,12 +236,8 @@ simeth_probe1(void)
 	 */
 	netdev_connect(dev->irq);
 
-	printk(KERN_INFO "%s: hosteth=%s simfd=%d, HwAddr",
-	       dev->name, simeth_device, local->simfd);
-	for(i = 0; i < ETH_ALEN; i++) {
-		printk(" %2.2x", dev->dev_addr[i]);
-	}
-	printk(", IRQ %d\n", dev->irq);
+	printk(KERN_INFO "%s: hosteth=%s simfd=%d, HwAddr %pM, IRQ %d\n",
+	       dev->name, simeth_device, local->simfd, dev->dev_addr, dev->irq);
 
 	return 0;
 } 
