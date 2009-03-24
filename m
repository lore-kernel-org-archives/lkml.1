Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZCXOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZCXOIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZCXODM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:03:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48950 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756831AbZCXODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:03:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/30] blackfin: Use unsigned long for flags with irq functions
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:03:35 +0000
Message-ID: <20090324140328.12735.74039.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
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
index c7c0c1b..6bd9016 100644
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

