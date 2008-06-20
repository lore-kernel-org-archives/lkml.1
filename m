Return-Path: <linux-kernel-owner+w=401wt.eu-S1764538AbYFTUbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764538AbYFTUbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761627AbYFTUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35215 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761595AbYFTUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 43/70] io_edgeport: Fix various bogus returns to the tty layer
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:41 +0100
Message-ID: <20080620200337.1479.38632.stgit@localhost.localdomain>
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

The edgeport reports negative error codes to functions that do not
expect them. This can cause ports to jam forever

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/io_edgeport.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 3cb2511..44d020e 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1444,15 +1444,15 @@ static int edge_write_room(struct tty_struct *tty)
 	dbg("%s", __func__);
 
 	if (edge_port == NULL)
-		return -ENODEV;
+		return 0;
 	if (edge_port->closePending)
-		return -ENODEV;
+		return 0;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	if (!edge_port->open) {
 		dbg("%s - port not opened", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	/* total of both buffers is still txCredit */
@@ -1484,13 +1484,13 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
 	dbg("%s", __func__);
 
 	if (edge_port == NULL)
-		return -ENODEV;
+		return 0;
 	if (edge_port->closePending)
-		return -ENODEV;
+		return 0;
 
 	if (!edge_port->open) {
 		dbg("%s - port not opened", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);

