Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXKOKlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXKOKlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbXKOKkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:40:53 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51623 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759137AbXKOKkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:40:52 -0500
Date: Thu, 15 Nov 2007 11:40:49 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: thomas@winischhofer.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2]: drivers/video: remove unnecessary pci_dev_put
Message-ID: <Pine.LNX.4.58.0711151140100.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_class implicitly does a pci_dev_put on its second argument, so
pci_dev_put is only needed if there is a break out of the loop.

The semantic match detecting this problem is as follows:

// <smpl>
@@
expression dev;
expression E;
@@

* pci_dev_put(dev)
  ... when != dev = E
(
* pci_get_device(...,dev)
|
* pci_get_device_reverse(...,dev)
|
* pci_get_subsys(...,dev)
|
* pci_get_class(...,dev)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -up a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c	2007-11-15 07:33:31.000000000 +0100
+++ b/drivers/video/sis/sis_main.c	2007-11-15 07:38:48.000000000 +0100
@@ -4620,9 +4620,9 @@ sisfb_find_host_bridge(struct sis_video_

 	while((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST, pdev))) {
 		temp = pdev->vendor;
-		pci_dev_put(pdev);
 		if(temp == pcivendor) {
 			ret = 1;
+			pci_dev_put(pdev);
 			break;
 		}
 	}
