Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbYFTUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbYFTUmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbYFTUYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58359 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762756AbYFTUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 67/70] omninet: Use string flip functions
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:07:05 +0100
Message-ID: <20080620200702.1479.96363.stgit@localhost.localdomain>
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

 drivers/usb/serial/omninet.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 5a76f32..ae8e227 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -206,8 +206,8 @@ static void omninet_read_bulk_callback(struct urb *urb)
 	unsigned char 		*data 	= urb->transfer_buffer;
 	struct omninet_header 	*header = (struct omninet_header *) &data[0];
 	int status = urb->status;
-	int i;
 	int result;
+	int i;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -229,9 +229,8 @@ static void omninet_read_bulk_callback(struct urb *urb)
 	}
 
 	if (urb->actual_length && header->oh_len) {
-		for (i = 0; i < header->oh_len; i++)
-			 tty_insert_flip_char(port->port.tty,
-					data[OMNINET_DATAOFFSET + i], 0);
+		tty_insert_flip_string(port->port.tty,
+			data + OMNINET_DATAOFFSET, header->oh_len);
 		tty_flip_buffer_push(port->port.tty);
 	}
 

