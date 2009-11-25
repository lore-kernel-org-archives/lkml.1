Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZKYJ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZKYJ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758422AbZKYJ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:29:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337AbZKYJ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:29:07 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       Jack Morgenstein <jackm@dev.mellanox.co.il>,
       Eli Cohen <eli@mellanox.co.il>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Franco Fichtner <franco@lastsummer.de>
Subject: [PATCH] don't wrap mlx4_remove_one in __devexit_p
Date: Wed, 25 Nov 2009 10:23:31 +0100
Message-Id: <1259141011-9567-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B0CF685.6060208@lastsummer.de>
References: <4B0CF685.6060208@lastsummer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function mlx4_remove_one is defined in .text, so there is no need to
wrap it with __devexit_p.

While at it add a trailing comma to the section initializer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Eli Cohen <eli@mellanox.co.il>
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org
Cc: Franco Fichtner <franco@lastsummer.de>
---
 drivers/net/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 291a505..acc2878 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1293,7 +1293,7 @@ static struct pci_driver mlx4_driver = {
 	.name		= DRV_NAME,
 	.id_table	= mlx4_pci_table,
 	.probe		= mlx4_init_one,
-	.remove		= __devexit_p(mlx4_remove_one)
+	.remove		= mlx4_remove_one,
 };
 
 static int __init mlx4_verify_params(void)
