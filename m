Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZLASC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZLASC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZLASC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:02:28 -0500
Received: from kroah.org ([198.145.64.141]:52005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbZLASC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:02:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Maxime Bizon <mbizon@freebox.fr>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] bcm63xx_uart: Fix serial driver compile breakage.
Date: Tue,  1 Dec 2009 09:59:05 -0800
Message-Id: <1259690346-12469-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091201174341.GB31972@kroah.com>
References: <20091201174341.GB31972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

The driver missed a small API change while sitting in Ralf's tree, this
patch makes it compile again.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bcm63xx_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bcm63xx_uart.c b/drivers/serial/bcm63xx_uart.c
index beddaa6..37ad0c4 100644
--- a/drivers/serial/bcm63xx_uart.c
+++ b/drivers/serial/bcm63xx_uart.c
@@ -242,7 +242,7 @@ static void bcm_uart_do_rx(struct uart_port *port)
 	 * higher than fifo size anyway since we're much faster than
 	 * serial port */
 	max_count = 32;
-	tty = port->info->port.tty;
+	tty = port->state->port.tty;
 	do {
 		unsigned int iestat, c, cstat;
 		char flag;
@@ -318,7 +318,7 @@ static void bcm_uart_do_tx(struct uart_port *port)
 		return;
 	}
 
-	xmit = &port->info->xmit;
+	xmit = &port->state->xmit;
 	if (uart_circ_empty(xmit))
 		goto txq_empty;
 
-- 
1.6.4.2

