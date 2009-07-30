Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbZG3J5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbZG3J5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZG3J5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:57:40 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:36597 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZG3J5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:57:39 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, johnpol@2ka.mipt.ru,
       akpm@linux-foundation.org, stanley.miao@windriver.com,
       rmk+kernel@arm.linux.org.uk, madhu.cr@ti.com, felipe.balbi@nokia.com
Subject: [PATCH] missing mutex unlock
Date: Thu, 30 Jul 2009 04:57:18 -0500
Message-ID: <1248947838-20087-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found using a semantic patch, more info can be found at:
http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/w1/masters/omap_hdq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index a7e3b70..0d92969 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -687,6 +687,7 @@ static int omap_hdq_remove(struct platform_device *pdev)
 
 	if (hdq_data->hdq_usecount) {
 		dev_dbg(&pdev->dev, "removed when use count is not zero\n");
+		mutex_unlock(&hdq_data->hdq_mutex);
 		return -EBUSY;
 	}
 
-- 
1.6.3.3

