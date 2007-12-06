Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbXLFWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbXLFWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXLFWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:36:36 -0500
Received: from dns.vs-node3.de ([87.106.12.105]:40740 "EHLO
	aragorn.vidconference.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXLFWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:36:35 -0500
X-Greylist: delayed 1757 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 17:36:35 EST
Date: Thu, 6 Dec 2007 23:06:35 +0100
To: video4linux-list@redhat.com
Cc: Ted Walther <ted@enumera.com>, John Sokol <sokol@videotechnology.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] vivi driver works only as first device
Message-ID: <20071206220634.GT17496@vidsoft.de>
References: <20071203225610.GS17496@vidsoft.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203225610.GS17496@vidsoft.de>
User-Agent: Mutt/1.5.9i
From: Gregor Jasny <jasny@vidsoft.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregor Jasny <gjasny@web.de>

When the vivi driver allocates a video device, video_register_device() stores the
allocated device minor inside the vivi structure. But when the device node is opened,
the file minor number is compared to the minor in the device list. So this patch
copies the allocated minor in the device list, too.

Without this patch it is impossible to use the vivi driver mith minors greater than zero. 

Signed-off-by: Gregor Jasny <gjasny@web.de>
---
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index ee73dc7..f4e533a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1175,6 +1175,9 @@ static int __init vivi_init(void)
 
 	ret = video_register_device(&vivi, VFL_TYPE_GRABBER, video_nr);
 	printk(KERN_INFO "Video Technology Magazine Virtual Video Capture Board (Load status: %d)\n", ret);
+
+	dev->vfd.minor = vivi.minor;
+
 	return ret;
 }
 
