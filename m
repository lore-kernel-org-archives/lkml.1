Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYLJDCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYLJDCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 22:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYLJDCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 22:02:45 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:39837 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYLJDCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 22:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent:from;
        b=bgk8L5Q3DVLL79VAmYqiWLs+SpZo8eor5iqvG3sE8IGNAnn91qMmr7RWA1pK2D5yNW
         uMYrHRs52TyCr1gneqOgm0p2sGAT+aBNvSQU2aagyQgem8DmQoiY1f0GqcwNz4lOeMj5
         G5649oVvH4jGCbvqWDFg3g1jhEUKTKioUKKgY=
Date: Wed, 10 Dec 2008 11:01:51 +0800
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH] rewrite the return method of static int
	s3c24xx_spi_setup(struct spi_device *spi) in
	drivers/spi/spi_s3c24xx.c 
Message-ID: <20081210030151.GA6404@helight>
Reply-To: "Helight.Xu" <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "Helight.Xu" <zhwenxu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

rewrite the return method of static int 
s3c24xx_spi_setup(struct spi_device *spi) 
in drivers/spi/spi_s3c24xx.c 

reason:
s3c24xx_spi_setupxfer(spi, NULL) return 0 or -EINVAL, 
so here shoud return the ret,but only 0.

here:
 drivers/spi/spi_s3c24xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index 3eb414b..0489254 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -165,14 +165,14 @@ static int s3c24xx_spi_setup(struct spi_device *spi)
        ret = s3c24xx_spi_setupxfer(spi, NULL);
        if (ret < 0) {
                dev_err(&spi->dev, "setupxfer returned %d\n", ret);
-               return ret;
+               goto err;
        }
 
        dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
                __func__, spi->mode, spi->bits_per_word,
                spi->max_speed_hz);
-                                                                                        
-       return 0;
+err:
+       return ret;
 }
 
 static inline unsigned int hw_txbyte(struct s3c24xx_spi *hw, int count)

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

--VS++wcV0S1rZb1Fb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-rewrite-the-return-method-of-static-int-s3c24xx_spi_setup.patch"

>From a99ab2a4a87f330125ed6263c16b4036d4991b89 Mon Sep 17 00:00:00 2001
From: Zhwen Xu <Helight.Xu@gmail.com>
Date: Wed, 10 Dec 2008 10:38:36 +0800
Subject: [PATCH] rewrite the return method of static int s3c24xx_spi_setup(struct spi_device *spi) in drivers/spi/spi_s3c24xx.c


Signed-off-by: ZhenwenXu <helight.xu@gmail.com> 
---
 drivers/spi/spi_s3c24xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index 3eb414b..0489254 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -165,14 +165,14 @@ static int s3c24xx_spi_setup(struct spi_device *spi)
 	ret = s3c24xx_spi_setupxfer(spi, NULL);
 	if (ret < 0) {
 		dev_err(&spi->dev, "setupxfer returned %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
 		__func__, spi->mode, spi->bits_per_word,
 		spi->max_speed_hz);
-
-	return 0;
+err:
+	return ret;
 }
 
 static inline unsigned int hw_txbyte(struct s3c24xx_spi *hw, int count)
-- 
1.5.6.5


--VS++wcV0S1rZb1Fb--
