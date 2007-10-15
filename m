Return-Path: <linux-kernel-owner+w=401wt.eu-S1765339AbXJOQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765339AbXJOQcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXJOQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:32:31 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58408 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543AbXJOQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:32:29 -0400
Message-id: <3012721321185026886@pripojeni.net>
Subject: [PATCH 1/3] Misc: phantom, synchronize_irq() on suspend
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:32:29 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

phantom, synchronize_irq() on suspend

Wait after disabling device's interrupt until the handler finishes its
work if still in progress.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 7e792ef384190b517f2fb27cd0237fa30dbe0775
tree 17b15e5ab7c90eef0e7ae57e532839e81b831d58
parent 5c008a5651ee92ebe020dd5108a66a7db74fe41d
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:52:21 +0200

 drivers/misc/phantom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 5108b7c..6e61a79 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -378,6 +378,8 @@ static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
 	iowrite32(0, dev->caddr + PHN_IRQCTL);
 	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
 
+	synchronize_irq(pdev->irq);
+
 	return 0;
 }
 
