Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZI2KjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZI2KjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZI2KjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:39:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:28894 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZI2KjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NmQPNGJE4e6K7FN4kAvBquR59EEE00PgWsN80WSkfMUUdj7hfYprchesNoIagAUmYs
         MYlQGs7Nqoc5t+slYJcQgmB35sr2zFABZi1rkhwZ1Y1S9nFeqCdUKlXIKB/lVth0RmUC
         Fq9odyts7VaamJFqV6ChsvXkuOU0aeR4DKy90=
Date: Tue, 29 Sep 2009 12:39:23 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH] USB: digi_acceleport: Fix broken unthrottle.
Message-ID: <20090929103923.GA2866@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression introduced in
39892da44b21b5362eb848ca424d73a25ccc488f.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi, 

This patch is untested as I haven't got the hardware, but seems
straight-forward to me. 

Can you verify, Oliver?

Thanks,
Johan


 drivers/usb/serial/digi_acceleport.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index ab3dd99..68e80be 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -898,16 +898,16 @@ static void digi_rx_unthrottle(struct tty_struct *tty)
 
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
-- 
1.6.4.2

