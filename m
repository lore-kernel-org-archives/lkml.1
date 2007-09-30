Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXI3XaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXI3XaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXI3X3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:29:54 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:54020 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXI3X3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:29:53 -0400
X-ME-UUID: 20070930232952276.06BA31C0008E@mwinf2709.orange.fr
Date: Mon, 1 Oct 2007 02:29:51 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Ryan Reading <ryanr23@gmail.com>
Subject: [PATCH -mm] IrCOMM discovery indication simplification
Message-ID: <20070930232951.GA18702@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Every IrCOMM socket is registered with the discovery subsystem, so we don't
need to loop over all of them for every discovery event. We just need to
do it for the registered IrCOMM socket.

Would you please consider this patch for -mm inclusion ?

From: Ryan Reading <ryanr23@gmail.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>

---
 net/irda/ircomm/ircomm_tty_attach.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: net-2.6.24-quilt/net/irda/ircomm/ircomm_tty_attach.c
===================================================================
--- net-2.6.24-quilt.orig/net/irda/ircomm/ircomm_tty_attach.c	2007-10-01 01:53:56.000000000 +0300
+++ net-2.6.24-quilt/net/irda/ircomm/ircomm_tty_attach.c	2007-10-01 01:53:58.000000000 +0300
@@ -381,18 +381,9 @@
 	info.daddr = discovery->daddr;
 	info.saddr = discovery->saddr;
 
-	/* FIXME. We have a locking problem on the hashbin here.
-	 * We probably need to use hashbin_find_next(), but we first
-	 * need to ensure that "line" is unique. - Jean II */
-	self = (struct ircomm_tty_cb *) hashbin_get_first(ircomm_tty);
-	while (self != NULL) {
-		IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return;);
-
-		ircomm_tty_do_event(self, IRCOMM_TTY_DISCOVERY_INDICATION,
-				    NULL, &info);
-
-		self = (struct ircomm_tty_cb *) hashbin_get_next(ircomm_tty);
-	}
+	self = (struct ircomm_tty_cb *) priv;
+	ircomm_tty_do_event(self, IRCOMM_TTY_DISCOVERY_INDICATION,
+			    NULL, &info);
 }
 
 /*

