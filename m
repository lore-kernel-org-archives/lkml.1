Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZAJWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZAJWjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZAJWie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:38:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753303AbZAJWid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:38:33 -0500
Message-Id: <20090110223818.900264000@polaris-admin.engr.sgi.com>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 10 Jan 2009 14:38:21 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] irq: initialize nr_irqs based on nr_cpu_ids
Content-Disposition: inline; filename=irq-variable-nr_irqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce memory usage.

This is the second half of the changes to make the irq_desc_ptrs be
variable sized based on nr_cpu_ids.  The algorithm is the same as the
setting of NR_IRQS except use nr_cpu_ids instead of NR_CPUS.  This is
only when CONFIG_SPARSE_IRQS=y.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/irq/handle.c |    5 +++++
 1 file changed, 5 insertions(+)

Files linux-2.6-for-ingo.orig/kernel/irq/.handle.c.swp and linux-2.6-for-ingo/kernel/irq/.handle.c.swp differ
--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -133,6 +133,11 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
+	/* initialize nr_irqs based on nr_cpu_ids */
+ 	nr_irqs =  (8 * nr_cpu_ids) > (32 * MAX_IO_APICS) ?
+ 			NR_VECTORS + (8 * nr_cpu_ids) :
+ 			NR_VECTORS + (32 * MAX_IO_APICS);
+
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
 
 	desc = irq_desc_legacy;

-- 
