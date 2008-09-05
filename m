Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYIEOHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYIEOHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYIEOHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:07:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51696 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427AbYIEOHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:07:21 -0400
Date: Fri, 5 Sep 2008 09:07:20 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] error missed ifndef CONFIG_HAVE_SPARSE_IRQ
Message-ID: <20080905140720.GA9393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An error return from create_irq_nr() is 0, but an error return from
create_irq() is -1.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/pci/htirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/pci/htirq.c
===================================================================
--- linux.orig/drivers/pci/htirq.c	2008-09-05 08:04:21.000000000 -0500
+++ linux/drivers/pci/htirq.c	2008-09-05 08:07:45.000000000 -0500
@@ -144,7 +144,7 @@ int __ht_create_irq(struct pci_dev *dev,
 #else
 	irq = create_irq();
 #endif
-	if (irq == 0) {
+	if (irq <= 0) {
 		kfree(cfg);
 		return -EBUSY;
 	}
