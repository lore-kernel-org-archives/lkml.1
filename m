Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXDLHFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXDLHFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDLHFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:05:02 -0400
Received: from mx1.suse.de ([195.135.220.2]:48950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXDLHFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:05:00 -0400
Subject: patch driver-core-suppress-uevents-via-filter.patch added to gregkh-2.6 tree
To: cornelia.huck@de.ibm.com, akpm@linux-foundation.org,
       eric.rannaud@gmail.com, greg@kroah.com, gregkh@suse.de,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 12 Apr 2007 00:04:26 -0700
In-Reply-To: <20070329111211.7f918aeb@gondolin.boeblingen.de.ibm.com>
Message-Id: <20070412070456.387A1B63041@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: suppress uevents via filter

to my gregkh-2.6 tree.  Its filename is

     driver-core-suppress-uevents-via-filter.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From cornelia.huck@de.ibm.com Thu Mar 29 02:10:23 2007
From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Thu, 29 Mar 2007 11:12:11 +0200
Subject: Driver core: suppress uevents via filter
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, Eric Rannaud <eric.rannaud@gmail.com>
Message-ID: <20070329111211.7f918aeb@gondolin.boeblingen.de.ibm.com>


From: Cornelia Huck <cornelia.huck@de.ibm.com>

Suppress uevents for devices if uevent_suppress is set via
dev_uevent_filter(). This makes the driver core suppress all device
uevents, not just the add event in device_add().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/base/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -120,6 +120,8 @@ static int dev_uevent_filter(struct kset
 
 	if (ktype == &ktype_device) {
 		struct device *dev = to_dev(kobj);
+		if (dev->uevent_suppress)
+			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -675,8 +677,7 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);


Patches currently in gregkh-2.6 which might be from cornelia.huck@de.ibm.com are

