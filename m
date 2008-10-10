Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbYJJK4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbYJJK4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYJJKve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:51:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47621 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758456AbYJJKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:51:33 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 26/27] ftdi: A few errors are err() that should be debug which
	causes much spewage
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:51:30 +0100
Message-ID: <20081010105127.31597.16229.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

