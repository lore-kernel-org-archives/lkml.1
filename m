Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZEOSut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZEOSut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZEOSud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:50:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51511 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZEOSud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:50:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] regulator: da903x: add missing __devexit_p()
Date: Fri, 15 May 2009 14:50:33 -0400
Message-Id: <1242413433-26688-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Mike Rapoport <mike@compulab.co.il>
CC: Eric Miao <eric.miao@marvell.com>
---
 drivers/regulator/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 72b1549..c6628f5 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -497,7 +497,7 @@ static struct platform_driver da903x_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= da903x_regulator_probe,
-	.remove		= da903x_regulator_remove,
+	.remove		= __devexit_p(da903x_regulator_remove),
 };
 
 static int __init da903x_regulator_init(void)
-- 
1.6.3

