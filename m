Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbZLKXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbZLKXhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbZLKX24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:56 -0500
Received: from kroah.org ([198.145.64.141]:50416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbZLKX2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <scottk@digi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/58] jsm: removing ch_old_baud field
Date: Fri, 11 Dec 2009 15:27:48 -0800
Message-Id: <1260574122-10676-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently the field jsm_channel->ch_old_baud is not used, just
assigned in a lot of places but never used. This patches removes
this field.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

