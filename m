Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbYJEQfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbYJEQfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbYJEQZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:25:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34349 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758677AbYJEQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:25:39 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 76/76] ftdi: A few errors are err() that should be debug which
	causes much spewage
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:25:39 +0100
Message-ID: <20081005162536.1997.95744.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
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
index 70a3719..c2ac129 100644
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
@@ -2259,7 +2259,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 			   0, 0,
 			   buf, 1, WDR_TIMEOUT);
 		if (ret < 0) {
-			err("%s Could not get modem status of device - err: %d", __func__,
+			dbg("%s Could not get modem status of device - err: %d", __func__,
 			    ret);
 			return ret;
 		}
@@ -2278,7 +2278,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 				   0, priv->interface,
 				   buf, 2, WDR_TIMEOUT);
 		if (ret < 0) {
-			err("%s Could not get modem status of device - err: %d", __func__,
+			dbg("%s Could not get modem status of device - err: %d", __func__,
 			    ret);
 			return ret;
 		}

