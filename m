Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0BJJWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:22:15 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39197 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0BJJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:22:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/35] irq: remove not need bootmem code
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_init is moved early already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/irq/handle.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 814940e..0e823c0 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -19,7 +19,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
-#include <linux/bootmem.h>
 #include <trace/events/irq.h>
 
 #include "internals.h"
@@ -87,12 +86,8 @@ void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
 	void *ptr;
 
-	if (slab_is_available())
-		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
-				   GFP_ATOMIC, node);
-	else
-		ptr = alloc_bootmem_node(NODE_DATA(node),
-				nr * sizeof(*desc->kstat_irqs));
+	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs),
+			   GFP_ATOMIC, node);
 
 	/*
 	 * don't overwite if can not get new one
@@ -219,10 +214,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	if (desc)
 		goto out_unlock;
 
-	if (slab_is_available())
-		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	else
-		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 
 	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
-- 
1.6.4.2

