Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYHCNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYHCNbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYHCNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:31:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYHCNbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i88yRCozYaFcRR0E8c6sw2Sq6TtofQTwu/HtKt+U5uAekJY8xkwOz7vMPMLBq7W2WN
         VyAKCUr/YMBYTae7aoEX2xhKvgrfuKfUI+LjCKU8UB/PbPL5SQ5vir5mz3+z9BKnet+7
         VIkBsZK5q7BM+mxst2lNkcrOjAdtcDhs5fOy4=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] gpiolib: dump correct irq trigger type
Date: Sun,  3 Aug 2008 17:30:06 +0400
Message-Id: <1217770206-6193-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use desc->action->flags for dumping irq flags, it is populated with
correct trigger type.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index beaf6b3..a35d19d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2,6 +2,7 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 
 #include <asm/gpio.h>
 
@@ -570,7 +571,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			if (irq >= 0 && desc->action) {
 				char *trigger;
 
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
+				switch (desc->action->flags & IRQ_TYPE_SENSE_MASK) {
 				case IRQ_TYPE_NONE:
 					trigger = "(default)";
 					break;
-- 
1.5.6.3

