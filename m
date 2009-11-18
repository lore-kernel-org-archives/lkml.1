Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZKROfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZKROfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZKROfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:35:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35725 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757272AbZKROfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:35:46 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 03/11] sdio_uart: Fix oops caused by the previous changeset
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:19:21 +0000
Message-ID: <20091118141917.3582.94183.stgit@localhost.localdomain>
In-Reply-To: <20091118141802.3582.47363.stgit@localhost.localdomain>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

Now... testing reveals that the very first patch "sdio_uart: use
tty_port" causes a segmentation fault in sdio_uart_open():

Unable to handle kernel NULL pointer dereference at virtual address 00000084
pgd = dfb44000 [00000084] *pgd=1fb99031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
last sysfs file:
/sys/devices/platform/mvsdio/mmc_host/mmc0/mmc0:f111/uevent
Modules linked in:
CPU: 0    Not tainted  (2.6.32-rc5-next-20091102-00001-gb36eae9 #10)
PC is at sdio_uart_open+0x204/0x2cc
[...]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index c2759db..671fe5e 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -608,7 +608,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 		if (!(sdio_uart_get_mctrl(port) & TIOCM_CTS))
 			tty->hw_stopped = 1;
 
-	clear_bit(TTY_IO_ERROR, &port->tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 
 	/* Kick the IRQ handler once while we're still holding the host lock */
 	sdio_uart_irq(port->func);

