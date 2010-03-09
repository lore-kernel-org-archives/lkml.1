Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0CIRXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:23:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54709 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0CIRWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 09/13] serial: bfin_sport_uart: drop useless status masks
Date: Tue,  9 Mar 2010 12:25:36 -0500
Message-Id: <1268155540-8241-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were all copied over from the Blackfin UART driver, but they don't
make sense here because these bits are all specific to the Blackfin UART.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 871f6fd..1b22c59 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -499,27 +499,12 @@ static void sport_set_termios(struct uart_port *port,
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-	port->read_status_mask = OE;
-	if (termios->c_iflag & INPCK)
-		port->read_status_mask |= (FE | PE);
-	if (termios->c_iflag & (BRKINT | PARMRK))
-		port->read_status_mask |= BI;
+	port->read_status_mask = 0;
 
 	/*
 	 * Characters to ignore
 	 */
 	port->ignore_status_mask = 0;
-	if (termios->c_iflag & IGNPAR)
-		port->ignore_status_mask |= FE | PE;
-	if (termios->c_iflag & IGNBRK) {
-		port->ignore_status_mask |= BI;
-		/*
-		 * If we're ignoring parity and break indicators,
-		 * ignore overruns too (for real raw support).
-		 */
-		if (termios->c_iflag & IGNPAR)
-			port->ignore_status_mask |= OE;
-	}
 
 	/* RX extract mask */
 	up->rxmask = 0x01 | (((up->csize + up->stopb) * 2 - 1) << 0x8);
-- 
1.7.0.2

