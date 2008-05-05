Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYEETU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYEETU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYEETUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:20:49 -0400
Received: from xenotime.net ([66.160.160.81]:54345 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750737AbYEETUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:20:47 -0400
Date: Mon, 5 May 2008 12:20:42 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
cc: stoth@hauppauge.com, v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH -next] multimedia/video: fix au0828 Kconfig
Message-ID: <Pine.LNX.4.64.0805051215550.27703@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix undefined references in au0828:
  depends on USB and select VIDEO_TVEEPROM

ERROR: "tveeprom_hauppauge_analog" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "tveeprom_read" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_kill_urb" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_deregister" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_control_msg" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_submit_urb" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_register_driver" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_free_urb" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/media/video/au0828/au0828.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/au0828/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- next-20080505.orig/drivers/media/video/au0828/Kconfig
+++ next-20080505/drivers/media/video/au0828/Kconfig
@@ -1,8 +1,9 @@
 
 config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
-       depends on VIDEO_DEV && I2C && INPUT && DVB_CORE
+	depends on VIDEO_DEV && I2C && INPUT && DVB_CORE && USB
 	select I2C_ALGOBIT
+	select VIDEO_TVEEPROM
 	select DVB_AU8522 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_XC5000 if !DVB_FE_CUSTOMIZE
 	---help---
