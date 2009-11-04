Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKDNUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKDNUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZKDNUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:20:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZKDNUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F4ny4MmWndmWDUQIeatLJETRKI2UoTXGWFaQ0Eo+Czc9Yi8mswNUVtLOyPSUCf4wM4
         7gN46c5aU2XVqZgH80vS5Gy4ibrsa2jbLCCembU2Wqw2MXxofhidFsFiueAWv4jv8ACH
         flXdRXhFGZGxpzLVTRqiPhOox9jxZxzPqbz8A=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] genirq: omit validate of desc->chip->shutdown
Date: Wed,  4 Nov 2009 21:20:39 +0800
Message-Id: <1257340841-3739-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because irq_chip_set_defaults() will do the init things, chip->shutdown
can't be NULL then the validate of it is redundant.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bde4c66..0b5e5ed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -878,10 +878,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
-		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
-		else
-			desc->chip->disable(irq);
+		desc->chip->shutdown(irq);
 	}
 
 	spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.6.3.3

