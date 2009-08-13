Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZHMKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZHMKCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZHMKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:02:27 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:45532 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754099AbZHMKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:01:51 -0400
Message-Id: <20090813100638.583297488@fluff.org>
References: <20090813100602.545180197@fluff.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:06:05 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.ne
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 3/7] spi_s3c24xx; Fix transfer setup code
Content-Disposition: inline; filename=spi-fix-bitperword.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the changes to the bitbang driver, there is the possibility we
will be called with either the speed_hz or bpw values zero. We take
these to mean that the default values (8 bits per word, or maximum
bus speed).

Signed-off-by: Ben Dooks <ben@simtec.co.uk>

---

Index: b/drivers/spi/spi_s3c24xx.c
===================================================================
--- a/drivers/spi/spi_s3c24xx.c	2009-07-27 18:55:16.000000000 +0100
+++ b/drivers/spi/spi_s3c24xx.c	2009-07-27 18:56:08.000000000 +0100
@@ -116,6 +116,12 @@ static int s3c24xx_spi_setupxfer(struct 
 	bpw = t ? t->bits_per_word : spi->bits_per_word;
 	hz  = t ? t->speed_hz : spi->max_speed_hz;
 
+	if (!bpw)
+		bpw = 8;
+
+	if (!hz)
+		hz = spi->max_speed_hz;
+
 	if (bpw != 8) {
 		dev_err(&spi->dev, "invalid bits-per-word (%d)\n", bpw);
 		return -EINVAL;

-- 
