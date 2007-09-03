Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbXICWDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbXICWDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 18:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXICWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 18:02:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXICWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 18:02:51 -0400
Date: Tue, 4 Sep 2007 03:45:55 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH -mm 1/2] 3c59x: Fix uninitialized variable bug
Message-ID: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/net/3c59x.c: In function 'vortex_up':
drivers/net/3c59x.c:1495: warning: 'err' may be used uninitialized in this function

is a genuine bug. The function returns an uninitialized value of 'err'
back to the caller, which expects it to be 0 for success cases. Let's
fix this by explicitly initializing 'err' to zero.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/net/3c59x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/net/3c59x.c~fix	2007-09-04 03:29:40.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/net/3c59x.c	2007-09-04 03:30:08.000000000 +0530
@@ -1492,7 +1492,8 @@ vortex_up(struct net_device *dev)
 	struct vortex_private *vp = netdev_priv(dev);
 	void __iomem *ioaddr = vp->ioaddr;
 	unsigned int config;
-	int i, mii_reg1, mii_reg5, err;
+	int i, mii_reg1, mii_reg5;
+	int err = 0;
 
 	if (VORTEX_PCI(vp)) {
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);	/* Go active */
