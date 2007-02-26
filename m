Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327AbXBZQId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbXBZQId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXBZQId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:08:33 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34699 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbXBZQIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:08:32 -0500
To: linux-kernel@vger.kernel.org
CC: devel@openvz.org
From: Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: [PATCH 1/3] IRQ: add __must_check to request_irq
Date: Mon, 26 Feb 2007 19:08:52 +0300
Message-ID: <871wkcrje3.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Mon, 26 Feb 2007 19:08:34 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This could help to find buggy drivers where request_irq return value wasn't
checked. There's just no reason to ignore errors which can and do occur.
Anyone who got warning during compilation have to realise what it is't realy
safe code.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 include/linux/interrupt.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8c52a56..c71f056 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -83,11 +83,11 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int request_irq(unsigned int, irq_handler_t handler,
+extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
-extern int devm_request_irq(struct device *dev, unsigned int irq,
+extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
-- 
1.5.0.1


