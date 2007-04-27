Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXD0S6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXD0S6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbXD0S5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:50634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbXD0S53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/46] Driver core: remove use of rwsem
Date: Fri, 27 Apr 2007 11:53:34 -0700
Message-Id: <11777001102852-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001072576-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This lock is never used by the rest of the driver core, so the fact that
we are grabbing it here means it isn't correct...

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/shutdown.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/shutdown.c b/drivers/base/power/shutdown.c
index 3483ae4..58b6f77 100644
--- a/drivers/base/power/shutdown.c
+++ b/drivers/base/power/shutdown.c
@@ -36,7 +36,6 @@ void device_shutdown(void)
 {
 	struct device * dev, *devn;
 
-	down_write(&devices_subsys.rwsem);
 	list_for_each_entry_safe_reverse(dev, devn, &devices_subsys.kset.list,
 				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
@@ -47,7 +46,6 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-	up_write(&devices_subsys.rwsem);
 
 	sysdev_shutdown();
 }
-- 
1.5.1.2

