Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0CJNpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:45:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab0CJNpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:45:13 -0500
Date: Wed, 10 Mar 2010 08:45:10 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, yinghai@kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100310134510.16144.50619.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: cleanup debug message in irq_to_desc_alloc_node()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up debug messages in irq_to_desc_alloc_node().

This debug message can result in valid output like

	alloc irq_desc for 73 on node -1

which looks like alot like an error message.

This debug statement has been in the kernel for about a year, so I think it is
safe to remove it and report the irq and node in the error case instead.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 17c71bb..5c3e38e 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -224,9 +224,10 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	else
 		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
 
-	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
-		printk(KERN_ERR "can not alloc irq_desc\n");
+		printk(KERN_ERR
+		       "can not alloc irq_desc for irq %d on node %d\n",
+		       irq, node);
 		BUG_ON(1);
 	}
 	init_one_irq_desc(irq, desc, node);
