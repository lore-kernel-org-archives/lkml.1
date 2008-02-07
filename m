Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbYBGXyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbYBGXyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbYBGXyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:54:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60709 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223AbYBGXyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:54:10 -0500
Subject: [-mm PATCH] sysdev_unregister() should call kobject_del()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 15:56:58 -0800
Message-Id: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

While playing with hotplug memory remove on 2.6.24-mm1, I 
noticed that /sysfs directory entries are not getting removed.

sysdev_unregister() used to call kobject_unregister().
But in 2.6.24-mm1, its only dropping the ref. It should
call kobject_del() to remove the object. Correct ?

With this change, the directories are getting removed
correctly. Comments ?

Thanks,
Badari

sysdev_unregister() should call kobject_del() to remove
the object.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 drivers/base/sys.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.24/drivers/base/sys.c
===================================================================
--- linux-2.6.24.orig/drivers/base/sys.c	2008-02-05 09:56:56.000000000 -0800
+++ linux-2.6.24/drivers/base/sys.c	2008-02-07 15:38:17.000000000 -0800
@@ -265,6 +265,7 @@ void sysdev_unregister(struct sys_device
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 
+	kobject_del(&sysdev->kobj);
 	kobject_put(&sysdev->kobj);
 }
 


