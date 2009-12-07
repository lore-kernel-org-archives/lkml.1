Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZLGAPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZLGAPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZLGAO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:28 -0500
Received: from kroah.org ([198.145.64.141]:34843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629AbZLGAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:01 2009
Message-Id: <20091207000701.379636613@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, Karsten Keil <isdn@linux-pingi.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [119/119] isdn: hfc_usb: Fix read buffer overflow
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=isdn-hfc_usb-fix-read-buffer-overflow.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roel Kluin <roel.kluin@gmail.com>

commit 286e633ef0ff5bb63c07b4516665da8004966fec upstream.

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hisax/hfc_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -817,8 +817,8 @@ collect_rx_frame(usb_fifo * fifo, __u8 *
 	}
 	/* we have a complete hdlc packet */
 	if (finish) {
-		if ((!fifo->skbuff->data[fifo->skbuff->len - 1])
-		    && (fifo->skbuff->len > 3)) {
+		if (fifo->skbuff->len > 3 &&
+				!fifo->skbuff->data[fifo->skbuff->len - 1]) {
 
 			if (fifon == HFCUSB_D_RX) {
 				DBG(HFCUSB_DBG_DCHANNEL,


