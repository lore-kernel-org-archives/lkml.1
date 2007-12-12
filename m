Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXLLCIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXLLCIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXLLCIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:08:36 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2495 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbXLLCIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:08:35 -0500
Message-Id: <20071212015650.481405953@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Dec 2007 17:56:50 -0800
Message-Id: <20071212015450.732327355@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Dec 2007 17:54:50 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] media: video: usbvision: add mutex_unlock() to error paths
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few error paths which don't unlock the usbvision->lock.

So I've added mutex_unlock() calls to fix those paths.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/media/video/usbvision/usbvision-video.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- linux-2.6.23.orig/drivers/media/video/usbvision/usbvision-video.c
+++ linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
@@ -1290,6 +1290,7 @@ static int usbvision_radio_open(struct i
 		errCode = usbvision_set_alternate(usbvision);
 		if (errCode < 0) {
 			usbvision->last_error = errCode;
+			mutex_unlock(&usbvision->lock);
 			return -EBUSY;
 		}
 
@@ -1806,6 +1807,7 @@ static int __devinit usbvision_probe(str
 					      usbvision->num_alt,GFP_KERNEL);
 	if (usbvision->alt_max_pkt_size == NULL) {
 		err("usbvision: out of memory!\n");
+		mutex_unlock(&usbvision->lock);
 		return -ENOMEM;
 	}
 
-- 

-- 
