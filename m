Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYEPIEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYEPIEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYEPIDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:03:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58800 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYEPIDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:03:00 -0400
Date: Fri, 16 May 2008 11:01:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [2.6 patch] always enter drivers/media/video/
Message-ID: <20080516080113.GO1936@cs181133002.pp.htv.fi>
References: <200805151515.28249.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805151515.28249.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 039d40019f3c5e26ea50ec5af4270189f63365e1
(V4L/DVB (7898): Fix VIDEO_MEDIA Kconfig logic)
VIDEO_MEDIA is no longer usable in Makefile's for deciding
which directories we enter, resulting in compile errors like the 
following with CONFIG_VIDEO_DEV=y, CONFIG_DVB_CORE=m:

<--  snip  -->

...
  MODPOST 187 modules
ERROR: "video_exclusive_release" [drivers/media/radio/radio-zoltrix.ko] undefined!
ERROR: "video_exclusive_open" [drivers/media/radio/radio-zoltrix.ko] undefined!
ERROR: "video_ioctl2" [drivers/media/radio/radio-zoltrix.ko] undefined!
ERROR: "video_register_device" [drivers/media/radio/radio-zoltrix.ko] undefined!
ERROR: "video_devdata" [drivers/media/radio/radio-zoltrix.ko] undefined!
ERROR: "video_unregister_device" [drivers/media/radio/radio-zoltrix.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

The easiest solution is to always enter video/

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
62aa0f0990ec569868b34764c255268a5e425486 diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index cc11c4c..09a829d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,12 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y := common/
-
-obj-$(CONFIG_VIDEO_MEDIA) += common/
-
-# Since hybrid devices are here, should be compiled if DVB and/or V4L
-obj-$(CONFIG_VIDEO_MEDIA) += video/
+obj-y += common/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/
