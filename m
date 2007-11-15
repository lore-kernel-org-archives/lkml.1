Return-Path: <linux-kernel-owner+w=401wt.eu-S1764604AbXKOKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764604AbXKOKki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbXKOKkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:40:16 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51526 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761188AbXKOKkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:40:14 -0500
Date: Thu, 15 Nov 2007 11:40:08 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2]: drivers/char: remove unnecessary pci_dev_put
Message-ID: <Pine.LNX.4.58.0711151139250.1184@pc-041.diku.dk>
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

diff -up a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c	2007-11-15 07:33:31.000000000 +0100
+++ b/drivers/char/agp/amd-k7-agp.c	2007-11-15 07:40:48.000000000 +0100
@@ -436,10 +436,6 @@ static int __devinit agp_amdk7_probe(str
 				return -ENODEV;
 			}
 			cap_ptr = pci_find_capability(gfxcard, PCI_CAP_ID_AGP);
-			if (!cap_ptr) {
-				pci_dev_put(gfxcard);
-				continue;
-			}
 		}

 		/* With so many variants of NVidia cards, it's simpler just
