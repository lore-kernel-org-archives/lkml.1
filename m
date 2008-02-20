Return-Path: <linux-kernel-owner+w=401wt.eu-S1765418AbYBTPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765418AbYBTPyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYBTPyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:54:14 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:58065 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYBTPyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:54:13 -0500
Date: Thu, 21 Feb 2008 00:54:32 +0900 (JST)
Message-Id: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] atmel_spi: support zero length transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A spi transfer with zero length is not invalid.  Such transfer can be
used to achieve delay before first CLK edge after chipselect assertion.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 293b7ca..5dff5e0 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -606,7 +606,7 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 		return -ESHUTDOWN;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		if (!(xfer->tx_buf || xfer->rx_buf)) {
+		if (!(xfer->tx_buf || xfer->rx_buf) && xfer->len) {
 			dev_dbg(&spi->dev, "missing rx or tx buf\n");
 			return -EINVAL;
 		}
