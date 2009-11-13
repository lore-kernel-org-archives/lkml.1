Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZKMM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZKMM3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZKMM33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:29:29 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:45727 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZKMM33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:29:29 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 07:29:28 EST
X-Spam-ASN: 
From: "Stanislav O\. Bezzubtsev" <stas@lvk.cs.msu.su>
Cc: davem@davemloft.net, aabdulla@nvidia.com, yinghai@kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Stanislav O\. Bezzubtsev" <stas@lvk.cs.msu.su>
Subject: [PATCH] forcedeth: mac address fix
Date: Fri, 13 Nov 2009 15:22:55 +0300
Message-Id: <1258114975-5715-1-git-send-email-stas@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.5
X-AV-Checked: ClamAV using ClamSMTP
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set second bit of randomly generated mac. That marks MAC
as locally assigned. IEEE802.3, section one, 3.2.3.

Signed-off-by: Stanislav O. Bezzubtsev <stas@lvk.cs.msu.su>
---
 drivers/net/forcedeth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index e1da466..b404c7a 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5821,7 +5821,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 		        dev->dev_addr);
 		dev_printk(KERN_ERR, &pci_dev->dev,
 			"Please complain to your hardware vendor. Switching to a random MAC.\n");
-		dev->dev_addr[0] = 0x00;
+		dev->dev_addr[0] = 0x02; /* set local assignment bit */
 		dev->dev_addr[1] = 0x00;
 		dev->dev_addr[2] = 0x6c;
 		get_random_bytes(&dev->dev_addr[3], 3);
-- 
1.6.5

