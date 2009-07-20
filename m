Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZGTKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZGTKfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZGTKfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:35:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59463 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZGTKfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:35:39 -0400
Date: Mon, 20 Jul 2009 12:35:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090720103532.GD19341@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
add few more drivers, and changing staging/Makefile each time sounds
like inviting conflicts.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 300b83e..50f9ab0 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -133,11 +133,9 @@ source "drivers/staging/cpc-usb/Kconfig"
 
 source "drivers/staging/pata_rdc/Kconfig"
 
-source "drivers/staging/dream/smd/Kconfig"
-
-source "drivers/staging/dream/camera/Kconfig"
-
 source "drivers/staging/udlfb/Kconfig"
 
+source "drivers/staging/dream/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 8d2e1c2..4fa2e07 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -1,7 +1,7 @@
 # Makefile for staging directory
 
 # fix for build system bug...
-obj-$(CONFIG_STAGING)		+= staging.o
+obj-$(CONFIG_STAGING)		+= staging.o dream/
 
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
@@ -49,5 +49,3 @@ obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_USB_CPC)		+= cpc-usb/
 obj-$(CONFIG_RDC_17F3101X)	+= pata_rdc/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
-obj-$(CONFIG_MSM_ADSP)		+= dream/qdsp5/ dream/smd/
-obj-$(CONFIG_MSM_CAMERA)	+= dream/camera/
diff --git a/drivers/staging/dream/Kconfig b/drivers/staging/dream/Kconfig
new file mode 100644
index 0000000..2e0c972
--- /dev/null
+++ b/drivers/staging/dream/Kconfig
@@ -0,0 +1,4 @@
+source "drivers/staging/dream/smd/Kconfig"
+
+source "drivers/staging/dream/camera/Kconfig"
+
diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
new file mode 100644
index 0000000..ab76800
--- /dev/null
+++ b/drivers/staging/dream/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
+obj-$(CONFIG_MSM_CAMERA)	+= camera/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
