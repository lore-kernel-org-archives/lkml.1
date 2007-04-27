Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbXD0S43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbXD0S43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXD0S42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXD0S41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>,
       Monakhov Dmitriy <dmonakhov@openvz.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/46] driver core: fix device_add error path
Date: Fri, 27 Apr 2007 11:53:15 -0700
Message-Id: <1177700040520-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <20070427185152.GA17121@kroah.com>
References: <20070427185152.GA17121@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitriy Monakhov <dmonakhov@sw.ru>

 - At the moment we jump here device was't added to
   dev->class->devices list yet.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d7fcf82..db3a151 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -677,15 +677,6 @@ int device_add(struct device *dev)
 #endif
 			sysfs_remove_link(&dev->kobj, "device");
 		}
-
-		down(&dev->class->sem);
-		/* notify any interfaces that the device is now gone */
-		list_for_each_entry(class_intf, &dev->class->interfaces, node)
-			if (class_intf->remove_dev)
-				class_intf->remove_dev(dev, class_intf);
-		/* remove the device from the class list */
-		list_del_init(&dev->node);
-		up(&dev->class->sem);
 	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
-- 
1.5.1.2

