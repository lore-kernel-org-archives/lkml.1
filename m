Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXFEVWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXFEVWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXFEVWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:22:21 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60316 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933583AbXFEVWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:22:20 -0400
Message-id: <15021191752898126212@wsc.cz>
In-reply-to: <1058130869771517818@wsc.cz>
Subject: [PATCH 3/3] Char: stallion, proper fail return values
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  5 Jun 2007 23:22:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stallion, proper fail return values

do not return 0 in one case and return proper values in other 2.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d62c04c8fe3271ab2089f442e04ad522a158bf8f
tree 31beaaee84ef718acc5401b3cb07a7f2e340f0fe
parent e7488128b7b4f61c82b6e323067d221c9397c43b
author Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 00:07:20 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 05 Jun 2007 23:14:45 +0200

 drivers/char/stallion.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 23ea4c8..45bf2a2 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -2177,6 +2177,7 @@ static int __devinit stl_initech(struct stlbrd *brdp)
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
 				"(size=%Zd)\n", sizeof(struct stlpanel));
+			retval = -ENOMEM;
 			goto err_fr;
 		}
 		panelp->magic = STL_PANELMAGIC;
@@ -2223,8 +2224,10 @@ static int __devinit stl_initech(struct stlbrd *brdp)
 		brdp->nrports += panelp->nrports;
 		brdp->panels[panelnr++] = panelp;
 		if ((brdp->brdtype != BRD_ECHPCI) &&
-		    (ioaddr >= (brdp->ioaddr2 + brdp->iosize2)))
+		    (ioaddr >= (brdp->ioaddr2 + brdp->iosize2))) {
+			retval = -EINVAL;
 			goto err_fr;
+		}
 	}
 
 	brdp->nrpanels = panelnr;
@@ -2371,6 +2374,7 @@ static int __devinit stl_pciprobe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
 		mutex_unlock(&stl_brdslock);
+		retval = -ENODEV;
 		goto err_fr;
 	}
 	brdp->brdnr = (unsigned int)brdnr;
