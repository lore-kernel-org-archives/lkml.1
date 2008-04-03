Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYDCIjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYDCIjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYDCIjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:39:10 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:24603 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754732AbYDCIjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:39:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=aGThR4BUdh6pnb295Wfy1irlTNc0/P0yAlIhwGDCgo/58JLxfcYTRHVMcouMhvVELnBXP4n61YkU8iigV5FvOK8W/dMWoZgw/bWiWCZvG9dA6x1GxBQHFFc57T2b3SOrrikR0vd6VYIdJqMZ1i2gQcMozPqiAaW3gro2qxFLlew=;
X-YMail-OSG: NWm8OHoVM1kGoOTn42XJxQTtveWinzRw93NDJCX5JWW3jvRc7SB5pEsO62n3p9xHE0sPW3EFBWGcZckh7mTpgR94SJTZb3bSxZRQwKZbSuhPKDvFkXxbgZWXG.A-
Date: Thu, 3 Apr 2008 10:39:06 +0200 (CEST)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: [PATCH] atmel serial reduce trasmitting window & code style patch
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1240872090-1207211946=:25009"
Content-Transfer-Encoding: 8bit
Message-ID: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1240872090-1207211946=:25009
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Hi,

two more patches for atmel serial driver.

Regards 
Michael



      Inviato da Yahoo! Mail. 
La casella di posta intelligente.
http://it.docs.yahoo.com/mail/overview/index.html
--0-1240872090-1207211946=:25009
Content-Type: text/x-patch; name="coding-style-cleanup.patch"
Content-Description: 3607956876-coding-style-cleanup.patch
Content-Disposition: inline; filename="coding-style-cleanup.patch"

Coding style clean-up patch.

Signed-off-by: michael <trimarchi@gandalf.sssup.it>

---
 drivers/serial/atmel_serial.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index d57bf3e..9f58eb3 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -122,7 +122,7 @@ struct atmel_uart_char {
 	u16		ch;
 };
 
-#define ATMEL_SERIAL_RINGSIZE 1024
+#define ATMEL_SERIAL_RINGSIZE	1024
 
 /*
  * We wrap our port structure around the generic uart_port.
@@ -394,8 +394,8 @@ static void atmel_rx_chars(struct uart_port *port)
 			/* clear error */
 			UART_PUT_CR(port, ATMEL_US_RSTSTA);
 
-			if (status & ATMEL_US_RXBRK
-			    && !atmel_port->break_active) {
+			if (status & ATMEL_US_RXBRK &&
+			    !atmel_port->break_active) {
 				atmel_port->break_active = 1;
 				UART_PUT_IER(port, ATMEL_US_RXBRK);
 			} else {
@@ -1394,8 +1394,8 @@ console_initcall(atmel_console_init);
  */
 static int __init atmel_late_console_init(void)
 {
-	if (atmel_default_console_device
-	    && !(atmel_console.flags & CON_ENABLED))
+	if (atmel_default_console_device &&
+	    !(atmel_console.flags & CON_ENABLED))
 		register_console(&atmel_console);
 
 	return 0;
@@ -1434,8 +1434,8 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (device_may_wakeup(&pdev->dev)
-	    && !at91_suspend_entering_slow_clock())
+	if (device_may_wakeup(&pdev->dev) &&
+	    !at91_suspend_entering_slow_clock())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
-- 
1.5.2.1.174.gcd03-dirty


--0-1240872090-1207211946=:25009
Content-Type: text/x-patch; name="atmel-interrupt-tx-chars-fix.patch"
Content-Description: 3362687731-atmel-interrupt-tx-chars-fix.patch
Content-Disposition: inline; filename="atmel-interrupt-tx-chars-fix.patch"

Reduce the trasmitting window size to avoid blocking of tasklet because 
it must handle the receive phase too.

Signed-off-by: michael <trimarchi@gandalf.sssup.it>

---
 drivers/serial/atmel_serial.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 9f58eb3..511a0cc 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -123,6 +123,7 @@ struct atmel_uart_char {
 };
 
 #define ATMEL_SERIAL_RINGSIZE	1024
+#define ATMEL_SERIAL_TXSIZE	32
 
 /*
  * We wrap our port structure around the generic uart_port.
@@ -426,6 +427,7 @@ static void atmel_rx_chars(struct uart_port *port)
 static void atmel_tx_chars(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->info->xmit;
+	int count = 0;
 
 	if (port->x_char && UART_GET_CSR(port) & ATMEL_US_TXRDY) {
 		UART_PUT_CHAR(port, port->x_char);
@@ -435,10 +437,12 @@ static void atmel_tx_chars(struct uart_port *port)
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return;
 
-	while (UART_GET_CSR(port) & ATMEL_US_TXRDY) {
+	while (UART_GET_CSR(port) & ATMEL_US_TXRDY &&
+	       count < ATMEL_SERIAL_TXSIZE) {
 		UART_PUT_CHAR(port, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
+		count++;
 		if (uart_circ_empty(xmit))
 			break;
 	}
-- 
1.5.2.1.174.gcd03-dirty


--0-1240872090-1207211946=:25009--
