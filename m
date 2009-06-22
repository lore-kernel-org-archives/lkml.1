Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZFVQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZFVQeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZFVQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:34:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbZFVQeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:34:04 -0400
Date: Mon, 22 Jun 2009 12:32:50 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [patch] Remove tty low_latency flag setting from drivers/char/
Message-ID: <20090622123250.5c2cd13e@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

Remove tty low_latency flag setting from drivers/char/.

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
 
--- linux-2.6.30.noarch.orig/drivers/char/pcmcia/ipwireless/tty.c
+++ linux-2.6.30.noarch/drivers/char/pcmcia/ipwireless/tty.c
@@ -134,7 +134,6 @@ static int ipw_open(struct tty_struct *l
 
 	tty->linux_tty = linux_tty;
 	linux_tty->driver_data = tty;
-	linux_tty->low_latency = 1;
 
 	if (tty->tty_type == TTYTYPE_MODEM)
 		ipwireless_ppp_open(tty->network);
