Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZDPU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZDPU33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZDPU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:29:19 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:46813 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZDPU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BKvNTPVloBaRoXU6eSDFRVQeqs5XSo09cS7l3yeBbzyHITUY97jSW0kYd3r3dRYhz/
         e3dVnoIW71mjexFCi/OHYh0gRPCZMTqjJEjROZAdvVjEaziAZX16OAuSaLaid9mZscba
         lQhhofvB9RXDfduV5mRHl8OnGnfoFQPkqBWF4=
Message-ID: <49E7951E.5020408@gmail.com>
Date: Thu, 16 Apr 2009 22:29:18 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: sonic.zhang@analog.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] bfin_5xx: misplaced parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`!' has a higher precedence than `&', parentheses are misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 18ba812..d86123e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -166,7 +166,7 @@ static void bfin_serial_start_tx(struct uart_port *port)
 	struct tty_struct *tty = uart->port.info->port.tty;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) & TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -368,7 +368,7 @@ static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 	struct bfin_serial_port *uart = dev_id;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port) & TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
@@ -504,7 +504,7 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->scts && (!bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
+	if (uart->scts && !(bfin_serial_get_mctrl(&uart->port)&TIOCM_CTS)) {
 		uart->scts = 0;
 		uart_handle_cts_change(&uart->port, uart->scts);
 	}
