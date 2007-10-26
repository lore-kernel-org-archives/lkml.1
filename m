Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXJZSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXJZSGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXJZSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:05:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbXJZSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:05:53 -0400
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
From: Kay Sievers <kay.sievers@vrfy.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47221E6F.1090607@lwfinger.net>
References: <47221E6F.1090607@lwfinger.net>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 20:07:44 +0200
Message-Id: <1193422064.2190.6.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18XX8NU/L4+vniCGjj5LfZipoLPd/jaOQ9GnC6
 06i7rWxMRkY2L6r6ALUUiwyLA0Ys6M2HHFPTjnkpZA7Qdobs8s
 PZlewK0jNTdGA3W9YSJB9mRta7tn1aA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 12:05 -0500, Larry Finger wrote:
> On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1,
> I get the sysfs rename messages.

Care to try this? Seems like a silly bug in the core if
SYSFS_DEPRECATED=y. That's why we didn't catch this earlier, sorry.

Thanks a lot for the help,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c134341..3f4d6aa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1228,18 +1228,18 @@ int device_rename(struct device *dev, char *new_name)
 			sysfs_remove_link(&dev->parent->kobj, old_class_name);
 		}
 	}
-#endif
-
+#else
 	if (dev->class) {
 		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
 		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
 					  dev->bus_id);
 		if (error) {
-			/* Uh... how to unravel this if restoring can fail? */
 			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
 				__FUNCTION__, error);
 		}
 	}
+#endif
+
 out:
 	put_device(dev);
 

