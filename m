Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYETNhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYETNhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763256AbYETNgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:36:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39138 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbYETNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:36:41 -0400
Date: Mon, 19 May 2008 20:41:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: PATCH] Replace a printk + WARN_ON() to a WARN()
Message-ID: <20080519204102.33e7c476@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] Replace a printk + WARN_ON() to a WARN()

Replace a printk+WARN_ON() by a WARN(); this increases the
chance of the string making it into the bugreport
(eg it goes inside the ---[ cute here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/irq/manage.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46d6611..e296f67 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -224,9 +224,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 			set_wake = NULL;
 	} else {
 		if (desc->wake_depth == 0) {
-			printk(KERN_WARNING "Unbalanced IRQ %d "
-					"wake disable\n", irq);
-			WARN_ON(1);
+			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0)
 			desc->status &= ~IRQ_WAKEUP;
 		else
-- 
1.5.4.5

