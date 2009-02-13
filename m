Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZBMHAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZBMHAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZBMHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:00:07 -0500
Received: from ozlabs.org ([203.10.76.45]:56382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbZBMHAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:00:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cpumask: remove unused mask field from struct irqaction.
Date: Fri, 13 Feb 2009 12:39:45 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
References: <200902131238.52419.rusty@rustcorp.com.au>
In-Reply-To: <200902131238.52419.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131239.45293.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up until 1.1.83, the primitive human tribes used struct sigaction for
interrupts.  The sa_mask field was overloaded to hold a pointer to the
name.

When someone created the new "struct irqaction" they carried across
the "mask" field as a kind of ancestor worship: the fact that it was
unused makes clear its spiritual significance.

As long as we avoid all other bad omens, I'm sure the Gods will
forgive us.

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
