Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZDPNue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZDPNue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZDPNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:50:24 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:65324 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZDPNuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:50:23 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] platform: Do not complain for platform_data added by platform_device_add_data()
Date: Thu, 16 Apr 2009 22:50:28 +0900
Message-Id: <1239889828-7300-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ce21c7bc ("driver core: fix passing platform_data") added
an error message "foo: use which platform_data?", but this is normal
if platform_device_add_data() was used.

Do not print the error message if pdev->platform_data and
pdev->dev.platform_data have same value.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/base/platform.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index d2198f6..f984376 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -253,7 +253,8 @@ int platform_device_add(struct platform_device *pdev)
 	* long time, so we allow the two cases coexist to make
 	* this kind of fix more easily*/
 	if (pdev->platform_data && pdev->dev.platform_data) {
-		printk(KERN_ERR
+		if (pdev->platform_data != pdev->dev.platform_data)
+			printk(KERN_ERR
 			       "%s: use which platform_data?\n",
 			       dev_name(&pdev->dev));
 	} else if (pdev->platform_data) {
-- 
1.5.6.3

