Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYA3Jd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYA3Jd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYA3Jab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:31 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:53984 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbYA3JaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:18 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624086"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 06/12] [Blackfin] serial driver: fix bug - should not wait for the TFI bit, just clear it when tx stop.
Date: Wed, 30 Jan 2008 17:30:06 +0800
Message-Id: <1201685412-29095-7-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 0074146..ca9ceaa 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -95,9 +95,6 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 	disable_dma(uart->tx_dma_channel);
 #else
 #ifdef CONFIG_BF54x
-	/* Waiting for Transmission Finished */
-	while (!(UART_GET_LSR(uart) & TFI))
-		continue;
 	/* Clear TFI bit */
 	UART_PUT_LSR(uart, TFI);
 	UART_CLEAR_IER(uart, ETBEI);
-- 
1.5.3.4
