Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbYCFCcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbYCFCcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbYCFCZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:63689 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbYCFCZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SAC0VswvDGkGnJPPSnVcEkMq/mAWIdBjKTd/H7jrN0hDv4VMdy9zGp2SjjJGemTlk/A4gvv3Jxj7m96dsvmpkWosFTPqYSl8RgyJ9utTXKEVzX2NzJZ7REudwM6teBDXal3b+cEAepyvKCht2alwdWO9w4Sr2i89wJwBv1gPqpM=
Subject: [PATCH 14/16] spi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:58 -0800
Message-Id: <1204770298.14154.50.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/spi/omap_uwire.c  |    4 ++--
 drivers/spi/spi_bitbang.c |    2 +-
 drivers/spi/spi_mpc83xx.c |    2 +-
 drivers/spi/spi_s3c24xx.c |    2 +-
 drivers/spi/xilinx_spi.c  |    8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
index 8245b51..ea18077 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/omap_uwire.c
@@ -151,7 +151,7 @@ static int wait_uwire_csr_flag(u16 mask, u16 val, int might_not_catch)
 		if (time_after(jiffies, max_jiffies)) {
 			printk(KERN_ERR "%s: timeout. reg=%#06x "
 					"mask=%#06x val=%#06x\n",
-			       __FUNCTION__, w, mask, val);
+			       __func__, w, mask, val);
 			return -1;
 		}
 		c++;
@@ -437,7 +437,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	}
 	omap_uwire_configure_mode(spi->chip_select, flags);
 	pr_debug("%s: uwire flags %02x, armxor %lu KHz, SCK %lu KHz\n",
-			__FUNCTION__, flags,
+			__func__, flags,
 			clk_get_rate(uwire->ck) / 1000,
 			rate / 1000);
 	status = 0;
diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
index f7f8580..061e344 100644
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi_bitbang.c
@@ -214,7 +214,7 @@ int spi_bitbang_setup(struct spi_device *spi)
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
-			__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
+			__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
 			spi->bits_per_word, 2 * cs->nsecs);
 
 	/* NOTE we _need_ to call chipselect() early, ideally with adapter
diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index 04f7cd9..df9f0d4 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -310,7 +310,7 @@ static int mpc83xx_spi_setup(struct spi_device *spi)
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec\n",
-		__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
+		__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
 		spi->bits_per_word, 2 * mpc83xx_spi->nsecs);
 
 	/* NOTE we _need_ to call chipselect() early, ideally with adapter
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index 6e834b8..4ad5abb 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -169,7 +169,7 @@ static int s3c24xx_spi_setup(struct spi_device *spi)
 	}
 
 	dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
-		__FUNCTION__, spi->mode, spi->bits_per_word,
+		__func__, spi->mode, spi->bits_per_word,
 		spi->max_speed_hz);
 
 	return 0;
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index 5d04f52..9ba5741 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -151,13 +151,13 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 	hz = (t) ? t->speed_hz : spi->max_speed_hz;
 	if (bits_per_word != 8) {
 		dev_err(&spi->dev, "%s, unsupported bits_per_word=%d\n",
-			__FUNCTION__, bits_per_word);
+			__func__, bits_per_word);
 		return -EINVAL;
 	}
 
 	if (hz && xspi->speed_hz > hz) {
 		dev_err(&spi->dev, "%s, unsupported clock rate %uHz\n",
-			__FUNCTION__, hz);
+			__func__, hz);
 		return -EINVAL;
 	}
 
@@ -181,7 +181,7 @@ static int xilinx_spi_setup(struct spi_device *spi)
 
 	if (spi->mode & ~MODEBITS) {
 		dev_err(&spi->dev, "%s, unsupported mode bits %x\n",
-			__FUNCTION__, spi->mode & ~MODEBITS);
+			__func__, spi->mode & ~MODEBITS);
 		return -EINVAL;
 	}
 
@@ -190,7 +190,7 @@ static int xilinx_spi_setup(struct spi_device *spi)
 		return retval;
 
 	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
-		__FUNCTION__, spi->mode & MODEBITS, spi->bits_per_word, 0);
+		__func__, spi->mode & MODEBITS, spi->bits_per_word, 0);
 
 	return 0;
 }
-- 
1.5.4.GIT


