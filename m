Return-Path: <linux-kernel-owner+w=401wt.eu-S935141AbZLKXke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141AbZLKXke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934173AbZLKXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:52 -0500
Received: from kroah.org ([198.145.64.141]:50451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787AbZLKX26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/58] tty_port: coding style cleaning pass
Date: Fri, 11 Dec 2009 15:27:58 -0800
Message-Id: <1260574122-10676-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Mind the hoover wire...

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index b22a61a..41b314c 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(tty_port_lower_dtr_rts);
  *	management of these lines. Note that the dtr/rts raise is done each
  *	iteration as a hangup may have previously dropped them while we wait.
  */
- 
+
 int tty_port_block_til_ready(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp)
 {
@@ -254,7 +254,8 @@ int tty_port_block_til_ready(struct tty_port *port,
 			tty_port_raise_dtr_rts(port);
 
 		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
-		/* Check for a hangup or uninitialised port. Return accordingly */
+		/* Check for a hangup or uninitialised port.
+							Return accordingly */
 		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
@@ -286,11 +287,11 @@ int tty_port_block_til_ready(struct tty_port *port,
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 	spin_unlock_irqrestore(&port->lock, flags);
 	return retval;
-	
 }
 EXPORT_SYMBOL(tty_port_block_til_ready);
 
-int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct file *filp)
+int tty_port_close_start(struct tty_port *port,
+				struct tty_struct *tty, struct file *filp)
 {
 	unsigned long flags;
 
@@ -300,7 +301,7 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 		return 0;
 	}
 
-	if( tty->count == 1 && port->count != 1) {
+	if (tty->count == 1 && port->count != 1) {
 		printk(KERN_WARNING
 		    "tty_port_close_start: tty->count = 1 port count = %d.\n",
 								port->count);
@@ -332,8 +333,8 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 		long timeout;
 
 		if (bps > 1200)
-			timeout = max_t(long, (HZ * 10 * port->drain_delay) / bps,
-								HZ / 10);
+			timeout = max_t(long,
+				(HZ * 10 * port->drain_delay) / bps, HZ / 10);
 		else
 			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
@@ -384,7 +385,7 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 EXPORT_SYMBOL(tty_port_close);
 
 int tty_port_open(struct tty_port *port, struct tty_struct *tty,
-                                                        struct file *filp)
+							struct file *filp)
 {
 	spin_lock_irq(&port->lock);
 	if (!tty_hung_up_p(filp))
@@ -404,10 +405,10 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
 			if (retval) {
-        		        mutex_unlock(&port->mutex);
-        			return retval;
-        		}
-                }
+				mutex_unlock(&port->mutex);
+				return retval;
+			}
+		}
 		set_bit(ASYNCB_INITIALIZED, &port->flags);
 	}
 	mutex_unlock(&port->mutex);
-- 
1.6.5.5

