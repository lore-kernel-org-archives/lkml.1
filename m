Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXHRJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXHRJlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXHRJku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:40:50 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:53405 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbXHRJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:40:49 -0400
Message-id: <20575257251065227509@wsc.cz>
In-reply-to: <737828602404912540@wsc.cz>
Subject: [PATCH 5/9] amba-pl011, rename BIT macro
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 18 Aug 2007 11:42:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

amba-pl011, rename BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 4e7c777ee287082c3185d50a5dab813f562f70de
tree 6f3888ad93bef885d9b9e7641a25e0d1ab16b19e
parent 0d66c4337fec02f0b9bd1c1fd783b60fbab5438b
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:48:05 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 15 Aug 2007 14:32:50 +0200

 drivers/serial/amba-pl011.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index b6dd38d..12c829a 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -263,15 +263,15 @@ static unsigned int pl01x_get_mctrl(struct uart_port *port)
 	unsigned int result = 0;
 	unsigned int status = readw(uap->port.membase + UART01x_FR);
 
-#define BIT(uartbit, tiocmbit)		\
+#define TIOCMBIT(uartbit, tiocmbit)	\
 	if (status & uartbit)		\
 		result |= tiocmbit
 
-	BIT(UART01x_FR_DCD, TIOCM_CAR);
-	BIT(UART01x_FR_DSR, TIOCM_DSR);
-	BIT(UART01x_FR_CTS, TIOCM_CTS);
-	BIT(UART011_FR_RI, TIOCM_RNG);
-#undef BIT
+	TIOCMBIT(UART01x_FR_DCD, TIOCM_CAR);
+	TIOCMBIT(UART01x_FR_DSR, TIOCM_DSR);
+	TIOCMBIT(UART01x_FR_CTS, TIOCM_CTS);
+	TIOCMBIT(UART011_FR_RI, TIOCM_RNG);
+#undef TIOCMBIT
 	return result;
 }
 
@@ -282,18 +282,18 @@ static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	cr = readw(uap->port.membase + UART011_CR);
 
-#define	BIT(tiocmbit, uartbit)		\
+#define	TIOCMBIT(tiocmbit, uartbit)		\
 	if (mctrl & tiocmbit)		\
 		cr |= uartbit;		\
 	else				\
 		cr &= ~uartbit
 
-	BIT(TIOCM_RTS, UART011_CR_RTS);
-	BIT(TIOCM_DTR, UART011_CR_DTR);
-	BIT(TIOCM_OUT1, UART011_CR_OUT1);
-	BIT(TIOCM_OUT2, UART011_CR_OUT2);
-	BIT(TIOCM_LOOP, UART011_CR_LBE);
-#undef BIT
+	TIOCMBIT(TIOCM_RTS, UART011_CR_RTS);
+	TIOCMBIT(TIOCM_DTR, UART011_CR_DTR);
+	TIOCMBIT(TIOCM_OUT1, UART011_CR_OUT1);
+	TIOCMBIT(TIOCM_OUT2, UART011_CR_OUT2);
+	TIOCMBIT(TIOCM_LOOP, UART011_CR_LBE);
+#undef TIOCMBIT
 
 	writew(cr, uap->port.membase + UART011_CR);
 }
