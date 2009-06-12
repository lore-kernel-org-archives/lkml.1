Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbZFLNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbZFLNcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbZFLN0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:06 -0400
Received: from ozlabs.org ([203.10.76.45]:54990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763365AbZFLN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:00 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 10/17] cpumask: remove unused mask field from struct irqaction.
Message-Id: <20090612132602.DDCACDDDE1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Up until 1.1.83, the primitive human tribes used struct sigaction for
interrupts.  The sa_mask field was overloaded to hold a pointer to the
name.

When someone created the new "struct irqaction" they carried across
the "mask" field as a kind of ancestor worship: the fact that it was
unused makes clear its spiritual significance.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/interrupt.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -64,7 +64,6 @@ struct irqaction {
 struct irqaction {
 	irq_handler_t handler;
 	unsigned long flags;
-	cpumask_t mask;
 	const char *name;
 	void *dev_id;
 	struct irqaction *next;

