Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0CDUWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:22:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35921 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753310Ab0CDUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:22:23 -0500
Date: Thu, 4 Mar 2010 15:22:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Weirdness in patch
Message-ID: <Pine.LNX.4.44L0.1003041511070.1305-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

In my copy of gregkh-all-2.6.33.patch (which is dated 2010-03-01), 
there are changes to drivers/base/power/main.c, coming from the 
gregkh-05-driver-core/driver-core-create-lock-unlock-functions-for-struct-device 
patch.

The first weird thing is this.  That file as it currently exists on
www.kernel.org (dated 2010-03-03) contains the following hunk (it's the
last hunk for drivers/base/power/main.c):

@@ -962,7 +962,7 @@ static int device_prepare(struct device
 		suspend_report_result(dev->class->pm->prepare, error);
 	}
  End:
-	up(&dev->sem);
+	device_unlock(dev);
 
 	return error;
 }

But in my copy of gregkh-all-2.6.33.patch, the corresponding hunk is:

@@ -852,7 +852,7 @@
 		suspend_report_result(dev->class->pm->prepare, error);
 	}
  End:
-	up(&dev->sem);
+	device_lock(dev);
 
 	return error;
 }

The device_unlock() got changed to device_lock()!  That messed up my 
suspend testing for a while...

Secondly, none of these changes is present in the 
gregkh-all-2.6.33.patch file at www.kernel.org.  Isn't that supposed to 
contain all the patches from the subsystems merged into one?

What's the story?

Alan Stern

