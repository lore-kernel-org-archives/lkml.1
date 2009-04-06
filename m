Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZDFPdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZDFPdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDFPc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:32:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56937 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbZDFPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:32:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/27] blackfin: Use unsigned long for flags with irq functions
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:32:28 +0100
Message-ID: <20090406163227.12934.77478.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/bfin_5xx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 318d69d..45c32b2 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -415,7 +415,8 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
-	int x_pos, pos, flags;
+	int x_pos, pos;
+	unsigned long flags;
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 
@@ -1088,7 +1089,7 @@ static void
 bfin_serial_console_write(struct console *co, const char *s, unsigned int count)
 {
 	struct bfin_serial_port *uart = &bfin_serial_ports[co->index];
-	int flags = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 	uart_console_write(&uart->port, s, count, bfin_serial_console_putchar);

