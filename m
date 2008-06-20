Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYFTUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYFTUgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbYFTUWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:22:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35237 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762193AbYFTUWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:22:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 54/70] keyspan_pda: Use string flip functions
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:11 +0100
Message-ID: <20080620200507.1479.7509.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/keyspan_pda.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 928f545..b11329e 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -220,7 +220,6 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty = port->port.tty;
 	unsigned char *data = urb->transfer_buffer;
-	int i;
 	int retval;
 	int status = urb->status;
 	struct keyspan_pda_private *priv;
@@ -248,8 +247,8 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 	case 0:
 		/* rest of message is rx data */
 		if (urb->actual_length) {
-			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], 0);
+			tty_insert_flip_string(tty, data + 1,
+						urb->actual_length - 1);
 			tty_flip_buffer_push(tty);
 		}
 		break;

