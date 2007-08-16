Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbXHPNWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbXHPNWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbXHPNUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:20:13 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1296 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbXHPNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:20:10 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <mshefty@ichips.intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: [PATCH 4/6] infiniband: mlx4_MAD_IFC copies out response unconditionally
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <65fd31510014453ccd0a99a20c83deb5@pinky>
Date: Thu, 16 Aug 2007 14:19:01 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It seems a trailing ';' has slipped into mlx4_MAD_IFC() which causes
the response to be copied out unconditionally.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <mshefty@ichips.intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: general@lists.openfabrics.org
---
 drivers/infiniband/hw/mlx4/mad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 3330917..0ed02b7 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -109,7 +109,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 			   in_modifier, op_modifier,
 			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
 
-	if (!err);
+	if (!err)
 		memcpy(response_mad, outmailbox->buf, 256);
 
 	mlx4_free_cmd_mailbox(dev->dev, inmailbox);
