Return-Path: <linux-kernel-owner+w=401wt.eu-S965710AbXBHAjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710AbXBHAjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422939AbXBHAcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:34052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXBHAcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:21 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/28] driver core: Change function call order in device_bind_driver().
Date: Wed,  7 Feb 2007 16:30:04 -0800
Message-Id: <11708946734097-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1170894670676-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Change function call order in device_bind_driver().

If we create symlinks (which might fail) before adding the device to the list
we don't have to clean up afterwards (which we didn't).

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f705137..b5bf243 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -86,8 +86,12 @@ static void driver_sysfs_remove(struct device *dev)
  */
 int device_bind_driver(struct device *dev)
 {
-	driver_bound(dev);
-	return driver_sysfs_add(dev);
+	int ret;
+
+	ret = driver_sysfs_add(dev);
+	if (!ret)
+		driver_bound(dev);
+	return ret;
 }
 
 struct stupid_thread_structure {
-- 
1.4.4.4

