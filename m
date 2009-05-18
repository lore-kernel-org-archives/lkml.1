Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZERHyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZERHyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZERHyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:54:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41458 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZERHyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:54:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] edac: add missing __devexit_p()
Date: Mon, 18 May 2009 03:54:06 -0400
Message-Id: <1242633246-16400-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Doug Thompson <dougthompson@xmission.com>
CC: bluesmoke-devel@lists.sourceforge.net
---
 drivers/edac/cell_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index cb0f639..c973004 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -227,7 +227,7 @@ static struct platform_driver cell_edac_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= cell_edac_probe,
-	.remove		= cell_edac_remove,
+	.remove		= __devexit_p(cell_edac_remove),
 };
 
 static int __init cell_edac_init(void)
-- 
1.6.3

