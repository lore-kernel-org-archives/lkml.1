Return-Path: <linux-kernel-owner+w=401wt.eu-S1763066AbZJOVPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763066AbZJOVPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZJOVPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:15:48 -0400
Received: from kroah.org ([198.145.64.141]:43154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbZJOVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:15:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct 15 14:10:20 2009
Message-Id: <20091015211020.207764920@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Oct 2009 11:54:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.org>
Subject: [3/3] USB: digi_acceleport: Fix broken unthrottle.
References: <20091015185430.128674330@mini.kroah.org>
Content-Disposition: inline; filename=usb-digi_acceleport-fix-broken-unthrottle.patch
In-Reply-To: <20091015211112.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit ba6b702f85a61561d329c4c11d3ed95604924f9a upstream.

This patch fixes a regression introduced in
39892da44b21b5362eb848ca424d73a25ccc488f.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/digi_acceleport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -892,16 +892,16 @@ static void digi_rx_unthrottle(struct tt
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
-	/* turn throttle off */
-	priv->dp_throttled = 0;
-	priv->dp_throttle_restart = 0;
-
 	/* restart read chain */
 	if (priv->dp_throttle_restart) {
 		port->read_urb->dev = port->serial->dev;
 		ret = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	}
 
+	/* turn throttle off */
+	priv->dp_throttled = 0;
+	priv->dp_throttle_restart = 0;
+
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
 
 	if (ret)


