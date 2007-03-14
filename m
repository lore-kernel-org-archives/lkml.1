Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXCNQHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXCNQHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbXCNQHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:07:32 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:52102 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbXCNQHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:07:31 -0400
Date: Thu, 15 Mar 2007 01:07:28 +0900 (JST)
Message-Id: <20070315.010728.70475304.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net
Subject: [PATCH] SPI: at25: do not use pointer before assignment
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/spi/at25.c b/drivers/spi/at25.c
index 48e4f48..8efa07e 100644
--- a/drivers/spi/at25.c
+++ b/drivers/spi/at25.c
@@ -291,7 +291,7 @@ static int at25_probe(struct spi_device
 	 */
 	sr = spi_w8r8(spi, AT25_RDSR);
 	if (sr < 0 || sr & AT25_SR_nRDY) {
-		dev_dbg(&at25->spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
+		dev_dbg(&spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
 		err = -ENXIO;
 		goto fail;
 	}
