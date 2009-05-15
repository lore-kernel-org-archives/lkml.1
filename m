Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZEOSuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZEOSuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZEOSuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:50:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51490 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZEOSuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:50:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] hwmon: (lm78) add missing __devexit_p()
Date: Fri, 15 May 2009 14:50:23 -0400
Message-Id: <1242413423-26654-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Jean Delvare <khali@linux-fr.org>
---
 drivers/hwmon/lm78.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index b5e3b28..a1787fd 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -182,7 +182,7 @@ static struct platform_driver lm78_isa_driver = {
 		.name	= "lm78",
 	},
 	.probe		= lm78_isa_probe,
-	.remove		= lm78_isa_remove,
+	.remove		= __devexit_p(lm78_isa_remove),
 };
 
 
-- 
1.6.3

