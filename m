Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbXJNEh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbXJNEh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXJNEhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:37:10 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22211 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXJNEhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:37:08 -0400
Date: Sat, 13 Oct 2007 22:37:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] mpc52xx-uart: fix compile warning (format type mismatch)
In-reply-to: <20071014043657.23348.56519.stgit@trillian.cg.shawcable.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, paulus@ozlabs.org
Message-id: <20071014043702.23348.7238.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071014043657.23348.56519.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Trivial compile warning fix

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/serial/mpc52xx_uart.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 035cca0..ec36ad7 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -756,8 +756,8 @@ mpc52xx_console_setup(struct console *co, char *options)
 	if (port->membase == NULL)
 		return -EINVAL;
 
-	pr_debug("mpc52xx-psc uart at %lx, mapped to %p, irq=%x, freq=%i\n",
-	         port->mapbase, port->membase, port->irq, port->uartclk);
+	pr_debug("mpc52xx-psc uart at %p, mapped to %p, irq=%x, freq=%i\n",
+	         (void*)port->mapbase, port->membase, port->irq, port->uartclk);
 
 	/* Setup the port parameters accoding to options */
 	if (options)
@@ -974,8 +974,8 @@ mpc52xx_uart_of_probe(struct of_device *op, const struct of_device_id *match)
 	port->mapbase = res.start;
 	port->irq = irq_of_parse_and_map(op->node, 0);
 
-	dev_dbg(&op->dev, "mpc52xx-psc uart at %lx, irq=%x, freq=%i\n",
-	        port->mapbase, port->irq, port->uartclk);
+	dev_dbg(&op->dev, "mpc52xx-psc uart at %p, irq=%x, freq=%i\n",
+	        (void*)port->mapbase, port->irq, port->uartclk);
 
 	if ((port->irq==NO_IRQ) || !port->mapbase) {
 		printk(KERN_ERR "Could not allocate resources for PSC\n");

