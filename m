Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0BRB6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:58:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:37308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab0BRB6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:58:02 -0500
Date: Thu, 18 Feb 2010 01:57:36 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1265793639-15071-29-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-29-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] irq: Remove unnecessary bootmem code
Message-ID: <tip-febcb0c59ac19fef2081a30e371e7af3619b5e91@git.kernel.org>
Git-Commit-ID: febcb0c59ac19fef2081a30e371e7af3619b5e91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  febcb0c59ac19fef2081a30e371e7af3619b5e91
Gitweb:     http://git.kernel.org/tip/febcb0c59ac19fef2081a30e371e7af3619b5e91
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:32 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 17:23:59 -0800

irq: Remove unnecessary bootmem code

mem_init is moved early already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-29-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
