Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbXG2PLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbXG2PLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764537AbXG2O75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47873 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764845AbXG2O7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:51 -0400
Date: Sun, 29 Jul 2007 16:59:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] export v4l2_int_device_{,un}register
Message-ID: <20070729145928.GH16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
>  git-dvb.patch
>...
>  git trees
>...

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 2135 modules
ERROR: "v4l2_int_device_register" [drivers/media/video/tcm825x.ko] undefined!
ERROR: "v4l2_int_device_unregister" [drivers/media/video/tcm825x.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/v4l2-int-device.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.23-rc1-mm1/drivers/media/video/v4l2-int-device.c.old	2007-07-27 14:03:33.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/media/video/v4l2-int-device.c	2007-07-27 14:04:03.000000000 +0200
@@ -101,6 +101,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(v4l2_int_device_register);
 
 void v4l2_int_device_unregister(struct v4l2_int_device *d)
 {
@@ -114,6 +115,7 @@
 	}
 	mutex_unlock(&mutex);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_device_unregister);
 
 /* Adapted from search_extable in extable.c. */
 static v4l2_int_ioctl_func *find_ioctl(struct v4l2_int_slave *slave, int cmd,

