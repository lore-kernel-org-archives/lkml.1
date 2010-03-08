Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0CHQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:32:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47124 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0CHQc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:32:28 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: socketcan-core@lists.berlios.de,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Cc: stable@kernel.org, stable-review@kernel.org, linux-kernel@vger.kernel.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH] can: fix bfin_can build error after alloc_candev() change
Date: Mon,  8 Mar 2010 11:35:44 -0500
Message-Id: <1268066144-26830-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Looks like commit a6e4bc530403 didn't include updates to drivers so the
Blackfin CAN driver fails to build now.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/net/can/bfin_can.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/bfin_can.c b/drivers/net/can/bfin_can.c
index 680060d..fe10a17 100644
--- a/drivers/net/can/bfin_can.c
+++ b/drivers/net/can/bfin_can.c
@@ -27,6 +27,7 @@
 
 #define DRV_NAME "bfin_can"
 #define BFIN_CAN_TIMEOUT 100
+#define TX_ECHO_SKB_MAX  1
 
 /*
  * bfin can private data
@@ -507,7 +508,7 @@ struct net_device *alloc_bfin_candev(void)
 	struct net_device *dev;
 	struct bfin_can_priv *priv;
 
-	dev = alloc_candev(sizeof(*priv));
+	dev = alloc_candev(sizeof(*priv), TX_ECHO_SKB_MAX);
 	if (!dev)
 		return NULL;
 
-- 
1.7.0

