Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYAEPt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYAEPt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbYAEPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:49:21 -0500
Received: from [212.12.190.185] ([212.12.190.185]:52993 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756221AbYAEPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:49:17 -0500
Message-Id: <200801051546.SAA08947@raad.intranet>
From: Al Boldi <a1426z@gawab.com>
To: linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Date: Sat, 5 Jan 2008 18:41:39 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Select SCSI for USB Mass Storage support.


Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---

--- 23.a/drivers/usb/storage/Kconfig
+++ 23.b/drivers/usb/storage/Kconfig
@@ -2,14 +2,10 @@
 # USB Storage driver configuration
 #
 
-comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
-	depends on USB
-comment "also be needed; see USB_STORAGE Help for more information"
-	depends on USB
-
 menuconfig USB_STORAGE
 	tristate "USB Mass Storage support"
-	depends on USB && SCSI
+	depends on USB
+	select SCSI
 	---help---
 	  Say Y here if you want to connect USB mass storage devices to your
 	  computer's USB port. This is the driver you need for USB
@@ -18,13 +14,17 @@ menuconfig USB_STORAGE
 	  similar devices. This driver may also be used for some cameras
 	  and card readers.
 
-	  This option depends on 'SCSI' support being enabled, but you
-	  probably also need 'SCSI device support: SCSI disk support'
+	  This option selects 'SCSI' support , but you probably
+	  also need 'SCSI device support: SCSI disk support'
 	  (BLK_DEV_SD) for most USB storage devices.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
 
+if USB_STORAGE
+comment "NOTE: USB_STORAGE selects SCSI, but 'SCSI disk support' may"
+comment "also be needed; see USB_STORAGE Help for more information"
+
 config USB_STORAGE_DEBUG
 	bool "USB Mass Storage verbose debug"
 	depends on USB_STORAGE
@@ -147,6 +147,8 @@ config USB_STORAGE_KARMA
 	  on the resulting scsi device node returns the Karma to normal
 	  operation.
 
+endif # USB_STORAGE
+
 config USB_LIBUSUAL
 	bool "The shared table of common (or usual) storage devices"
 	depends on USB

