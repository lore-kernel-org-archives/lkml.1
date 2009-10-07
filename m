Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbZJGSGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbZJGSGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZJGSGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:06:43 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44219 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbZJGSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fzjFRhW38vQ+oFM9mxjG9EiXqyeEJ48GezTn8NhXBziXzsi8WmvopFR5AP/4BGlg5u
         1Fwo58wgBRUiSOwDvtG29/fwjzApx7/60woOBTy12YJCXYEXDQ/JJLBUJvH64uir0ZC2
         vZ9nSVxWBOgJ8wK8xqgtDckfRJhpWsxYwrUwI=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/4] USB: ftdi_sio: remove tty->low_latency
Date: Wed,  7 Oct 2009 20:05:04 +0200
Message-Id: <1254938707-6996-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
References: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes tty_flip_buffer_push being called from hard interrupt context with
low_latency set.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4f883b1..0ac2c2f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1234,7 +1234,6 @@ static int set_serial_info(struct tty_struct *tty,
 					(new_serial.flags & ASYNC_FLAGS));
 	priv->custom_divisor = new_serial.custom_divisor;
 
-	tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 	write_latency_timer(port);
 
 check_and_exit:
@@ -1704,9 +1703,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	priv->rx_bytes = 0;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
-	if (tty)
-		tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
-
 	write_latency_timer(port);
 
 	/* No error checking for this (will get errors later anyway) */
-- 
1.6.5.rc2

