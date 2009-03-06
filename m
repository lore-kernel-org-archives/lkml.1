Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZCFGnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZCFGnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZCFGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:00 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:39798 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZCFGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:56 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883652"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 08/18] Blackfin Serial Driver: use "unsigned long" for flags with irq functions rather than "int"
Date: Fri,  6 Mar 2009 14:42:50 +0800
Message-Id: <1236321780-28718-9-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index de8709d..2eab47e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -403,7 +403,8 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
-	int x_pos, pos, flags;
+	int x_pos, pos;
+	unsigned long flags;
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 
@@ -1151,7 +1152,7 @@ static void
 bfin_serial_console_write(struct console *co, const char *s, unsigned int count)
 {
 	struct bfin_serial_port *uart = &bfin_serial_ports[co->index];
-	int flags = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 	uart_console_write(&uart->port, s, count, bfin_serial_console_putchar);
-- 
1.5.6.3
