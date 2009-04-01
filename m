Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbZDAOIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbZDAOIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765607AbZDAOFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:05:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37760 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765582AbZDAOFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:05:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/24] blackfin: Subtract ANOMALY_05000230 on quot
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:05:43 +0100
Message-ID: <20090401140540.22882.20789.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

