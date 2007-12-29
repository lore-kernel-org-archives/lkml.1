Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbXL2BQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbXL2BQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXL2BQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:16:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:34423 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXL2BQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iOuGR4F4MlGq3YT4ap9pBDVug9ao7Kb2Ef3evO0T6JCLYTEzdVnknWWn4gUE2yF0Y8xfxKk0GvF3wlbd0q4ZG4rXvRCuz72PymJPjVxSHUMR8faIUx6sjoBjuxy9DIiCI8zGh6zDY3dYXO707j8CbTS93hfCUKhnAFXe00eoGZE=
Date: Sat, 29 Dec 2007 09:20:21 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 12/12] usb : Use mutex instead of semaphore in driver core
Message-ID: <20071229012021.GM2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
include/linux/usb.h |    6 +++---
1 file changed, 3 insertions(+), 3 deletions(-)

diff -upr linux/include/linux/usb.h linux.new/include/linux/usb.h
--- linux/include/linux/usb.h	2007-12-28 10:50:31.000000000 +0800
+++ linux.new/include/linux/usb.h	2007-12-28 10:52:31.000000000 +0800
@@ -441,9 +441,9 @@ extern struct usb_device *usb_get_dev(st
 extern void usb_put_dev(struct usb_device *dev);
 
 /* USB device locking */
-#define usb_lock_device(udev)		down(&(udev)->dev.sem)
-#define usb_unlock_device(udev)		up(&(udev)->dev.sem)
-#define usb_trylock_device(udev)	down_trylock(&(udev)->dev.sem)
+#define usb_lock_device(udev)		mutex_lock(&(udev)->dev.mutex)
+#define usb_unlock_device(udev)		mutex_unlock(&(udev)->dev.mutex)
+#define usb_trylock_device(udev)	mutex_trylock(&(udev)->dev.mutex)
 extern int usb_lock_device_for_reset(struct usb_device *udev,
 				     const struct usb_interface *iface);
 
