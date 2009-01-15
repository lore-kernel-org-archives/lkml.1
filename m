Return-Path: <linux-kernel-owner+w=401wt.eu-S1765316AbZAONb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765316AbZAONb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764862AbZAONav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60785 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764845AbZAONau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:50 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/8] ftdi_sio: fix kref leak
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:31:07 +0000
Message-ID: <20090115133101.21366.66605.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Paris <jim@jtan.com>

Commit 4a90f09b20f4622dcbff1f0e1e6bae1704f8ad8c added kref stuff to
ftdi_sio, but missed tty_kref_put at one exit point in
ftdi_process_read.

Signed-off-by: Jim Paris <jim@jtan.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ef6cfa5..c70a8f6 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2030,7 +2030,7 @@ static void ftdi_process_read(struct work_struct *work)
 			spin_unlock_irqrestore(&priv->rx_lock, flags);
 			dbg("%s - deferring remainder until unthrottled",
 					__func__);
-			return;
+			goto out;
 		}
 		spin_unlock_irqrestore(&priv->rx_lock, flags);
 		/* if the port is closed stop trying to read */

