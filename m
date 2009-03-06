Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZCFGpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZCFGpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZCFGlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:07 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33492 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZCFGk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:58 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883661"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 16/18] Blackfin Serial Driver: fix bug - up arrow key works abnormal for bf561 ezkit board
Date: Fri,  6 Mar 2009 14:42:58 +0800
Message-Id: <1236321780-28718-17-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Subtrack ANOMALY_05000230 on quot.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 8aa0e37..c037e8e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -789,7 +789,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
-	quot = uart_get_divisor(port, baud);
+	quot = uart_get_divisor(port, baud) - ANOMALY_05000230;
 	spin_lock_irqsave(&uart->port.lock, flags);
 
 	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
-- 
1.5.6.3
