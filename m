Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZHITzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZHITzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZHITzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:55:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:8562 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZHITzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xuU7V+AROAKa6UQN9KBdqQYpM/ctWVYVmqN/X76j4xSmZoHMkVjJcY2sLu7tW/LYgW
         yOv7KjHP1XZ/IB0BzvbsR6xvOrX4rcf/sgFj3m2h8YlxxCmTsLixKW/vyKAAPe7uTsnE
         HJInBS59Q3y4M0ciXZvWY/+Dq9fGErYJcHiC4=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org
Subject: [PATCH 11/14] drivers/net: use printk_once
Date: Sun,  9 Aug 2009 21:54:06 +0200
Message-Id: <1249847649-11631-12-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/mlx4/en_main.c |    6 +-----
 drivers/net/mv643xx_eth.c  |    4 +---
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index 9ed4a15..18e9e4f 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -151,15 +151,11 @@ static void mlx4_en_remove(struct mlx4_dev *dev, void *endev_ptr)
 
 static void *mlx4_en_add(struct mlx4_dev *dev)
 {
-	static int mlx4_en_version_printed;
 	struct mlx4_en_dev *mdev;
 	int i;
 	int err;
 
-	if (!mlx4_en_version_printed) {
-		printk(KERN_INFO "%s", mlx4_en_version);
-		mlx4_en_version_printed++;
-	}
+	printk_once(KERN_INFO "%s", mlx4_en_version);
 
 	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
 	if (!mdev) {
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 0f32db3..dbb1d9c 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -2622,14 +2622,12 @@ static void infer_hw_params(struct mv643xx_eth_shared_private *msp)
 
 static int mv643xx_eth_shared_probe(struct platform_device *pdev)
 {
-	static int mv643xx_eth_version_printed;
 	struct mv643xx_eth_shared_platform_data *pd = pdev->dev.platform_data;
 	struct mv643xx_eth_shared_private *msp;
 	struct resource *res;
 	int ret;
 
-	if (!mv643xx_eth_version_printed++)
-		printk(KERN_NOTICE "MV-643xx 10/100/1000 ethernet "
+	printk_once(KERN_NOTICE "MV-643xx 10/100/1000 ethernet "
 			"driver version %s\n", mv643xx_eth_driver_version);
 
 	ret = -EINVAL;
-- 
1.6.3.3

