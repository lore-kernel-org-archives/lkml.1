Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYIKKOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYIKKOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYIKKNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:13:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:48404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYIKKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:13:41 -0400
Subject: patch driver-core-fix-cleanup-in-device_create_vargs.patch added to gregkh-2.6 tree
To: cornelia.huck@de.ibm.com, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
From: <gregkh@suse.de>
Date: Thu, 11 Sep 2008 03:11:45 -0700
In-Reply-To: <20080903182641.75db23a6@gondolin.boeblingen.de.ibm.com>
Message-ID: <12211279052027@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: Fix cleanup in device_create_vargs().

to my gregkh-2.6 tree.  Its filename is

     driver-core-fix-cleanup-in-device_create_vargs.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From cornelia.huck@de.ibm.com  Thu Sep 11 02:38:46 2008
From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Wed, 3 Sep 2008 18:26:41 +0200
Subject: Driver core: Fix cleanup in device_create_vargs().
To: Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <20080903182641.75db23a6@gondolin.boeblingen.de.ibm.com>

From: Cornelia Huck <cornelia.huck@de.ibm.com>

If device_register() in device_create_vargs() fails, the device
must be cleaned up with put_device() (which is also fine on NULL)
instead of kfree().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1256,7 +1256,7 @@ struct device *device_create_vargs(struc
 	return dev;
 
 error:
-	kfree(dev);
+	put_device(dev);
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(device_create_vargs);


Patches currently in gregkh-2.6 which might be from cornelia.huck@de.ibm.com are

driver-core/s390-bus_id-dev_name-conversions.patch
driver-core/driver-core-clarify-device-cleanup.patch
driver-core/driver-core-fix-cleanup-in-device_create_vargs.patch
driver-core/s390-bus_id-dev_set_name-changes.patch
driver-core/s390-more-bus_id-dev_name-conversions.patch
driver-core/s390-use-s390_root_dev_-in-kvm_virtio.patch
driver-core/s390-bus_id-dev_set_name-for-css-and-ccw-busses.patch
driver-core/driver-core-provide-a-dev_set_name-that-handles-names-longer-than-20-chars.patch
