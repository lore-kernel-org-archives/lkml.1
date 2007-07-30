Return-Path: <linux-kernel-owner+w=401wt.eu-S968307AbXG3TMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968307AbXG3TMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967158AbXG3TMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:12:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:42257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966975AbXG3TMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:12:34 -0400
Subject: patch driver-core-revert-device-link-creation-check.patch added to gregkh-2.6 tree
To: cornelia.huck@de.ibm.com, gregkh@suse.de, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, simon@fire.lp0.eu
From: <gregkh@suse.de>
Date: Mon, 30 Jul 2007 12:12:24 -0700
In-Reply-To: <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>
Message-Id: <20070730191231.C9D1C14458DB@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: driver core: revert "device" link creation check

to my gregkh-2.6 tree.  Its filename is

     driver-core-revert-device-link-creation-check.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From cornelia.huck@de.ibm.com Wed Jul 25 00:58:00 2007
From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Wed, 25 Jul 2007 09:58:08 +0200
Subject: driver core: revert "device" link creation check
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Simon Arlott" <simon@fire.lp0.eu>, "Greg KH" <gregkh@suse.de>, "Linux  Kernel Mailing List" <linux-kernel@vger.kernel.org>
Message-ID: <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>

From: Cornelia Huck <cornelia.huck@de.ibm.com>

driver core: revert "device" link creation check

Commit 2ee97caf0a6602f749ddbfdb1449e383e1212707 introduced an extra
check on when to create the "device" symlink. Unfortunately, this
breaks input, so let's revert to the old behaviour.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/base/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -692,8 +692,7 @@ static int device_add_class_symlinks(str
 		if (error)
 			goto out_subsys;
 	}
-	/* only bus-device parents get a "device"-link */
-	if (dev->parent && dev->parent->bus) {
+	if (dev->parent) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)


Patches currently in gregkh-2.6 which might be from cornelia.huck@de.ibm.com are

driver/kobject-fix-link-error-when-config_hotplug-is-disabled.patch
driver/driver-core-revert-device-link-creation-check.patch
driver/kobject-update-documentation.patch
driver/kset-kernel-doc-cleanups.patch
