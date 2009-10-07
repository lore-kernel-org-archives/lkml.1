Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZJGWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZJGWAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJGWAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:00:16 -0400
Received: from kroah.org ([198.145.64.141]:41212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZJGWAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:00:12 -0400
Date: Wed, 7 Oct 2009 14:55:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.3
Message-ID: <20091007215559.GB7241@kroah.com>
References: <20091007215538.GC7241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007215607.GC7241@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d3a69fd..0138557 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 31
-EXTRAVERSION = .2
+EXTRAVERSION = .3
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 549bd0f..fa4ce67 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -99,7 +99,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	if (port->ops->shutdown &&
-		test_and_clear_bit(ASYNC_INITIALIZED, &port->flags))
+		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 
 }
@@ -309,7 +309,7 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 			port->ops->drop(port);
 		return 0;
 	}
-	set_bit(ASYNC_CLOSING, &port->flags);
+	set_bit(ASYNCB_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 	/* Don't block on a stalled port, just pull the chain */
