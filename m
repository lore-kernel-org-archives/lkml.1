Return-Path: <linux-kernel-owner+w=401wt.eu-S935224AbXGKXlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224AbXGKXlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935085AbXGKXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:33761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934996AbXGKXeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/61] Driver core: coding style cleanup
Date: Wed, 11 Jul 2007 16:31:37 -0700
Message-Id: <11841968271925-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968231043-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

This converts code of the form

	if ((error = some_func()))
		goto fixup;
to
	error = some_func();
	if (error)
		goto fixup;

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c  |    6 ++++--
 drivers/base/core.c |    9 ++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7ff5aaf..f299e0d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -622,7 +622,8 @@ int bus_add_driver(struct device_driver *drv)
 	if (error)
 		goto out_put_bus;
 	drv->kobj.kset = &bus->drivers;
-	if ((error = kobject_register(&drv->kobj)))
+	error = kobject_register(&drv->kobj);
+	if (error)
 		goto out_put_bus;
 
 	if (drv->bus->drivers_autoprobe) {
@@ -772,7 +773,8 @@ static int bus_add_attrs(struct bus_type * bus)
 
 	if (bus->bus_attrs) {
 		for (i = 0; attr_name(bus->bus_attrs[i]); i++) {
-			if ((error = bus_create_file(bus,&bus->bus_attrs[i])))
+			error = bus_create_file(bus,&bus->bus_attrs[i]);
+			if (error)
 				goto Err;
 		}
 	}
diff --git a/drivers/base/core.c b/drivers/base/core.c
index dd40d78..cff4fbf 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -733,11 +733,14 @@ int device_add(struct device *dev)
 		}
 	}
 
-	if ((error = device_add_attrs(dev)))
+	error = device_add_attrs(dev);
+	if (error)
 		goto AttrsError;
-	if ((error = device_pm_add(dev)))
+	error = device_pm_add(dev);
+	if (error)
 		goto PMError;
-	if ((error = bus_add_device(dev)))
+	error = bus_add_device(dev);
+	if (error)
 		goto BusError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
-- 
1.5.2.2

