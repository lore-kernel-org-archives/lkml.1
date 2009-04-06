Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbZDFPgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbZDFPgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbZDFPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:34:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56970 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756209AbZDFPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:34:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/27] blackfin: Subtract ANOMALY_05000230 on quot
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:32:49 +0100
Message-ID: <20090406163248.12934.12234.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Fix bug - up arrow key works abnormal for bf561 ezkit board

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/bfin_5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 12b11da..f9b5a72 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -760,7 +760,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
-	quot = uart_get_divisor(port, baud);
+	quot = uart_get_divisor(port, baud) - ANOMALY_05000230;
 	spin_lock_irqsave(&uart->port.lock, flags);
 
 	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);

