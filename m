Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbZFBHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbZFBHN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbZFBHLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46630 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996AbZFBHLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 07/11] Blackfin Serial Driver: fix missing new lines when under load
Date: Tue,  2 Jun 2009 03:11:36 -0400
Message-Id: <1243926700-30485-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Add a SSYNC() into bfin_serial_dma_tx_chars() to ensure DMA registers are
written with new data otherwise we might miss a byte or two when the
system is under load.  PIO mode is OK though.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index dfae22d..676efda 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -415,6 +415,7 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 	set_dma_start_addr(uart->tx_dma_channel, (unsigned long)(xmit->buf+xmit->tail));
 	set_dma_x_count(uart->tx_dma_channel, uart->tx_count);
 	set_dma_x_modify(uart->tx_dma_channel, 1);
+	SSYNC();
 	enable_dma(uart->tx_dma_channel);
 
 	UART_SET_IER(uart, ETBEI);
-- 
1.6.3.1

