Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315Ab0AHXrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0AHXrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219Ab0AHXrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:47:46 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42491 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0AHXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:47:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 08 Jan 2010 15:46:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/5] irq: remove not need bootmem code
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_init is moved early already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -19,7 +19,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
-#include <linux/bootmem.h>
 #include <trace/events/irq.h>
 
 #include "internals.h"
@@ -87,12 +86,8 @@ void __ref init_kstat_irqs(struct irq_de
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
@@ -219,10 +214,7 @@ struct irq_desc * __ref irq_to_desc_allo
 	if (desc)
 		goto out_unlock;
 
-	if (slab_is_available())
-		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	else
-		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 
 	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
