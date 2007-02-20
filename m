Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXBTMjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXBTMjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXBTMjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:39:44 -0500
Received: from tim.rpsys.net ([194.106.48.114]:58026 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXBTMjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:39:43 -0500
Subject: Re: BACKLIGHT_CLASS_DEVICE=y, SYSFS=n compile error
From: Richard Purdie <rpurdie@rpsys.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070220000829.GO13958@stusta.de>
References: <20070220000829.GO13958@stusta.de>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 12:38:40 +0000
Message-Id: <1171975120.5884.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 01:08 +0100, Adrian Bunk wrote:
> CONFIG_BACKLIGHT_CLASS_DEVICE=y, CONFIG_SYSFS=n results int he 
> following compile error:
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `nvidia_bl_exit':
> (.text+0x27d01): undefined reference to `backlight_device_unregister'
> drivers/built-in.o: In function `nvidia_bl_init':
> (.text+0x27e3c): undefined reference to `backlight_device_register'

I've added the patch below to the git backlight tree to resolve this.

Cheers,

Richard


backlight: Remove bogus SYSFS dependency

Remove a bogus SYSFS dependency from the backlight class

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index cd2ef0a..f8bc43c 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -4,9 +4,7 @@
 
 menu "Graphics support"
 
-if SYSFS
-	source "drivers/video/backlight/Kconfig"
-endif
+source "drivers/video/backlight/Kconfig"
 
 config FB
 	tristate "Support for frame buffer devices"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 6801edf..1b79a6f 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -12,7 +12,7 @@ fb-objs                           := $(fb-y)
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
-obj-$(CONFIG_SYSFS)		  += backlight/
+obj-y				  += backlight/
 
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o





