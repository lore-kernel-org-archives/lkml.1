Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbZDAONN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbZDAONN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbZDAOGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37784 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932377AbZDAOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/24] mxser: remove tty_port_tty_get from
	mxser_check_modem_status
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:57 +0100
Message-ID: <20090401140653.22882.17126.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

