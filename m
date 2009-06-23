Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZFWNNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZFWNNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759062AbZFWNN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:13:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52284 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759056AbZFWNNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:13:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: gregkh@suse.de, bigeasy@linuxtronix.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] USB: isp1760: add missing __devexit_p()
Date: Tue, 23 Jun 2009 09:13:05 -0400
Message-Id: <1245762785-7577-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/host/isp1760-if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index 3fa3a17..d4feebf 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -361,7 +361,7 @@ static int __devexit isp1760_plat_remove(struct platform_device *pdev)
 
 static struct platform_driver isp1760_plat_driver = {
 	.probe	= isp1760_plat_probe,
-	.remove	= isp1760_plat_remove,
+	.remove	= __devexit_p(isp1760_plat_remove),
 	.driver	= {
 		.name	= "isp1760",
 	},
-- 
1.6.3.1

