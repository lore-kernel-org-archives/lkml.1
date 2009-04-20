Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZDTHNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZDTHNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZDTHNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:13:37 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:63272 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZDTHNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:13:36 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.40,215,1238990400"; 
   d="scan'208";a="86550166"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] bfin_5xx: misplaced parentheses
Date: Mon, 20 Apr 2009 15:13:38 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03E77D30@chinexm1.ad.analog.com>
In-Reply-To: <49E7951E.5020408@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] bfin_5xx: misplaced parentheses
Thread-Index: Acm+0gckKRCUz49iS1+AiEEQCqtmtQCtV39w
References: <49E7951E.5020408@gmail.com>
To: "Roel Kluin" <roel.kluin@gmail.com>
CC: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Apr 2009 07:13:13.0501 (UTC) FILETIME=[78037CD0:01C9C187]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Sonic Zhang <sonic.zhang@analog.com>


Sonic 

-----Original Message-----
From: Roel Kluin [mailto:roel.kluin@gmail.com] 
Sent: Friday, April 17, 2009 4:29 AM
To: Zhang, Sonic
Cc: Andrew Morton; lkml
Subject: [PATCH] bfin_5xx: misplaced parentheses

`!' has a higher precedence than `&', parentheses are misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c index
18ba812..d86123e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -166,7 +166,7 @@ static void bfin_serial_start_tx(struct uart_port
*port)
 	struct tty_struct *tty = uart->port.info->port.tty;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts &&
(!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) &
TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -368,7 +368,7 @@ static irqreturn_t bfin_serial_tx_int(int irq, void
*dev_id)
 	struct bfin_serial_port *uart = dev_id;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts &&
(!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) &
TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -504,7 +504,7 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq,
void *dev_id)
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts &&
(!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts &&
!(bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
