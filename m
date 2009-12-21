Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZLUPSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZLUPSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZLUPSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:18:49 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:48696 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZLUPSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:18:48 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Donald Becker <becker@scyld.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] 3c507.c: remove unused NULL pointer check
Date: Mon, 21 Dec 2009 19:23:58 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211923.58735.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	In driver drivers/net/3c507.c in function Iirqreturn_t el16_interrupt:
1. If in line 555 dev = NULL then we goto line 556
2. In line 556 we have null dereference because pr_err called with dev->name 
in third parameter.
 555        if (dev == NULL) {
 556                pr_err("%s: net_interrupt(): irq %d for unknown device.
\n",
 557                        dev->name, irq);
 558                return IRQ_NONE;
 559        }

Found by Linux Device Drivers Verification (Svace detector)

Remove unused NULL pointer check.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./0000/drivers/net/3c507.c b/./moder/drivers/net/3c507.c
index fbc2311..3bfb3dd 100644
--- a/./0000/drivers/net/3c507.c
+++ b/./moder/drivers/net/3c507.c
@@ -552,12 +552,6 @@ static irqreturn_t el16_interrupt(int irq, void *dev_id)
 	ushort ack_cmd = 0;
 	void __iomem *shmem;
 
-	if (dev == NULL) {
-		pr_err("%s: net_interrupt(): irq %d for unknown device.\n",
-			dev->name, irq);
-		return IRQ_NONE;
-	}
-
 	ioaddr = dev->base_addr;
 	lp = netdev_priv(dev);
 	shmem = lp->base;
