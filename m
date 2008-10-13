Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbYJMJmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbYJMJmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbYJMJgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56175 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760401AbYJMJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/80] ftdi: A few errors are err() that should be debug which
	causes much spewage
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:00 +0100
Message-ID: <20081013093556.21645.34243.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Fixes #10783

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/ftdi_sio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3dc93b5..1ac7e80 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -860,7 +860,7 @@ static int update_mctrl(struct usb_serial_port *port, unsigned int set,
 
 	kfree(buf);
 	if (rv < 0) {
-		err("%s Error from MODEM_CTRL urb: DTR %s, RTS %s",
+		dbg("%s Error from MODEM_CTRL urb: DTR %s, RTS %s",
 				__func__,
 				(set & TIOCM_DTR) ? "HIGH" :
 				(clear & TIOCM_DTR) ? "LOW" : "unchanged",
@@ -2256,7 +2256,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 			   0, 0,
 			   buf, 1, WDR_TIMEOUT);
 		if (ret < 0) {
-			err("%s Could not get modem status of device - err: %d", __func__,
+			dbg("%s Could not get modem status of device - err: %d", __func__,
 			    ret);
 			return ret;
 		}
@@ -2275,7 +2275,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 				   0, priv->interface,
 				   buf, 2, WDR_TIMEOUT);
 		if (ret < 0) {
-			err("%s Could not get modem status of device - err: %d", __func__,
+			dbg("%s Could not get modem status of device - err: %d", __func__,
 			    ret);
 			return ret;
 		}

