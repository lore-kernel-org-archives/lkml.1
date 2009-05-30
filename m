Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbZE3QjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbZE3QjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 12:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbZE3QjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 12:39:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbZE3QjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 12:39:10 -0400
Date: Sat, 30 May 2009 18:39:07 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: fix spi_write_then_read() comment
Message-ID: <20090530163906.GB3427@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] spi: fix spi_write_then_read() comment

Spotted a tiny mislead. I guess buffer need not be dma-safe, not rx data length.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8eba98c..85a46c7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -636,8 +636,8 @@ static u8	*buf;
  * @spi: device with which data will be exchanged
  * @txbuf: data to be written (need not be dma-safe)
  * @n_tx: size of txbuf, in bytes
- * @rxbuf: buffer into which data will be read
- * @n_rx: size of rxbuf, in bytes (need not be dma-safe)
+ * @rxbuf: buffer into which data will be read (need not be dma-safe)
+ * @n_rx: size of rxbuf, in bytes
  * Context: can sleep
  *
  * This performs a half duplex MicroWire style transaction with the
