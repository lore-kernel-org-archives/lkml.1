Return-Path: <linux-kernel-owner+w=401wt.eu-S1760058AbYJMJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbYJMJfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbYJMJdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:33:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56127 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758186AbYJMJdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:33:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/80] Blackfin Serial Driver: Fix bug - Don't call tx_stop in
	tx_transfer.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:33:33 +0100
Message-ID: <20081013093330.21645.67253.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Disable irq and return immediately.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 8d2d757..5e20f50 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -301,7 +301,11 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 	bfin_serial_mctrl_check(uart);
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
-		bfin_serial_stop_tx(&uart->port);
+#ifdef CONFIG_BF54x
+		/* Clear TFI bit */
+		UART_PUT_LSR(uart, TFI);
+#endif
+		UART_CLEAR_IER(uart, ETBEI);
 		return;
 	}
 

