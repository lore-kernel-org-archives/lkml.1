Return-Path: <linux-kernel-owner+w=401wt.eu-S938582AbYCSXMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938582AbYCSXMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937918AbYCSVkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:40:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935869AbYCSVk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:40:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 1/3] Fix misuse of wakeup flag accessors in serial core
Date: Wed, 19 Mar 2008 22:35:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
References: <200803190315.m2J3FXnK029022@imap1.linux-foundation.org> <20080319185755.GA18464@kroah.com> <200803192233.55313.rjw@sisk.pl>
In-Reply-To: <200803192233.55313.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192235.14645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1059) fixes a mistake in the way the serial core
initializes a device's wakeup settings.  It should use the accessor
routine instead of relying on a macro producing an lvalue.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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



