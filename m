Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXCJEJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXCJEJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965840AbXCJEJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:09:12 -0500
Received: from mail.suse.de ([195.135.220.2]:36291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767772AbXCJEJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:09:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] Revert "driver core: refcounting fix"
Date: Fri,  9 Mar 2007 20:07:28 -0800
Message-Id: <11734996523796-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <20070310040405.GC30638@kroah.com>
References: <20070310040405.GC30638@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 63ce18cfe685115ff8d341bae4c9204a79043cf0.

It was the incorrect fix and causes a reference counting bug whenever
any driver module is removed from the system. Mike Galbraith
<efault@gmx.de> is looking for the real fix for his problem.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f77e893..fbc51de 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2419,12 +2419,6 @@ void module_remove_driver(struct device_driver *drv)
 			kfree(driver_name);
 		}
 	}
-	/*
-	 * Undo the additional reference we added in module_add_driver()
-	 * via kset_find_obj()
-	 */
-	if (drv->mod_name)
-		kobject_put(&drv->kobj);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif
-- 
1.5.0.2

