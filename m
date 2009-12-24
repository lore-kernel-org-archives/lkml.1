Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZLXLnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZLXLnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZLXLnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:43:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57639 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbZLXLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gJMWgf5juqM8MvOS1XYRTVbAUi19hHaKgP1EFZiP4lzrU7e0eSfyx/fvTR3UwQmM5k
         L981KnRvxj3u/Z90AZRVUjJR/Od/f4EhmDBKIgdp7nIPDzlURAUMGF8hTAO2gGA2poJ8
         EzutC2VKU4zy9d5w28OJ7LujxDTLeId6b8mFA=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/5] USB: ftdi_sio: use error code from usb stack in read_latency_timer
Date: Thu, 24 Dec 2009 12:42:07 +0100
Message-Id: <1261654931-31543-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
In-Reply-To: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same semantics as for write_latency_timer.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bf34524..a952a3a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1174,10 +1174,9 @@ static int read_latency_timer(struct usb_serial_port *port)
 			     0, priv->interface,
 			     (char *) &latency, 1, WDR_TIMEOUT);
 
-	if (rv < 0) {
+	if (rv < 0)
 		dev_err(&port->dev, "Unable to read latency timer: %i\n", rv);
-		return -EIO;
-	} else
+	else
 		priv->latency = latency;
 	return rv;
 }
-- 
1.6.6.rc4

