Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZJFPQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZJFPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbZJFPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:16:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35826 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757605AbZJFPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:16:48 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] tty_port: coding style cleaning pass
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 06 Oct 2009 16:06:21 +0100
Message-ID: <20091006150616.9431.29417.stgit@localhost.localdomain>
In-Reply-To: <20091006145413.9431.47083.stgit@localhost.localdomain>
References: <20091006145413.9431.47083.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mind the hoover wire...

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 2512262..c16ba2d 100644
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
@@ -248,7 +248,8 @@ int tty_port_block_til_ready(struct tty_port *port,
 			tty_port_raise_dtr_rts(port);
 
 		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
-		/* Check for a hangup or uninitialised port. Return accordingly */
+		/* Check for a hangup or uninitialised port.
+							Return accordingly */
 		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
@@ -280,11 +281,11 @@ int tty_port_block_til_ready(struct tty_port *port,
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
 
@@ -294,7 +295,7 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 		return 0;
 	}
 
-	if( tty->count == 1 && port->count != 1) {
+	if (tty->count == 1 && port->count != 1) {
 		printk(KERN_WARNING
 		    "tty_port_close_start: tty->count = 1 port count = %d.\n",
 								port->count);
@@ -326,8 +327,8 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 		long timeout;
 
 		if (bps > 1200)
-			timeout = max_t(long, (HZ * 10 * port->drain_delay) / bps,
-								HZ / 10);
+			timeout = max_t(long,
+				(HZ * 10 * port->drain_delay) / bps, HZ / 10);
 		else
 			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
@@ -378,7 +379,7 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 EXPORT_SYMBOL(tty_port_close);
 
 int tty_port_open(struct tty_port *port, struct tty_struct *tty,
-                                                        struct file *filp)
+							struct file *filp)
 {
 	spin_lock_irq(&port->lock);
 	if (!tty_hung_up_p(filp))
@@ -398,14 +399,13 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
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
 	return tty_port_block_til_ready(port, tty, filp);
-}        
-
+}
 EXPORT_SYMBOL(tty_port_open);

