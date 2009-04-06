Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZDFPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZDFPjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZDFPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:35:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56997 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714AbZDFPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:35:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/27] mxser: remove tty_port_tty_get from
	mxser_check_modem_status
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:34:10 +0100
Message-ID: <20090406163409.12934.31210.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

mxser_check_modem_status is called with tty parameter, so the
reference should be increased by callers already -- for ioctl
syscall it is held whole time gap since open to close, for
interrupt, the reference count is increased in the irq handler.

There is no tty_kref_put in that function, so this also fixes
a refcounting bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/mxser.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 402c9f2..a420e8d 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -820,7 +820,6 @@ static void mxser_check_modem_status(struct tty_struct *tty,
 			wake_up_interruptible(&port->port.open_wait);
 	}
 
-	tty = tty_port_tty_get(&port->port);
 	if (port->port.flags & ASYNC_CTS_FLOW) {
 		if (tty->hw_stopped) {
 			if (status & UART_MSR_CTS) {

