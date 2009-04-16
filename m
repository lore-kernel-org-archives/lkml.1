Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZDPBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZDPBp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbZDPBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:45:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:46372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbZDPBpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:45:40 -0400
Message-ID: <49E68D7F.7060209@kernel.org>
Date: Wed, 15 Apr 2009 18:44:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] irq: make ht irq_desc numa aware
References: <49E68C41.4020801@kernel.org>
In-Reply-To: <49E68C41.4020801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: use create_irq_nr

try to get irq_desc on the node with create_irq_nr

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/htirq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -98,6 +98,7 @@ int __ht_create_irq(struct pci_dev *dev,
 	int max_irq;
 	int pos;
 	int irq;
+	int node;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,7 +126,8 @@ int __ht_create_irq(struct pci_dev *dev,
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	irq = create_irq();
+	node = dev_to_node(&dev->dev);
+	irq = create_irq_nr(0, node);
 
 	if (irq <= 0) {
 		kfree(cfg);
