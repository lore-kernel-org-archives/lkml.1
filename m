Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab0BQNVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:21:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36277 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932183Ab0BQNVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:21:34 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RESEND PATCH] xen: clean up event funcs
To: ian.campbell@citrix.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 12:57:32 +0000
Message-ID: <20100217125723.15007.56854.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mk_pirq_info, gsi_from_irq and vector_from_irq are static and unused in the
C file that defines them. Remove them and the warnings this causes.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/xen/events.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)


diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..5131ef6 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -131,13 +131,6 @@ static struct irq_info mk_virq_info(unsigned short evtchn, unsigned short virq)
 			.cpu = 0, .u.virq = virq };
 }
 
-static struct irq_info mk_pirq_info(unsigned short evtchn,
-				    unsigned short gsi, unsigned short vector)
-{
-	return (struct irq_info) { .type = IRQT_PIRQ, .evtchn = evtchn,
-			.cpu = 0, .u.pirq = { .gsi = gsi, .vector = vector } };
-}
-
 /*
  * Accessors for packed IRQ information.
  */
@@ -177,26 +170,6 @@ static unsigned virq_from_irq(unsigned irq)
 	return info->u.virq;
 }
 
-static unsigned gsi_from_irq(unsigned irq)
-{
-	struct irq_info *info = info_for_irq(irq);
-
-	BUG_ON(info == NULL);
-	BUG_ON(info->type != IRQT_PIRQ);
-
-	return info->u.pirq.gsi;
-}
-
-static unsigned vector_from_irq(unsigned irq)
-{
-	struct irq_info *info = info_for_irq(irq);
-
-	BUG_ON(info == NULL);
-	BUG_ON(info->type != IRQT_PIRQ);
-
-	return info->u.pirq.vector;
-}
-
 static enum xen_irq_type type_from_irq(unsigned irq)
 {
 	return info_for_irq(irq)->type;

