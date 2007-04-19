Return-Path: <linux-kernel-owner+w=401wt.eu-S1031094AbXDSEDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031094AbXDSEDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031102AbXDSEDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:03:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28036 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031094AbXDSEDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CiNbmdQm0eRpsl4anJ3+Auw1NYshEkXDDEZVEVM9biAWVt1pAvyPNtMmGvGNY5sbx4jEZ2BeIFazQNT5d2GR7dJuWmaogKpCtex9Doq+R/yJCjJeXmZUBN81381CqYFpHywIHexXkTkpKcsfuYoTgst5hIduoGJz0uSoyXMaDoI=
Date: Thu, 19 Apr 2007 09:35:58 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>, i2c <i2c@lm-sensors.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, khali@linux-fr.org
Subject: [KJ][PATCH] i2c: SPIN_LOCK_UNLOCKED cleanup
Message-ID: <20070419040557.GA14283@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 i2c-pxa.c     |    2 +-
 i2c-s3c2410.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 14e83d0..d5d44ed 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -825,7 +825,7 @@ static const struct i2c_algorithm i2c_pxa_algorithm = {
 };
 
 static struct pxa_i2c i2c_pxa = {
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(i2c_pxa.lock),
 	.adap	= {
 		.owner		= THIS_MODULE,
 		.algo		= &i2c_pxa_algorithm,
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 556f244..3eb5958 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -570,7 +570,7 @@ static const struct i2c_algorithm s3c24xx_i2c_algorithm = {
 };
 
 static struct s3c24xx_i2c s3c24xx_i2c = {
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(s3c24xx_i2c.lock),
 	.wait	= __WAIT_QUEUE_HEAD_INITIALIZER(s3c24xx_i2c.wait),
 	.adap	= {
 		.name			= "s3c2410-i2c",

-- 
Milind Arun Choudhary
