Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab0APDMh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925Ab0APDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:11:34 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58153 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab0APDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:06:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 27/37] irq: remove not need bootmem code
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
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

