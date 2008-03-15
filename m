Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYCOVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYCOVxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYCOVxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:53:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754852AbYCOVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:53:20 -0400
Date: Sat, 15 Mar 2008 17:53:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <apw@shadowen.org>, Len Brown <lenb@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] Fix misuse of wakeup flag accessors in serial core
In-Reply-To: <200803142337.12605.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803151713480.28007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1059) fixes a mistake in the way the serial core
initializes a device's wakeup settings.  It should use the accessor
routine instead of relying on a macro producing an lvalue.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/serial/serial_core.c
===================================================================
--- usb-2.6.orig/drivers/serial/serial_core.c
+++ usb-2.6/drivers/serial/serial_core.c
@@ -2356,7 +2356,7 @@ int uart_add_one_port(struct uart_driver
 	 */
 	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
 	if (likely(!IS_ERR(tty_dev))) {
-		device_can_wakeup(tty_dev) = 1;
+		device_init_wakeup(tty_dev, 1);
 		device_set_wakeup_enable(tty_dev, 0);
 	} else
 		printk(KERN_ERR "Cannot register tty device on line %d\n",

