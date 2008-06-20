Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbYFTUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbYFTUi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762438AbYFTUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58341 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762430AbYFTUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 58/70] mct_u232: Use flip buffer functions
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:05:57 +0100
Message-ID: <20080620200553.1479.77291.stgit@localhost.localdomain>
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

 drivers/usb/serial/mct_u232.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 7a804d6..0ded8bd 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -563,11 +563,9 @@ static void mct_u232_read_int_callback(struct urb *urb)
 	 * Work-a-round: handle the 'usual' bulk-in pipe here
 	 */
 	if (urb->transfer_buffer_length > 2) {
-		int i;
 		tty = port->port.tty;
 		if (urb->actual_length) {
-			for (i = 0; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], 0);
+			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 		}
 		goto exit;

