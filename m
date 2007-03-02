Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067AbXCBVla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbXCBVla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXCBVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:41:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38851 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXCBVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:28 -0500
Date: Fri, 2 Mar 2007 21:41:12 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: akpm@linux-foundation.org, rpurdie@rpsys.net, romosan@sycorax.lbl.gov,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] 2.6.21-rc2 radeon backlight
In-Reply-To: <20070302.123514.35465791.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0703022131310.6960@pentafluge.infradead.org>
References: <20070301184531.b3aeafe3.akpm@linux-foundation.org>
 <87tzx35zkc.fsf@sycorax.lbl.gov> <20070302122920.a2967ebf.akpm@linux-foundation.org>
 <20070302.123514.35465791.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > yes, if i disable the radeon backlight and use the ibm acpi module,
> > > than the backlight works. if i enable the radeon backlight, the screen
> > > stays dark and i can't turn it on (i tried using radeontool to control
> > > it but nothing happened).
> > 
> > Richard, is this actually a bug, or is it a config error or something like that?
> > 
> > And should we track it as a post-2.6.20 regression?
> 
> Why don't we compromise for 2.6.21 by marking the Radeon backlight
> stuff EXPERIMENTAL until the cases where IBM ACPI works and the
> Radeon backlight stuff does not are worked out?

How about this?

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index b8f0a11..eb54d1f 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -679,7 +679,6 @@ config FB_NVIDIA
 	depends on FB && PCI
 	select I2C_ALGOBIT if FB_NVIDIA_I2C
 	select I2C if FB_NVIDIA_I2C
-	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -708,7 +707,8 @@ config FB_NVIDIA_I2C
 
 config FB_NVIDIA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_NVIDIA
+	depends on FB_NVIDIA && EXPERIMENTAL
+	select FB_BACKLIGHT
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -717,7 +717,6 @@ config FB_RIVA
 	tristate "nVidia Riva support"
 	depends on FB && PCI
 	select FB_DDC if FB_RIVA_I2C
-	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -754,7 +753,8 @@ config FB_RIVA_DEBUG
 
 config FB_RIVA_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RIVA
+	depends on FB_RIVA && EXPERIMENTAL
+	select FB_BACKLIGHT
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -994,7 +994,6 @@ config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
 	select FB_DDC if FB_RADEON_I2C
-	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1024,7 +1023,8 @@ config FB_RADEON_I2C
 
 config FB_RADEON_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_RADEON
+	depends on FB_RADEON && EXPERIMENTAL 
+	select FB_BACKLIGHT
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1044,7 +1044,6 @@ config FB_ATY128
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
 	select FB_MACMODES if PPC_PMAC
 	help
 	  This driver supports graphics boards with the ATI Rage128 chips.
@@ -1056,7 +1055,8 @@ config FB_ATY128
 
 config FB_ATY128_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY128
+	depends on FB_ATY128 && EXPERIMENTAL
+	select FB_BACKLIGHT
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
@@ -1067,7 +1067,6 @@ config FB_ATY
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
 	select FB_MACMODES if PPC
 	help
 	  This driver supports graphics boards with the ATI Mach64 chips.
@@ -1106,7 +1105,8 @@ config FB_ATY_GX
 
 config FB_ATY_BACKLIGHT
 	bool "Support for backlight control"
-	depends on FB_ATY
+	depends on FB_ATY && EXPERIMENTAL
+	select FB_BACKLIGHT	
 	default y
 	help
 	  Say Y here if you want to control the backlight of your display.
