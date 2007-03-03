Return-Path: <linux-kernel-owner+w=401wt.eu-S1030380AbXCCTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbXCCTJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXCCTJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:09:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41037 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030380AbXCCTJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:09:19 -0500
Date: Sat, 3 Mar 2007 20:09:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: usb-storage@lists.one-eyed-alien.net, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb-storage: do not rebuild when kernel version changes
Message-ID: <20070303190941.GB30463@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing use of UTS_RELEASE with utsname()->release
avoids that the usb-storage driver is recompiled each
time the kernel version changes.

Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 7e7ec29..8e898e3 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -55,7 +55,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <linux/utsrelease.h>
+#include <linux/utsname.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -547,7 +547,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id)
 				idesc->bInterfaceSubClass,
 				idesc->bInterfaceProtocol,
 				msgs[msg],
-				UTS_RELEASE);
+				utsname()->release);
 	}
 
 	return 0;
