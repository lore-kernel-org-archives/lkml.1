Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZDAOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZDAOIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765658AbZDAOFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:05:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37763 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764884AbZDAOFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:05:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/24] Fix DMA rx ring buffer handling
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:05:35 +0100
Message-ID: <20090401140533.22882.78400.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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
index d7b2716..12b11da 100644
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

