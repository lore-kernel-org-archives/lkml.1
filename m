Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbXE1Ik4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbXE1Ik4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760787AbXE1Igs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22622 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798AbXE1Igg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:36 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300056:sNHT25987451"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 16/20] Blackfin serial driver: ignore framing and parity errors
Date: Mon, 28 May 2007 16:37:51 +0800
Message-Id: <11803414802800-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

if we get a break signal, we want to ignore framing and parity errors
because those will always be set (by nature of the signal)

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index aeb3cc2..9d356fc 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -185,6 +185,7 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto ignore_char;
+		status &= ~(PE | FE);
 	}
 	if (status & PE)
 		uart->port.icount.parity++;
@@ -341,6 +342,7 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto dma_ignore_char;
+		status &= ~(PE | FE);
 	}
 	if (status & PE)
 		uart->port.icount.parity++;
-- 
1.5.2
