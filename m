Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZCFGpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZCFGpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZCFGlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:06 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:39798 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZCFGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:57 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883659"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 14/18] Blackfin Serial Driver: use the DLAB macro to hide variant differences
Date: Fri,  6 Mar 2009 14:42:56 +0800
Message-Id: <1236321780-28718-15-git-send-email-cooloney@kernel.org>
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
 drivers/serial/bfin_5xx.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index b89861d..71a9e6b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1250,7 +1250,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
 void bfin_serial_debug(const char *fmt, ...)
 {
 	struct bfin_serial_port *uart = &bfin_serial_ports[0];
-	unsigned short status, tmp;
+	unsigned short status;
 	unsigned long flags;
 	int i, count;
 	char buf[128];
@@ -1273,11 +1273,7 @@ void bfin_serial_debug(const char *fmt, ...)
 			status = UART_GET_LSR(uart);
 		} while (!(status & THRE));
 
-#ifndef CONFIG_BF54x
-		tmp = UART_GET_LCR(uart);
-		tmp &= ~DLAB;
-		UART_PUT_LCR(uart, tmp);
-#endif
+		UART_CLEAR_DLAB(uart);
 		UART_PUT_CHAR(uart, buf[i]);
 		if (buf[i] == '\n') {
 			do {
-- 
1.5.6.3
