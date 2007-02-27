Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXB0ODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXB0ODW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXB0ODW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:03:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:52604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXB0ODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nnuuEYGMIOypGOVRIxoXL7kju+hS6f+KJmg7G5TCnCnjg6OW416Zki6ENQhdCHgShPVv97Fl8i32KOvI+Egc9sqMS3S09LFy5MBOezfGSvp/cgJ6PWgB+TCaMDKU4Ez6Y0ZqLoSTMF0V4i/T9LSguIVe/42cduhzsbLL7NrnZ+c=
Message-ID: <961aa3350702270603j476c68c0x1c7177ca0581ddef@mail.gmail.com>
Date: Tue, 27 Feb 2007 23:03:18 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: [PATCH 2/3] driver core: add missing symlinks error handling
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2/3] driver core: add missing symlinks error handling

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: 2.6-mm/drivers/base/core.c
===================================================================
--- 2.6-mm.orig/drivers/base/core.c
+++ 2.6-mm/drivers/base/core.c
@@ -649,8 +649,10 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_groups(dev);
  GroupError:
- 	device_remove_attrs(dev);
+	device_remove_attrs(dev);
  AttrsError:
+	device_remove_links(dev, parent);
+
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
