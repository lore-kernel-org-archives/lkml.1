Return-Path: <linux-kernel-owner+w=401wt.eu-S1423269AbXBHTsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423269AbXBHTsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423282AbXBHTsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:48:09 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:37230 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423269AbXBHTsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:48:08 -0500
Message-id: <156451408997831024@wsc.cz>
Subject: [PATCH 1/2] Char: specialix, isr have 2 params
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <R.E.Wolff@BitWizard.nl>
Date: Thu,  8 Feb 2007 20:48:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

specialix, isr have 2 params

pt_regs are no longer the third parameter of isr, call sx_interrupt without
it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fc1cfd05e494252ac71a223e0cdd35cff7dd9844
tree eaca805ac95536c421feadf5a798f89c485e0628
parent e8d5617886087b5c8eee9df2c73381495672e23c
author Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 13:08:26 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 13:08:26 +0100

 drivers/char/specialix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 92043c8..f1688fe 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -459,7 +459,7 @@ void missed_irq (unsigned long data)
 	if (irq) {
 		printk (KERN_INFO "Missed interrupt... Calling int from timer. \n");
 		sx_interrupt (((struct specialix_board *)data)->irq,
-		              (void*)data, NULL);
+				(void*)data);
 	}
 	missed_irq_timer.expires = jiffies + sx_poll;
 	add_timer (&missed_irq_timer);
