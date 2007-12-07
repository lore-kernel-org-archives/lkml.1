Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXLHDIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXLHDIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXLHDIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:08:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7814 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbXLHDIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:08:11 -0500
Message-Id: <20071208025620.470633411@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/4] media: video: usbvision: remove ctrlUrbLock
Message-Id: <20071208025608.631609481@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=usbvision-video-remove-CtrlUrbLock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ctrlUrbLock has all it's users commented out, and so it's unused.
This patch removes it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/media/video/usbvision/usbvision-core.c  |    3 ---
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/media/video/usbvision/usbvision.h       |    1 -
 3 files changed, 5 deletions(-)

Index: linux-2.6.23/drivers/media/video/usbvision/usbvision-core.c
===================================================================
--- linux-2.6.23.orig/drivers/media/video/usbvision/usbvision-core.c
+++ linux-2.6.23/drivers/media/video/usbvision/usbvision-core.c
@@ -1561,13 +1561,10 @@ static int usbvision_write_reg_irq(struc
 	if (len > 8) {
 		return -EFAULT;
 	}
-//	down(&usbvision->ctrlUrbLock);
 	if (usbvision->ctrlUrbBusy) {
-//		up(&usbvision->ctrlUrbLock);
 		return -EBUSY;
 	}
 	usbvision->ctrlUrbBusy = 1;
-//	up(&usbvision->ctrlUrbLock);
 
 	usbvision->ctrlUrbSetup.bRequestType = USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT;
 	usbvision->ctrlUrbSetup.bRequest     = USBVISION_OP_CODE;
Index: linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- linux-2.6.23.orig/drivers/media/video/usbvision/usbvision-video.c
+++ linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
@@ -1650,7 +1650,6 @@ static struct usb_usbvision *usbvision_a
 		goto err_exit;
 	}
 	init_waitqueue_head(&usbvision->ctrlUrb_wq);
-	init_MUTEX(&usbvision->ctrlUrbLock);	/* to 1 == available */
 
 	usbvision_init_powerOffTimer(usbvision);
 
Index: linux-2.6.23/drivers/media/video/usbvision/usbvision.h
===================================================================
--- linux-2.6.23.orig/drivers/media/video/usbvision/usbvision.h
+++ linux-2.6.23/drivers/media/video/usbvision/usbvision.h
@@ -374,7 +374,6 @@ struct usb_usbvision {
 	int ctrlUrbBusy;
 	struct usb_ctrlrequest ctrlUrbSetup;
 	wait_queue_head_t ctrlUrb_wq;					// Processes waiting
-	struct semaphore ctrlUrbLock;
 
 	/* configuration part */
 	int have_tuner;

-- 
