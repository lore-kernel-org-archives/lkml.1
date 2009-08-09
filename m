Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZHITzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZHITzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZHITzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:55:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZHITy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NFkGyBEiVRzDynxXQPIqdoRdQ1zdXb6eZ/KZI4e3tTvQSGmGH21tq3zY3xBb55/X1d
         lywWOtML4KFsfBrNZEgq/iRO8qU0BEVdha4PYdYynDmQAZFT+88Eh+avgeF+rv/P/p2q
         FMLpJa45Fg+NDfw2Z+5J2kHvzDY1/3mRi4j5Q=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: [PATCH 10/14] infiniband: use printk_once
Date: Sun,  9 Aug 2009 21:54:05 +0200
Message-Id: <1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: general@lists.openfabrics.org
---
 drivers/infiniband/hw/cxgb3/iwch.c |    4 +---
 drivers/infiniband/hw/mlx4/main.c  |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 26fc0a4..9cc99df 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -105,11 +105,9 @@ static void rnic_init(struct iwch_dev *rnicp)
 static void open_rnic_dev(struct t3cdev *tdev)
 {
 	struct iwch_dev *rnicp;
-	static int vers_printed;
 
 	PDBG("%s t3cdev %p\n", __func__,  tdev);
-	if (!vers_printed++)
-		printk(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
+	printk_once(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
 		       DRV_VERSION);
 	rnicp = (struct iwch_dev *)ib_alloc_device(sizeof(*rnicp));
 	if (!rnicp) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ae3d759..0b2f77a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -540,15 +540,11 @@ static struct device_attribute *mlx4_class_attributes[] = {
 
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
-	static int mlx4_ib_version_printed;
 	struct mlx4_ib_dev *ibdev;
 	int num_ports = 0;
 	int i;
 
-	if (!mlx4_ib_version_printed) {
-		printk(KERN_INFO "%s", mlx4_ib_version);
-		++mlx4_ib_version_printed;
-	}
+	printk_once(KERN_INFO "%s", mlx4_ib_version);
 
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
 		num_ports++;
-- 
1.6.3.3

