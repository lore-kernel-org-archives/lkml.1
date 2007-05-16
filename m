Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbXEPJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbXEPJFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEPJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:05:30 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:58437 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbXEPJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:05:28 -0400
Date: Wed, 16 May 2007 11:05:26 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch -mm] Driver core: coding style cleanup
Message-ID: <20070516110526.67e5b36e@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[This goes on top of
driver-core-check-return-code-of-sysfs_create_link.patch]

From: Cornelia Huck <cornelia.huck@de.ibm.com>

This converts code of the form

	if ((error = some_func()))
		goto fixup;
to
	error = some_func();
	if (error)
		goto fixup;

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/bus.c  |    6 ++++--
 drivers/base/core.c |   12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -764,13 +764,17 @@ int device_add(struct device *dev)
 		if (error)
 			goto ueventattrError;
 	}
-	if ((error = device_add_class_symlinks(dev)))
+	error = device_add_class_symlinks(dev);
+	if (error)
 		goto SymlinkError;
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
--- linux-2.6.orig/drivers/base/bus.c
+++ linux-2.6/drivers/base/bus.c
@@ -608,7 +608,8 @@ int bus_add_driver(struct device_driver 
 	if (error)
 		goto out_put_bus;
 	drv->kobj.kset = &bus->drivers;
-	if ((error = kobject_register(&drv->kobj)))
+	error = kobject_register(&drv->kobj);
+	if (error)
 		goto out_put_bus;
 
 	if (drv->bus->drivers_autoprobe) {
@@ -757,7 +758,8 @@ static int bus_add_attrs(struct bus_type
 
 	if (bus->bus_attrs) {
 		for (i = 0; attr_name(bus->bus_attrs[i]); i++) {
-			if ((error = bus_create_file(bus,&bus->bus_attrs[i])))
+			error = bus_create_file(bus,&bus->bus_attrs[i]);
+			if (error)
 				goto Err;
 		}
 	}
