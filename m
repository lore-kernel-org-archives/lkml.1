Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZCXOI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZCXOI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbZCXODf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:03:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48956 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758264AbZCXODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:03:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/30] Fix DMA rx ring buffer handling
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:03:57 +0000
Message-ID: <20090324140352.12735.70438.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Reported-by: Qian Zhang <zhangq@sansitech.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/bfin_5xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 1e08e36..371a62f 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -401,9 +401,11 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 	else
 		flg = TTY_NORMAL;
 
-	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
+	for (i = uart->rx_dma_buf.tail; ; i++) {
 		if (i >= UART_XMIT_SIZE)
 			i = 0;
+		if (i == uart->rx_dma_buf.head)
+			break;
 		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
 			uart_insert_char(&uart->port, status, OE,
 				uart->rx_dma_buf.buf[i], flg);

