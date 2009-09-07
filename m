Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZIGK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZIGK1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZIGK1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:27:21 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:53599 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZIGK1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:27:20 -0400
X-Greylist: delayed 1626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 06:27:20 EDT
Date: Mon, 7 Sep 2009 12:00:13 +0200 (MEST)
Message-Id: <200909071000.n87A0CBF019863@pilspetsen.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ben-linux@fluff.org
Subject: [PATCH 2.6.31-rc9] i2c-mv64xxx.c: correct mv64xxx_i2c_intr() return type
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, mgreer@mvista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mv64xxx_i2c_intr() irq handler in drivers/i2c/busses/i2c-mv64xxx.c
is declared as returning 'int', resulting in this compile-time warning:

drivers/i2c/busses/i2c-mv64xxx.c: In function 'mv64xxx_i2c_probe':
drivers/i2c/busses/i2c-mv64xxx.c:540: warning: passing argument 2 of 'request_irq' from incompatible pointer type

Fix: correct the return type to 'irqreturn_t'.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/i2c/busses/i2c-mv64xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc9/drivers/i2c/busses/i2c-mv64xxx.c.~1~	2009-09-06 12:20:56.000000000 +0200
+++ linux-2.6.31-rc9/drivers/i2c/busses/i2c-mv64xxx.c	2009-09-07 11:31:43.000000000 +0200
@@ -293,13 +293,13 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c
 	}
 }
 
-static int
+static irqreturn_t
 mv64xxx_i2c_intr(int irq, void *dev_id)
 {
 	struct mv64xxx_i2c_data	*drv_data = dev_id;
 	unsigned long	flags;
 	u32		status;
-	int		rc = IRQ_NONE;
+	irqreturn_t	rc = IRQ_NONE;
 
 	spin_lock_irqsave(&drv_data->lock, flags);
 	while (readl(drv_data->reg_base + MV64XXX_I2C_REG_CONTROL) &
