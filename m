Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbZAONdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbZAONdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764956AbZAONbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:31:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60794 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764004AbZAONbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:31:16 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 8/8] hso serial throttled tty kref fix.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:31:34 +0000
Message-ID: <20090115133129.21366.5313.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Joseph Barrow <D.Barow@option.com>

This patch is for Alan Cox as it related to the tty layer.
Hopefully the hso driver is again relatively stable with this fix.

Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/usb/hso.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index e25a58f..6478bf6 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2053,8 +2053,10 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 			serial->curr_rx_urb_offset;
 		D1("data to push to tty");
 		while (write_length_remaining) {
-			if (test_bit(TTY_THROTTLED, &tty->flags))
+			if (test_bit(TTY_THROTTLED, &tty->flags)) {
+				tty_kref_put(tty);
 				return -1;
+			}
 			curr_write_len =  tty_insert_flip_string
 				(tty, urb->transfer_buffer +
 				 serial->curr_rx_urb_offset,

