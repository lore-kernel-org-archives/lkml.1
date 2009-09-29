Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZI2SRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZI2SRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZI2SRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:17:00 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55961 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbZI2SQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:16:58 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com
Subject: [PATCH 2/5] jsm: removing ch_old_baud field
Date: Tue, 29 Sep 2009 15:16:56 -0300
Message-Id: <116256e6da08aa022f03bc17f60d1570990a4c15.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the field jsm_channel->ch_old_baud is not used, just
assigned in a lot of places but never used. This patches removes
this field.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h     |    2 --
 drivers/serial/jsm/jsm_neo.c |    2 --
 drivers/serial/jsm/jsm_tty.c |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index afcbee2..d413e4a 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -215,8 +215,6 @@ struct jsm_channel {
 	u8		ch_stopc;	/* Stop character		*/
 	u8		ch_startc;	/* Start character		*/
 
-	u32		ch_old_baud;	/* Cache of the current baud */
-
 	u32		ch_wopen;	/* Waiting for open process cnt */
 
 	u8		ch_mostat;	/* FEP output modem status	*/
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index 088e702..bee3727 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -954,7 +954,6 @@ static void neo_param(struct jsm_channel *ch)
 		ch->ch_flags |= (CH_BAUD0);
 		ch->ch_mostat &= ~(UART_MCR_RTS | UART_MCR_DTR);
 		neo_assert_modem_signals(ch);
-		ch->ch_old_baud = 0;
 		return;
 
 	} else {
@@ -1041,7 +1040,6 @@ static void neo_param(struct jsm_channel *ch)
 	quot = ch->ch_bd->bd_dividend / baud;
 
 	if (quot != 0) {
-		ch->ch_old_baud = baud;
 		writeb(UART_LCR_DLAB, &ch->ch_neo_uart->lcr);
 		writeb((quot & 0xff), &ch->ch_neo_uart->txrx);
 		writeb((quot >> 8), &ch->ch_neo_uart->ier);
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 6423dfb..1bcad59 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -296,8 +296,6 @@ static void jsm_tty_close(struct uart_port *port)
 		bd->bd_ops->assert_modem_signals(channel);
 	}
 
-	channel->ch_old_baud = 0;
-
 	/* Turn off UART interrupts for this port */
 	channel->ch_bd->bd_ops->uart_off(channel);
 
-- 
1.6.0.4

