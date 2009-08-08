Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZHHM1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZHHM1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbZHHM1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:27:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53701 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057AbZHHM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:27:08 -0400
Date: Sat, 8 Aug 2009 14:27:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090808122701.GD11163@elf.ucw.cz>
References: <20090720103532.GD19341@elf.ucw.cz> <20090727153711.GA4323@kroah.com> <20090805152721.GA8337@elf.ucw.cz> <20090805160652.GA9474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805160652.GA9474@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > OTOH Dream is still major user; and I guess I can just introduce
> > "CONFIG_DREAM". Should I?
> 
> What's wrong with using the CONFIG_ANDROID dependancy here?  Actually,
> why not use it for all of the dream files?

Ok... simple enough and should do the trick, done :-).

---

Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
add few more drivers, and changing staging/Makefile each time sounds
like inviting conflicts.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index c0ae9db..7d0ad5a 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -99,6 +99,8 @@ source "drivers/staging/frontier/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/dream/Kconfig"
+
 source "drivers/staging/dst/Kconfig"
 
 source "drivers/staging/pohmelfs/Kconfig"
@@ -129,10 +131,6 @@ source "drivers/staging/vt6656/Kconfig"
 
 source "drivers/staging/cpc-usb/Kconfig"
 
-source "drivers/staging/dream/smd/Kconfig"
-
-source "drivers/staging/dream/camera/Kconfig"
-
 source "drivers/staging/udlfb/Kconfig"
 
 source "drivers/staging/hv/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 48cae04..7439983 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_USB_RSPI)		+= rspiusb/
 obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_ANDROID)		+= dream/
 obj-$(CONFIG_DST)		+= dst/
 obj-$(CONFIG_POHMELFS)		+= pohmelfs/
 obj-$(CONFIG_STLC45XX)		+= stlc45xx/
@@ -47,7 +48,5 @@ obj-$(CONFIG_VT6655)		+= vt6655/
 obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_USB_CPC)		+= cpc-usb/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
-obj-$(CONFIG_MSM_ADSP)		+= dream/qdsp5/ dream/smd/
-obj-$(CONFIG_MSM_CAMERA)	+= dream/camera/
 obj-$(CONFIG_HYPERV)		+= hv/
 obj-$(CONFIG_VME)		+= vme/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
