Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbZLKXgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbZLKXgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934929AbZLKXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:15 -0500
Received: from kroah.org ([198.145.64.141]:50472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934241AbZLKX3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/58] tty: sdio_uart: Fix termios handling
Date: Fri, 11 Dec 2009 15:28:15 -0800
Message-Id: <1260574122-10676-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Switching between two non standard baud rates fails because of the cflag
test. Do as we did elsewhere and just kill the "optimisation".

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 95027b0..2104397 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -902,12 +902,6 @@ static void sdio_uart_set_termios(struct tty_struct *tty, struct ktermios *old_t
 	struct sdio_uart_port *port = tty->driver_data;
 	unsigned int cflag = tty->termios->c_cflag;
 
-#define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
-	if ((cflag ^ old_termios->c_cflag) == 0 &&
-	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
-		return;
-
 	if (sdio_uart_claim_func(port) != 0)
 		return;
 
-- 
1.6.5.5

