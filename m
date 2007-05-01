Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXEASNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXEASNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXEASNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:13:37 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:52197 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030354AbXEASNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:13:35 -0400
Message-id: <14586147702477213939@wsc.cz>
In-reply-to: <88401795395522653@wsc.cz>
Subject: [PATCH 3/3] Serial: serial_core, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  1 May 2007 20:13:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

serial_core, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2261bd870cd3c289ec74db4b2cfddb5c9ed59e95
tree 05f23ba7ce1add483b1e72c5a02bc0309536b7ea
parent f4fba1005f8f25f5dc369f6e6e04643f4b6a6822
author Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:10:04 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:10:04 +0200

 drivers/serial/serial_core.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 74e34ba..6dbcd7e 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -37,13 +37,6 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
-#undef	DEBUG
-#ifdef DEBUG
-#define DPRINTK(x...)	printk(x)
-#else
-#define DPRINTK(x...)	do { } while (0)
-#endif
-
 /*
  * This is used to lock changes in serial line configuration.
  */
@@ -560,7 +553,7 @@ static void uart_flush_buffer(struct tty_struct *tty)
 		return;
 	}
 
-	DPRINTK("uart_flush_buffer(%d) called\n", tty->index);
+	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
 	uart_circ_clear(&state->info->xmit);
@@ -1234,7 +1227,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	port = state->port;
 
-	DPRINTK("uart_close(%d) called\n", port->line);
+	pr_debug("uart_close(%d) called\n", port->line);
 
 	mutex_lock(&state->mutex);
 
@@ -1353,7 +1346,7 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	expire = jiffies + timeout;
 
-	DPRINTK("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
+	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
 	        port->line, jiffies, expire);
 
 	/*
@@ -1382,7 +1375,7 @@ static void uart_hangup(struct tty_struct *tty)
 	struct uart_state *state = tty->driver_data;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_hangup(%d)\n", state->port->line);
+	pr_debug("uart_hangup(%d)\n", state->port->line);
 
 	mutex_lock(&state->mutex);
 	if (state->info && state->info->flags & UIF_NORMAL_ACTIVE) {
@@ -1584,7 +1577,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	int retval, line = tty->index;
 
 	BUG_ON(!kernel_locked());
-	DPRINTK("uart_open(%d) called\n", line);
+	pr_debug("uart_open(%d) called\n", line);
 
 	/*
 	 * tty->driver->num won't change, so we won't fail here with
