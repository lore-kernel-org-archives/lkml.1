Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZISVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZISVnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZISVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:15 -0400
Received: from kroah.org ([198.145.64.141]:40519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZISVnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 56/79] serial: introduce tty krefs
Date: Sat, 19 Sep 2009 14:37:01 -0700
Message-Id: <1253396244-7885-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Initially just use the helper and thus krefs when we set and clear the
port values.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/serial/serial_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 69c4e20..3fd0134 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1333,7 +1333,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	port->tty = NULL;
+	tty_port_tty_set(port, NULL);
 
 	if (port->blocked_open) {
 		if (port->close_delay)
@@ -1431,7 +1431,7 @@ static void uart_hangup(struct tty_struct *tty)
 		uart_shutdown(state);
 		port->count = 0;
 		clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
-		port->tty = NULL;
+		tty_port_tty_set(port, NULL);
 		wake_up_interruptible(&port->open_wait);
 		wake_up_interruptible(&port->delta_msr_wait);
 	}
@@ -1639,7 +1639,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	state->uart_port->state = state;
 	tty->low_latency = (state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 	tty->alt_speed = 0;
-	port->tty = tty;
+	tty_port_tty_set(port, tty);
 
 	/*
 	 * If the port is in the middle of closing, bail out now.
-- 
1.6.4.2

