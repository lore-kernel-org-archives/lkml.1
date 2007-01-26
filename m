Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXAZKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXAZKs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXAZKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:48:56 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:47002 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbXAZKsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:48:55 -0500
Date: Fri, 26 Jan 2007 11:48:38 +0100
Message-Id: <200701261048.l0QAmckm032461@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
In-reply-to: <200701250502.56467.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 05:02:56 -0800)
Subject: [PATCH 2/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just some trivial patches to make sure the existing drivers in
the official tree don't *silently* fail with the introduction of
default_tx_word.  Never tested in any way.  Not sure if this is
all, for example I didn't look in arch/*.

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -upr a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c	2007-01-26 10:38:49.000000000 +0100
+++ b/drivers/spi/pxa2xx_spi.c	2007-01-26 11:17:49.000000000 +0100
@@ -1077,6 +1077,9 @@ static int setup(struct spi_device *spi)
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 
+	if (spi->default_tx_word != 0)
+		return -EINVAL;
+
 	if (drv_data->ssp_type != PXA25x_SSP
 		&& (spi->bits_per_word < 4 || spi->bits_per_word > 32)) {
 		dev_err(&spi->dev, "failed setup: ssp_type=%d, bits/wrd=%d "
diff -upr a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c	2007-01-26 10:38:49.000000000 +0100
+++ b/drivers/spi/spi_mpc83xx.c	2007-01-26 11:19:01.553401939 +0100
@@ -238,6 +238,9 @@ static int mpc83xx_spi_setup(struct spi_
 	struct mpc83xx_spi *mpc83xx_spi;
 	int retval;
 
+	if (spi->default_tx_word != 0)
+		return -EINVAL;
+
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
diff -upr a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c	2007-01-26 10:38:49.000000000 +0100
+++ b/drivers/spi/spi_s3c24xx.c	2007-01-26 11:19:19.014017640 +0100
@@ -153,6 +153,9 @@ static int s3c24xx_spi_setup(struct spi_
 {
 	int ret;
 
+	if (spi->default_tx_word != 0)
+		return -EINVAL;
+
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 

brgds, H-P
