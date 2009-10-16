Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZJPR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZJPR21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZJPR2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:28:24 -0400
Received: from kroah.org ([198.145.64.141]:48452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZJPRSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:16 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:50 2009
Message-Id: <20091016171149.936555143@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [07/46] USB: ftdi_sio: remove tty->low_latency
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-ftdi_sio-remove-tty-low_latency.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit 0cbd81a9f6bac734ac3266687bf027af1e395270 upstream.

Fixes tty_flip_buffer_push being called from hard interrupt context with
low_latency set.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1235,7 +1235,6 @@ static int set_serial_info(struct tty_st
 					(new_serial.flags & ASYNC_FLAGS));
 	priv->custom_divisor = new_serial.custom_divisor;
 
-	tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 	write_latency_timer(port);
 
 check_and_exit:
@@ -1706,9 +1705,6 @@ static int ftdi_open(struct tty_struct *
 	priv->rx_bytes = 0;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
-	if (tty)
-		tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
-
 	write_latency_timer(port);
 
 	/* No error checking for this (will get errors later anyway) */


