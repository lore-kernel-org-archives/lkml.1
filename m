Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZFVRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZFVRfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZFVRfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:35:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZFVRfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:35:44 -0400
Date: Mon, 22 Jun 2009 13:34:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] Remove low_latency flag setting from nozomi and mxser
 drivers
Message-ID: <20090622133436.23b1442a@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Remove low_latency flag setting from nozomi and mxser drivers

The kernel oopses if this flag is set.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.30.noarch.orig/drivers/char/nozomi.c
+++ linux-2.6.30.noarch/drivers/char/nozomi.c
@@ -1591,8 +1591,6 @@ static int ntty_open(struct tty_struct *
 
 	/* Enable interrupt downlink for channel */
 	if (port->port.count == 1) {
-		/* FIXME: is this needed now ? */
-		tty->low_latency = 1;
 		tty->driver_data = port;
 		tty_port_tty_set(&port->port, tty);
 		DBG1("open: %d", port->token_dl);
--- linux-2.6.30.noarch.orig/drivers/char/mxser.c
+++ linux-2.6.30.noarch/drivers/char/mxser.c
@@ -1048,8 +1048,6 @@ static int mxser_open(struct tty_struct 
 	if (retval)
 		return retval;
 
-	/* unmark here for very high baud rate (ex. 921600 bps) used */
-	tty->low_latency = 1;
 	return 0;
 }
 
