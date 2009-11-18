Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZKROgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZKROgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbZKROge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:36:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35741 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757442AbZKROgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:36:32 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/11] sdio_uart: Fix termios handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:20:07 +0000
Message-ID: <20091118142003.3582.40033.stgit@localhost.localdomain>
In-Reply-To: <20091118141802.3582.47363.stgit@localhost.localdomain>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching between two non standard baud rates fails because of the cflag
test. Do as we did elsewhere and just kill the "optimisation".

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 1be90bc..ffa56cb 100644
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
 

