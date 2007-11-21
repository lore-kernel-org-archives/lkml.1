Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXKULeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXKULeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXKULeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:34:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbXKULeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:34:09 -0500
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, drzeus-mmc@drzeus.cx, nico@cam.org,
       Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] sdio_uart: fix sign of paramter status in sdio_uart_receive_chars()
Date: Wed, 21 Nov 2007 12:33:45 +0100
Message-Id: <11956448251191-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: n
References: n
X-Provags-ID: V01U2FsdGVkX18iCmhP+aHckBtVjUhjyIbqigKQcsPBIkruluM
 KFVGBEyOXS6xfKGWNWf2OE9gQ7dV8IpUIbUs2GqwXxS5FhNoJh
 TBg5l8IkwVmBT6ms72I2/7nxl2csEiPIRqh0HWJtLQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think, the status paramter should be unsigned. Is this correct?
This also fixes a sparse warning about different signedness.
Only compile tested, because i do not have the hardware.

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/mmc/card/sdio_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index d552de6..eeea84c 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -386,7 +386,7 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
 	sdio_out(port, UART_IER, port->ier);
 }
 
-static void sdio_uart_receive_chars(struct sdio_uart_port *port, int *status)
+static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *status)
 {
 	struct tty_struct *tty = port->tty;
 	unsigned int ch, flag;
-- 
1.4.4.4

