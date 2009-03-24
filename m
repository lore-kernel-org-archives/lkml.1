Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbZCXOPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbZCXOPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbZCXOGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:06:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48997 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759463AbZCXOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:06:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/30] mxser: remove tty_port_tty_get from
	mxser_check_modem_status
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:06:20 +0000
Message-ID: <20090324140607.12735.71156.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
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

