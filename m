Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0CJOFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab0CJOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:05:37 -0500
Date: Wed, 10 Mar 2010 09:05:35 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, yinghai@kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100310140535.16273.90102.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: cleanup debug message in init_kstat_irqs()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup a debug message in init_kstat_irqs().

This debug message can result in valid output like

	alloc kstat_irqs on node -1

which looks alot like an error message.

This debug statement has been in the kernel for over a year, so I think it is
safe to remove it and report the node in only the error case instead.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..e7fb871 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -94,10 +94,10 @@ void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 	 * don't overwite if can not get new one
 	 * init_copy_kstat_irqs() could still use old one
 	 */
-	if (ptr) {
-		printk(KERN_DEBUG "  alloc kstat_irqs on node %d\n", node);
+	if (ptr)
 		desc->kstat_irqs = ptr;
-	}
+	else
+		printk(KERN_ERR "  alloc kstat_irqs on node %d failed\n", node);
 }
 
